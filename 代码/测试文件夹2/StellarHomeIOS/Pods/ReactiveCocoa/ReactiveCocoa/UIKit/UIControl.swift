#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIControl {
	internal var associatedAction: Atomic<(action: CocoaAction<Base>, controlEvents: UIControl.Event, disposable: Disposable)?> {
		return associatedValue { _ in Atomic(nil) }
	}
	internal func setAction(_ action: CocoaAction<Base>?, for controlEvents: UIControl.Event, disposable: Disposable? = nil) {
		associatedAction.modify { associatedAction in
			associatedAction?.disposable.dispose()
			if let action = action {
				base.addTarget(action, action: CocoaAction<Base>.selector, for: controlEvents)
				let compositeDisposable = CompositeDisposable()
				compositeDisposable += isEnabled <~ action.isEnabled
				compositeDisposable += { [weak base = self.base] in
					base?.removeTarget(action, action: CocoaAction<Base>.selector, for: controlEvents)
				}
				compositeDisposable += disposable
				associatedAction = (action, controlEvents, ScopedDisposable(compositeDisposable))
			} else {
				associatedAction = nil
			}
		}
	}
	public func controlEvents(_ controlEvents: UIControl.Event) -> Signal<Base, Never> {
		return mapControlEvents(controlEvents, { $0 })
	}
	public func mapControlEvents<Value>(_ controlEvents: UIControl.Event, _ transform: @escaping (Base) -> Value) -> Signal<Value, Never> {
		return Signal { observer, signalLifetime in
			let receiver = CocoaTarget(observer) { transform($0 as! Base) }
			base.addTarget(receiver,
			               action: #selector(receiver.invoke),
			               for: controlEvents)
			let disposable = lifetime.ended.observeCompleted(observer.sendCompleted)
			signalLifetime.observeEnded { [weak base] in
				disposable?.dispose()
				base?.removeTarget(receiver,
				                   action: #selector(receiver.invoke),
				                   for: controlEvents)
			}
		}
	}
	@available(*, unavailable, renamed: "controlEvents(_:)")
	public func trigger(for controlEvents: UIControl.Event) -> Signal<(), Never> {
		fatalError()
	}
	public var isEnabled: BindingTarget<Bool> {
		return makeBindingTarget { $0.isEnabled = $1 }
	}
	public var isSelected: BindingTarget<Bool> {
		return makeBindingTarget { $0.isSelected = $1 }
	}
	public var isHighlighted: BindingTarget<Bool> {
		return makeBindingTarget { $0.isHighlighted = $1 }
	}
}
#endif