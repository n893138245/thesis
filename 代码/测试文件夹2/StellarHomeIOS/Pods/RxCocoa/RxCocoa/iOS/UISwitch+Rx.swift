#if os(iOS)
import UIKit
import RxSwift
extension Reactive where Base: UISwitch {
    public var isOn: ControlProperty<Bool> {
        return value
    }
    public var value: ControlProperty<Bool> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { uiSwitch in
                uiSwitch.isOn
            }, setter: { uiSwitch, value in
                uiSwitch.isOn = value
            }
        )
    }
}
#endif