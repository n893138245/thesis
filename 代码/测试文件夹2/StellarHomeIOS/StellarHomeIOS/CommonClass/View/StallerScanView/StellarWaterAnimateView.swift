import UIKit
class StellarWaterAnimateView: UIView {
    private let pulsingCount = 3
    private let animationDuration = 4.0
    private let multiple = 2.25
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func getanimationGroup(animations: [CAAnimation], index: Int) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = CACurrentMediaTime() + Double(index) * animationDuration / Double(pulsingCount)
        animationGroup.duration = CFTimeInterval(animationDuration)
        animationGroup.repeatCount = HUGE;
        animationGroup.animations = animations
        animationGroup.isRemovedOnCompletion = false
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: .default)
        return animationGroup
    }
    private func getPulsingLayer(rect: CGRect, animation: CAAnimationGroup) -> CALayer {
        let pulsingLayer = CALayer()
        pulsingLayer.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        pulsingLayer.cornerRadius = rect.size.height / 2
        pulsingLayer.borderWidth = 0.5
        pulsingLayer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        pulsingLayer.add(animation, forKey: "plulsing")
        return pulsingLayer
    }
    private lazy var animationArray: [CAAnimation] = {
        return [scaleAnimation,backgroundColorAnimation,borderColorAnimation]
    }()
    private lazy var scaleAnimation: CABasicAnimation = {
        let scaleAnimation = CABasicAnimation()
        scaleAnimation.keyPath = "transform.scale"
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = multiple
        return scaleAnimation
    }()
    private lazy var borderColorAnimation: CAKeyframeAnimation = {
        let borderColorAnimation = CAKeyframeAnimation()
        borderColorAnimation.keyPath = "borderColor"
        borderColorAnimation.values = [
            UIColor.black.withAlphaComponent(0.15).cgColor,
            UIColor.black.withAlphaComponent(0.05).cgColor,
            UIColor.black.withAlphaComponent(0.01).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        borderColorAnimation.keyTimes = [0.3, 0.6, 0.9, 1]
        return borderColorAnimation
    }()
    private lazy var backgroundColorAnimation: CAKeyframeAnimation = {
        let backgroundColorAnimation = CAKeyframeAnimation()
        backgroundColorAnimation.keyPath = "backgroundColor"
        backgroundColorAnimation.values = [
            UIColor.lightGray.withAlphaComponent(0.1).cgColor,
            UIColor.lightGray.withAlphaComponent(0.05).cgColor,
            UIColor.lightGray.withAlphaComponent(0.02).cgColor,
            UIColor.lightGray.withAlphaComponent(0).cgColor
        ]
        backgroundColorAnimation.keyTimes = [0.3, 0.6, 0.9, 1]
        return backgroundColorAnimation
    }()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if layer.sublayers?.isEmpty ?? true {
            let animationLayer = CALayer()
            for idx in 0..<pulsingCount {
                let animationList = animationArray
                let animationGroup = getanimationGroup(animations: animationList, index: idx)
                let pulsingLayer = getPulsingLayer(rect: rect, animation: animationGroup)
                animationLayer.addSublayer(pulsingLayer)
            }
            layer.addSublayer(animationLayer)
        }
    }
}