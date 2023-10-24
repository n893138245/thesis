import Foundation
extension NSObject {
    static func newConvertible() -> Convertible {
        return self.init() as! Convertible
    }
}