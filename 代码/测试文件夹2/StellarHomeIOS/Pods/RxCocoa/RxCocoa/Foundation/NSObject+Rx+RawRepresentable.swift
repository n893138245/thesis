#if !os(Linux)
import RxSwift
import Foundation.NSObject
extension Reactive where Base: NSObject {
    public func observe<Element: RawRepresentable>(_ type: Element.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial], retainSelf: Bool = true) -> Observable<Element?> where Element.RawValue: KVORepresentable {
        return self.observe(Element.RawValue.KVOType.self, keyPath, options: options, retainSelf: retainSelf)
            .map(Element.init)
    }
}
#if !DISABLE_SWIZZLING
    extension Reactive where Base: NSObject {
        public func observeWeakly<Element: RawRepresentable>(_ type: Element.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial]) -> Observable<Element?> where Element.RawValue: KVORepresentable {
            return self.observeWeakly(Element.RawValue.KVOType.self, keyPath, options: options)
                .map(Element.init)
        }
    }
#endif
#endif