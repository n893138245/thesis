#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UITabBarItem {
    public var badgeValue: Binder<String?> {
        return Binder(self.base) { tabBarItem, badgeValue in
            tabBarItem.badgeValue = badgeValue
        }
    }
}
#endif