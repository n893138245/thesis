#if os(iOS)
import RxSwift
import UIKit
extension Reactive where Base: UIButton {
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
#endif
#if os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UIButton {
    public var primaryAction: ControlEvent<Void> {
        return controlEvent(.primaryActionTriggered)
    }
}
#endif
#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UIButton {
    public func title(for controlState: UIControl.State = []) -> Binder<String?> {
        return Binder(self.base) { button, title -> Void in
            button.setTitle(title, for: controlState)
        }
    }
    public func image(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        return Binder(self.base) { button, image -> Void in
            button.setImage(image, for: controlState)
        }
    }
    public func backgroundImage(for controlState: UIControl.State = []) -> Binder<UIImage?> {
        return Binder(self.base) { button, image -> Void in
            button.setBackgroundImage(image, for: controlState)
        }
    }
}
#endif
#if os(iOS) || os(tvOS)
    import RxSwift
    import UIKit
    extension Reactive where Base: UIButton {
        public func attributedTitle(for controlState: UIControl.State = []) -> Binder<NSAttributedString?> {
            return Binder(self.base) { button, attributedTitle -> Void in
                button.setAttributedTitle(attributedTitle, for: controlState)
            }
        }
    }
#endif