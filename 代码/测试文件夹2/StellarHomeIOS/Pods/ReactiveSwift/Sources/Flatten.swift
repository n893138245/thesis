public struct FlattenStrategy {
	fileprivate enum Kind {
		case concurrent(limit: UInt)
		case latest
		case race
		case throttle
	}
	fileprivate let kind: Kind
	private init(kind: Kind) {
		self.kind = kind
	}
	public static let merge = FlattenStrategy(kind: .concurrent(limit: .max))
	public static let concat = FlattenStrategy(kind: .concurrent(limit: 1))
	public static func concurrent(limit: UInt) -> FlattenStrategy {
		return FlattenStrategy(kind: .concurrent(limit: limit))
	}
	public static let latest = FlattenStrategy(kind: .latest)
	public static let race = FlattenStrategy(kind: .race)
	public static let throttle = FlattenStrategy(kind: .throttle)
}
extension Signal where Value: SignalProducerConvertible, Error == Value.Error {
	public func flatten(_ strategy: FlattenStrategy) -> Signal<Value.Value, Error> {
		switch strategy.kind {
		case .concurrent(let limit):
			return self.concurrent(limit: limit)
		case .latest:
			return self.switchToLatest()
		case .race:
			return self.race()
		case .throttle:
			return self.throttle()
		}
	}
}
extension Signal where Value: SignalProducerConvertible, Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> Signal<Value.Value, Value.Error> {
		return self
			.promoteError(Value.Error.self)
			.flatten(strategy)
	}
}
extension Signal where Value: SignalProducerConvertible, Error == Never, Value.Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> Signal<Value.Value, Value.Error> {
		switch strategy.kind {
		case .concurrent(let limit):
			return self.concurrent(limit: limit)
		case .latest:
			return self.switchToLatest()
		case .race:
			return self.race()
		case .throttle:
			return self.throttle()
		}
	}
}
extension Signal where Value: SignalProducerConvertible, Value.Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> Signal<Value.Value, Error> {
		return self.flatMap(strategy) { $0.producer.promoteError(Error.self) }
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Value.Error {
	public func flatten(_ strategy: FlattenStrategy) -> SignalProducer<Value.Value, Error> {
		switch strategy.kind {
		case .concurrent(let limit):
			return self.concurrent(limit: limit)
		case .latest:
			return self.switchToLatest()
		case .race:
			return self.race()
		case .throttle:
			return self.throttle()
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> SignalProducer<Value.Value, Value.Error> {
		return self
			.promoteError(Value.Error.self)
			.flatten(strategy)
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Never, Value.Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> SignalProducer<Value.Value, Value.Error> {
		switch strategy.kind {
		case .concurrent(let limit):
			return self.concurrent(limit: limit)
		case .latest:
			return self.switchToLatest()
		case .race:
			return self.race()
		case .throttle:
			return self.throttle()
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Value.Error == Never {
	public func flatten(_ strategy: FlattenStrategy) -> SignalProducer<Value.Value, Error> {
		return self.flatMap(strategy) { $0.producer.promoteError(Error.self) }
	}
}
extension Signal where Value: Sequence {
	public func flatten() -> Signal<Value.Iterator.Element, Error> {
		return self.flatMap(.merge, SignalProducer.init)
	}
}
extension SignalProducer where Value: Sequence {
	public func flatten() -> SignalProducer<Value.Iterator.Element, Error> {
		return self.flatMap(.merge, SignalProducer<Value.Iterator.Element, Never>.init)
	}
}
extension Signal where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func concurrent(limit: UInt) -> Signal<Value.Value, Error> {
		precondition(limit > 0, "The concurrent limit must be greater than zero.")
		return Signal<Value.Value, Error> { relayObserver, lifetime in
			lifetime += self.observeConcurrent(relayObserver, limit, lifetime)
		}
	}
	fileprivate func observeConcurrent(_ observer: Signal<Value.Value, Error>.Observer, _ limit: UInt, _ lifetime: Lifetime) -> Disposable? {
		let state = Atomic(ConcurrentFlattenState<Value.Value, Error>(limit: limit))
		func startNextIfNeeded() {
			while let producer = state.modify({ $0.dequeue() }) {
				let producerState = UnsafeAtomicState<ProducerState>(.starting)
				let deinitializer = ScopedDisposable(AnyDisposable(producerState.deinitialize))
				producer.startWithSignal { signal, inner in
					let handle = lifetime += inner
					signal.observe { event in
						switch event {
						case .completed, .interrupted:
							handle?.dispose()
							let shouldComplete: Bool = state.modify { state in
								state.activeCount -= 1
								return state.shouldComplete
							}
							withExtendedLifetime(deinitializer) {
								if shouldComplete {
									observer.sendCompleted()
								} else if producerState.is(.started) {
									startNextIfNeeded()
								}
							}
						case .value, .failed:
							observer.send(event)
						}
					}
				}
				withExtendedLifetime(deinitializer) {
					producerState.setStarted()
				}
			}
		}
		return observe { event in
			switch event {
			case let .value(value):
				state.modify { $0.queue.append(value.producer) }
				startNextIfNeeded()
			case let .failed(error):
				observer.send(error: error)
			case .completed:
				let shouldComplete: Bool = state.modify { state in
					state.isOuterCompleted = true
					return state.shouldComplete
				}
				if shouldComplete {
					observer.sendCompleted()
				}
			case .interrupted:
				observer.sendInterrupted()
			}
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func concurrent(limit: UInt) -> SignalProducer<Value.Value, Error> {
		precondition(limit > 0, "The concurrent limit must be greater than zero.")
		return SignalProducer<Value.Value, Error> { relayObserver, lifetime in
			self.startWithSignal { signal, interruptHandle in
				lifetime += interruptHandle
				_ = signal.observeConcurrent(relayObserver, limit, lifetime)
			}
		}
	}
}
extension SignalProducer {
	public func concat(_ next: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return SignalProducer<SignalProducer<Value, Error>, Error>([ self, next ]).flatten(.concat)
	}
	public func concat<Next: SignalProducerConvertible>(_ next: Next) -> SignalProducer<Value, Error> where Next.Value == Value, Next.Error == Error {
		return concat(next.producer)
	}
	public func concat(value: Value) -> SignalProducer<Value, Error> {
		return concat(SignalProducer(value: value))
	}
	public func concat(error: Error) -> SignalProducer<Value, Error> {
		return concat(SignalProducer(error: error))
	}
	public func prefix(_ previous: SignalProducer<Value, Error>) -> SignalProducer<Value, Error> {
		return previous.concat(self)
	}
	public func prefix<Previous: SignalProducerConvertible>(_ previous: Previous) -> SignalProducer<Value, Error> where Previous.Value == Value, Previous.Error == Error {
		return prefix(previous.producer)
	}
	public func prefix(value: Value) -> SignalProducer<Value, Error> {
		return prefix(SignalProducer(value: value))
	}
}
private final class ConcurrentFlattenState<Value, Error: Swift.Error> {
	typealias Producer = ReactiveSwift.SignalProducer<Value, Error>
	let limit: UInt
	var activeCount: UInt = 0
	var queue: [Producer] = []
	var isOuterCompleted = false
	var shouldComplete: Bool {
		return isOuterCompleted && activeCount == 0 && queue.isEmpty
	}
	init(limit: UInt) {
		self.limit = limit
	}
	func dequeue() -> Producer? {
		if activeCount < limit, !queue.isEmpty {
			activeCount += 1
			return queue.removeFirst()
		} else {
			return nil
		}
	}
}
private enum ProducerState: Int32 {
	case starting
	case started
}
extension UnsafeAtomicState where State == ProducerState {
	fileprivate func setStarted() {
		precondition(tryTransition(from: .starting, to: .started), "The transition is not supposed to fail.")
	}
}
extension Signal {
	public static func merge<Seq: Sequence>(_ signals: Seq) -> Signal<Value, Error> where Seq.Iterator.Element == Signal<Value, Error>
	{
		return SignalProducer<Signal<Value, Error>, Error>(signals)
			.flatten(.merge)
			.startAndRetrieveSignal()
	}
	public static func merge(_ signals: Signal<Value, Error>...) -> Signal<Value, Error> {
		return Signal.merge(signals)
	}
}
extension SignalProducer {
	public static func merge<Seq: Sequence>(_ producers: Seq) -> SignalProducer<Value, Error> where Seq.Iterator.Element == SignalProducer<Value, Error>
	{
		return SignalProducer<Seq.Iterator.Element, Never>(producers).flatten(.merge)
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible>(_ a: A, _ b: B) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error {
		return SignalProducer.merge([a.producer, b.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error, F.Value == Value, F.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer, f.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error, F.Value == Value, F.Error == Error, G.Value == Value, G.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error, F.Value == Value, F.Error == Error, G.Value == Value, G.Error == Error, H.Value == Value, H.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error, F.Value == Value, F.Error == Error, G.Value == Value, G.Error == Error, H.Value == Value, H.Error == Error, I.Value == Value, I.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer])
	}
	public static func merge<A: SignalProducerConvertible, B: SignalProducerConvertible, C: SignalProducerConvertible, D: SignalProducerConvertible, E: SignalProducerConvertible, F: SignalProducerConvertible, G: SignalProducerConvertible, H: SignalProducerConvertible, I: SignalProducerConvertible, J: SignalProducerConvertible>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) -> SignalProducer<Value, Error> where A.Value == Value, A.Error == Error, B.Value == Value, B.Error == Error, C.Value == Value, C.Error == Error, D.Value == Value, D.Error == Error, E.Value == Value, E.Error == Error, F.Value == Value, F.Error == Error, G.Value == Value, G.Error == Error, H.Value == Value, H.Error == Error, I.Value == Value, I.Error == Error, J.Value == Value, J.Error == Error {
		return SignalProducer.merge([a.producer, b.producer, c.producer, d.producer, e.producer, f.producer, g.producer, h.producer, i.producer, j.producer])
	}
}
extension Signal where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func switchToLatest() -> Signal<Value.Value, Error> {
		return Signal<Value.Value, Error> { observer, lifetime in
			let serial = SerialDisposable()
			lifetime += serial
			lifetime += self.observeSwitchToLatest(observer, serial)
		}
	}
	fileprivate func observeSwitchToLatest(_ observer: Signal<Value.Value, Error>.Observer, _ latestInnerDisposable: SerialDisposable) -> Disposable? {
		let state = Atomic(LatestState<Value, Error>())
		return self.observe { event in
			switch event {
			case let .value(p):
				p.producer.startWithSignal { innerSignal, innerDisposable in
					state.modify {
						$0.replacingInnerSignal = true
					}
					latestInnerDisposable.inner = innerDisposable
					state.modify {
						$0.replacingInnerSignal = false
						$0.innerSignalComplete = false
					}
					innerSignal.observe { event in
						switch event {
						case .interrupted:
							let shouldComplete: Bool = state.modify { state in
								if !state.replacingInnerSignal {
									state.innerSignalComplete = true
								}
								return !state.replacingInnerSignal && state.outerSignalComplete
							}
							if shouldComplete {
								observer.sendCompleted()
							}
						case .completed:
							let shouldComplete: Bool = state.modify {
								$0.innerSignalComplete = true
								return $0.outerSignalComplete
							}
							if shouldComplete {
								observer.sendCompleted()
							}
						case .value, .failed:
							observer.send(event)
						}
					}
				}
			case let .failed(error):
				observer.send(error: error)
			case .completed:
				let shouldComplete: Bool = state.modify {
					$0.outerSignalComplete = true
					return $0.innerSignalComplete
				}
				if shouldComplete {
					observer.sendCompleted()
				}
			case .interrupted:
				observer.sendInterrupted()
			}
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func switchToLatest() -> SignalProducer<Value.Value, Error> {
		return SignalProducer<Value.Value, Error> { observer, lifetime in
			let latestInnerDisposable = SerialDisposable()
			lifetime += latestInnerDisposable
			self.startWithSignal { signal, signalDisposable in
				lifetime += signalDisposable
				lifetime += signal.observeSwitchToLatest(observer, latestInnerDisposable)
			}
		}
	}
}
private struct LatestState<Value, Error: Swift.Error> {
	var outerSignalComplete: Bool = false
	var innerSignalComplete: Bool = true
	var replacingInnerSignal: Bool = false
}
extension Signal where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func race() -> Signal<Value.Value, Error> {
		return Signal<Value.Value, Error> { observer, lifetime in
			let relayDisposable = CompositeDisposable()
			lifetime += relayDisposable
			lifetime += self.observeRace(observer, relayDisposable)
		}
	}
	fileprivate func observeRace(_ observer: Signal<Value.Value, Error>.Observer, _ relayDisposable: CompositeDisposable) -> Disposable? {
		let state = Atomic(RaceState())
		return self.observe { event in
			switch event {
			case let .value(innerProducer):
				guard !relayDisposable.isDisposed else {
					return
				}
				innerProducer.producer.startWithSignal { innerSignal, innerDisposable in
					state.modify {
						$0.innerSignalComplete = false
					}
					let disposableHandle = relayDisposable.add(innerDisposable)
					var isWinningSignal = false
					innerSignal.observe { event in
						if !isWinningSignal {
							isWinningSignal = state.modify { state in
								guard !state.isActivated else {
									return false
								}
								state.isActivated = true
								return true
							}
							guard isWinningSignal else { return }
							disposableHandle?.dispose()
							relayDisposable.dispose()
						}
						switch event {
						case .completed:
							let shouldComplete: Bool = state.modify { state in
								state.innerSignalComplete = true
								return state.outerSignalComplete
							}
							if shouldComplete {
								observer.sendCompleted()
							}
						case .value, .failed, .interrupted:
							observer.send(event)
						}
					}
				}
			case let .failed(error):
				observer.send(error: error)
			case .completed:
				let shouldComplete: Bool = state.modify { state in
					state.outerSignalComplete = true
					return state.innerSignalComplete
				}
				if shouldComplete {
					observer.sendCompleted()
				}
			case .interrupted:
				observer.sendInterrupted()
			}
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func race() -> SignalProducer<Value.Value, Error> {
		return SignalProducer<Value.Value, Error> { observer, lifetime in
			let relayDisposable = CompositeDisposable()
			lifetime += relayDisposable
			self.startWithSignal { signal, signalDisposable in
				lifetime += signalDisposable
				lifetime += signal.observeRace(observer, relayDisposable)
			}
		}
	}
}
private struct RaceState {
	var outerSignalComplete = false
	var innerSignalComplete = true
	var isActivated = false
}
extension Signal where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func throttle() -> Signal<Value.Value, Error> {
		return Signal<Value.Value, Error> { observer, lifetime in
			let relayDisposable = CompositeDisposable()
			lifetime += relayDisposable
			lifetime += self.observeThrottle(observer, relayDisposable)
		}
	}
	fileprivate func observeThrottle(_ observer: Signal<Value.Value, Error>.Observer, _ relayDisposable: CompositeDisposable) -> Disposable? {
		let state = Atomic(ThrottleState())
		return self.observe { event in
			switch event {
			case let .value(innerProducer):
				let isFirstInnerProducer: Bool = state.modify { state in
					guard !state.hasFirstInnerProducer else {
						return false
					}
					state.hasFirstInnerProducer = true
					return true
				}
				guard isFirstInnerProducer else { return }
				innerProducer.producer.startWithSignal { innerSignal, innerDisposable in
					relayDisposable.add(innerDisposable)
					innerSignal.observe { event in
						switch event {
						case .completed:
							let shouldComplete: Bool = state.modify { state in
								state.hasFirstInnerProducer = false
								return state.outerSignalComplete
							}
							if shouldComplete {
								observer.sendCompleted()
							}
						case .value, .failed, .interrupted:
							observer.send(event)
						}
					}
				}
			case let .failed(error):
				observer.send(error: error)
			case .completed:
				let shouldComplete: Bool = state.modify { state in
					state.outerSignalComplete = true
					return !state.hasFirstInnerProducer
				}
				if shouldComplete {
					observer.sendCompleted()
				}
			case .interrupted:
				observer.sendInterrupted()
			}
		}
	}
}
extension SignalProducer where Value: SignalProducerConvertible, Error == Value.Error {
	fileprivate func throttle() -> SignalProducer<Value.Value, Error> {
		return SignalProducer<Value.Value, Error> { observer, lifetime in
			let relayDisposable = CompositeDisposable()
			lifetime += relayDisposable
			self.startWithSignal { signal, signalDisposable in
				lifetime += signalDisposable
				lifetime += signal.observeThrottle(observer, relayDisposable)
			}
		}
	}
}
private struct ThrottleState {
	var outerSignalComplete = false
	var hasFirstInnerProducer = false
}
extension Signal {
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Error>) -> Signal<U, Error>{
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> Signal<Inner.Value, Error> where Inner.Error == Error {
		return flatMap(strategy) { transform($0).producer }
	}
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Never>) -> Signal<U, Error> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> Signal<Inner.Value, Error> where Inner.Error == Never {
		return flatMap(strategy) { transform($0).producer }
	}
}
extension Signal where Error == Never {
	public func flatMap<U, F>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, F>) -> Signal<U, F> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> Signal<Inner.Value, Inner.Error> {
		return flatMap(strategy) { transform($0).producer }
	}
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Never>) -> Signal<U, Never> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> Signal<Inner.Value, Never> where Inner.Error == Never {
		return flatMap(strategy) { transform($0).producer }
	}
}
extension SignalProducer {
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> SignalProducer<Inner.Value, Error> where Inner.Error == Error {
		return flatMap(strategy) { transform($0).producer }
	}
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Never>) -> SignalProducer<U, Error> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> SignalProducer<Inner.Value, Error> where Inner.Error == Never {
		return flatMap(strategy) { transform($0).producer }
	}
}
extension SignalProducer where Error == Never {
	public func flatMap<U>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> SignalProducer<Inner.Value, Error> where Inner.Error == Error {
		return flatMap(strategy) { transform($0).producer }
	}
	public func flatMap<U, F>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> SignalProducer<U, F>) -> SignalProducer<U, F> {
		return map(transform).flatten(strategy)
	}
	public func flatMap<Inner: SignalProducerConvertible>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> Inner) -> SignalProducer<Inner.Value, Inner.Error> {
		return flatMap(strategy) { transform($0).producer }
	}
}
extension Signal {
	public func flatMapError<F>(_ transform: @escaping (Error) -> SignalProducer<Value, F>) -> Signal<Value, F> {
		return Signal<Value, F> { observer, lifetime in
			lifetime += self.observeFlatMapError(transform, observer, SerialDisposable())
		}
	}
	public func flatMapError<Inner: SignalProducerConvertible>(_ transform: @escaping (Error) -> Inner) -> Signal<Value, Inner.Error> where Inner.Value == Value {
		return flatMapError { transform($0).producer }
	}
	fileprivate func observeFlatMapError<Inner: SignalProducerConvertible>(
		_ handler: @escaping (Error) -> Inner,
		_ observer: Signal<Value, Inner.Error>.Observer,
		_ serialDisposable: SerialDisposable) -> Disposable? where Inner.Value == Value {
		return self.observe { event in
			switch event {
			case let .value(value):
				observer.send(value: value)
			case let .failed(error):
				handler(error).producer.startWithSignal { signal, disposable in
					serialDisposable.inner = disposable
					signal.observe(observer)
				}
			case .completed:
				observer.sendCompleted()
			case .interrupted:
				observer.sendInterrupted()
			}
		}
	}
}
extension SignalProducer {
	public func flatMapError<F>(_ transform: @escaping (Error) -> SignalProducer<Value, F>) -> SignalProducer<Value, F> {
		return SignalProducer<Value, F> { observer, lifetime in
			let serialDisposable = SerialDisposable()
			lifetime += serialDisposable
			self.startWithSignal { signal, signalDisposable in
				serialDisposable.inner = signalDisposable
				_ = signal.observeFlatMapError(transform, observer, serialDisposable)
			}
		}
	}
	public func flatMapError<Inner: SignalProducerConvertible>(_ transform: @escaping (Error) -> Inner) -> SignalProducer<Value, Inner.Error> where Inner.Value == Value {
		return flatMapError { transform($0).producer }
	}
}