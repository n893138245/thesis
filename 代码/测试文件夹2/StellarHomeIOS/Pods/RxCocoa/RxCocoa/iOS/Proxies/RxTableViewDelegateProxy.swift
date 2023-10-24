#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
open class RxTableViewDelegateProxy
    : RxScrollViewDelegateProxy
    , UITableViewDelegate {
    public weak private(set) var tableView: UITableView?
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init(scrollView: tableView)
    }
}
#endif