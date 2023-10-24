#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UISwitch {
	public var toggled: CocoaAction<Base>? {
		get {
			return associatedAction.withValue { info in
				return info.flatMap { info in
					return info.controlEvents == .valueChanged ? info.action : nil
				}
			}
		}
		nonmutating set {
			setAction(newValue, for: .valueChanged)
		}
	}
	public var isOn: BindingTarget<Bool> {
		return makeBindingTarget { $0.isOn = $1 }
	}
	public var isOnValues: Signal<Bool, Never> {
		return mapControlEvents(.valueChanged) { $0.isOn }
	}
}
#endif