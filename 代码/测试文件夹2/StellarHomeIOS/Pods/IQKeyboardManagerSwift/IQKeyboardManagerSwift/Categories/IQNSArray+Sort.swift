import Foundation
import UIKit
internal extension Array where Element: UIView {
    func sortedArrayByTag() -> [Element] {
        return sorted(by: { (obj1: Element, obj2: Element) -> Bool in
            return (obj1.tag < obj2.tag)
        })
    }
    func sortedArrayByPosition() -> [Element] {
        return sorted(by: { (obj1: Element, obj2: Element) -> Bool in
            if obj1.frame.minY != obj2.frame.minY {
                return obj1.frame.minY < obj2.frame.minY
            } else {
                return obj1.frame.minX < obj2.frame.minX
            }
        })
    }
}