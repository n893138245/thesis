import Foundation
extension FloatingPoint {
    typealias identity = Self
    public var identity: Self {
        return self
    }
}
extension Float : IdentifiableType {
}
extension Double : IdentifiableType {
}