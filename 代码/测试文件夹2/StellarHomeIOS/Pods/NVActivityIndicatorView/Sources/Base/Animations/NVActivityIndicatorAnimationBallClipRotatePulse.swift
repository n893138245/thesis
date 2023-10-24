#if canImport(UIKit)
import UIKit
class NVActivityIndicatorAnimationBallClipRotatePulse: NVActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.09, 0.57, 0.49, 0.9)
        smallCircleWith(duration: duration, timingFunction: timingFunction, layer: layer, size: size, color: color)
        bigCircleWith(duration: duration, timingFunction: timingFunction, layer: layer, size: size, color: color)
    }
    func smallCircleWith(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, layer: CALayer, size: CGSize, color: UIColor) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.3, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        let circleSize = size.width / 2
        let circle = NVActivityIndicatorShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - circleSize) / 2,
                           y: (layer.bounds.size.height - circleSize) / 2,
                           width: circleSize,
                           height: circleSize)
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    func bigCircleWith(duration: CFTimeInterval, timingFunction: CAMediaTimingFunction, layer: CALayer, size: CGSize, color: UIColor) {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.timingFunctions = [timingFunction, timingFunction]
        scaleAnimation.values = [1, 0.6, 1]
        scaleAnimation.duration = duration
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.keyTimes = scaleAnimation.keyTimes
        rotateAnimation.timingFunctions = [timingFunction, timingFunction]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        rotateAnimation.duration = duration
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, rotateAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        let circle = NVActivityIndicatorShape.ringTwoHalfVertical.layerWith(size: size, color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                           y: (layer.bounds.size.height - size.height) / 2,
                           width: size.width,
                           height: size.height)
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
#endif