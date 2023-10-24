#if os(iOS)
import RxSwift
import UIKit
extension Reactive where Base: UISlider {
    public var value: ControlProperty<Float> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { slider in
                slider.value
            }, setter: { slider, value in
                slider.value = value
            }
        )
    }
}
#endif