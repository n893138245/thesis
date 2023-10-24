#if os(iOS)
import RxSwift
import UIKit
extension UISearchController: HasDelegate {
    public typealias Delegate = UISearchControllerDelegate
}
@available(iOS 8.0, *)
open class RxSearchControllerDelegateProxy
    : DelegateProxy<UISearchController, UISearchControllerDelegate>
    , DelegateProxyType 
    , UISearchControllerDelegate {
    public weak private(set) var searchController: UISearchController?
    public init(searchController: UISearchController) {
        self.searchController = searchController
        super.init(parentObject: searchController, delegateProxy: RxSearchControllerDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxSearchControllerDelegateProxy(searchController: $0) }
    }
}
#endif