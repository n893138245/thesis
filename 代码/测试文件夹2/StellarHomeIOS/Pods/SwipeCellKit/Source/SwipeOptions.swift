import UIKit
public typealias SwipeTableOptions = SwipeOptions
public struct SwipeOptions {
    public var transitionStyle: SwipeTransitionStyle = .border
    public var expansionStyle: SwipeExpansionStyle?
    public var expansionDelegate: SwipeExpanding?
    public var backgroundColor: UIColor?
    public var maximumButtonWidth: CGFloat?
    public var minimumButtonWidth: CGFloat?
    public var buttonVerticalAlignment: SwipeVerticalAlignment = .centerFirstBaseline
    public var buttonPadding: CGFloat?
    public var buttonSpacing: CGFloat?
    public init() {}
}
public enum SwipeTransitionStyle {
    case border
    case drag
    case reveal
}
public enum SwipeActionsOrientation: CGFloat {
    case left = -1
    case right = 1
    var scale: CGFloat {
        return rawValue
    }
}
public enum SwipeVerticalAlignment {
    case centerFirstBaseline
    case center
}