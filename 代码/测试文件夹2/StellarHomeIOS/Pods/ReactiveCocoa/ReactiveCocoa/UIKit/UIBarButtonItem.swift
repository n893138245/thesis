#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIBarButtonItem {
	private var associatedAction: Atomic<(action: CocoaAction<Base>, disposable: Disposable?)?> {
		return associatedValue { _ in Atomic(nil) }
	}
	public var pressed: CocoaAction<Base>? {
		get {
			return associatedAction.value?.action
		}
		nonmutating set {
			base.target = newValue
			base.action = newValue.map { _ in CocoaAction<Base>.selector }
			associatedAction
				.swap(newValue.map { action in
						let disposable = isEnabled <~ action.isEnabled
						return (action, disposable)
				})?
				.disposable?.dispose()
		}
	}
	public var style: BindingTarget<UIBarButtonItem.Style> {
		return makeBindingTarget { $0.style = $1 }
	}
	public var width: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.width = $1 }
	}
	public var possibleTitles: BindingTarget<Set<String>?> {
		return makeBindingTarget { $0.possibleTitles = $1 }
	}
	public var customView: BindingTarget<UIView?> {
		return makeBindingTarget { $0.customView = $1 }
	}
}
#endif