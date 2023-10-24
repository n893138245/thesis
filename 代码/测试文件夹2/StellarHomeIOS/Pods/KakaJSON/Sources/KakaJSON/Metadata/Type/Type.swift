public protocol Type : AnyObject {
    var name: String { get }
    var type: Any.Type { get }
    var kind: Kind { get }
    var module: String { get }
    var isSystemModule: Bool { get }
}
protocol LayoutType: Type {
    associatedtype InnerLayout: Layout
    var layout: UnsafeMutablePointer<InnerLayout>! { get }
}
extension LayoutType {
    func builtLayout() -> UnsafeMutablePointer<InnerLayout> {
        return type ~>> UnsafeMutablePointer<InnerLayout>.self
    }
}
protocol NominalType: Type {
    var genericTypes: [Any.Type]? { get }
}
extension NominalType where Self: LayoutType, InnerLayout: NominalLayout {
    func genenicTypesPtr() -> UnsafeMutablePointer<FieldList<Any.Type>> {
        let offset = layout.pointee.genericTypeOffset * MemoryLayout<UnsafeRawPointer>.size
        return ((type ~>> UnsafeMutableRawPointer.self) + offset) ~> FieldList<Any.Type>.self
    }
    func builtGenericTypes() -> [Any.Type]? {
        let description = layout.pointee.description
        if !description.pointee.isGeneric { return nil }
        let typesCount = description.pointee.genericTypesCount
        if typesCount <= 0 { return nil }
        if layout.pointee.genericTypeOffset == GenenicTypeOffset.wrong { return nil }
        let ptr = genenicTypesPtr()
        return (0..<typesCount).map { ptr.pointee.item($0) }
    }
}
enum GenenicTypeOffset {
    static let wrong = Int.min
}
protocol PropertyType: NominalType {
    var properties: [Property]? { get }
}
extension PropertyType where Self: LayoutType, InnerLayout: ModelLayout {
    func builtProperties() -> [Property]? {
        let description = layout.pointee.description
        let offsets = description.pointee.fieldOffsets(type)
        if offsets.isEmpty { return nil }
        let fieldDescriptorPtr = description.pointee.fields.advanced()
        let ptr = genenicTypesPtr()
        return (0..<Int(description.pointee.numFields)).map { i -> Property in
            let recordPtr = fieldDescriptorPtr.pointee.fieldRecords.ptr(i)
            return Property(name: recordPtr.pointee.fieldName(),
                            type: recordPtr.pointee.type(layout.pointee.description, ptr),
                            isVar: recordPtr.pointee.isVar,
                            offset: offsets[i],
                            ownerType: type)
        }
    }
}