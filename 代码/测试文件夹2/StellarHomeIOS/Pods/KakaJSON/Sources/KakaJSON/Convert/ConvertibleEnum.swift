public protocol ConvertibleEnum {
    static func kj_convert(from value: Any) -> Self?
    var kj_value: Any { get }
    static var kj_valueType: Any.Type { get }
}
public extension RawRepresentable where Self: ConvertibleEnum {
    static func kj_convert(from value: Any) -> Self? {
        return (value as? RawValue).flatMap { Self.init(rawValue: $0) }
    }
    var kj_value: Any { return rawValue }
    static var kj_valueType: Any.Type { return RawValue.self }
}