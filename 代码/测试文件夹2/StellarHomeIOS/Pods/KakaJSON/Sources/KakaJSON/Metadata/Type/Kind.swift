public enum Kind {
    case `class`
    case `struct`
    case `enum`
    case optional
    case foreignClass
    case opaque
    case tuple
    case function
    case existential
    case metatype
    case objCClassWrapper
    case existentialMetatype
    case heapLocalVariable
    case heapArray
    case heapGenericLocalVariable
    case errorObject
    private static let nonType: UInt = 0x400
    private static let nonHeap: UInt = 0x200
    private static let runtimePrivate: UInt = 0x100
    private static let runtimePrivate_nonHeap = runtimePrivate | nonHeap
    private static let runtimePrivate_nonType = runtimePrivate | nonType
    init(_ type: Any.Type) {
        let kind = (type ~>> UnsafePointer<UInt>.self).pointee
        switch kind {
        case 0 | Kind.nonHeap, 1: self = .struct
        case 1 | Kind.nonHeap, 2: self = .enum
        case 2 | Kind.nonHeap, 3: self = .optional
        case 3 | Kind.nonHeap: self = .foreignClass
        case 0 | Kind.runtimePrivate_nonHeap, 8: self = .opaque
        case 1 | Kind.runtimePrivate_nonHeap, 9: self = .tuple
        case 2 | Kind.runtimePrivate_nonHeap, 10: self = .function
        case 3 | Kind.runtimePrivate_nonHeap, 12: self = .existential
        case 4 | Kind.runtimePrivate_nonHeap, 13: self = .metatype
        case 5 | Kind.runtimePrivate_nonHeap, 14: self = .objCClassWrapper
        case 6 | Kind.runtimePrivate_nonHeap, 15: self = .existentialMetatype
        case 0 | Kind.nonType, 64: self = .heapLocalVariable
        case 0 | Kind.runtimePrivate_nonType: self = .heapGenericLocalVariable
        case 1 | Kind.runtimePrivate_nonType: self = .errorObject
        case 65: self = .heapArray
        case 0: fallthrough
        default: self = .class
        }
    }
}