extension Signal {
	public final class Observer: ReactiveSwift.Observer<Value, Error> {
		public typealias Action = (Event) -> Void
		private let _send: Action
		private let interruptsOnDeinit: Bool
		internal init(action: @escaping Action, interruptsOnDeinit: Bool) {
			self._send = action
			self.interruptsOnDeinit = interruptsOnDeinit
		}
		public init(_ action: @escaping Action) {
			self._send = action
			self.interruptsOnDeinit = false
		}
		public convenience init(
			value: ((Value) -> Void)? = nil,
			failed: ((Error) -> Void)? = nil,
			completed: (() -> Void)? = nil,
			interrupted: (() -> Void)? = nil
		) {
			self.init { event in
				switch event {
				case let .value(v):
					value?(v)
				case let .failed(error):
					failed?(error)
				case .completed:
					completed?()
				case .interrupted:
					interrupted?()
				}
			}
		}
		internal convenience init(mappingInterruptedToCompleted observer: Signal<Value, Error>.Observer) {
			self.init { event in
				switch event {
				case .value, .completed, .failed:
					observer.send(event)
				case .interrupted:
					observer.sendCompleted()
				}
			}
		}
		deinit {
			if interruptsOnDeinit {
				_send(.interrupted)
			}
		}
		public override func receive(_ value: Value) {
			send(value: value)
		}
		public override func terminate(_ termination: Termination<Error>) {
			switch termination {
			case let .failed(error):
				send(error: error)
			case .completed:
				sendCompleted()
			case .interrupted:
				sendInterrupted()
			}
		}
		public func send(_ event: Event) {
			_send(event)
		}
		public func send(value: Value) {
			_send(.value(value))
		}
		public func send(error: Error) {
			_send(.failed(error))
		}
		public func sendCompleted() {
			_send(.completed)
		}
		public func sendInterrupted() {
			_send(.interrupted)
		}
	}
}
extension Signal.Observer {
	@available(*, unavailable, renamed:"send(_:)")
	public var action: Action { fatalError() }
}