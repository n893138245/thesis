#if os(iOS) || os(tvOS)
    import UIKit
    import RxSwift
    extension Reactive where Base: UIViewController {
        public var title: Binder<String> {
            return Binder(self.base) { viewController, title in
                viewController.title = title
            }
        }
    }
#endif