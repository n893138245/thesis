#if os(iOS)
    import RxSwift
    import UIKit
    @available(iOS 8.0, *)
    extension Reactive where Base: UISearchController {
        public var delegate: DelegateProxy<UISearchController, UISearchControllerDelegate> {
            return RxSearchControllerDelegateProxy.proxy(for: base)
        }
        public var didDismiss: Observable<Void> {
            return delegate
                .methodInvoked( #selector(UISearchControllerDelegate.didDismissSearchController(_:)))
                .map { _ in }
        }
        public var didPresent: Observable<Void> {
            return delegate
                .methodInvoked(#selector(UISearchControllerDelegate.didPresentSearchController(_:)))
                .map { _ in }
        }
        public var present: Observable<Void> {
            return delegate
                .methodInvoked( #selector(UISearchControllerDelegate.presentSearchController(_:)))
                .map { _ in }
        }
        public var willDismiss: Observable<Void> {
            return delegate
                .methodInvoked(#selector(UISearchControllerDelegate.willDismissSearchController(_:)))
                .map { _ in }
        }
        public var willPresent: Observable<Void> {
            return delegate
                .methodInvoked( #selector(UISearchControllerDelegate.willPresentSearchController(_:)))
                .map { _ in }
        }
    }
#endif