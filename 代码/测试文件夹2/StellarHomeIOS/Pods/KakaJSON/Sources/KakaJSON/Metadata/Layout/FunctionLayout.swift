struct FunctionLayout: Layout {
    let kind: UnsafeRawPointer
    var flags: Int
    var parameters: FieldList<Any.Type>
}