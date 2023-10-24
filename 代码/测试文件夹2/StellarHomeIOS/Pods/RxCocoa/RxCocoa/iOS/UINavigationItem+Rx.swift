#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UINavigationItem {
    public var title: Binder<String?> {
        return Binder(self.base) { navigationItem, text in
            navigationItem.title = text
        }
    }
}
#endif