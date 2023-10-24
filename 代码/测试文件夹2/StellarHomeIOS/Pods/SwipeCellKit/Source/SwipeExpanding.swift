import UIKit
public protocol SwipeExpanding {
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> SwipeExpansionAnimationTimingParameters
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton])
}
public struct SwipeExpansionAnimationTimingParameters {
    public static var `default`: SwipeExpansionAnimationTimingParameters { return SwipeExpansionAnimationTimingParameters() }
    public var duration: Double
    public var delay: Double
    public init(duration: Double = 0.6, delay: Double = 0) {
        self.duration = duration
        self.delay = delay
    }
}
public struct ScaleAndAlphaExpansion: SwipeExpanding {
    public static var `default`: ScaleAndAlphaExpansion { return ScaleAndAlphaExpansion() }
    public let duration: Double
    public let scale: CGFloat
    public let interButtonDelay: Double
    public init(duration: Double = 0.15, scale: CGFloat = 0.8, interButtonDelay: Double = 0.1) {
        self.duration = duration
        self.scale = scale
        self.interButtonDelay = interButtonDelay
    }
    public func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> SwipeExpansionAnimationTimingParameters {
        var timingParameters = SwipeExpansionAnimationTimingParameters.default
        timingParameters.delay = expanding ? interButtonDelay : 0
        return timingParameters
    }
    public func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton]) {
        let buttons = expanding ? otherActionButtons : otherActionButtons.reversed()
        buttons.enumerated().forEach { index, button in
            UIView.animate(withDuration: duration, delay: interButtonDelay * Double(expanding ? index : index + 1), options: [], animations: {
                button.transform = expanding ? .init(scaleX: self.scale, y: self.scale) : .identity
                button.alpha = expanding ? 0.0 : 1.0
            }, completion: nil)
        }
    }
}