#if os(Linux)
import class Foundation.NSObject
final class RxMutableBox<T>: NSObject {
    var value: T
    init (_ value: T) {
        self.value = value
    }
}
#else
final class RxMutableBox<T>: CustomDebugStringConvertible {
    var value: T
    init (_ value: T) {
        self.value = value
    }
}
extension RxMutableBox {
    var debugDescription: String {
        return "MutatingBox(\(self.value))"
    }
}
#endif