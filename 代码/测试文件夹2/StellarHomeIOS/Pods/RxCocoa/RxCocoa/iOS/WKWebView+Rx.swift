#if os(iOS) || os(macOS)
import RxSwift
import WebKit
@available(iOS 8.0, OSX 10.10, OSXApplicationExtension 10.10, *)
extension Reactive where Base: WKWebView {
    public var navigationDelegate: DelegateProxy<WKWebView, WKNavigationDelegate> {
        RxWKNavigationDelegateProxy.proxy(for: base)
    }
    public var didCommit: Observable<WKNavigation> {
        navigationDelegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didCommit:)))
            .map { a in try castOrThrow(WKNavigation.self, a[1]) }
    }
    public var didStartLoad: Observable<WKNavigation> {
        navigationDelegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:)))
            .map { a in try castOrThrow(WKNavigation.self, a[1]) }
    }
    public var didFinishLoad: Observable<WKNavigation> {
        navigationDelegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didFinish:)))
            .map { a in try castOrThrow(WKNavigation.self, a[1]) }
    }
    public var didFailLoad: Observable<(WKNavigation, Error)> {
        navigationDelegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didFail:withError:)))
            .map { a in
                (
                    try castOrThrow(WKNavigation.self, a[1]),
                    try castOrThrow(Error.self, a[2])
                )
            }
    }
}
#endif