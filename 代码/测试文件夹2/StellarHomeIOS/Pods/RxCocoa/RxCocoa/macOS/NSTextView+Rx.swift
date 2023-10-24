#if os(macOS)
import Cocoa
import RxSwift
open class RxTextViewDelegateProxy: DelegateProxy<NSTextView, NSTextViewDelegate>, DelegateProxyType, NSTextViewDelegate {
    #if compiler(>=5.2)
    public private(set) var textView: NSTextView?
    #else
    public weak private(set) var textView: NSTextView?
    #endif
    init(textView: NSTextView) {
        self.textView = textView
        super.init(parentObject: textView, delegateProxy: RxTextViewDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxTextViewDelegateProxy(textView: $0) }
    }
    fileprivate let textSubject = PublishSubject<String>()
    open func textDidChange(_ notification: Notification) {
        let textView: NSTextView = castOrFatalError(notification.object)
        let nextValue = textView.string
        self.textSubject.on(.next(nextValue))
        self._forwardToDelegate?.textDidChange?(notification)
    }
    open class func currentDelegate(for object: ParentObject) -> NSTextViewDelegate? {
        return object.delegate
    }
    open class func setCurrentDelegate(_ delegate: NSTextViewDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }
}
extension Reactive where Base: NSTextView {
    public var delegate: DelegateProxy<NSTextView, NSTextViewDelegate> {
        return RxTextViewDelegateProxy.proxy(for: self.base)
    }
    public var string: ControlProperty<String> {
        let delegate = RxTextViewDelegateProxy.proxy(for: self.base)
        let source = Observable.deferred { [weak textView = self.base] in
            delegate.textSubject.startWith(textView?.string ?? "")
        }.takeUntil(self.deallocated)
        let observer = Binder(self.base) { control, value in
            control.string = value
        }
        return ControlProperty(values: source, valueSink: observer.asObserver())
    }
}
#endif