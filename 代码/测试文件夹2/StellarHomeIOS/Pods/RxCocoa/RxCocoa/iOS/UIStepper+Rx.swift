#if os(iOS)
import UIKit
import RxSwift
extension Reactive where Base: UIStepper {
    public var value: ControlProperty<Double> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { stepper in
                stepper.value
            }, setter: { stepper, value in
                stepper.value = value
            }
        )
    }
    public var stepValue: Binder<Double> {
        return Binder(self.base) { stepper, value in
            stepper.stepValue = value
        }
    }
}
#endif