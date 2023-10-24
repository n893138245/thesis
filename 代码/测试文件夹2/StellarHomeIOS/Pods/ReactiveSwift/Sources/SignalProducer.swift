import Dispatch
import Foundation
public struct SignalProducer<Value, Error: Swift.Error> {
	public typealias ProducedSignal = Signal<Value, Error>
	fileprivate let core: SignalProducerCore<Value, Error>
	public init<T: SignalProducerConvertible>(_ base: T) where T.Value == Value, T.Error == Error {
		self = base.producer
	}
	public init(_ signal: Signal<Value, Error>) {
		self.init { observer, lifetime in
			lifetime += signal.observe(observer)
		}
	}
	public init(_ startHandler: @escaping (Signal<Value, Error>.Observer, Lifetime) -> Void) {
		self.init(SignalCore {
			let disposable = CompositeDisposable()
			let (signal, observer) = Signal<Value, Error>.pipe(disposable: disposable)
			let observerDidSetup = { startHandler(observer, Lifetime(disposable)) }
			let interruptHandle = AnyDisposable(observer.sendInterrupted)
			return SignalProducerCore.Instance(signal: signal,
			                                   observerDidSetup: observerDidSetup,
			                                   interruptHandle: interruptHandle)
		})
	}
	internal init(_ core: SignalProducerCore<Value, Error>) {
		self.core = core
	}
	public init(value: Value) {
		self.init(GeneratorCore { observer, _ in
			observer.send(value: value)
			observer.sendCompleted()
		})
	}
	public init(_ action: @escaping () -> Value) {
		self.init(GeneratorCore { observer, _ in
			observer.send(value: action())
			observer.sendCompleted()
		})
	}
	public init(_ action: @escaping () -> Result<Value, Error>) {
		self.init(GeneratorCore { observer, _ in
			switch action() {
			case let .success(value):
				observer.send(value: value)
				observer.sendCompleted()
			case let .failure(error):
				observer.send(error: error)
			}
		})
	}
	public init(error: Error) {
		self.init(GeneratorCore { observer, _ in observer.send(error: error) })
	}
	public init(result: Result<Value, Error>) {
		switch result {
		case let .success(value):
			self.init(value: value)
		case let .failure(error):
			self.init(error: error)
		}
	}
	public init<S: Sequence>(_ values: S) where S.Iterator.Element == Value {
		self.init(GeneratorCore(isDisposable: true) { observer, disposable in
			for value in values {
				observer.send(value: value)
				if disposable.isDisposed {
					break
				}
			}
			observer.sendCompleted()
		})
	}
	public init(values first: Value, _ second: Value, _ tail: Value...) {
		self.init([ first, second ] + tail)
	}
	public static var empty: SignalProducer {
		return SignalProducer(GeneratorCore { observer, _ in observer.sendCompleted() })
	}
	internal static var interrupted: SignalProducer {
		return SignalProducer(GeneratorCore { observer, _ in observer.sendInterrupted() })
	}
	public static var never: SignalProducer {
		return self.init { observer, lifetime in
			lifetime.observeEnded { _ = observer }
		}
	}
	@discardableResult
	public func startWithSignal<Result>(_ setup: (_ signal: Signal<Value, Error>, _ interruptHandle: Disposable) -> Result) -> Result {
		let instance = core.makeInstance()
		let result = setup(instance.signal, instance.interruptHandle)
		if !instance.interruptHandle.isDisposed {
			instance.observerDidSetup()
		}
		return result
	}
}
internal class SignalProducerCore<Value, Error: Swift.Error> {
	struct Instance {
		let signal: Signal<Value, Error>
		let observerDidSetup: () -> Void
		let interruptHandle: Disposable
	}
	func makeInstance() -> Instance {
		fatalError()
	}
	@discardableResult
	func start(_ generator: (_ upstreamInterruptHandle: Disposable) -> Signal<Value, Error>.Observer) -> Disposable {
		fatalError()
	}
	internal func flatMapEvent<U, E>(_ transform: @escaping Signal<Value, Error>.Event.Transformation<U, E>) -> SignalProducer<U, E> {
		return SignalProducer<U, E>(TransformerCore(source: self, transform: transform))
	}
}
private final class SignalCore<Value, Error: Swift.Error>: SignalProducerCore<Value, Error> {
	private let _make: () -> Instance
	init(_ action: @escaping () -> Instance) {
		self._make = action
	}
	@discardableResult
	override func start(_ generator: (Disposable) -> Signal<Value, Error>.Observer) -> Disposable {
		let instance = makeInstance()
		instance.signal.observe(generator(instance.interruptHandle))
		instance.observerDidSetup()
		return instance.interruptHandle
	}
	override func makeInstance() -> Instance {
		return _make()
	}
}
private final class TransformerCore<Value, Error: Swift.Error, SourceValue, SourceError: Swift.Error>: SignalProducerCore<Value, Error> {
	private let source: SignalProducerCore<SourceValue, SourceError>
	private let transform: Signal<SourceValue, SourceError>.Event.Transformation<Value, Error>
	init(source: SignalProducerCore<SourceValue, SourceError>, transform: @escaping Signal<SourceValue, SourceError>.Event.Transformation<Value, Error>) {
		self.source = source
		self.transform = transform
	}
	@discardableResult
	internal override func start(_ generator: (Disposable) -> Signal<Value, Error>.Observer) -> Disposable {
		let disposables = CompositeDisposable()
		source.start { upstreamInterrupter in
			disposables += upstreamInterrupter
			var hasDeliveredTerminalEvent = false
			let output = generator(disposables)
			let wrappedOutput = Signal<Value, Error>.Observer { event in
				if !hasDeliveredTerminalEvent {
					output.send(event)
					if event.isTerminating {
						hasDeliveredTerminalEvent = true
						disposables.dispose()
					}
				}
			}
			let input = transform(wrappedOutput, Lifetime(disposables))
			return input.assumeUnboundDemand()
		}
		return disposables
	}
	internal override func flatMapEvent<U, E>(_ transform: @escaping Signal<Value, Error>.Event.Transformation<U, E>) -> SignalProducer<U, E> {
		return SignalProducer<U, E>(TransformerCore<U, E, SourceValue, SourceError>(source: source) { [innerTransform = self.transform] action, lifetime in
			return innerTransform(transform(action, lifetime), lifetime)
		})
	}
	internal override func makeInstance() -> Instance {
		let disposable = SerialDisposable()
		let (signal, observer) = Signal<Value, Error>.pipe(disposable: disposable)
		func observerDidSetup() {
			start { interrupter in
				disposable.inner = interrupter
				return observer
			}
		}
		return Instance(signal: signal,
		                observerDidSetup: observerDidSetup,
		                interruptHandle: disposable)
	}
}
private final class GeneratorCore<Value, Error: Swift.Error>: SignalProducerCore<Value, Error> {
	private let isDisposable: Bool
	private let generator: (Signal<Value, Error>.Observer, Disposable) -> Void
	init(isDisposable: Bool = false, _ generator: @escaping (Signal<Value, Error>.Observer, Disposable) -> Void) {
		self.isDisposable = isDisposable
		self.generator = generator
	}
	@discardableResult
	internal override func start(_ observerGenerator: (Disposable) -> Signal<Value, Error>.Observer) -> Disposable {
		let d: Disposable = isDisposable ? _SimpleDisposable() : NopDisposable.shared
		generator(observerGenerator(d), d)
		return d
	}
	internal override func makeInstance() -> Instance {
		let (signal, observer) = Signal<Value, Error>.pipe()
		let d = AnyDisposable(observer.sendInterrupted)
		return Instance(signal: signal,
		                             observerDidSetup: { self.generator(observer, d) },
		                             interruptHandle: d)
	}
}
extension SignalProducer where Error == Never {
	public init(value: Value) {
		self.init(GeneratorCore { observer, _ in
			observer.send(value: value)
			observer.sendCompleted()
		})
	}
	public init<S: Sequence>(_ values: S) where S.Iterator.Element == Value {
		self.init(GeneratorCore(isDisposable: true) { observer, disposable in
			for value in values {
				observer.send(value: value)
				if disposable.isDisposed {
					break
				}
			}
			observer.sendCompleted()
		})
	}
	public init(values first: Value, _ second: Value, _ tail: Value...) {
		self.init([ first, second ] + tail)
	}
}
extension SignalProducer where Error == Swift.Error {
	public init(_ action: @escaping () throws -> Value) {
		self.init {
			return Result {
				return try action()
			}
		}
	}
}
public protocol SignalProducerConvertible {
	associatedtype Value
	associatedtype Error: Swift.Error
	var producer: SignalProducer<Value, Error> { get }
}
public protocol SignalProducerProtocol {
	associatedtype Value
	associatedtype Error: Swift.Error
	var producer: SignalProducer<Value, Error> { get }
}
extension SignalProducer: SignalProducerConvertible, SignalProducerProtocol {
	public var producer: SignalProducer {
		return self
	}
}
extension SignalProducer {
	@discardableResult
	public func start(_ observer: Signal<Value, Error>.Observer = .init()) -> Disposable {
		return core.start { _ in observer }
	}
	@discardableResult
	public func start(_ action: @escaping Signal<Value, Error>.Observer.Action) -> Disposable {
		return start(Signal.Observer(action))
	}
	@discardableResult
	public func startWithResult(_ action: @escaping (Result<Value, Error>) -> Void) -> Disposable {
		return start(
			Signal.Observer(
				value: { action(.success($0)) },
				failed: { action(.failure($0)) }
			)
		)
	}
	@discardableResult
	public func startWithCompleted(_ action: @escaping () -> Void) -> Disposable {
		return start(Signal.Observer(completed: action))
	}
	@discardableResult
	public func startWithFailed(_ action: @escaping (Error) -> Void) -> Disposable {
		return start(Signal.Observer(failed: action))
	}
	@discardableResult
	public func startWithInterrupted(_ action: @escaping () -> Void) -> Disposable {
		return start(Signal.Observer(interrupted: action))
	}
	internal func startAndRetrieveSignal() -> Signal<Value, Error> {
		var result: Signal<Value, Error>!
		self.startWithSignal { signal, _ in
			result = signal
		}
		return result
	}
	fileprivate func startWithSignal(during lifetime: Lifetime, setup: (Signal<Value, Error>) -> Void) {
		startWithSignal { signal, interruptHandle in
			lifetime += interruptHandle
			setup(signal)
		}
	}
}
extension SignalProducer where Error == Never {
	@discardableResult
	public func startWithValues(_ action: @escaping (Value) -> Void) -> Disposable {
		return start(Signal.Observer(value: action))
	}
}
extension SignalProducer {
	public func lift<U, F>(_ transform: @escaping (Signal<Value, Error>) -> Signal<U, F>) -> SignalProducer<U, F> {
		return SignalProducer<U, F> { observer, lifetime in
			self.startWithSignal { signal, interrupter in
				lifetime += interrupter
				lifetime += transform(signal).observe(observer)
			}
		}
	}
	internal func liftLeft<U, F, V, G>(_ transform: @escaping (Signal<Value, Error>) -> (Signal<U, F>) -> Signal<V, G>) -> (SignalProducer<U, F>) -> SignalProducer<V, G> {
		return { right in
			return SignalProducer<V, G> { observer, lifetime in
				right.startWithSignal { rightSignal, rightInterrupter in
					lifetime += rightInterrupter
					self.startWithSignal { leftSignal, leftInterrupter in
						lifetime += leftInterrupter
						lifetime += transform(leftSignal)(rightSignal).observe(observer)
					}
				}
			}
		}
	}
	internal func liftRight<U, F, V, G>(_ transform: @escaping (Signal<Value, Error>) -> (Signal<U, F>) -> Signal<V, G>) -> (SignalProducer<U, F>) -> SignalProducer<V, G> {
		return { right in
			return SignalProducer<V, G> { observer, lifetime in
				self.startWithSignal { leftSignal, leftInterrupter in
					lifetime += leftInterrupter
					right.startWithSignal { rightSignal, rightInterrupter in
						lifetime += rightInterrupter
						lifetime += transform(leftSignal)(rightSignal).observe(observer)
					}
				}
			}
		}
	}
	public func lift<U, F, V, G>(_ transform: @escaping (Signal<Value, Error>) -> (Signal<U, F>) -> Signal<V, G>) -> (SignalProducer<U, F>) -> SignalProducer<V, G> {
		return liftRight(transform)
	}
}
private func flattenStart<A, B, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>) -> Void) {
	b.startWithSignal(during: lifetime) { b in
		a.startWithSignal(during: lifetime) { setup($0, b) }
	}
}
private func flattenStart<A, B, C, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>) -> Void) {
	c.startWithSignal(during: lifetime) { c in
		flattenStart(lifetime, a, b) { setup($0, $1, c) }
	}
}
private func flattenStart<A, B, C, D, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>) -> Void) {
	d.startWithSignal(during: lifetime) { d in
		flattenStart(lifetime, a, b, c) { setup($0, $1, $2, d) }
	}
}
private func flattenStart<A, B, C, D, E, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>) -> Void) {
	e.startWithSignal(during: lifetime) { e in
		flattenStart(lifetime, a, b, c, d) { setup($0, $1, $2, $3, e) }
	}
}
private func flattenStart<A, B, C, D, E, F, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ f: SignalProducer<F, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>, Signal<F, Error>) -> Void) {
	f.startWithSignal(during: lifetime) { f in
		flattenStart(lifetime, a, b, c, d, e) { setup($0, $1, $2, $3, $4, f) }
	}
}
private func flattenStart<A, B, C, D, E, F, G, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ f: SignalProducer<F, Error>, _ g: SignalProducer<G, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>, Signal<F, Error>, Signal<G, Error>) -> Void) {
	g.startWithSignal(during: lifetime) { g in
		flattenStart(lifetime, a, b, c, d, e, f) { setup($0, $1, $2, $3, $4, $5, g) }
	}
}
private func flattenStart<A, B, C, D, E, F, G, H, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ f: SignalProducer<F, Error>, _ g: SignalProducer<G, Error>, _ h: SignalProducer<H, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>, Signal<F, Error>, Signal<G, Error>, Signal<H, Error>) -> Void) {
	h.startWithSignal(during: lifetime) { h in
		flattenStart(lifetime, a, b, c, d, e, f, g) { setup($0, $1, $2, $3, $4, $5, $6, h) }
	}
}
private func flattenStart<A, B, C, D, E, F, G, H, I, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ f: SignalProducer<F, Error>, _ g: SignalProducer<G, Error>, _ h: SignalProducer<H, Error>, _ i: SignalProducer<I, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>, Signal<F, Error>, Signal<G, Error>, Signal<H, Error>, Signal<I, Error>) -> Void) {
	i.startWithSignal(during: lifetime) { i in
		flattenStart(lifetime, a, b, c, d, e, f, g, h) { setup($0, $1, $2, $3, $4, $5, $6, $7, i) }
	}
}
private func flattenStart<A, B, C, D, E, F, G, H, I, J, Error>(_ lifetime: Lifetime, _ a: SignalProducer<A, Error>, _ b: SignalProducer<B, Error>, _ c: SignalProducer<C, Error>, _ d: SignalProducer<D, Error>, _ e: SignalProducer<E, Error>, _ f: SignalProducer<F, Error>, _ g: SignalProducer<G, Error>, _ h: SignalProducer<H, Error>, _ i: SignalProducer<I, Error>, _ j: SignalProducer<J, Error>, _ setup: (Signal<A, Error>, Signal<B, Error>, Signal<C, Error>, Signal<D, Error>, Signal<E, Error>, Signal<F, Error>, Signal<G, Error>, Signal<H, Error>, Signal<I, Error>, Signal<J, Error>) -> Void) {
	j.startWithSignal(during: lifetime) { j in
		flattenStart(lifetime, a, b, c, d, e, f, g, h, i) { setup($0, $1, $2, $3, $4, $5, $6, $7, $8, j) }
	}
}
extension SignalProducer {
	public func map<U>(_ transform: @escaping (Value) -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.map(transform))
	}
	public func map<U>(value: U) -> SignalProducer<U, Error> {
		return lift { $0.map(value: value) }
	}
	public func map<U>(_ keyPath: KeyPath<Value, U>) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.compactMap { $0[keyPath: keyPath] })
	}
	public func mapError<F>(_ transform: @escaping (Error) -> F) -> SignalProducer<Value, F> {
		return core.flatMapEvent(Signal.Event.mapError(transform))
	}
	public func lazyMap<U>(on scheduler: Scheduler, transform: @escaping (Value) -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.lazyMap(on: scheduler, transform: transform))
	}
	public func filter(_ isIncluded: @escaping (Value) -> Bool) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.filter(isIncluded))
	}
	public func compactMap<U>(_ transform: @escaping (Value) -> U?) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.compactMap(transform))
	}
	@available(*, deprecated, renamed: "compactMap")
	public func filterMap<U>(_ transform: @escaping (Value) -> U?) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.compactMap(transform))
	}
	public func take(first count: Int) -> SignalProducer<Value, Error> {
		guard count >= 1 else { return .interrupted }
		return core.flatMapEvent(Signal.Event.take(first: count))
	}
	public func collect() -> SignalProducer<[Value], Error> {
		return core.flatMapEvent(Signal.Event.collect)
	}
	public func collect(count: Int) -> SignalProducer<[Value], Error> {
		return core.flatMapEvent(Signal.Event.collect(count: count))
	}
	public func collect(_ shouldEmit: @escaping (_ values: [Value]) -> Bool) -> SignalProducer<[Value], Error> {
		return core.flatMapEvent(Signal.Event.collect(shouldEmit))
	}
	public func collect(_ shouldEmit: @escaping (_ collected: [Value], _ latest: Value) -> Bool) -> SignalProducer<[Value], Error> {
		return core.flatMapEvent(Signal.Event.collect(shouldEmit))
	}
	public func collect(every interval: DispatchTimeInterval, on scheduler: DateScheduler, skipEmpty: Bool = false, discardWhenCompleted: Bool = true) -> SignalProducer<[Value], Error> {
		return core.flatMapEvent(Signal.Event.collect(every: interval, on: scheduler, skipEmpty: skipEmpty, discardWhenCompleted: discardWhenCompleted))
	}
	public func observe(on scheduler: Scheduler) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.observe(on: scheduler))
	}
	public func combineLatest<U>(with other: SignalProducer<U, Error>) -> SignalProducer<(Value, U), Error> {
		return SignalProducer.combineLatest(self, other)
	}
	public func combineLatest<Other: SignalProducerConvertible>(with other: Other) -> SignalProducer<(Value, Other.Value), Error> where Other.Error == Error {
		return combineLatest(with: other.producer)
	}
	public func merge(with other: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return SignalProducer.merge(self, other)
	}
	public func merge<Other: SignalProducerConvertible>(with other: Other) -> SignalProducer<Value, Error> where Other.Value == Value, Other.Error == Error {
		return merge(with: other.producer)
	}
	public func delay(_ interval: TimeInterval, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.delay(interval, on: scheduler))
	}
	public func skip(first count: Int) -> SignalProducer<Value, Error> {
		guard count != 0 else { return self }
		return core.flatMapEvent(Signal.Event.skip(first: count))
	}
	public func materialize() -> SignalProducer<ProducedSignal.Event, Never> {
		return core.flatMapEvent(Signal.Event.materialize)
	}
	public func materializeResults() -> SignalProducer<Result<Value, Error>, Never> {
		return core.flatMapEvent(Signal.Event.materializeResults)
	}
	public func sample<U>(with sampler: SignalProducer<U, Never>) -> SignalProducer<(Value, U), Error> {
		return liftLeft(Signal.sample(with:))(sampler)
	}
	public func sample<Sampler: SignalProducerConvertible>(with sampler: Sampler) -> SignalProducer<(Value, Sampler.Value), Error> where Sampler.Error == Never {
		return sample(with: sampler.producer)
	}
	public func sample(on sampler: SignalProducer<(), Never>) -> SignalProducer<Value, Error> {
		return liftLeft(Signal.sample(on:))(sampler)
	}
	public func sample<Sampler: SignalProducerConvertible>(on sampler: Sampler) -> SignalProducer<Value, Error> where Sampler.Value == (), Sampler.Error == Never {
		return sample(on: sampler.producer)
	}
	public func withLatest<U>(from samplee: SignalProducer<U, Never>) -> SignalProducer<(Value, U), Error> {
		return liftRight(Signal.withLatest)(samplee.producer)
	}
	public func withLatest<Samplee: SignalProducerConvertible>(from samplee: Samplee) -> SignalProducer<(Value, Samplee.Value), Error> where Samplee.Error == Never {
		return withLatest(from: samplee.producer)
	}
	public func take(during lifetime: Lifetime) -> SignalProducer<Value, Error> {
		return lift { $0.take(during: lifetime) }
	}
	public func take(until trigger: SignalProducer<(), Never>) -> SignalProducer<Value, Error> {
		return liftRight(Signal.take(until:))(trigger)
	}
	public func take<Trigger: SignalProducerConvertible>(until trigger: Trigger) -> SignalProducer<Value, Error> where Trigger.Value == (), Trigger.Error == Never {
		return take(until: trigger.producer)
	}
	public func skip(until trigger: SignalProducer<(), Never>) -> SignalProducer<Value, Error> {
		return liftRight(Signal.skip(until:))(trigger)
	}
	public func skip<Trigger: SignalProducerConvertible>(until trigger: Trigger) -> SignalProducer<Value, Error> where Trigger.Value == (), Trigger.Error == Never {
		return skip(until: trigger.producer)
	}
	public func combinePrevious(_ initial: Value) -> SignalProducer<(Value, Value), Error> {
		return core.flatMapEvent(Signal.Event.combinePrevious(initial: initial))
	}
	public func combinePrevious() -> SignalProducer<(Value, Value), Error> {
		return core.flatMapEvent(Signal.Event.combinePrevious(initial: nil))
	}
	public func reduce<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.reduce(initialResult, nextPartialResult))
	}
	public func reduce<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.reduce(into: initialResult, nextPartialResult))
	}
	public func scan<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.scan(initialResult, nextPartialResult))
	}
	public func scan<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.scan(into: initialResult, nextPartialResult))
	}
	public func scanMap<State, U>(_ initialState: State, _ next: @escaping (State, Value) -> (State, U)) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.scanMap(initialState, next))
	}
	public func scanMap<State, U>(into initialState: State, _ next: @escaping (inout State, Value) -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.scanMap(into: initialState, next))
	}
	public func skipRepeats(_ isEquivalent: @escaping (Value, Value) -> Bool) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.skipRepeats(isEquivalent))
	}
	public func skip(while shouldContinue: @escaping (Value) -> Bool) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.skip(while: shouldContinue))
	}
	public func take(untilReplacement replacement: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return liftRight(Signal.take(untilReplacement:))(replacement)
	}
	public func take<Replacement: SignalProducerConvertible>(untilReplacement replacement: Replacement) -> SignalProducer<Value, Error> where Replacement.Value == Value, Replacement.Error == Error {
		return take(untilReplacement: replacement.producer)
	}
	public func take(last count: Int) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.take(last: count))
	}
	public func take(while shouldContinue: @escaping (Value) -> Bool) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.take(while: shouldContinue))
	}
	public func zip<U>(with other: SignalProducer<U, Error>) -> SignalProducer<(Value, U), Error> {
		return SignalProducer.zip(self, other)
	}
	public func zip<Other: SignalProducerConvertible>(with other: Other) -> SignalProducer<(Value, Other.Value), Error> where Other.Error == Error {
		return zip(with: other.producer)
	}
	public func attempt(_ action: @escaping (Value) -> Result<(), Error>) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.attempt(action))
	}
	public func attemptMap<U>(_ action: @escaping (Value) -> Result<U, Error>) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.attemptMap(action))
	}
	public func throttle(_ interval: TimeInterval, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.throttle(interval, on: scheduler))
	}
	public func throttle<P: PropertyProtocol>(while shouldThrottle: P, on scheduler: Scheduler) -> SignalProducer<Value, Error>
		where P.Value == Bool
	{
		let shouldThrottle = Property(shouldThrottle)
		return lift { $0.throttle(while: shouldThrottle, on: scheduler) }
	}
	public func debounce(_ interval: TimeInterval, on scheduler: DateScheduler, discardWhenCompleted: Bool = true) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.debounce(interval, on: scheduler, discardWhenCompleted: discardWhenCompleted))
	}
	public func timeout(after interval: TimeInterval, raising error: Error, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
		return lift { $0.timeout(after: interval, raising: error, on: scheduler) }
	}
}
extension SignalProducer where Value: OptionalProtocol {
	public func skipNil() -> SignalProducer<Value.Wrapped, Error> {
		return core.flatMapEvent(Signal.Event.skipNil)
	}
}
extension SignalProducer where Value: EventProtocol, Error == Never {
	public func dematerialize() -> SignalProducer<Value.Value, Value.Error> {
		return core.flatMapEvent(Signal.Event.dematerialize)
	}
}
extension SignalProducer where Error == Never {
	public func dematerializeResults<Success, Failure>() -> SignalProducer<Success, Failure> where Value == Result<Success, Failure> {
		return core.flatMapEvent(Signal.Event.dematerializeResults)
	}
}
extension SignalProducer where Error == Never {
	public func promoteError<F>(_: F.Type = F.self) -> SignalProducer<Value, F> {
		return core.flatMapEvent(Signal.Event.promoteError(F.self))
	}
	public func promoteError(_: Error.Type = Error.self) -> SignalProducer<Value, Error> {
		return self
	}
	public func timeout<NewError>(
		after interval: TimeInterval,
		raising error: NewError,
		on scheduler: DateScheduler
	) -> SignalProducer<Value, NewError> {
		return lift { $0.timeout(after: interval, raising: error, on: scheduler) }
	}
	public func attempt(_ action: @escaping (Value) throws -> Void) -> SignalProducer<Value, Swift.Error> {
		return self
			.promoteError(Swift.Error.self)
			.attempt(action)
	}
	public func attemptMap<U>(_ action: @escaping (Value) throws -> U) -> SignalProducer<U, Swift.Error> {
		return self
			.promoteError(Swift.Error.self)
			.attemptMap(action)
	}
}
extension SignalProducer where Error == Swift.Error {
	public func attempt(_ action: @escaping (Value) throws -> Void) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.attempt(action))
	}
	public func attemptMap<U>(_ transform: @escaping (Value) throws -> U) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.attemptMap(transform))
	}
}
extension SignalProducer where Value == Never {
	public func promoteValue<U>(_: U.Type = U.self) -> SignalProducer<U, Error> {
		return core.flatMapEvent(Signal.Event.promoteValue(U.self))
	}
	public func promoteValue(_: Value.Type = Value.self) -> SignalProducer<Value, Error> {
		return self
	}
}
extension SignalProducer where Value: Equatable {
	public func skipRepeats() -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.skipRepeats(==))
	}
}
extension SignalProducer {
	public func uniqueValues<Identity: Hashable>(_ transform: @escaping (Value) -> Identity) -> SignalProducer<Value, Error> {
		return core.flatMapEvent(Signal.Event.uniqueValues(transform))
	}
}
extension SignalProducer where Value: Hashable {
	public func uniqueValues() -> SignalProducer<Value, Error> {
		return uniqueValues { $0 }
	}
}
extension SignalProducer {
	public func on(
		starting: (() -> Void)? = nil,
		started: (() -> Void)? = nil,
		event: ((ProducedSignal.Event) -> Void)? = nil,
		failed: ((Error) -> Void)? = nil,
		completed: (() -> Void)? = nil,
		interrupted: (() -> Void)? = nil,
		terminated: (() -> Void)? = nil,
		disposed: (() -> Void)? = nil,
		value: ((Value) -> Void)? = nil
	) -> SignalProducer<Value, Error> {
		return SignalProducer(SignalCore {
			let instance = self.core.makeInstance()
			let signal = instance.signal.on(event: event,
			                                failed: failed,
			                                completed: completed,
			                                interrupted: interrupted,
			                                terminated: terminated,
			                                disposed: disposed,
			                                value: value)
			return .init(signal: signal,
			             observerDidSetup: { starting?(); instance.observerDidSetup(); started?() },
			             interruptHandle: instance.interruptHandle)
		})
	}
	public func start(on scheduler: Scheduler) -> SignalProducer<Value, Error> {
		return SignalProducer { observer, lifetime in
			lifetime += scheduler.schedule {
				self.startWithSignal { signal, signalDisposable in
					lifetime += signalDisposable
					signal.observe(observer)
				}
			}
		}
	}
}
extension SignalProducer {
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible>(_ a: A, _ b: B) -> SignalProducer<(Value, B.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer) { Signal.combineLatest($0, $1).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C) -> SignalProducer<(Value, B.Value, C.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer) { Signal.combineLatest($0, $1, $2).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D) -> SignalProducer<(Value, B.Value, C.Value, D.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer) { Signal.combineLatest($0, $1, $2, $3).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer) { Signal.combineLatest($0, $1, $2, $3, $4).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer) { Signal.combineLatest($0, $1, $2, $3, $4, $5).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer) { Signal.combineLatest($0, $1, $2, $3, $4, $5, $6).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer) { Signal.combineLatest($0, $1, $2, $3, $4, $5, $6, $7).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error, I.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer) { Signal.combineLatest($0, $1, $2, $3, $4, $5, $6, $7, $8).observe(observer) }
		}
	}
	public static func combineLatest<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible, J: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value, J.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error, I.Error == Error, J.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer, j.producer) { Signal.combineLatest($0, $1, $2, $3, $4, $5, $6, $7, $8, $9).observe(observer) }
		}
	}
	public static func combineLatest<S: Sequence>(_ producers: S) -> SignalProducer<[Value], Error> where S.Iterator.Element: SignalProducerConvertible, S.Iterator.Element.Value == Value, S.Iterator.Element.Error == Error {
		return start(producers, Signal.combineLatest)
	}
	public static func combineLatest<S: Sequence>(_ producers: S, emptySentinel: [S.Iterator.Element.Value]) -> SignalProducer<[Value], Error> where S.Iterator.Element: SignalProducerConvertible, S.Iterator.Element.Value == Value, S.Iterator.Element.Error == Error {
		return start(producers, emptySentinel: emptySentinel, Signal.combineLatest)
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible>(_ a: A, _ b: B) -> SignalProducer<(Value, B.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer) { Signal.zip($0, $1).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C) -> SignalProducer<(Value, B.Value, C.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer) { Signal.zip($0, $1, $2).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D) -> SignalProducer<(Value, B.Value, C.Value, D.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer) { Signal.zip($0, $1, $2, $3).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer) { Signal.zip($0, $1, $2, $3, $4).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer) { Signal.zip($0, $1, $2, $3, $4, $5).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer) { Signal.zip($0, $1, $2, $3, $4, $5, $6).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer) { Signal.zip($0, $1, $2, $3, $4, $5, $6, $7).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error, I.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer) { Signal.zip($0, $1, $2, $3, $4, $5, $6, $7, $8).observe(observer) }
		}
	}
	public static func zip<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible, J: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) -> SignalProducer<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value, J.Value), Error> where A.Value == Value, A.Error == Error, B.Error == Error, C.Error == Error, D.Error == Error, E.Error == Error, F.Error == Error, G.Error == Error, H.Error == Error, I.Error == Error, J.Error == Error {
		return .init { observer, lifetime in
			flattenStart(lifetime, a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer, j.producer) { Signal.zip($0, $1, $2, $3, $4, $5, $6, $7, $8, $9).observe(observer) }
		}
	}
	public static func zip<S: Sequence>(_ producers: S) -> SignalProducer<[Value], Error> where S.Iterator.Element: SignalProducerConvertible, S.Iterator.Element.Value == Value, S.Iterator.Element.Error == Error {
		return start(producers, Signal.zip)
	}
	public static func zip<S: Sequence>(_ producers: S, emptySentinel: [S.Iterator.Element.Value]) -> SignalProducer<[Value], Error> where S.Iterator.Element: SignalProducerConvertible, S.Iterator.Element.Value == Value, S.Iterator.Element.Error == Error {
		return start(producers, emptySentinel: emptySentinel, Signal.zip)
	}
	private static func start<S: Sequence>(
		_ producers: S,
		emptySentinel: [S.Iterator.Element.Value]? = nil,
		_ transform: @escaping (AnySequence<Signal<Value, Error>>) -> Signal<[Value], Error>
	) -> SignalProducer<[Value], Error>
		where S.Iterator.Element: SignalProducerConvertible, S.Iterator.Element.Value == Value, S.Iterator.Element.Error == Error
	{
		return SignalProducer<[Value], Error> { observer, lifetime in
			let setup = producers.map {
				(producer: $0.producer, pipe: Signal<Value, Error>.pipe())
			}
			guard !setup.isEmpty else {
				if let emptySentinel = emptySentinel {
					observer.send(value: emptySentinel)
				}
				observer.sendCompleted()
				return
			}
			lifetime += transform(AnySequence(setup.lazy.map { $0.pipe.output })).observe(observer)
			for (producer, pipe) in setup {
				lifetime += producer.start(pipe.input)
			}
		}
	}
}
extension SignalProducer {
	public func `repeat`(_ count: Int) -> SignalProducer<Value, Error> {
		precondition(count >= 0)
		if count == 0 {
			return .empty
		} else if count == 1 {
			return producer
		}
		return SignalProducer { observer, lifetime in
			let serialDisposable = SerialDisposable()
			lifetime += serialDisposable
			func iterate(_ current: Int) {
				self.startWithSignal { signal, signalDisposable in
					serialDisposable.inner = signalDisposable
					signal.observe { event in
						if case .completed = event {
							let remainingTimes = current - 1
							if remainingTimes > 0 {
								iterate(remainingTimes)
							} else {
								observer.sendCompleted()
							}
						} else {
							observer.send(event)
						}
					}
				}
			}
			iterate(count)
		}
	}
	public func retry(upTo count: Int) -> SignalProducer<Value, Error> {
		precondition(count >= 0)
		if count == 0 {
			return producer
		} else {
			return flatMapError { _ in
				self.retry(upTo: count - 1)
			}
		}
	}
	public func retry(upTo count: Int, interval: TimeInterval, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
		precondition(count >= 0)
		if count == 0 {
			return producer
		}
		var retries = count
		return flatMapError { error -> SignalProducer<Value, Error> in
				var producer = SignalProducer<Value, Error>(error: error)
				if retries > 0 {
					producer = SignalProducer.empty
						.delay(interval, on: scheduler)
						.concat(producer)
				}
				retries -= 1
				return producer
			}
			.retry(upTo: count)
	}
	public func then<U>(_ replacement: SignalProducer<U, Never>) -> SignalProducer<U, Error> {
		return _then(replacement.promoteError(Error.self))
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Replacement.Value, Error> where Replacement.Error == Never {
		return then(replacement.producer)
	}
	public func then<U>(_ replacement: SignalProducer<U, Error>) -> SignalProducer<U, Error> {
		return _then(replacement)
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Replacement.Value, Error> where Replacement.Error == Error {
		return then(replacement.producer)
	}
	public func then(_ replacement: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return _then(replacement)
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Value, Error> where Replacement.Value == Value, Replacement.Error == Error {
		return then(replacement.producer)
	}
	internal func _then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Replacement.Value, Error> where Replacement.Error == Error {
		return SignalProducer<Replacement.Value, Error> { observer, lifetime in
			self.startWithSignal { signal, signalDisposable in
				lifetime += signalDisposable
				signal.observe { event in
					switch event {
					case let .failed(error):
						observer.send(error: error)
					case .completed:
						lifetime += replacement.producer.start(observer)
					case .interrupted:
						observer.sendInterrupted()
					case .value:
						break
					}
				}
			}
		}
	}
}
extension SignalProducer where Error == Never {
	public func then<U, F>(_ replacement: SignalProducer<U, F>) -> SignalProducer<U, F> {
		return promoteError(F.self)._then(replacement)
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Replacement.Value, Replacement.Error> {
		return then(replacement.producer)
	}
	public func then<U>(_ replacement: SignalProducer<U, Never>) -> SignalProducer<U, Never> {
		return _then(replacement)
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Replacement.Value, Never> where Replacement.Error == Never {
		return then(replacement.producer)
	}
	public func then(_ replacement: SignalProducer<Value, Never>) -> SignalProducer<Value, Never> {
		return _then(replacement)
	}
	public func then<Replacement: SignalProducerConvertible>(_ replacement: Replacement) -> SignalProducer<Value, Never> where Replacement.Value == Value, Replacement.Error == Never {
		return then(replacement.producer)
	}
}
extension SignalProducer {
	public func first() -> Result<Value, Error>? {
		return take(first: 1).single()
	}
	public func single() -> Result<Value, Error>? {
		let semaphore = DispatchSemaphore(value: 0)
		var result: Result<Value, Error>?
		take(first: 2).start { event in
			switch event {
			case let .value(value):
				if result != nil {
					result = nil
					return
				}
				result = .success(value)
			case let .failed(error):
				result = .failure(error)
				semaphore.signal()
			case .completed, .interrupted:
				semaphore.signal()
			}
		}
		semaphore.wait()
		return result
	}
	public func last() -> Result<Value, Error>? {
		return take(last: 1).single()
	}
	public func wait() -> Result<(), Error> {
		return then(SignalProducer<(), Error>(value: ())).last() ?? .success(())
	}
	public func replayLazily(upTo capacity: Int) -> SignalProducer<Value, Error> {
		precondition(capacity >= 0, "Invalid capacity: \(capacity)")
		let lifetimeToken = Lifetime.Token()
		let lifetime = Lifetime(lifetimeToken)
		let state = Atomic(ReplayState<Value, Error>(upTo: capacity))
		let start: Atomic<(() -> Void)?> = Atomic {
			self
				.take(during: lifetime)
				.start { event in
					let observers: Bag<Signal<Value, Error>.Observer>? = state.modify { state in
						defer { state.enqueue(event) }
						return state.observers
					}
					observers?.forEach { $0.send(event) }
				}
		}
		return SignalProducer { observer, lifetime in
			lifetime.observeEnded { _ = lifetimeToken }
			while true {
				var result: Result<Bag<Signal<Value, Error>.Observer>.Token?, ReplayError<Value>>!
				state.modify {
					result = $0.observe(observer)
				}
				switch result! {
				case let .success(token):
					if let token = token {
						lifetime.observeEnded {
							state.modify {
								$0.removeObserver(using: token)
							}
						}
					}
					start.swap(nil)?()
					return
				case let .failure(error):
					error.values.forEach(observer.send(value:))
				}
			}
		}
	}
}
extension SignalProducer where Value == Bool {
	public func negate() -> SignalProducer<Value, Error> {
		return map(!)
	}
	public func and(_ booleans: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return type(of: self).all([self, booleans])
	}
	public func and<Booleans: SignalProducerConvertible>(_ booleans: Booleans) -> SignalProducer<Value, Error> where Booleans.Value == Value, Booleans.Error == Error {
		return and(booleans.producer)
	}
	public static func all<BooleansCollection: Collection>(_ booleans: BooleansCollection) -> SignalProducer<Value, Error> where BooleansCollection.Element == SignalProducer<Value, Error> {
		return combineLatest(booleans, emptySentinel: []).map { $0.reduce(true) { $0 && $1 } }
	}
    public static func all(_ booleans: SignalProducer<Value, Error>...) -> SignalProducer<Value, Error> {
        return .all(booleans)
    }
	public static func all<Booleans: SignalProducerConvertible, BooleansCollection: Collection>(_ booleans: BooleansCollection) -> SignalProducer<Value, Error> where Booleans.Value == Value, Booleans.Error == Error, BooleansCollection.Element == Booleans {
		return all(booleans.map { $0.producer })
	}
	public func or(_ booleans: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return type(of: self).any([self, booleans])
	}
	public func or<Booleans: SignalProducerConvertible>(_ booleans: Booleans) -> SignalProducer<Value, Error> where Booleans.Value == Value, Booleans.Error == Error {
		return or(booleans.producer)
	}
	public static func any<BooleansCollection: Collection>(_ booleans: BooleansCollection) -> SignalProducer<Value, Error> where BooleansCollection.Element == SignalProducer<Value, Error> {
		return combineLatest(booleans, emptySentinel: []).map { $0.reduce(false) { $0 || $1 } }
	}
    public static func any(_ booleans: SignalProducer<Value, Error>...) -> SignalProducer<Value, Error> {
        return .any(booleans)
    }
	public static func any<Booleans: SignalProducerConvertible, BooleansCollection: Collection>(_ booleans: BooleansCollection) -> SignalProducer<Value, Error> where Booleans.Value == Value, Booleans.Error == Error, BooleansCollection.Element == Booleans {
		return any(booleans.map { $0.producer })
	}
}
private struct ReplayError<Value>: Error {
	let values: [Value]
}
private struct ReplayState<Value, Error: Swift.Error> {
	let capacity: Int
	var values: [Value] = []
	var terminationEvent: Signal<Value, Error>.Event?
	var observers: Bag<Signal<Value, Error>.Observer>? = Bag()
	var replayBuffers: [ObjectIdentifier: [Value]] = [:]
	init(upTo capacity: Int) {
		self.capacity = capacity
	}
	mutating func observe(_ observer: Signal<Value, Error>.Observer) -> Result<Bag<Signal<Value, Error>.Observer>.Token?, ReplayError<Value>> {
		let id = ObjectIdentifier(observer)
		switch replayBuffers[id] {
		case .none where !values.isEmpty:
			replayBuffers[id] = []
			return .failure(ReplayError(values: values))
		case let .some(buffer) where !buffer.isEmpty:
			defer { replayBuffers[id] = [] }
			return .failure(ReplayError(values: buffer))
		case let .some(buffer) where buffer.isEmpty:
			replayBuffers.removeValue(forKey: id)
		default:
			break
		}
		if let event = terminationEvent {
			observer.send(event)
		}
		return .success(observers?.insert(observer))
	}
	mutating func enqueue(_ event: Signal<Value, Error>.Event) {
		switch event {
		case let .value(value):
			for key in replayBuffers.keys {
				replayBuffers[key]!.append(value)
			}
			switch capacity {
			case 0:
				break
			case 1:
				values = [value]
			default:
				values.append(value)
				let overflow = values.count - capacity
				if overflow > 0 {
					values.removeFirst(overflow)
				}
			}
		case .completed, .failed, .interrupted:
			terminationEvent = event
			observers = nil
		}
	}
	mutating func removeObserver(using token: Bag<Signal<Value, Error>.Observer>.Token) {
		observers?.remove(using: token)
	}
}
extension SignalProducer where Value == Date, Error == Never {
	public static func timer(interval: DispatchTimeInterval, on scheduler: DateScheduler) -> SignalProducer<Value, Error> {
		return timer(interval: interval, on: scheduler, leeway: interval * 0.1)
	}
	public static func timer(interval: DispatchTimeInterval, on scheduler: DateScheduler, leeway: DispatchTimeInterval) -> SignalProducer<Value, Error> {
		precondition(interval.timeInterval >= 0)
		precondition(leeway.timeInterval >= 0)
		return SignalProducer { observer, lifetime in
			lifetime += scheduler.schedule(
				after: scheduler.currentDate.addingTimeInterval(interval),
				interval: interval,
				leeway: leeway,
				action: { observer.send(value: scheduler.currentDate) }
			)
		}
	}
}
extension SignalProducer where Error == Never {
	public static func interval<S: Sequence>(
		_ values: S,
		interval: DispatchTimeInterval,
		on scheduler: DateScheduler
	) -> SignalProducer<S.Element, Error> where S.Iterator.Element == Value {
		return SignalProducer { observer, lifetime in
			var iterator = values.makeIterator()
			lifetime += scheduler.schedule(
				after: scheduler.currentDate.addingTimeInterval(interval),
				interval: interval,
				leeway: interval * 0.1,
				action: {
					switch iterator.next() {
					case let .some(value):
						observer.send(value: value)
					case .none:
						observer.sendCompleted()
					}
				}
			)
		}
	}
	public static func interval(
		_ interval: DispatchTimeInterval,
		on scheduler: DateScheduler
	) -> SignalProducer where Value == Int {
		.interval(0..., interval: interval, on: scheduler)
	}
}