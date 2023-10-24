import Foundation
import Dispatch
precedencegroup BindingPrecedence {
	associativity: right
	higherThan: AssignmentPrecedence
}
infix operator <~ : BindingPrecedence
public protocol BindingSource: SignalProducerConvertible where Error == Never {}
extension Signal: BindingSource where Error == Never {}
extension SignalProducer: BindingSource where Error == Never {}
public protocol BindingTargetProvider {
	associatedtype Value
	var bindingTarget: BindingTarget<Value> { get }
}
extension BindingTargetProvider {
	@discardableResult
	public static func <~
		<Source: BindingSource>
		(provider: Self, source: Source) -> Disposable?
		where Source.Value == Value
	{
		return source.producer
			.take(during: provider.bindingTarget.lifetime)
			.startWithValues(provider.bindingTarget.action)
	}
	@discardableResult
	public static func <~
		<Source: BindingSource>
		(provider: Self, source: Source) -> Disposable?
		where Value == Source.Value?
	{
		return provider <~ source.producer.optionalize()
	}
}
extension Signal.Observer {
	@discardableResult
	public static func <~
		<Source: BindingSource>
		(observer: Signal<Value, Error>.Observer, source: Source) -> Disposable?
		where Source.Value == Value
	{
		return source.producer.startWithValues { [weak observer] in
			observer?.send(value: $0)
		}
	}
}
public struct BindingTarget<Value>: BindingTargetProvider {
	public let lifetime: Lifetime
	public let action: (Value) -> Void
	public var bindingTarget: BindingTarget<Value> {
		return self
	}
	public init(on scheduler: Scheduler = ImmediateScheduler(), lifetime: Lifetime, action: @escaping (Value) -> Void) {
		self.lifetime = lifetime
		if scheduler is ImmediateScheduler {
			self.action = action
		} else {
			self.action = { value in
				scheduler.schedule {
					action(value)
				}
			}
		}
	}
	public init<Object: AnyObject>(on scheduler: Scheduler = ImmediateScheduler(), lifetime: Lifetime, object: Object, keyPath: WritableKeyPath<Object, Value>) {
		self.init(on: scheduler, lifetime: lifetime) { [weak object] in object?[keyPath: keyPath] = $0 }
	}
}
extension Optional: BindingTargetProvider where Wrapped: BindingTargetProvider {
	public typealias Value = Wrapped.Value
	public var bindingTarget: BindingTarget<Wrapped.Value> {
		switch self {
		case let .some(provider):
			return provider.bindingTarget
		case .none:
			return BindingTarget(lifetime: .empty, action: { _ in })
		}
	}
}