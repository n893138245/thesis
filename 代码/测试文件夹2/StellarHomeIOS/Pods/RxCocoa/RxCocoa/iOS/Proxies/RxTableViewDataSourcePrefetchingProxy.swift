#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
@available(iOS 10.0, tvOS 10.0, *)
extension UITableView: HasPrefetchDataSource {
    public typealias PrefetchDataSource = UITableViewDataSourcePrefetching
}
@available(iOS 10.0, tvOS 10.0, *)
private let tableViewPrefetchDataSourceNotSet = TableViewPrefetchDataSourceNotSet()
@available(iOS 10.0, tvOS 10.0, *)
private final class TableViewPrefetchDataSourceNotSet
    : NSObject
    , UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}
}
@available(iOS 10.0, tvOS 10.0, *)
open class RxTableViewDataSourcePrefetchingProxy
    : DelegateProxy<UITableView, UITableViewDataSourcePrefetching>
    , DelegateProxyType
    , UITableViewDataSourcePrefetching {
    public weak private(set) var tableView: UITableView?
    public init(tableView: ParentObject) {
        self.tableView = tableView
        super.init(parentObject: tableView, delegateProxy: RxTableViewDataSourcePrefetchingProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxTableViewDataSourcePrefetchingProxy(tableView: $0) }
    }
    private var _prefetchRowsPublishSubject: PublishSubject<[IndexPath]>?
    internal var prefetchRowsPublishSubject: PublishSubject<[IndexPath]> {
        if let subject = _prefetchRowsPublishSubject {
            return subject
        }
        let subject = PublishSubject<[IndexPath]>()
        _prefetchRowsPublishSubject = subject
        return subject
    }
    private weak var _requiredMethodsPrefetchDataSource: UITableViewDataSourcePrefetching? = tableViewPrefetchDataSourceNotSet
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let subject = _prefetchRowsPublishSubject {
            subject.on(.next(indexPaths))
        }
        (_requiredMethodsPrefetchDataSource ?? tableViewPrefetchDataSourceNotSet).tableView(tableView, prefetchRowsAt: indexPaths)
    }
    open override func setForwardToDelegate(_ forwardToDelegate: UITableViewDataSourcePrefetching?, retainDelegate: Bool) {
        _requiredMethodsPrefetchDataSource = forwardToDelegate ?? tableViewPrefetchDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
    deinit {
        if let subject = _prefetchRowsPublishSubject {
            subject.on(.completed)
        }
    }
}
#endif