#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension UITabBarController: HasDelegate {
    public typealias Delegate = UITabBarControllerDelegate
}
open class RxTabBarControllerDelegateProxy
    : DelegateProxy<UITabBarController, UITabBarControllerDelegate>
    , DelegateProxyType 
    , UITabBarControllerDelegate {
    public weak private(set) var tabBar: UITabBarController?
    public init(tabBar: ParentObject) {
        self.tabBar = tabBar
        super.init(parentObject: tabBar, delegateProxy: RxTabBarControllerDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxTabBarControllerDelegateProxy(tabBar: $0) }
    }
}
#endif