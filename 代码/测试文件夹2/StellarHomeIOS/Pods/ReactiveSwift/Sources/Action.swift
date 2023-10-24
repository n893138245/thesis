import Dispatch
import Foundation
public final class Action<Input, Output, Error: Swift.Error> {
	private struct ActionState<Value> {
		var isEnabled: Bool {
			return isUserEnabled && !isExecuting
		}
		var isUserEnabled: Bool
		var isExecuting: Bool
		var value: Value
	}
	private let execute: (Action<Input, Output, Error>, Input) -> SignalProducer<Output, ActionError<Error>>
	private let eventsObserver: Signal<Signal<Output, Error>.Event, Never>.Observer
	private let disabledErrorsObserver: Signal<(), Never>.Observer
	private let deinitToken: Lifetime.Token
	public let lifetime: Lifetime
	public let events: Signal<Signal<Output, Error>.Event, Never>
	public let values: Signal<Output, Never>
	public let errors: Signal<Error, Never>
	public let disabledErrors: Signal<(), Never>
	public let completed: Signal<(), Never>
	public let isExecuting: Property<Bool>
	public let isEnabled: Property<Bool>
	public init<State: PropertyProtocol>(state: State, enabledIf isEnabled: @escaping (State.Value) -> Bool, execute: @escaping (State.Value, Input) -> SignalProducer<Output, Error>) {
		let isUserEnabled = isEnabled
		(lifetime, deinitToken) = Lifetime.make()
		lifetime.observeEnded { _ = state }
		(events, eventsObserver) = Signal<Signal<Output, Error>.Event, Never>.pipe()
		(disabledErrors, disabledErrorsObserver) = Signal<(), Never>.pipe()
		values = events.compactMap { $0.value }
		errors = events.compactMap { $0.error }
		completed = events.compactMap { $0.isCompleted ? () : nil }
		let actionState = MutableProperty(ActionState<State.Value>(isUserEnabled: true, isExecuting: false, value: state.value))
		let isExecuting = MutableProperty(false)
		self.isExecuting = Property(capturing: isExecuting)
		let isEnabled = MutableProperty(actionState.value.isEnabled)
		self.isEnabled = Property(capturing: isEnabled)
		func modifyActionState<Result>(_ action: (inout ActionState<State.Value>) throws -> Result) rethrows -> Result {
			return try actionState.begin { storage in
				let oldState = storage.value
				defer {
					let newState = storage.value
					if oldState.isEnabled != newState.isEnabled {
						isEnabled.value = newState.isEnabled
					}
					if oldState.isExecuting != newState.isExecuting {
						isExecuting.value = newState.isExecuting
					}
				}
				return try storage.modify(action)
			}
		}
		lifetime += state.producer.startWithValues { value in
			modifyActionState { state in
				state.value = value
				state.isUserEnabled = isUserEnabled(value)
			}
		}
		self.execute = { action, input in
			return SignalProducer { observer, lifetime in
				let latestState: State.Value? = modifyActionState { state in
					guard state.isEnabled else {
						return nil
					}
					state.isExecuting = true
					return state.value
				}
				guard let state = latestState else {
					observer.send(error: .disabled)
					action.disabledErrorsObserver.send(value: ())
					return
				}
				let interruptHandle = execute(state, input).start { event in
					observer.send(event.mapError(ActionError.producerFailed))
					action.eventsObserver.send(value: event)
				}
				lifetime.observeEnded {
					interruptHandle.dispose()
					modifyActionState { $0.isExecuting = false }
				}
			}
		}
	}
	public convenience init<P: PropertyProtocol>(state: P, execute: @escaping (P.Value, Input) -> SignalProducer<Output, Error>) {
		self.init(state: state, enabledIf: { _ in true }, execute: execute)
	}
	public convenience init<P: PropertyProtocol>(enabledIf isEnabled: P, execute: @escaping (Input) -> SignalProducer<Output, Error>) where P.Value == Bool {
		self.init(state: isEnabled, enabledIf: { $0 }) { _, input in
			execute(input)
		}
	}
	public convenience init<P: PropertyProtocol, T>(unwrapping state: P, execute: @escaping (T, Input) -> SignalProducer<Output, Error>) where P.Value == T? {
		self.init(state: state, enabledIf: { $0 != nil }) { state, input in
			execute(state!, input)
		}
	}
	public convenience init<T, E>(validated state: ValidatingProperty<T, E>, execute: @escaping (T, Input) -> SignalProducer<Output, Error>) {
		self.init(unwrapping: state.result.map { $0.value }, execute: execute)
	}
	public convenience init(execute: @escaping (Input) -> SignalProducer<Output, Error>) {
		self.init(enabledIf: Property(value: true), execute: execute)
	}
	deinit {
		eventsObserver.sendCompleted()
		disabledErrorsObserver.sendCompleted()
	}
	public func apply(_ input: Input) -> SignalProducer<Output, ActionError<Error>> {
		return execute(self, input)
	}
}
extension Action: BindingTargetProvider {
	public var bindingTarget: BindingTarget<Input> {
		return BindingTarget(lifetime: lifetime) { [weak self] in self?.apply($0).start() }
	}
}
extension Action where Input == Void {
	public func apply() -> SignalProducer<Output, ActionError<Error>> {
		return apply(())
	}
	public convenience init<P: PropertyProtocol, T>(unwrapping state: P, execute: @escaping (T) -> SignalProducer<Output, Error>) where P.Value == T? {
		self.init(unwrapping: state) { state, _ in
			execute(state)
		}
	}
	public convenience init<T, E>(validated state: ValidatingProperty<T, E>, execute: @escaping (T) -> SignalProducer<Output, Error>) {
		self.init(validated: state) { state, _ in
			execute(state)
		}
	}
	public convenience init<P: PropertyProtocol, T>(state: P, execute: @escaping (T) -> SignalProducer<Output, Error>) where P.Value == T {
		self.init(state: state) { state, _ in
			execute(state)
		}
	}
}
public enum ActionError<Error: Swift.Error>: Swift.Error {
	case disabled
	case producerFailed(Error)
}
extension ActionError where Error: Equatable {
	public static func == (lhs: ActionError<Error>, rhs: ActionError<Error>) -> Bool {
		switch (lhs, rhs) {
		case (.disabled, .disabled):
			return true
		case let (.producerFailed(left), .producerFailed(right)):
			return left == right
		default:
			return false
		}
	}
}
extension ActionError: Equatable where Error: Equatable {}