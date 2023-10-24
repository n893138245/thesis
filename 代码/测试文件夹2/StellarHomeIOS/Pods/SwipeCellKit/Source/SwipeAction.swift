import UIKit
public enum SwipeActionStyle: Int {
    case `default`
    case destructive
}
public class SwipeAction: NSObject {
    public var identifier: String?
    public var title: String?
    public var style: SwipeActionStyle
    public var transitionDelegate: SwipeActionTransitioning?
    public var font: UIFont?
    public var textColor: UIColor?
    public var highlightedTextColor: UIColor?
    public var image: UIImage?
    public var highlightedImage: UIImage?
    public var handler: ((SwipeAction, IndexPath) -> Void)?
    public var backgroundColor: UIColor?
    public var highlightedBackgroundColor: UIColor?
    public var backgroundEffect: UIVisualEffect?
    public var hidesWhenSelected = false
    public init(style: SwipeActionStyle, title: String?, handler: ((SwipeAction, IndexPath) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    public func fulfill(with style: ExpansionFulfillmentStyle) {
        completionHandler?(style)
    }
    internal var completionHandler: ((ExpansionFulfillmentStyle) -> Void)?
}
public enum ExpansionFulfillmentStyle {
    case delete
    case reset
}
internal extension SwipeAction {
    var hasBackgroundColor: Bool {
        return backgroundColor != .clear && backgroundEffect == nil
    }
}