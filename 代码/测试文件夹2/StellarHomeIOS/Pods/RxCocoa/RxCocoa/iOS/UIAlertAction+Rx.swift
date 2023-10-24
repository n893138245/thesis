#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UIAlertAction {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { alertAction, value in
            alertAction.isEnabled = value
        }
    }
}
#endif