#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension UITabBar: HasDelegate {
    public typealias Delegate = UITabBarDelegate
}
open class RxTabBarDelegateProxy
    : DelegateProxy<UITabBar, UITabBarDelegate>
    , DelegateProxyType 
    , UITabBarDelegate {
    public weak private(set) var tabBar: UITabBar?
    public init(tabBar: ParentObject) {
        self.tabBar = tabBar
        super.init(parentObject: tabBar, delegateProxy: RxTabBarDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxTabBarDelegateProxy(tabBar: $0) }
    }
    open class func currentDelegate(for object: ParentObject) -> UITabBarDelegate? {
        return object.delegate
    }
    open class func setCurrentDelegate(_ delegate: UITabBarDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }
}
#endif