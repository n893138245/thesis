#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UINavigationController {
    public typealias ShowEvent = (viewController: UIViewController, animated: Bool)
    public var delegate: DelegateProxy<UINavigationController, UINavigationControllerDelegate> {
        return RxNavigationControllerDelegateProxy.proxy(for: base)
    }
    public var willShow: ControlEvent<ShowEvent> {
        let source: Observable<ShowEvent> = delegate
            .methodInvoked(#selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:)))
            .map { arg in
                let viewController = try castOrThrow(UIViewController.self, arg[1])
                let animated = try castOrThrow(Bool.self, arg[2])
                return (viewController, animated)
        }
        return ControlEvent(events: source)
    }
    public var didShow: ControlEvent<ShowEvent> {
        let source: Observable<ShowEvent> = delegate
            .methodInvoked(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { arg in
                let viewController = try castOrThrow(UIViewController.self, arg[1])
                let animated = try castOrThrow(Bool.self, arg[2])
                return (viewController, animated)
        }
        return ControlEvent(events: source)
    }
}
#endif