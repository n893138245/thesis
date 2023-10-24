#if os(iOS)
    import UIKit
    import RxSwift
    extension Reactive where Base: UIApplication {
        public var isNetworkActivityIndicatorVisible: Binder<Bool> {
            return Binder(self.base) { application, active in
                application.isNetworkActivityIndicatorVisible = active
            }
        }
    }
#endif