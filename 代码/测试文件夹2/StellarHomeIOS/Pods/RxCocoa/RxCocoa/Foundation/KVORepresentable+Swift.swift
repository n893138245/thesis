import class Foundation.NSNumber
extension Int : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.int32Value)
    }
}
extension Int32 : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.int32Value)
    }
}
extension Int64 : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.int64Value)
    }
}
extension UInt : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.uintValue)
    }
}
extension UInt32 : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.uint32Value)
    }
}
extension UInt64 : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.uint64Value)
    }
}
extension Bool : KVORepresentable {
    public typealias KVOType = NSNumber
    public init?(KVOValue: KVOType) {
        self.init(KVOValue.boolValue)
    }
}
extension RawRepresentable where RawValue: KVORepresentable {
    init?(KVOValue: RawValue.KVOType?) {
        guard let KVOValue = KVOValue else {
            return nil
        }
        guard let rawValue = RawValue(KVOValue: KVOValue) else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
}