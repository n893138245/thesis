public struct KJ<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KJCompatible {}
public extension KJCompatible {
    static var kj: KJ<Self>.Type {
        get { return KJ<Self>.self }
        set {}
    }
    var kj: KJ<Self> {
        get { return KJ(self) }
        set {}
    }
}
public struct KJGeneric<Base, T> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KJGenericCompatible {
    associatedtype T
}
public extension KJGenericCompatible {
    static var kj: KJGeneric<Self, T>.Type {
        get { return KJGeneric<Self, T>.self }
        set {}
    }
    var kj: KJGeneric<Self, T> {
        get { return KJGeneric(self) }
        set {}
    }
}
public struct KJGeneric2<Base, T1, T2> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol KJGenericCompatible2 {
    associatedtype T1
    associatedtype T2
}
public extension KJGenericCompatible2 {
    static var kj: KJGeneric2<Self, T1, T2>.Type {
        get { return KJGeneric2<Self, T1, T2>.self }
        set {}
    }
    var kj: KJGeneric2<Self, T1, T2> {
        get { return KJGeneric2(self) }
        set {}
    }
}