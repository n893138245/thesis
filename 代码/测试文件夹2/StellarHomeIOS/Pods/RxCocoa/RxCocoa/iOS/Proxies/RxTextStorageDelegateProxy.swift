#if os(iOS) || os(tvOS)
    import RxSwift
    import UIKit
    extension NSTextStorage: HasDelegate {
        public typealias Delegate = NSTextStorageDelegate
    }
    open class RxTextStorageDelegateProxy
        : DelegateProxy<NSTextStorage, NSTextStorageDelegate>
        , DelegateProxyType 
        , NSTextStorageDelegate {
        public weak private(set) var textStorage: NSTextStorage?
        public init(textStorage: NSTextStorage) {
            self.textStorage = textStorage
            super.init(parentObject: textStorage, delegateProxy: RxTextStorageDelegateProxy.self)
        }
        public static func registerKnownImplementations() {
            self.register { RxTextStorageDelegateProxy(textStorage: $0) }
        }
    }
#endif