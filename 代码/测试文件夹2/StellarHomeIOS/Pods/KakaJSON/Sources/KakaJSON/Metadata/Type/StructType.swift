public class StructType: ModelType, PropertyType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<StructLayout>!
    override func build() {
        super.build()
        layout = builtLayout()
        properties = builtProperties()
        genericTypes = builtGenericTypes()
    }
    override public var description: String {
        return "\(name) { kind = \(kind), properties = \(properties ?? []), genericTypes = \(genericTypes ?? []) }"
    }
}