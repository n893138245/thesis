struct ClassLayout: ModelLayout {
    let kind: UnsafeRawPointer
    let superclass: Any.Type
    let runtimeReserved0: UInt
    let runtimeReserved1: UInt
    let rodata: UInt
    let flags: UInt32
    let instanceAddressPoint: UInt32
    let instanceSize: UInt32
    let instanceAlignMask: UInt16
    let reserved: UInt16
    let classSize: UInt32
    let classAddressPoint: UInt32
    var description: UnsafeMutablePointer<ClassDescriptor>
    let iVarDestroyer: UnsafeRawPointer
    var genericTypeOffset: Int {
        let descriptor = description.pointee
        if (0x4000 & flags) == 0 {
            return (flags & 0x800) == 0
            ? Int(descriptor.metadataPositiveSizeInWords - descriptor.numImmediateMembers)
            : -Int(descriptor.metadataNegativeSizeInWords)
        }
        return GenenicTypeOffset.wrong
    }
}