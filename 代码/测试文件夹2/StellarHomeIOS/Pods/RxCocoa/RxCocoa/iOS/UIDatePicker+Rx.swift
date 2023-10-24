#if os(iOS)
import RxSwift
import UIKit
extension Reactive where Base: UIDatePicker {
    public var date: ControlProperty<Date> {
        return value
    }
    public var value: ControlProperty<Date> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { datePicker in
                datePicker.date
            }, setter: { datePicker, value in
                datePicker.date = value
            }
        )
    }
    public var countDownDuration: ControlProperty<TimeInterval> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { datePicker in
                datePicker.countDownDuration
            }, setter: { datePicker, value in
                datePicker.countDownDuration = value
            }
        )
    }
}
#endif