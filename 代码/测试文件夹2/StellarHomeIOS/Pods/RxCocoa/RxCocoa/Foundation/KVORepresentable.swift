public protocol KVORepresentable {
    associatedtype KVOType
    init?(KVOValue: KVOType)
}
extension KVORepresentable {
    init?(KVOValue: KVOType?) {
        guard let KVOValue = KVOValue else {
            return nil
        }
        self.init(KVOValue: KVOValue)
    }
}