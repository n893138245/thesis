import UIKit
public protocol SwipeActionTransitioning {
    func didTransition(with context: SwipeActionTransitioningContext) -> Void
}
public struct SwipeActionTransitioningContext {
    public let actionIdentifier: String?
    public let button: UIButton
    public let newPercentVisible: CGFloat
    public let oldPercentVisible: CGFloat
    internal let wrapperView: UIView
    internal init(actionIdentifier: String?, button: UIButton, newPercentVisible: CGFloat, oldPercentVisible: CGFloat, wrapperView: UIView) {
        self.actionIdentifier = actionIdentifier
        self.button = button
        self.newPercentVisible = newPercentVisible
        self.oldPercentVisible = oldPercentVisible
        self.wrapperView = wrapperView
    }
    public func setBackgroundColor(_ color: UIColor?) {
        wrapperView.backgroundColor = color
    }
}
public struct ScaleTransition: SwipeActionTransitioning {
    public static var `default`: ScaleTransition { return ScaleTransition() }
    public let duration: Double
    public let initialScale: CGFloat
    public let threshold: CGFloat
    public init(duration: Double = 0.15, initialScale: CGFloat = 0.8, threshold: CGFloat = 0.5) {
        self.duration = duration
        self.initialScale = initialScale
        self.threshold = threshold
    }
    public func didTransition(with context: SwipeActionTransitioningContext) -> Void {
        if context.oldPercentVisible == 0 {
            context.button.transform = .init(scaleX: initialScale, y: initialScale)
        }
        if context.oldPercentVisible < threshold && context.newPercentVisible >= threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .identity
            }
        } else if context.oldPercentVisible >= threshold && context.newPercentVisible < threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .init(scaleX: self.initialScale, y: self.initialScale)
            }
        }
    }
}