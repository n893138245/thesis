#if os(iOS) || os(macOS)
import RxSwift
import WebKit
@available(iOS 8.0, OSX 10.10, OSXApplicationExtension 10.10, *)
open class RxWKNavigationDelegateProxy
    : DelegateProxy<WKWebView, WKNavigationDelegate>
    , DelegateProxyType
, WKNavigationDelegate {
    public weak private(set) var webView: WKWebView?
    public init(webView: ParentObject) {
        self.webView = webView
        super.init(parentObject: webView, delegateProxy: RxWKNavigationDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxWKNavigationDelegateProxy(webView: $0) }
    }
    public static func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
        object.navigationDelegate
    }
    public static func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
        object.navigationDelegate = delegate
    }
}
#endif