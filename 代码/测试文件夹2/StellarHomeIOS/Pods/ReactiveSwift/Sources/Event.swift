import Foundation
import Dispatch
extension Signal {
	public enum Event {
		case value(Value)
		case failed(Error)
		case completed
		case interrupted
		public var isCompleted: Bool {
			switch self {
			case .completed:
				return true
			case .value, .failed, .interrupted:
				return false
			}
		}
		public var isTerminating: Bool {
			switch self {
			case .value:
				return false
			case .failed, .completed, .interrupted:
				return true
			}
		}
		public func map<U>(_ f: (Value) -> U) -> Signal<U, Error>.Event {
			switch self {
			case let .value(value):
				return .value(f(value))
			case let .failed(error):
				return .failed(error)
			case .completed:
				return .completed
			case .interrupted:
				return .interrupted
			}
		}
		public func mapError<F>(_ f: (Error) -> F) -> Signal<Value, F>.Event {
			switch self {
			case let .value(value):
				return .value(value)
			case let .failed(error):
				return .failed(f(error))
			case .completed:
				return .completed
			case .interrupted:
				return .interrupted
			}
		}
		public var value: Value? {
			if case let .value(value) = self {
				return value
			} else {
				return nil
			}
		}
		public var error: Error? {
			if case let .failed(error) = self {
				return error
			} else {
				return nil
			}
		}
	}
}
extension Signal.Event where Value: Equatable, Error: Equatable {
	public static func == (lhs: Signal<Value, Error>.Event, rhs: Signal<Value, Error>.Event) -> Bool {
		switch (lhs, rhs) {
		case let (.value(left), .value(right)):
			return left == right
		case let (.failed(left), .failed(right)):
			return left == right
		case (.completed, .completed):
			return true
		case (.interrupted, .interrupted):
			return true
		default:
			return false
		}
	}
}
extension Signal.Event: Equatable where Value: Equatable, Error: Equatable {}
extension Signal.Event: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .value(value):
			return "VALUE \(value)"
		case let .failed(error):
			return "FAILED \(error)"
		case .completed:
			return "COMPLETED"
		case .interrupted:
			return "INTERRUPTED"
		}
	}
}
public protocol EventProtocol {
	associatedtype Value
	associatedtype Error: Swift.Error
	var event: Signal<Value, Error>.Event { get }
}
extension Signal.Event: EventProtocol {
	public var event: Signal<Value, Error>.Event {
		return self
	}
}
extension Signal.Event {
	internal typealias Transformation<U, E: Swift.Error> = (ReactiveSwift.Observer<U, E>, Lifetime) -> ReactiveSwift.Observer<Value, Error>
	internal static func filter(_ isIncluded: @escaping (Value) -> Bool) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.Filter(downstream: downstream, predicate: isIncluded)
		}
	}
	internal static func compactMap<U>(_ transform: @escaping (Value) -> U?) -> Transformation<U, Error> {
		return { downstream, _ in
			Operators.CompactMap(downstream: downstream, transform: transform)
		}
	}
	internal static func map<U>(_ transform: @escaping (Value) -> U) -> Transformation<U, Error> {
		return { downstream, _ in
			Operators.Map(downstream: downstream, transform: transform)
		}
	}
	internal static func mapError<E>(_ transform: @escaping (Error) -> E) -> Transformation<Value, E> {
		return { downstream, _ in
			Operators.MapError(downstream: downstream, transform: transform)
		}
	}
	internal static var materialize: Transformation<Signal<Value, Error>.Event, Never> {
		return { downstream, _ in
			Operators.Materialize(downstream: downstream)
		}
	}
	internal static var materializeResults: Transformation<Result<Value, Error>, Never> {
		return { downstream, _ in
			Operators.MaterializeAsResult(downstream: downstream)
		}
	}
	internal static func attemptMap<U>(_ transform: @escaping (Value) -> Result<U, Error>) -> Transformation<U, Error> {
		return { downstream, _ in
			Operators.AttemptMap(downstream: downstream, transform: transform)
		}
	}
	internal static func attempt(_ action: @escaping (Value) -> Result<(), Error>) -> Transformation<Value, Error> {
		return attemptMap { value -> Result<Value, Error> in
			return action(value).map { _ in value }
		}
	}
}
extension Signal.Event where Error == Swift.Error {
	internal static func attempt(_ action: @escaping (Value) throws -> Void) -> Transformation<Value, Error> {
		return attemptMap { value in
			try action(value)
			return value
		}
	}
	internal static func attemptMap<U>(_ transform: @escaping (Value) throws -> U) -> Transformation<U, Error> {
		return attemptMap { value in
			Result { try transform(value) }
		}
	}
}
extension Signal.Event {
	internal static func take(first count: Int) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.TakeFirst(downstream: downstream, count: count)
		}
	}
	internal static func take(last count: Int) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.TakeLast(downstream: downstream, count: count)
		}
	}
	internal static func take(while shouldContinue: @escaping (Value) -> Bool) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.TakeWhile(downstream: downstream, shouldContinue: shouldContinue)
		}
	}
	internal static func skip(first count: Int) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.SkipFirst(downstream: downstream, count: count)
		}
	}
	internal static func skip(while shouldContinue: @escaping (Value) -> Bool) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.SkipWhile(downstream: downstream, shouldContinueToSkip: shouldContinue)
		}
	}
}
extension Signal.Event where Value: EventProtocol, Error == Never {
	internal static var dematerialize: Transformation<Value.Value, Value.Error> {
		return { downstream, _ in
			Operators.Dematerialize(downstream: downstream)
		}
	}
}
extension Signal.Event where Value: ResultProtocol, Error == Never {
	internal static var dematerializeResults: Transformation<Value.Success, Value.Failure> {
		return { downstream, _ in
			Operators.DematerializeResults(downstream: downstream)
		}
	}
}
extension Signal.Event where Value: OptionalProtocol {
	internal static var skipNil: Transformation<Value.Wrapped, Error> {
		return compactMap { $0.optional }
	}
}
extension Signal.Event {
	internal static var collect: Transformation<[Value], Error> {
		return collect { _, _ in false }
	}
	internal static func collect(count: Int) -> Transformation<[Value], Error> {
		precondition(count > 0)
		return collect { values in values.count == count }
	}
	internal static func collect(_ shouldEmit: @escaping (_ collectedValues: [Value]) -> Bool) -> Transformation<[Value], Error> {
		return { downstream, _ in
			Operators.Collect(downstream: downstream, shouldEmit: shouldEmit)
		}
	}
	internal static func collect(_ shouldEmit: @escaping (_ collected: [Value], _ latest: Value) -> Bool) -> Transformation<[Value], Error> {
		return { downstream, _ in
			Operators.Collect(downstream: downstream, shouldEmit: shouldEmit)
		}
	}
	internal static func combinePrevious(initial: Value?) -> Transformation<(Value, Value), Error> {
		return { downstream, _ in
			Operators.CombinePrevious(downstream: downstream, initial: initial)
		}
	}
	internal static func skipRepeats(_ isEquivalent: @escaping (Value, Value) -> Bool) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.SkipRepeats(downstream: downstream, isEquivalent: isEquivalent)
		}
	}
	internal static func uniqueValues<Identity: Hashable>(_ transform: @escaping (Value) -> Identity) -> Transformation<Value, Error> {
		return { downstream, _ in
			Operators.UniqueValues(downstream: downstream, extract: transform)
		}
	}
	internal static func reduce<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> Transformation<U, Error> {
		return { downstream, _ in
			Operators.Reduce(downstream: downstream, initial: initialResult, nextPartialResult: nextPartialResult)
		}
	}
	internal static func reduce<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> Transformation<U, Error> {
		return reduce(into: initialResult) { $0 = nextPartialResult($0, $1) }
	}
	internal static func scan<U>(into initialResult: U, _ nextPartialResult: @escaping (inout U, Value) -> Void) -> Transformation<U, Error> {
		return self.scanMap(into: initialResult, { result, value -> U in
			nextPartialResult(&result, value)
			return result
		})
	}
	internal static func scan<U>(_ initialResult: U, _ nextPartialResult: @escaping (U, Value) -> U) -> Transformation<U, Error> {
		return scan(into: initialResult) { $0 = nextPartialResult($0, $1) }
	}
	internal static func scanMap<State, U>(into initialState: State, _ next: @escaping (inout State, Value) -> U) -> Transformation<U, Error> {
		return { downstream, _ in
			Operators.ScanMap(downstream: downstream, initial: initialState, next: next)
		}
	}
	internal static func scanMap<State, U>(_ initialState: State, _ next: @escaping (State, Value) -> (State, U)) -> Transformation<U, Error> {
		return scanMap(into: initialState) { state, value in
			let new = next(state, value)
			state = new.0
			return new.1
		}
	}
	internal static func observe(on scheduler: Scheduler) -> Transformation<Value, Error> {
		return { action, lifetime in
			lifetime.observeEnded {
				scheduler.schedule {
					action(.interrupted)
				}
			}
			return Signal.Observer { event in
				scheduler.schedule {
					if !lifetime.hasEnded {
						action(event)
					}
				}
			}
		}
	}
	internal static func lazyMap<U>(on scheduler: Scheduler, transform: @escaping (Value) -> U) -> Transformation<U, Error> {
		return { action, lifetime in
			let box = Atomic<Value?>(nil)
			let completionDisposable = SerialDisposable()
			let valueDisposable = SerialDisposable()
			lifetime += valueDisposable
			lifetime += completionDisposable
			lifetime.observeEnded {
				scheduler.schedule {
					action(.interrupted)
				}
			}
			return Signal.Observer { event in
				switch event {
				case let .value(value):
					if box.swap(value) == nil {
						valueDisposable.inner = scheduler.schedule {
							if let value = box.swap(nil) {
								action(.value(transform(value)))
							}
						}
					}
				case .completed, .failed:
					completionDisposable.inner = scheduler.schedule {
						action(event.map(transform))
					}
				case .interrupted:
					valueDisposable.dispose()
					completionDisposable.dispose()
					scheduler.schedule {
						action(.interrupted)
					}
				}
			}
		}
	}
	internal static func delay(_ interval: TimeInterval, on scheduler: DateScheduler) -> Transformation<Value, Error> {
		precondition(interval >= 0)
		return { action, lifetime in
			lifetime.observeEnded {
				scheduler.schedule {
					action(.interrupted)
				}
			}
			return Signal.Observer { event in
				switch event {
				case .failed, .interrupted:
					scheduler.schedule {
						action(event)
					}
				case .value, .completed:
					let date = scheduler.currentDate.addingTimeInterval(interval)
					scheduler.schedule(after: date) {
						if !lifetime.hasEnded {
							action(event)
						}
					}
				}
			}
		}
	}
	internal static func throttle(_ interval: TimeInterval, on scheduler: DateScheduler) -> Transformation<Value, Error> {
		precondition(interval >= 0)
		return { action, lifetime in
			let state: Atomic<ThrottleState<Value>> = Atomic(ThrottleState())
			let schedulerDisposable = SerialDisposable()
			lifetime.observeEnded {
				schedulerDisposable.dispose()
				scheduler.schedule { action(.interrupted) }
			}
			return Signal.Observer { event in
				guard let value = event.value else {
					schedulerDisposable.inner = scheduler.schedule {
						action(event)
					}
					return
				}
				let scheduleDate: Date = state.modify { state in
					state.pendingValue = value
					let proposedScheduleDate: Date
					if let previousDate = state.previousDate, previousDate <= scheduler.currentDate {
						proposedScheduleDate = previousDate.addingTimeInterval(interval)
					} else {
						proposedScheduleDate = scheduler.currentDate
					}
					return proposedScheduleDate < scheduler.currentDate ? scheduler.currentDate : proposedScheduleDate
				}
				schedulerDisposable.inner = scheduler.schedule(after: scheduleDate) {
					if let pendingValue = state.modify({ $0.retrieveValue(date: scheduleDate) }) {
						action(.value(pendingValue))
					}
				}
			}
		}
	}
	internal static func debounce(_ interval: TimeInterval, on scheduler: DateScheduler, discardWhenCompleted: Bool) -> Transformation<Value, Error> {
		precondition(interval >= 0)
		return { action, lifetime in
			let state: Atomic<ThrottleState<Value>> = Atomic(ThrottleState(previousDate: scheduler.currentDate, pendingValue: nil))
			let d = SerialDisposable()
			lifetime.observeEnded {
				d.dispose()
				scheduler.schedule { action(.interrupted) }
			}
			return Signal.Observer { event in
				switch event {
				case let .value(value):
					state.modify { state in
						state.pendingValue = value
					}
					let date = scheduler.currentDate.addingTimeInterval(interval)
					d.inner = scheduler.schedule(after: date) {
						if let pendingValue = state.modify({ $0.retrieveValue(date: date) }) {
							action(.value(pendingValue))
						}
					}
				case .completed:
					d.inner = scheduler.schedule {
						let pending: (value: Value, previousDate: Date)? = state.modify { state in
							defer { state.pendingValue = nil }
							guard let pendingValue = state.pendingValue, let previousDate = state.previousDate else { return nil }
							return (pendingValue, previousDate)
						}
						if !discardWhenCompleted, let (pendingValue, previousDate) = pending {
							scheduler.schedule(after: previousDate.addingTimeInterval(interval)) {
								action(.value(pendingValue))
								action(.completed)
							}
						} else {
							action(.completed)
						}
					}
				case .failed, .interrupted:
					d.inner = scheduler.schedule {
						action(event)
					}
				}
			}
		}
	}
	internal static func collect(every interval: DispatchTimeInterval, on scheduler: DateScheduler, skipEmpty: Bool, discardWhenCompleted: Bool) -> Transformation<[Value], Error> {
		return { action, lifetime in
			let state = Atomic<CollectEveryState<Value>>(.init(skipEmpty: skipEmpty))
			let d = SerialDisposable()
			d.inner = scheduler.schedule(after: scheduler.currentDate.addingTimeInterval(interval), interval: interval, leeway: interval * 0.1) {
				let (currentValues, isCompleted) = state.modify { ($0.collect(), $0.isCompleted) }
				if let currentValues = currentValues {
					action(.value(currentValues))
				}
				if isCompleted {
					action(.completed)
				}
			}
			lifetime.observeEnded {
				d.dispose()
				scheduler.schedule { action(.interrupted) }
			}
			return Signal.Observer { event in
				switch event {
				case let .value(value):
					state.modify { $0.values.append(value) }
				case let .failed(error):
					d.inner = scheduler.schedule { action(.failed(error)) }
				case .completed where !discardWhenCompleted:
					state.modify { $0.isCompleted = true }
				case .completed:
					d.inner = scheduler.schedule { action(.completed) }
				case .interrupted:
					d.inner = scheduler.schedule { action(.interrupted) }
				}
			}
		}
	}
}
private struct CollectEveryState<Value> {
	let skipEmpty: Bool
	var values: [Value] = []
	var isCompleted: Bool = false
	init(skipEmpty: Bool) {
		self.skipEmpty = skipEmpty
	}
	var hasValues: Bool {
		return !values.isEmpty || !skipEmpty
	}
	mutating func collect() -> [Value]? {
		guard hasValues else { return nil }
		defer { values.removeAll() }
		return values
	}
}
private struct ThrottleState<Value> {
	var previousDate: Date?
	var pendingValue: Value?
	mutating func retrieveValue(date: Date) -> Value? {
		defer {
			if pendingValue != nil {
				pendingValue = nil
				previousDate = date
			}
		}
		return pendingValue
	}
}
extension Signal.Event where Error == Never {
	internal static func promoteError<F>(_: F.Type) -> Transformation<Value, F> {
		return { action, _ in
			return Signal.Observer { event in
				switch event {
				case let .value(value):
					action(.value(value))
				case .failed:
					fatalError("Never is impossible to construct")
				case .completed:
					action(.completed)
				case .interrupted:
					action(.interrupted)
				}
			}
		}
	}
}
extension Signal.Event where Value == Never {
	internal static func promoteValue<U>(_: U.Type) -> Transformation<U, Error> {
		return { action, _ in
			return Signal.Observer { event in
				action(event.promoteValue())
			}
		}
	}
}
extension Signal.Event where Value == Never {
	internal func promoteValue<U>() -> Signal<U, Error>.Event {
        switch event {
        case .value:
            fatalError("Never is impossible to construct")
        case let .failed(error):
            return .failed(error)
        case .completed:
            return .completed
        case .interrupted:
            return .interrupted
        }
    }
}