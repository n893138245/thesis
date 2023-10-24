#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
#if os(iOS)
extension Reactive where Base: UITabBar {
    public var willBeginCustomizing: ControlEvent<[UITabBarItem]> {
        let source = delegate.methodInvoked(#selector(UITabBarDelegate.tabBar(_:willBeginCustomizing:)))
            .map { a in
                return try castOrThrow([UITabBarItem].self, a[1])
            }
        return ControlEvent(events: source)
    }
    public var didBeginCustomizing: ControlEvent<[UITabBarItem]> {
        let source = delegate.methodInvoked(#selector(UITabBarDelegate.tabBar(_:didBeginCustomizing:)))
            .map { a in
                return try castOrThrow([UITabBarItem].self, a[1])
            }
        return ControlEvent(events: source)
    }
    public var willEndCustomizing: ControlEvent<([UITabBarItem], Bool)> {
        let source = delegate.methodInvoked(#selector(UITabBarDelegate.tabBar(_:willEndCustomizing:changed:)))
            .map { (a: [Any]) -> (([UITabBarItem], Bool)) in
                let items = try castOrThrow([UITabBarItem].self, a[1])
                let changed = try castOrThrow(Bool.self, a[2])
                return (items, changed)
            }
        return ControlEvent(events: source)
    }
    public var didEndCustomizing: ControlEvent<([UITabBarItem], Bool)> {
        let source = delegate.methodInvoked(#selector(UITabBarDelegate.tabBar(_:didEndCustomizing:changed:)))
            .map { (a: [Any]) -> (([UITabBarItem], Bool)) in
                let items = try castOrThrow([UITabBarItem].self, a[1])
                let changed = try castOrThrow(Bool.self, a[2])
                return (items, changed)
            }
        return ControlEvent(events: source)
    }
}
#endif
extension Reactive where Base: UITabBar {
    public var delegate: DelegateProxy<UITabBar, UITabBarDelegate> {
        return RxTabBarDelegateProxy.proxy(for: base)
    }
    public var didSelectItem: ControlEvent<UITabBarItem> {
        let source = delegate.methodInvoked(#selector(UITabBarDelegate.tabBar(_:didSelect:)))
            .map { a in
                return try castOrThrow(UITabBarItem.self, a[1])
            }
        return ControlEvent(events: source)
    }
}
#endif