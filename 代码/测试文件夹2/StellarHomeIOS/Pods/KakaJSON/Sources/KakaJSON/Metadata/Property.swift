public class Property: CustomStringConvertible {
    public let name: String
    public let type: Any.Type
    public private(set) lazy var dataType: Any.Type = type~!
    public let isVar: Bool
    public let offset: Int
    public let ownerType: Any.Type
    init(name: String, type: Any.Type,
         isVar: Bool, offset: Int,
         ownerType: Any.Type) {
        self.name = name
        self.type = type
        self.isVar = isVar
        self.offset = offset
        self.ownerType = ownerType
    }
    func set(_ value: Any, for model: UnsafeMutableRawPointer) {
        (model + offset).kj_set(value, type)
    }
    func get(from model: UnsafeMutableRawPointer) -> Any {
        return (model + offset).kj_get(type)
    }
    public var description: String {
        return "\(name) { type = \(type), isVar = \(isVar), offset = \(offset), ownerType = \(ownerType) }"
    }
}