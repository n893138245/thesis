#if os(iOS) || os(tvOS)
    import UIKit
    import RxSwift
    extension UINavigationController: HasDelegate {
        public typealias Delegate = UINavigationControllerDelegate
    }
    open class RxNavigationControllerDelegateProxy
        : DelegateProxy<UINavigationController, UINavigationControllerDelegate>
        , DelegateProxyType 
        , UINavigationControllerDelegate {
        public weak private(set) var navigationController: UINavigationController?
        public init(navigationController: ParentObject) {
            self.navigationController = navigationController
            super.init(parentObject: navigationController, delegateProxy: RxNavigationControllerDelegateProxy.self)
        }
        public static func registerKnownImplementations() {
            self.register { RxNavigationControllerDelegateProxy(navigationController: $0) }
        }
    }
#endif