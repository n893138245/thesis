#if !os(Linux)
import Foundation.NSObject
import RxSwift
public struct KeyValueObservingOptions: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let initial = KeyValueObservingOptions(rawValue: 1 << 0)
    public static let new = KeyValueObservingOptions(rawValue: 1 << 1)
}
extension Reactive where Base: NSObject {
    public func observe<Element: KVORepresentable>(_ type: Element.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial], retainSelf: Bool = true) -> Observable<Element?> {
        return self.observe(Element.KVOType.self, keyPath, options: options, retainSelf: retainSelf)
            .map(Element.init)
    }
}
#if !DISABLE_SWIZZLING && !os(Linux)
    extension Reactive where Base: NSObject {
        public func observeWeakly<Element: KVORepresentable>(_ type: Element.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial]) -> Observable<Element?> {
            return self.observeWeakly(Element.KVOType.self, keyPath, options: options)
                .map(Element.init)
        }
    }
#endif
#endif