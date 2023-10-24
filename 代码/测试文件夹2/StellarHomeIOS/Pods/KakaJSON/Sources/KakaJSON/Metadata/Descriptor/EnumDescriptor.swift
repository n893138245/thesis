struct EnumDescriptor: NominalDescriptor {
    let flags: ContextDescriptorFlags
    let parent: RelativeContextPointer
    var name: RelativeDirectPointer<CChar>
    let accessFunctionPtr: RelativeDirectPointer<MetadataResponse>
    var fields: RelativeDirectPointer<FieldDescriptor>
    let numPayloadCasesAndPayloadSizeOffset: UInt32
    let numEmptyCases: UInt32
    let fieldOffsetVectorOffset: FieldOffsetPointer<Int32>
    let genericContextHeader: TargetTypeGenericContextDescriptorHeader
}