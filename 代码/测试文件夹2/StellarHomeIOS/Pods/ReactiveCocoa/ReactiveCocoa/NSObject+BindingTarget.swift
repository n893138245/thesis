import Foundation
import ReactiveSwift
extension Reactive where Base: AnyObject {
	public func makeBindingTarget<U>(on scheduler: Scheduler = UIScheduler(), _ action: @escaping (Base, U) -> Void) -> BindingTarget<U> {
		return BindingTarget(on: scheduler, lifetime: Lifetime.of(base)) { [weak base = self.base] value in
			if let base = base {
				action(base, value)
			}
		}
	}
}
#if swift(>=3.2)
extension Reactive where Base: AnyObject {
	public subscript<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>) -> BindingTarget<Value> {
		return BindingTarget(on: UIScheduler(), lifetime: Lifetime.of(base), object: base, keyPath: keyPath)
	}
	public subscript<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>, on scheduler: Scheduler) -> BindingTarget<Value> {
		return BindingTarget(on: scheduler, lifetime: Lifetime.of(base), object: base, keyPath: keyPath)
	}
}
#endif