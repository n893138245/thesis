#if os(macOS)
import RxSwift
import Cocoa
extension Reactive where Base: NSButton {
    public var tap: ControlEvent<Void> {
        return self.controlEvent
    }
    public var state: ControlProperty<NSControl.StateValue> {
        return self.base.rx.controlProperty(
            getter: { control in
                return control.state
            }, setter: { (control: NSButton, state: NSControl.StateValue) in
                control.state = state
            }
        )
    }
}
#endif