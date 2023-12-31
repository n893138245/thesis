#if canImport(UIKit)
import UIKit
class NVActivityIndicatorAnimationBallScale: NVActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        let circle = NVActivityIndicatorShape.circle.layerWith(size: size, color: color)
        circle.frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                              y: (layer.bounds.size.height - size.height) / 2,
                              width: size.width,
                              height: size.height)
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
}
#endif