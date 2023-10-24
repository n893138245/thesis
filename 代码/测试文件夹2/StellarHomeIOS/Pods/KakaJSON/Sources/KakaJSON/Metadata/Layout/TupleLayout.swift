struct TupleLayout: Layout {
    let kind: UnsafeRawPointer
    let numElements: Int
    let labels: UnsafeMutablePointer<CChar>
    var elements: FieldList<TupleElement>
}
struct TupleElement {
    let type: Any.Type
    let offset: Int
}