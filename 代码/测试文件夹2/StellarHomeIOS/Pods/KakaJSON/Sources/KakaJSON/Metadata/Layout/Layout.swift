protocol Layout {
    var kind: UnsafeRawPointer { get }
}
protocol NominalLayout: Layout {
    associatedtype DescriptorType: NominalDescriptor
    var description: UnsafeMutablePointer<DescriptorType> { get }
    var genericTypeOffset: Int { get }
}
extension NominalLayout {
    var genericTypeOffset: Int { return 2 }
}
protocol ModelLayout: NominalLayout where DescriptorType: ModelDescriptor  {}