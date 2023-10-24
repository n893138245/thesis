struct EnumLayout: NominalLayout {
    let kind: UnsafeRawPointer
    var description: UnsafeMutablePointer<EnumDescriptor>
}