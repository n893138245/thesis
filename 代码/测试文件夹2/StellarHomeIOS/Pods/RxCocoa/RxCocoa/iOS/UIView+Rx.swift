#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
    public var alpha: Binder<CGFloat> {
        return Binder(self.base) { view, alpha in
            view.alpha = alpha
        }
    }
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
    public var isUserInteractionEnabled: Binder<Bool> {
        return Binder(self.base) { view, userInteractionEnabled in
            view.isUserInteractionEnabled = userInteractionEnabled
        }
    }
}
#endif