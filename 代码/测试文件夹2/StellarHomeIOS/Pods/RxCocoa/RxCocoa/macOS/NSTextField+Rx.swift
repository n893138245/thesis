#if os(macOS)
import Cocoa
import RxSwift
open class RxTextFieldDelegateProxy
    : DelegateProxy<NSTextField, NSTextFieldDelegate>
    , DelegateProxyType 
    , NSTextFieldDelegate {
    public weak private(set) var textField: NSTextField?
    init(textField: NSTextField) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxTextFieldDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxTextFieldDelegateProxy(textField: $0) }
    }
    fileprivate let textSubject = PublishSubject<String?>()
    open func controlTextDidChange(_ notification: Notification) {
        let textField: NSTextField = castOrFatalError(notification.object)
        let nextValue = textField.stringValue
        self.textSubject.on(.next(nextValue))
        _forwardToDelegate?.controlTextDidChange?(notification)
    }
    open class func currentDelegate(for object: ParentObject) -> NSTextFieldDelegate? {
        return object.delegate
    }
    open class func setCurrentDelegate(_ delegate: NSTextFieldDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }
}
extension Reactive where Base: NSTextField {
    public var delegate: DelegateProxy<NSTextField, NSTextFieldDelegate> {
        return RxTextFieldDelegateProxy.proxy(for: self.base)
    }
    public var text: ControlProperty<String?> {
        let delegate = RxTextFieldDelegateProxy.proxy(for: self.base)
        let source = Observable.deferred { [weak textField = self.base] in
            delegate.textSubject.startWith(textField?.stringValue)
        }.takeUntil(self.deallocated)
        let observer = Binder(self.base) { (control, value: String?) in
            control.stringValue = value ?? ""
        }
        return ControlProperty(values: source, valueSink: observer.asObserver())
    }
}
#endif