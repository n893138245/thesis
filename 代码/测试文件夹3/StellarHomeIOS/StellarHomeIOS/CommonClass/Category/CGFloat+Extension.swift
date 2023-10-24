import UIKit
extension CGFloat: SSCompatible {}
extension SS where Base == CGFloat {
    func truncate(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat(Int(base * divisor)) / divisor
    }
}