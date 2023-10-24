protocol Descriptor {}
protocol NominalDescriptor: Descriptor {
    var flags: ContextDescriptorFlags { get }
    var parent: RelativeContextPointer { get }
    var name: RelativeDirectPointer<CChar> { get set }
    var accessFunctionPtr: RelativeDirectPointer<MetadataResponse> { get }
    var fields: RelativeDirectPointer<FieldDescriptor> { get set }
    associatedtype OffsetType: BinaryInteger
    var fieldOffsetVectorOffset: FieldOffsetPointer<OffsetType> { get }
    var genericContextHeader: TargetTypeGenericContextDescriptorHeader { get }
}
extension NominalDescriptor {
    var isGeneric: Bool { return (flags.value & 0x80) != 0 }
    var genericTypesCount: Int { return Int(genericContextHeader.base.numberOfParams) }
}
protocol ModelDescriptor: NominalDescriptor {
    var numFields: UInt32 { get }
}
extension ModelDescriptor {
    func fieldOffsets(_ type: Any.Type) -> [Int] {
        let ptr = ((type ~>> UnsafePointer<Int>.self) + Int(fieldOffsetVectorOffset.offset))
            .kj_raw ~> OffsetType.self
        return (0..<Int(numFields)).map { Int(ptr[$0]) }
    }
}
struct ContextDescriptorFlags {
    let value: UInt32
}
struct RelativeContextPointer {
    let offset: Int32
}
struct RelativeDirectPointer <Pointee> {
    var relativeOffset: Int32
    mutating func advanced() -> UnsafeMutablePointer<Pointee> {
        let offset = relativeOffset
        return withUnsafeMutablePointer(to: &self) {
            ($0.kj_raw + Int(offset)) ~> Pointee.self
        }
    }
}
struct FieldOffsetPointer <Pointee: BinaryInteger> {
    let offset: UInt32
}
struct MetadataResponse {}
struct TargetTypeGenericContextDescriptorHeader {
    var instantiationCache: Int32
    var defaultInstantiationPattern: Int32
    var base: TargetGenericContextDescriptorHeader
}
struct TargetGenericContextDescriptorHeader {
    var numberOfParams: UInt16
    var numberOfRequirements: UInt16
    var numberOfKeyArguments: UInt16
    var numberOfExtraArguments: UInt16
}