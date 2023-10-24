#if os(iOS)
import UIKit
import RxSwift
extension Reactive where Base: UIRefreshControl {
    public var isRefreshing: Binder<Bool> {
        return Binder(self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}
#endif