public struct Reactive<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
public protocol ReactiveCompatible {
    associatedtype ReactiveBase
    @available(*, deprecated, renamed: "ReactiveBase")
    typealias CompatibleType = ReactiveBase
    static var rx: Reactive<ReactiveBase>.Type { get set }
    var rx: Reactive<ReactiveBase> { get set }
}
extension ReactiveCompatible {
    public static var rx: Reactive<Self>.Type {
        get {
            return Reactive<Self>.self
        }
        set {
        }
    }
    public var rx: Reactive<Self> {
        get {
            return Reactive(self)
        }
        set {
        }
    }
}
import class Foundation.NSObject
extension NSObject: ReactiveCompatible { }