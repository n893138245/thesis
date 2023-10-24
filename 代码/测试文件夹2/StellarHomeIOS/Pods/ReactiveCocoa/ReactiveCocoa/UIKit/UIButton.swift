#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIButton {
	public var pressed: CocoaAction<Base>? {
		get {
			return associatedAction.withValue { info in
				return info.flatMap { info in
					return info.controlEvents == pressEvent ? info.action : nil
				}
			}
		}
		nonmutating set {
			setAction(newValue, for: pressEvent)
		}
	}
	private var pressEvent: UIControl.Event {
		if #available(iOS 9.0, tvOS 9.0, *) {
			return .primaryActionTriggered
		} else {
			return .touchUpInside
		}
    }
	public var title: BindingTarget<String> {
		return makeBindingTarget { $0.setTitle($1, for: .normal) }
	}
	public func title(for state: UIControl.State) -> BindingTarget<String> {
		return makeBindingTarget { $0.setTitle($1, for: state) }
	}
	public func image(for state: UIControl.State) -> BindingTarget<UIImage?> {
		return makeBindingTarget { $0.setImage($1, for: state) }
	}
	public var image: BindingTarget<UIImage?> {
		return image(for: .normal)
	}
}
#endif