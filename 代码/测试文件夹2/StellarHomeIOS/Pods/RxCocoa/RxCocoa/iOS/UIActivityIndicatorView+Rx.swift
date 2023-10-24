#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UIActivityIndicatorView {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}
#endif