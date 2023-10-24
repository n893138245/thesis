struct StructLayout: ModelLayout {
    let kind: UnsafeRawPointer
    var description: UnsafeMutablePointer<StructDescriptor>
}