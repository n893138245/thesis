#if os(macOS)
import RxSwift
import Cocoa
extension Reactive where Base: NSSlider {
    public var value: ControlProperty<Double> {
        return self.base.rx.controlProperty(
            getter: { control -> Double in
                return control.doubleValue
            },
            setter: { control, value in
                control.doubleValue = value
            }
        )
    }
}
#endif