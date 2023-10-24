struct StructDescriptor: ModelDescriptor {
    let flags: ContextDescriptorFlags
    let parent: RelativeContextPointer
    var name: RelativeDirectPointer<CChar>
    let accessFunctionPtr: RelativeDirectPointer<MetadataResponse>
    var fields: RelativeDirectPointer<FieldDescriptor>
    let numFields: UInt32
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int32>
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}