struct ClassDescriptor: ModelDescriptor {
    let flags: ContextDescriptorFlags
    let parent: RelativeContextPointer
    var name: RelativeDirectPointer<CChar>
    let accessFunctionPtr: RelativeDirectPointer<MetadataResponse>
    var fields: RelativeDirectPointer<FieldDescriptor>
    let superclassType: RelativeDirectPointer<CChar>
    let metadataNegativeSizeInWords: UInt32
    let metadataPositiveSizeInWords: UInt32
    let numImmediateMembers: UInt32
    let numFields: UInt32
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int>
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}