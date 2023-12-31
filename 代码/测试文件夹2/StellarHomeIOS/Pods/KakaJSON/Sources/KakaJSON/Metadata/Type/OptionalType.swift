public class OptionalType: EnumType {
    public private(set) var wrapType: Any.Type = Any.self
    override func build() {
        super.build()
        var wt: BaseType! = self
        while wt.kind == .optional {
            wt = Metadata.type((wt as! OptionalType).genericTypes![0])
        }
        wrapType = wt.type
    }
    override public var description: String {
        return "\(name) { kind = \(kind), wrapType = \(wrapType) }"
    }
}