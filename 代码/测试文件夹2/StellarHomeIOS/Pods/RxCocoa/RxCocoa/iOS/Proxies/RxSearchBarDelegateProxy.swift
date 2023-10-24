#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension UISearchBar: HasDelegate {
    public typealias Delegate = UISearchBarDelegate
}
open class RxSearchBarDelegateProxy
    : DelegateProxy<UISearchBar, UISearchBarDelegate>
    , DelegateProxyType 
    , UISearchBarDelegate {
    public weak private(set) var searchBar: UISearchBar?
    public init(searchBar: ParentObject) {
        self.searchBar = searchBar
        super.init(parentObject: searchBar, delegateProxy: RxSearchBarDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxSearchBarDelegateProxy(searchBar: $0) }
    }
}
#endif