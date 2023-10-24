#if !os(Linux)
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import RxSwift
#if os(iOS) || os(macOS) || os(tvOS)
extension Reactive where Base: NSLayoutConstraint {
    public var constant: Binder<CGFloat> {
        return Binder(self.base) { constraint, constant in
            constraint.constant = constant
        }
    }
    @available(iOS 8, OSX 10.10, *)
    public var active: Binder<Bool> {
        return Binder(self.base) { constraint, value in
            constraint.isActive = value
        }
    }
}
#endif
#endif