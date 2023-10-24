#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
public protocol RxTableViewDataSourceType  {
    associatedtype Element
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>)
}
#endif