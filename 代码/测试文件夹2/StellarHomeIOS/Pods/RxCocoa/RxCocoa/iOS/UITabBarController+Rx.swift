#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
#if os(iOS)
extension Reactive where Base: UITabBarController {
    public var willBeginCustomizing: ControlEvent<[UIViewController]> {
        let source = delegate.methodInvoked(#selector(UITabBarControllerDelegate.tabBarController(_:willBeginCustomizing:)))
            .map { a in
                return try castOrThrow([UIViewController].self, a[1])
        }
        return ControlEvent(events: source)
    }
    public var willEndCustomizing: ControlEvent<(viewControllers: [UIViewController], changed: Bool)> {
        let source = delegate.methodInvoked(#selector(UITabBarControllerDelegate.tabBarController(_:willEndCustomizing:changed:)))
            .map { (a: [Any]) -> (viewControllers: [UIViewController], changed: Bool) in
                let viewControllers = try castOrThrow([UIViewController].self, a[1])
                let changed = try castOrThrow(Bool.self, a[2])
                return (viewControllers, changed)
        }
        return ControlEvent(events: source)
    }
    public var didEndCustomizing: ControlEvent<(viewControllers: [UIViewController], changed: Bool)> {
        let source = delegate.methodInvoked(#selector(UITabBarControllerDelegate.tabBarController(_:didEndCustomizing:changed:)))
            .map { (a: [Any]) -> (viewControllers: [UIViewController], changed: Bool) in
                let viewControllers = try castOrThrow([UIViewController].self, a[1])
                let changed = try castOrThrow(Bool.self, a[2])
                return (viewControllers, changed)
        }
        return ControlEvent(events: source)
    }
}
#endif
    extension Reactive where Base: UITabBarController {
    public var delegate: DelegateProxy<UITabBarController, UITabBarControllerDelegate> {
        return RxTabBarControllerDelegateProxy.proxy(for: base)
    }
    public var didSelect: ControlEvent<UIViewController> {
        let source = delegate.methodInvoked(#selector(UITabBarControllerDelegate.tabBarController(_:didSelect:)))
            .map { a in
                return try castOrThrow(UIViewController.self, a[1])
        }
        return ControlEvent(events: source)
    }
}
#endif