public class ClassType: ModelType, PropertyType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<ClassLayout>!
    public private(set) var `super`: ClassType?
    override func build() {
        super.build()
        layout = builtLayout()
        genericTypes = builtGenericTypes()
        properties = builtProperties()
        `super` = Metadata.type(layout.pointee.superclass) as? ClassType
        if let superProperties = `super`?.properties {
            properties = properties ?? []
            properties!.insert(contentsOf: superProperties, at: 0)
        }
    }
    override public var description: String {
        return "\(name) { kind = \(kind), properties = \(properties ?? []), genericTypes = \(genericTypes ?? []), super = \(`super` != nil ? String(describing: `super`!) : "nil") }"
    }
}