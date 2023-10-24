#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UISegmentedControl {
    public var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }
    public var value: ControlProperty<Int> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { segmentedControl in
                segmentedControl.selectedSegmentIndex
            }, setter: { segmentedControl, value in
                segmentedControl.selectedSegmentIndex = value
            }
        )
    }
    public func enabledForSegment(at index: Int) -> Binder<Bool> {
        return Binder(self.base) { segmentedControl, segmentEnabled -> Void in
            segmentedControl.setEnabled(segmentEnabled, forSegmentAt: index)
        }
    }
    public func titleForSegment(at index: Int) -> Binder<String?> {
        return Binder(self.base) { segmentedControl, title -> Void in
            segmentedControl.setTitle(title, forSegmentAt: index)
        }
    }
    public func imageForSegment(at index: Int) -> Binder<UIImage?> {
        return Binder(self.base) { segmentedControl, image -> Void in
            segmentedControl.setImage(image, forSegmentAt: index)
        }
    }
}
#endif