import Foundation
import Dispatch
public final class Signal<Value, Error: Swift.Error> {
	private let core: Core
	private final class Core {
		private let disposable: CompositeDisposable
		private var state: State
		private let stateLock: Lock
		private let sendLock: Lock
		fileprivate init(_ generator: (Observer, Lifetime) -> Void) {
			state = .alive(Bag(), hasDeinitialized: false)
			stateLock = Lock.make()
			sendLock = Lock.make()
			disposable = CompositeDisposable()
			generator(Observer(action: self.send, interruptsOnDeinit: true), Lifetime(disposable))
		}
		private func send(_ event: Event) {
			if event.isTerminating {
				self.stateLock.lock()
				if case let .alive(observers, _) = state {
					self.state = .terminating(observers, .init(event))
					self.stateLock.unlock()
				} else {
					self.stateLock.unlock()
				}
				tryToCommitTermination()
			} else {
				self.sendLock.lock()
				self.stateLock.lock()
				if case let .alive(observers, _) = self.state {
					self.stateLock.unlock()
					for observer in observers {
						observer.send(event)
					}
				} else {
					self.stateLock.unlock()
				}
				self.sendLock.unlock()
				stateLock.lock()
				if case .terminating = state {
					stateLock.unlock()
					tryToCommitTermination()
				} else {
					stateLock.unlock()
				}
			}
		}
		fileprivate func observe(_ observer: Observer) -> Disposable? {
			var token: Bag<Observer>.Token?
			stateLock.lock()
			if case let .alive(observers, hasDeinitialized) = state {
				var newObservers = observers
				token = newObservers.insert(observer)
				self.state = .alive(newObservers, hasDeinitialized: hasDeinitialized)
			}
			stateLock.unlock()
			if let token = token {
				return AnyDisposable { [weak self] in
					self?.removeObserver(with: token)
				}
			} else {
				observer.sendInterrupted()
				return nil
			}
		}
		private func removeObserver(with token: Bag<Observer>.Token) {
			stateLock.lock()
			if case let .alive(observers, hasDeinitialized) = state {
				var newObservers = observers
				let observer = newObservers.remove(using: token)
				self.state = .alive(newObservers, hasDeinitialized: hasDeinitialized)
				withExtendedLifetime(observer) {
					tryToDisposeSilentlyIfQualified(unlocking: stateLock)
				}
			} else {
				stateLock.unlock()
			}
		}
		private func tryToCommitTermination() {
			stateLock.lock()
			if case let .terminating(observers, terminationKind) = state {
				if sendLock.try() {
					state = .terminated
					stateLock.unlock()
					if let event = terminationKind.materialize() {
						for observer in observers {
							observer.send(event)
						}
					}
					sendLock.unlock()
					disposable.dispose()
					return
				}
			}
			stateLock.unlock()
		}
		private func tryToDisposeSilentlyIfQualified(unlocking stateLock: Lock) {
			assert(!stateLock.try(), "Calling `unconditionallyTerminate` without acquiring `stateLock`.")
			if case let .alive(observers, true) = state, observers.isEmpty {
				if sendLock.try() {
					self.state = .terminated
					stateLock.unlock()
					sendLock.unlock()
					disposable.dispose()
					return
				}
				self.state = .terminating(Bag(), .silent)
				stateLock.unlock()
				tryToCommitTermination()
				return
			}
			stateLock.unlock()
		}
		fileprivate func signalDidDeinitialize() {
			stateLock.lock()
			if case let .alive(observers, false) = state {
				state = .alive(observers, hasDeinitialized: true)
			}
			tryToDisposeSilentlyIfQualified(unlocking: stateLock)
		}
		deinit {
			disposable.dispose()
		}
	}
	public init(_ generator: (Observer, Lifetime) -> Void) {
		core = Core(generator)
	}
	@discardableResult
	public func observe(_ observer: Observer) -> Disposable? {
		return core.observe(observer)
	}
	deinit {
		core.signalDidDeinitialize()
	}
	private enum State {
		enum TerminationKind {
			case completed
			case interrupted
			case failed(Swift.Error)
			case silent
			init(_ event: Event) {
				switch event {
				case .value:
					fatalError()
				case .interrupted:
					self = .interrupted
				case let .failed(error):
					self = .failed(error)
				case .completed:
					self = .completed
				}
			}
			func materialize() -> Event? {
				switch self {
				case .completed:
					return .completed
				case .interrupted:
					return .interrupted
				case let .failed(error):
					return .failed(error as! Error)
				case .silent:
					return nil
				}
			}
		}
		case alive(Bag<Observer>, hasDeinitialized: Bool)
		case terminating(Bag<Observer>, TerminationKind)
		case terminated
	}
}
extension Signal {
	public static var never: Signal {
		return self.init { observer, lifetime in
			lifetime.observeEnded { _ = observer }
		}
	}
	public static var empty: Signal {
		return self.init { observer, _ in
			observer.sendCompleted()
		}
	}
	public static func pipe(disposable: Disposable? = nil) -> (output: Signal, input: Observer) {
		var observer: Observer!
		let signal = self.init { innerObserver, lifetime in
			observer = innerObserver
			lifetime += disposable
		}
		return (signal, observer)
	}
}
public protocol SignalProtocol: AnyObject {
	associatedtype Value
	associatedtype Error: Swift.Error
	var signal: Signal<Value, Error> { get }
}
extension Signal: SignalProtocol {
	public var signal: Signal<Value, Error> {
		return self
	}
}
extension Signal: SignalProducerConvertible {
	public var producer: SignalProducer<Value, Error> {
		return SignalProducer(self)
	}
}
extension Signal {
	@discardableResult
	public func observe(_ action: @escaping Signal<Value, Error>.Observer.Action) -> Disposable? {
		return observe(Observer(action))
	}
	@discardableResult
	public func observeResult(_ action: @escaping (Result<Value, Error>) -> Void) -> Disposable? {
		return observe(
			Observer(
				value: { action(.success($0)) },
				failed: { action(.failure($0)) }
			)
		)
	}
	@discardableResult
	public func observeCompleted(_ action: @escaping () -> Void) -> Disposable? {
		return observe(Observer(completed: action))
	}
	@discardableResult
	public func observeFailed(_ action: @escaping (Error) -> Void) -> Disposable? {
		return observe(Observer(failed: action))
	}
	@discardableResult
	public func observeInterrupted(_ action: @escaping () -> Void) -> Disposable? {
		return observe(Observer(interrupted: action))
	}
}
extension Signal where Error == Never {
	@discardableResult
	public func observeValues(_ action: @escaping (Value) -> Void) -> Disposable? {
		return observe(Observer(value: action))
	}
}
extension Signal {
	internal func flatMapEvent<U, E>(_ transform: @escaping Event.Transformation<U, E>) -> Signal<U, E> {
		return Signal<U, E> { output, lifetime in
			let input = transform(output, lifetime)
			lifetime += self.observe(input.assumeUnboundDemand())
		}
	}
	public func map<U>(_ transform: @escaping (Value) -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.map(transform))
	}
	public func map<U>(value: U) -> Signal<U, Error> {
		return map { _ in value }
	}
	public func map<U>(_ keyPath: KeyPath<Value, U>) -> Signal<U, Error> {
		return map { $0[keyPath: keyPath] }
	}
	public func mapError<F>(_ transform: @escaping (Error) -> F) -> Signal<Value, F> {
		return flatMapEvent(Signal.Event.mapError(transform))
	}
	public func lazyMap<U>(on scheduler: Scheduler, transform: @escaping (Value) -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.lazyMap(on: scheduler, transform: transform))
	}
	public func filter(_ isIncluded: @escaping (Value) -> Bool) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.filter(isIncluded))
	}
	public func compactMap<U>(_ transform: @escaping (Value) -> U?) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.compactMap(transform))
	}
	@available(*, deprecated, renamed: "compactMap")
	public func filterMap<U>(_ transform: @escaping (Value) -> U?) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.compactMap(transform))
	}
}
extension Signal where Value: OptionalProtocol {
	public func skipNil() -> Signal<Value.Wrapped, Error> {
		return flatMapEvent(Signal.Event.skipNil)
	}
}
extension Signal {
	public func take(first count: Int) -> Signal<Value, Error> {
		precondition(count >= 0)
		guard count >= 1 else { return .empty }
		return flatMapEvent(Signal.Event.take(first: count))
	}
	public func collect() -> Signal<[Value], Error> {
		return flatMapEvent(Signal.Event.collect)
	}
	public func collect(count: Int) -> Signal<[Value], Error> {
		return flatMapEvent(Signal.Event.collect(count: count))
	}
	public func collect(_ shouldEmit: @escaping (_ collectedValues: [Value]) -> Bool) -> Signal<[Value], Error> {
		return flatMapEvent(Signal.Event.collect(shouldEmit))
	}
	public func collect(_ shouldEmit: @escaping (_ collected: [Value], _ latest: Value) -> Bool) -> Signal<[Value], Error> {
		return flatMapEvent(Signal.Event.collect(shouldEmit))
	}
	public func collect(every interval: DispatchTimeInterval, on scheduler: DateScheduler, skipEmpty: Bool = false, discardWhenCompleted: Bool = true) -> Signal<[Value], Error> {
		return flatMapEvent(Signal.Event.collect(every: interval, on: scheduler, skipEmpty: skipEmpty, discardWhenCompleted: discardWhenCompleted))
	}
	public func observe(on scheduler: Scheduler) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.observe(on: scheduler))
	}
}
extension Signal {
	public func combineLatest<U>(with other: Signal<U, Error>) -> Signal<(Value, U), Error> {
		return Signal.combineLatest(self, other)
	}
	public func merge(with other: Signal<Value, Error>) -> Signal<Value, Error> {
		return Signal.merge(self, other)
	}
	public func delay(_ interval: TimeInterval, on scheduler: DateScheduler) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.delay(interval, on: scheduler))
	}
	public func skip(first count: Int) -> Signal<Value, Error> {
		guard count != 0 else { return self }
		return flatMapEvent(Signal.Event.skip(first: count))
	}
	public func materialize() -> Signal<Event, Never> {
		return flatMapEvent(Signal.Event.materialize)
	}
	public func materializeResults() -> Signal<Result<Value, Error>, Never> {
		return flatMapEvent(Signal.Event.materializeResults)
	}
}
extension Signal where Value: EventProtocol, Error == Never {
	public func dematerialize() -> Signal<Value.Value, Value.Error> {
		return flatMapEvent(Signal.Event.dematerialize)
	}
}
extension Signal where Error == Never {
	public func dematerializeResults<Success, Failure>() -> Signal<Success, Failure> where Value == Result<Success, Failure> {
		return flatMapEvent(Signal.Event.dematerializeResults)
	}
}
extension Signal {
	public func on(
		event: ((Event) -> Void)? = nil,
		failed: ((Error) -> Void)? = nil,
		completed: (() -> Void)? = nil,
		interrupted: (() -> Void)? = nil,
		terminated: (() -> Void)? = nil,
		disposed: (() -> Void)? = nil,
		value: ((Value) -> Void)? = nil
	) -> Signal<Value, Error> {
		return Signal { observer, lifetime in
			if let action = disposed {
				lifetime.observeEnded(action)
			}
			lifetime += signal.observe { receivedEvent in
				event?(receivedEvent)
				switch receivedEvent {
				case let .value(v):
					value?(v)
				case let .failed(error):
					failed?(error)
				case .completed:
					completed?()
				case .interrupted:
					interrupted?()
				}
				if receivedEvent.isTerminating {
					terminated?()
				}
				observer.send(receivedEvent)
			}
		}
	}
}
private struct SampleState<Value> {
	var latestValue: Value?
	var isSignalCompleted: Bool = false
	var isSamplerCompleted: Bool = false
}
extension Signal {
	public func sample<T>(with sampler: Signal<T, Never>) -> Signal<(Value, T), Error> {
		return Signal<(Value, T), Error> { observer, lifetime in
			let state = Atomic(SampleState<Value>())
			lifetime += self.observe { event in
				switch event {
				case let .value(value):
					state.modify {
						$0.latestValue = value
					}
				case let .failed(error):
					observer.send(error: error)
				case .completed:
					let shouldComplete: Bool = state.modify {
						$0.isSignalCompleted = true
						return $0.isSamplerCompleted
					}
					if shouldComplete {
						observer.sendCompleted()
					}
				case .interrupted:
					observer.sendInterrupted()
				}
			}
			lifetime += sampler.observe { event in
				switch event {
				case .value(let samplerValue):
					if let value = state.value.latestValue {
						observer.send(value: (value, samplerValue))
					}
				case .completed:
					let shouldComplete: Bool = state.modify {
						$0.isSamplerCompleted = true
						return $0.isSignalCompleted
					}
					if shouldComplete {
						observer.sendCompleted()
					}
				case .interrupted:
					observer.sendInterrupted()
				case .failed:
					break
				}
			}
		}
	}
	public func sample(on sampler: Signal<(), Never>) -> Signal<Value, Error> {
		return sample(with: sampler)
			.map { $0.0 }
	}
	public func withLatest<U>(from samplee: Signal<U, Never>) -> Signal<(Value, U), Error> {
		return Signal<(Value, U), Error> { observer, lifetime in
			let state = Atomic<U?>(nil)
			lifetime += samplee.observeValues { value in
				state.value = value
			}
			lifetime += self.observe { event in
				switch event {
				case let .value(value):
					if let value2 = state.value {
						observer.send(value: (value, value2))
					}
				case .completed:
					observer.sendCompleted()
				case let .failed(error):
					observer.send(error: error)
				case .interrupted:
					observer.sendInterrupted()
				}
			}
		}
	}
	public func withLatest<U>(from samplee: SignalProducer<U, Never>) -> Signal<(Value, U), Error> {
		return Signal<(Value, U), Error> { observer, lifetime in
			samplee.startWithSignal { signal, disposable in
				lifetime += disposable
				lifetime += self.withLatest(from: signal).observe(observer)
			}
		}
	}
	public func withLatest<Samplee: SignalProducerConvertible>(from samplee: Samplee) -> Signal<(Value, Samplee.Value), Error> where Samplee.Error == Never {
		return withLatest(from: samplee.producer)
	}
}
extension Signal {
	public func take(during lifetime: Lifetime) -> Signal<Value, Error> {
		return Signal<Value, Error> { observer, innerLifetime in
			innerLifetime += self.observe(observer)
			innerLifetime += lifetime.observeEnded(observer.sendCompleted)
		}
	}
	public func take(until trigger: Signal<(), Never>) -> Signal<Value, Error> {
		return Signal<Value, Error> { observer, lifetime in
			lifetime += self.observe(observer)
			lifetime += trigger.observe { event in
				switch event {
				case .value, .completed:
					observer.sendCompleted()
				case .failed, .interrupted:
					break
				}
			}
		}
	}
	public func skip(until trigger: Signal<(), Never>) -> Signal<Value, Error> {
		return Signal { observer, lifetime in
			let disposable = SerialDisposable()
			lifetime += disposable
			disposable.inner = trigger.observe { event in
				switch event {
				case .value, .completed:
					disposable.inner = self.observe(observer)
				case .failed, .interrupted:
					break
				}
			}
		}
	}
	public func combinePrevious(_ initial: Value) -> Signal<(Value, Value), Error> {
		return flatMapEvent(Signal.Event.combinePrevious(initial: initial))
	}
	public func combinePrevious() -> Signal<(Value, Value), Error> {
		return flatMapEvent(Signal.Event.combinePrevious(initial: nil))
	}
	public func reduce<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.reduce(initialResult, nextPartialResult))
	}
	public func reduce<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.reduce(into: initialResult, nextPartialResult))
	}
	public func scan<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.scan(initialResult, nextPartialResult))
	}
	public func scan<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.scan(into: initialResult, nextPartialResult))
	}
	public func scanMap<State, U>(_ initialState: State, _ next: @escaping (State, Value) -> (State, U)) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.scanMap(initialState, next))
	}
	public func scanMap<State, U>(into initialState: State, _ next: @escaping (inout State, Value) -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.scanMap(into: initialState, next))
	}
}
extension Signal where Value: Equatable {
	public func skipRepeats() -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.skipRepeats(==))
	}
}
extension Signal {
	public func skipRepeats(_ isEquivalent: @escaping (Value, Value) -> Bool) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.skipRepeats(isEquivalent))
	}
	public func skip(while shouldContinue: @escaping (Value) -> Bool) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.skip(while: shouldContinue))
	}
	public func take(untilReplacement signal: Signal<Value, Error>) -> Signal<Value, Error> {
		return Signal { observer, lifetime in
			let signalDisposable = self.observe { event in
				switch event {
				case .completed:
					break
				case .value, .failed, .interrupted:
					observer.send(event)
				}
			}
			lifetime += signalDisposable
			lifetime += signal.observe { event in
				signalDisposable?.dispose()
				observer.send(event)
			}
		}
	}
	public func take(last count: Int) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.take(last: count))
	}
	public func take(while shouldContinue: @escaping (Value) -> Bool) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.take(while: shouldContinue))
	}
}
extension Signal {
	public func zip<U>(with other: Signal<U, Error>) -> Signal<(Value, U), Error> {
		return Signal.zip(self, other)
	}
	public func throttle(_ interval: TimeInterval, on scheduler: DateScheduler) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.throttle(interval, on: scheduler))
	}
	public func throttle<P: PropertyProtocol>(while shouldThrottle: P, on scheduler: Scheduler) -> Signal<Value, Error>
		where P.Value == Bool
	{
		return Signal { observer, lifetime in
			let initial: ThrottleWhileState<Value> = .resumed
			let state = Atomic(initial)
			let schedulerDisposable = SerialDisposable()
			lifetime += schedulerDisposable
			lifetime += shouldThrottle.producer
				.skipRepeats()
				.startWithValues { shouldThrottle in
					let valueToSend = state.modify { state -> Value? in
						guard !state.isTerminated else { return nil }
						if shouldThrottle {
							state = .throttled(nil)
						} else {
							defer { state = .resumed }
							if case let .throttled(value?) = state {
								return value
							}
						}
						return nil
					}
					if let value = valueToSend {
						schedulerDisposable.inner = scheduler.schedule {
							observer.send(value: value)
						}
					}
				}
			lifetime += self.observe { event in
				let eventToSend = state.modify { state -> Event? in
					switch event {
					case let .value(value):
						switch state {
						case .throttled:
							state = .throttled(value)
							return nil
						case .resumed:
							return event
						case .terminated:
							return nil
						}
					case .completed, .interrupted, .failed:
						state = .terminated
						return event
					}
				}
				if let event = eventToSend {
					schedulerDisposable.inner = scheduler.schedule {
						observer.send(event)
					}
				}
			}
		}
	}
	public func debounce(_ interval: TimeInterval, on scheduler: DateScheduler, discardWhenCompleted: Bool = true) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.debounce(interval, on: scheduler, discardWhenCompleted: discardWhenCompleted))
	}
}
extension Signal {
	public func uniqueValues<Identity: Hashable>(_ transform: @escaping (Value) -> Identity) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.uniqueValues(transform))
	}
}
extension Signal where Value: Hashable {
	public func uniqueValues() -> Signal<Value, Error> {
		return uniqueValues { $0 }
	}
}
private enum ThrottleWhileState<Value> {
	case resumed
	case throttled(Value?)
	case terminated
	var isTerminated: Bool {
		switch self {
		case .terminated:
			return true
		case .resumed, .throttled:
			return false
		}
	}
}
private protocol SignalAggregateStrategy: AnyObject {
	func update(_ value: Any, at position: Int)
	func complete(at position: Int)
	init(count: Int, action: @escaping (AggregateStrategyEvent) -> Void)
}
private enum AggregateStrategyEvent {
	case value(ContiguousArray<Any>)
	case completed
}
extension Signal {
	private final class CombineLatestStrategy: SignalAggregateStrategy {
		private enum Placeholder {
			case none
		}
		var values: ContiguousArray<Any>
		private var _haveAllSentInitial: Bool
		private var haveAllSentInitial: Bool {
			get {
				if _haveAllSentInitial {
					return true
				}
				_haveAllSentInitial = values.allSatisfy { !($0 is Placeholder) }
				return _haveAllSentInitial
			}
		}
		private let count: Int
		private let lock: Lock
		private let completion: Atomic<Int>
		private let action: (AggregateStrategyEvent) -> Void
		func update(_ value: Any, at position: Int) {
			lock.lock()
			values[position] = value
			if haveAllSentInitial {
				action(.value(values))
			}
			lock.unlock()
			if completion.value == self.count, lock.try() {
				action(.completed)
				lock.unlock()
			}
		}
		func complete(at position: Int) {
			let count: Int = completion.modify { count in
				count += 1
				return count
			}
			if count == self.count, lock.try() {
				action(.completed)
				lock.unlock()
			}
		}
		init(count: Int, action: @escaping (AggregateStrategyEvent) -> Void) {
			self.count = count
			self.lock = Lock.make()
			self.values = ContiguousArray(repeating: Placeholder.none, count: count)
			self._haveAllSentInitial = false
			self.completion = Atomic(0)
			self.action = action
		}
	}
	private final class ZipStrategy: SignalAggregateStrategy {
		private let stateLock: Lock
		private let sendLock: Lock
		private var values: ContiguousArray<[Any]>
		private var canEmit: Bool {
			return values.reduce(true) { $0 && !$1.isEmpty }
		}
		private var hasConcurrentlyCompleted: Bool
		private var isCompleted: ContiguousArray<Bool>
		private var hasCompletedAndEmptiedSignal: Bool {
			return Swift.zip(values, isCompleted).contains(where: { $0.0.isEmpty && $0.1 })
		}
		private var areAllCompleted: Bool {
			return isCompleted.reduce(true) { $0 && $1 }
		}
		private let action: (AggregateStrategyEvent) -> Void
		func update(_ value: Any, at position: Int) {
			stateLock.lock()
			values[position].append(value)
			if canEmit {
				var buffer = ContiguousArray<Any>()
				buffer.reserveCapacity(values.count)
				for index in values.indices {
					buffer.append(values[index].removeFirst())
				}
				let shouldComplete = areAllCompleted || hasCompletedAndEmptiedSignal
				sendLock.lock()
				stateLock.unlock()
				action(.value(buffer))
				if shouldComplete {
					action(.completed)
				}
				sendLock.unlock()
				stateLock.lock()
				if hasConcurrentlyCompleted {
					sendLock.lock()
					action(.completed)
					sendLock.unlock()
				}
			}
			stateLock.unlock()
		}
		func complete(at position: Int) {
			stateLock.lock()
			isCompleted[position] = true
			if hasConcurrentlyCompleted || areAllCompleted || hasCompletedAndEmptiedSignal {
				if sendLock.try() {
					stateLock.unlock()
					action(.completed)
					sendLock.unlock()
					return
				}
				hasConcurrentlyCompleted = true
			}
			stateLock.unlock()
		}
		init(count: Int, action: @escaping (AggregateStrategyEvent) -> Void) {
			self.values = ContiguousArray(repeating: [], count: count)
			self.hasConcurrentlyCompleted = false
			self.isCompleted = ContiguousArray(repeating: false, count: count)
			self.action = action
			self.sendLock = Lock.make()
			self.stateLock = Lock.make()
		}
	}
	private final class AggregateBuilder<Strategy: SignalAggregateStrategy> {
		fileprivate var startHandlers: [(_ index: Int, _ strategy: Strategy, _ action: @escaping (Signal<Never, Error>.Event) -> Void) -> Disposable?]
		init() {
			self.startHandlers = []
		}
		@discardableResult
		func add<U>(_ signal: Signal<U, Error>) -> Self {
			startHandlers.append { index, strategy, action in
				return signal.observe { event in
					switch event {
					case let .value(value):
						strategy.update(value, at: index)
					case .completed:
						strategy.complete(at: index)
					case .interrupted:
						action(.interrupted)
					case let .failed(error):
						action(.failed(error))
					}
				}
			}
			return self
		}
	}
	private convenience init<Strategy>(_ builder: AggregateBuilder<Strategy>, _ transform: @escaping (ContiguousArray<Any>) -> Value) {
		self.init { observer, lifetime in
			let strategy = Strategy(count: builder.startHandlers.count) { event in
				switch event {
				case let .value(value):
					observer.send(value: transform(value))
				case .completed:
					observer.sendCompleted()
				}
			}
			for (index, action) in builder.startHandlers.enumerated() where !lifetime.hasEnded {
				lifetime += action(index, strategy) { observer.send($0.promoteValue()) }
			}
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, U, S: Sequence>(_ strategy: Strategy.Type, _ signals: S) where Value == [U], S.Iterator.Element == Signal<U, Error> {
		self.init(signals.reduce(AggregateBuilder<Strategy>()) { $0.add($1) }) { $0.map { $0 as! U } }
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>) where Value == (A, B) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b)) {
			return ($0[0] as! A, $0[1] as! B)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>) where Value == (A, B, C) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>) where Value == (A, B, C, D) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>) where Value == (A, B, C, D, E) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E, F>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>) where Value == (A, B, C, D, E, F) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e).add(f)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E, $0[5] as! F)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E, F, G>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>) where Value == (A, B, C, D, E, F, G) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e).add(f).add(g)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E, $0[5] as! F, $0[6] as! G)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E, F, G, H>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>) where Value == (A, B, C, D, E, F, G, H) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e).add(f).add(g).add(h)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E, $0[5] as! F, $0[6] as! G, $0[7] as! H)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E, F, G, H, I>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>) where Value == (A, B, C, D, E, F, G, H, I) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e).add(f).add(g).add(h).add(i)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E, $0[5] as! F, $0[6] as! G, $0[7] as! H, $0[8] as! I)
		}
	}
	private convenience init<Strategy: SignalAggregateStrategy, A, B, C, D, E, F, G, H, I, J>(_ strategy: Strategy.Type, _ a: Signal<A, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>, _ j: Signal<J, Error>) where Value == (A, B, C, D, E, F, G, H, I, J) {
		self.init(AggregateBuilder<Strategy>().add(a).add(b).add(c).add(d).add(e).add(f).add(g).add(h).add(i).add(j)) {
			return ($0[0] as! A, $0[1] as! B, $0[2] as! C, $0[3] as! D, $0[4] as! E, $0[5] as! F, $0[6] as! G, $0[7] as! H, $0[8] as! I, $0[9] as! J)
		}
	}
	public static func combineLatest<B>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>) -> Signal<(Value, B), Error> {
		return .init(CombineLatestStrategy.self, a, b)
	}
	public static func combineLatest<B, C>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>) -> Signal<(Value, B, C), Error> {
		return .init(CombineLatestStrategy.self, a, b, c)
	}
	public static func combineLatest<B, C, D>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>) -> Signal<(Value, B, C, D), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d)
	}
	public static func combineLatest<B, C, D, E>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>) -> Signal<(Value, B, C, D, E), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e)
	}
	public static func combineLatest<B, C, D, E, F>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>) -> Signal<(Value, B, C, D, E, F), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e, f)
	}
	public static func combineLatest<B, C, D, E, F, G>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>) -> Signal<(Value, B, C, D, E, F, G), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e, f, g)
	}
	public static func combineLatest<B, C, D, E, F, G, H>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>) -> Signal<(Value, B, C, D, E, F, G, H), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e, f, g, h)
	}
	public static func combineLatest<B, C, D, E, F, G, H, I>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>) -> Signal<(Value, B, C, D, E, F, G, H, I), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e, f, g, h, i)
	}
	public static func combineLatest<B, C, D, E, F, G, H, I, J>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>, _ j: Signal<J, Error>) -> Signal<(Value, B, C, D, E, F, G, H, I, J), Error> {
		return .init(CombineLatestStrategy.self, a, b, c, d, e, f, g, h, i, j)
	}
	public static func combineLatest<S: Sequence>(_ signals: S) -> Signal<[Value], Error> where S.Iterator.Element == Signal<Value, Error> {
		return .init(CombineLatestStrategy.self, signals)
	}
	public static func zip<B>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>) -> Signal<(Value, B), Error> {
		return .init(ZipStrategy.self, a, b)
	}
	public static func zip<B, C>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>) -> Signal<(Value, B, C), Error> {
		return .init(ZipStrategy.self, a, b, c)
	}
	public static func zip<B, C, D>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>) -> Signal<(Value, B, C, D), Error> {
		return .init(ZipStrategy.self, a, b, c, d)
	}
	public static func zip<B, C, D, E>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>) -> Signal<(Value, B, C, D, E), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e)
	}
	public static func zip<B, C, D, E, F>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>) -> Signal<(Value, B, C, D, E, F), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e, f)
	}
	public static func zip<B, C, D, E, F, G>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>) -> Signal<(Value, B, C, D, E, F, G), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e, f, g)
	}
	public static func zip<B, C, D, E, F, G, H>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>) -> Signal<(Value, B, C, D, E, F, G, H), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e, f, g, h)
	}
	public static func zip<B, C, D, E, F, G, H, I>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>) -> Signal<(Value, B, C, D, E, F, G, H, I), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e, f, g, h, i)
	}
	public static func zip<B, C, D, E, F, G, H, I, J>(_ a: Signal<Value, Error>, _ b: Signal<B, Error>, _ c: Signal<C, Error>, _ d: Signal<D, Error>, _ e: Signal<E, Error>, _ f: Signal<F, Error>, _ g: Signal<G, Error>, _ h: Signal<H, Error>, _ i: Signal<I, Error>, _ j: Signal<J, Error>) -> Signal<(Value, B, C, D, E, F, G, H, I, J), Error> {
		return .init(ZipStrategy.self, a, b, c, d, e, f, g, h, i, j)
	}
	public static func zip<S: Sequence>(_ signals: S) -> Signal<[Value], Error> where S.Iterator.Element == Signal<Value, Error> {
		return .init(ZipStrategy.self, signals)
	}
}
extension Signal {
	public func timeout(after interval: TimeInterval, raising error: Error, on scheduler: DateScheduler) -> Signal<Value, Error> {
		precondition(interval >= 0)
		return Signal { observer, lifetime in
			let date = scheduler.currentDate.addingTimeInterval(interval)
			lifetime += scheduler.schedule(after: date) {
				observer.send(error: error)
			}
			lifetime += self.observe(observer)
		}
	}
}
extension Signal where Error == Never {
	public func promoteError<F>(_: F.Type = F.self) -> Signal<Value, F> {
		return flatMapEvent(Signal.Event.promoteError(F.self))
	}
	public func promoteError(_: Error.Type = Error.self) -> Signal<Value, Error> {
		return self
	}
	public func timeout<NewError>(
		after interval: TimeInterval,
		raising error: NewError,
		on scheduler: DateScheduler
	) -> Signal<Value, NewError> {
		return self
			.promoteError(NewError.self)
			.timeout(after: interval, raising: error, on: scheduler)
	}
}
extension Signal where Value == Never {
	public func promoteValue<U>(_: U.Type = U.self) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.promoteValue(U.self))
	}
	public func promoteValue(_: Value.Type = Value.self) -> Signal<Value, Error> {
		return self
	}
}
extension Signal where Value == Bool {
	public func negate() -> Signal<Value, Error> {
		return self.map(!)
	}
	public func and(_ signal: Signal<Value, Error>) -> Signal<Value, Error> {
		return type(of: self).all([self, signal])
	}
	public static func all<BooleansCollection: Collection>(_ booleans: BooleansCollection) -> Signal<Value, Error> where BooleansCollection.Element == Signal<Value, Error> {
		return combineLatest(booleans).map { $0.reduce(true) { $0 && $1 } }
	}
    public static func all(_ booleans: Signal<Value, Error>...) -> Signal<Value, Error> {
        return .all(booleans)
    }
	public func or(_ signal: Signal<Value, Error>) -> Signal<Value, Error> {
		return type(of: self).any([self, signal])
	}
	public static func any<BooleansCollection: Collection>(_ booleans: BooleansCollection) -> Signal<Value, Error> where BooleansCollection.Element == Signal<Value, Error> {
		return combineLatest(booleans).map { $0.reduce(false) { $0 || $1 } }
    }
    public static func any(_ booleans: Signal<Value, Error>...) -> Signal<Value, Error> {
        return .any(booleans)
    }
}
extension Signal {
	public func attempt(_ action: @escaping (Value) -> Result<(), Error>) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.attempt(action))
	}
	public func attemptMap<U>(_ transform: @escaping (Value) -> Result<U, Error>) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.attemptMap(transform))
	}
}
extension Signal where Error == Never {
	public func attempt(_ action: @escaping (Value) throws -> Void) -> Signal<Value, Swift.Error> {
		return self
			.promoteError(Swift.Error.self)
			.attempt(action)
	}
	public func attemptMap<U>(_ transform: @escaping (Value) throws -> U) -> Signal<U, Swift.Error> {
		return self
			.promoteError(Swift.Error.self)
			.attemptMap(transform)
	}
}
extension Signal where Error == Swift.Error {
	public func attempt(_ action: @escaping (Value) throws -> Void) -> Signal<Value, Error> {
		return flatMapEvent(Signal.Event.attempt(action))
	}
	public func attemptMap<U>(_ transform: @escaping (Value) throws -> U) -> Signal<U, Error> {
		return flatMapEvent(Signal.Event.attemptMap(transform))
	}
}