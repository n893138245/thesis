import Foundation
protocol OptionalValue {
    var kj_value: Any? { get }
}
extension Optional: OptionalValue {
    var kj_value: Any? {
        guard let v = self else { return nil }
        return (v as? OptionalValue)?.kj_value ?? v
    }
}