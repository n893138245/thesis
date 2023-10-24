import UIKit
public struct SwipeExpansionStyle {    
    public static var selection: SwipeExpansionStyle { return SwipeExpansionStyle(target: .percentage(0.5),
                                                                                  elasticOverscroll: true,
                                                                                  completionAnimation: .bounce) }
    public static var destructive: SwipeExpansionStyle { return .destructive(automaticallyDelete: true, timing: .with) }
    public static var destructiveAfterFill: SwipeExpansionStyle { return .destructive(automaticallyDelete: true, timing: .after) }
    public static var fill: SwipeExpansionStyle { return SwipeExpansionStyle(target: .edgeInset(30),
                                                                             additionalTriggers: [.overscroll(30)],
                                                                             completionAnimation: .fill(.manual(timing: .after))) }
    public static func destructive(automaticallyDelete: Bool, timing: FillOptions.HandlerInvocationTiming = .with) -> SwipeExpansionStyle {
        return SwipeExpansionStyle(target: .edgeInset(30),
                                   additionalTriggers: [.touchThreshold(0.8)],
                                   completionAnimation: .fill(automaticallyDelete ? .automatic(.delete, timing: timing) : .manual(timing: timing)))
    }
    public let target: Target
    public let additionalTriggers: [Trigger]
    public let elasticOverscroll: Bool
    public let completionAnimation: CompletionAnimation
    public var minimumTargetOverscroll: CGFloat = 20
    public var targetOverscrollElasticity: CGFloat = 0.2
    var minimumExpansionTranslation: CGFloat = 8.0
    public init(target: Target, additionalTriggers: [Trigger] = [], elasticOverscroll: Bool = false, completionAnimation: CompletionAnimation = .bounce) {
        self.target = target
        self.additionalTriggers = additionalTriggers
        self.elasticOverscroll = elasticOverscroll
        self.completionAnimation = completionAnimation
    }
    func shouldExpand(view: Swipeable, gesture: UIPanGestureRecognizer, in superview: UIView, within frame: CGRect? = nil) -> Bool {
        guard let actionsView = view.actionsView, let gestureView = gesture.view else { return false }
        guard abs(gesture.translation(in: gestureView).x) > minimumExpansionTranslation else { return false }
        let xDelta = floor(abs(frame?.minX ?? view.frame.minX))
        if xDelta <= actionsView.preferredWidth {
            return false
        } else if xDelta > targetOffset(for: view) {
            return true
        }
        let referenceFrame: CGRect = frame != nil ? view.frame : superview.bounds
        for trigger in additionalTriggers {
            if trigger.isTriggered(view: view, gesture: gesture, in: superview, referenceFrame: referenceFrame) {
                return true
            }
        }
        return false
    }
    func targetOffset(for view: Swipeable) -> CGFloat {
        return target.offset(for: view, minimumOverscroll: minimumTargetOverscroll)
    }
}
extension SwipeExpansionStyle {    
    public enum Target {
        case percentage(CGFloat)
        case edgeInset(CGFloat)
        func offset(for view: Swipeable, minimumOverscroll: CGFloat) -> CGFloat {
            guard let actionsView = view.actionsView else { return .greatestFiniteMagnitude }
            let offset: CGFloat = {
                switch self {
                case .percentage(let value):
                    return view.frame.width * value
                case .edgeInset(let value):
                    return view.frame.width - value
                }
            }()
            return max(actionsView.preferredWidth + minimumOverscroll, offset)
        }
    }
    public enum Trigger {
        case touchThreshold(CGFloat)
        case overscroll(CGFloat)
        func isTriggered(view: Swipeable, gesture: UIPanGestureRecognizer, in superview: UIView, referenceFrame: CGRect) -> Bool {
            guard let actionsView = view.actionsView else { return false }
            switch self {
            case .touchThreshold(let value):
                let location = gesture.location(in: superview).x - referenceFrame.origin.x
                let locationRatio = (actionsView.orientation == .left ? location : referenceFrame.width - location) / referenceFrame.width
                return locationRatio > value
            case .overscroll(let value):
                return abs(view.frame.minX) > actionsView.preferredWidth + value
            }
        }
    }
    public enum CompletionAnimation {
        case fill(FillOptions)
        case bounce
    }
    public struct FillOptions {
        public enum HandlerInvocationTiming {
            case with
            case after
        }
        public static func automatic(_ style: ExpansionFulfillmentStyle, timing: HandlerInvocationTiming) -> FillOptions {
            return FillOptions(autoFulFillmentStyle: style, timing: timing)
        }
        public static func manual(timing: HandlerInvocationTiming) -> FillOptions {
            return FillOptions(autoFulFillmentStyle: nil, timing: timing)
        }
        public let autoFulFillmentStyle: ExpansionFulfillmentStyle?
        public let timing: HandlerInvocationTiming
    }
}
extension SwipeExpansionStyle.Target: Equatable {
    public static func ==(lhs: SwipeExpansionStyle.Target, rhs: SwipeExpansionStyle.Target) -> Bool {
        switch (lhs, rhs) {
        case (.percentage(let lhs), .percentage(let rhs)):
            return lhs == rhs
        case (.edgeInset(let lhs), .edgeInset(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
extension SwipeExpansionStyle.CompletionAnimation: Equatable {
    public static func ==(lhs: SwipeExpansionStyle.CompletionAnimation, rhs: SwipeExpansionStyle.CompletionAnimation) -> Bool {
        switch (lhs, rhs) {
        case (.fill, .fill):
            return true
        case (.bounce, .bounce):
            return true
        default:
            return false
        }
    }
}