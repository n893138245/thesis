#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif
public class LayoutConstraint : NSLayoutConstraint {
    public var label: String? {
        get {
            return self.identifier
        }
        set {
            self.identifier = newValue
        }
    }
    internal weak var constraint: Constraint? = nil
}
internal func ==(lhs: LayoutConstraint, rhs: LayoutConstraint) -> Bool {
    guard lhs.firstAttribute == rhs.firstAttribute &&
          lhs.secondAttribute == rhs.secondAttribute &&
          lhs.relation == rhs.relation &&
          lhs.priority == rhs.priority &&
          lhs.multiplier == rhs.multiplier &&
          lhs.secondItem === rhs.secondItem &&
          lhs.firstItem === rhs.firstItem else {
        return false
    }
    return true
}