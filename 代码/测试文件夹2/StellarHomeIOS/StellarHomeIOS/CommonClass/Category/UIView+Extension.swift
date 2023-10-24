import UIKit
extension UIView: SSCompatible{}
extension SS where Base:UIView {
    func addGradientLayer(maskPreView:UIView){
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor.ss.rgbColor(239.0, 239.0, 240.0)
        let endColor = UIColor.ss.rgbColor(232.0, 232.0, 232.0)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor, startColor.cgColor]
        gradientLayer.locations = [0.2, 0.5, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.3)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: base.bounds.width, height: maskPreView.bounds.height)
        gradientLayer.add(getAnimation(maskPreView: maskPreView), forKey: nil)
        maskPreView.layer.addSublayer(gradientLayer)
        maskPreView.layer.masksToBounds = true
        maskPreView.backgroundColor = UIColor.ss.rgbColor(239.0, 239.0, 240.0)
    }
    func getAnimation(maskPreView:UIView) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform")
        animation.repeatCount = MAXFLOAT
        animation.duration = 2
        animation.fromValue = CATransform3DMakeTranslation(-(base.frame.width), 0, 0)
        animation.toValue = CATransform3DMakeTranslation((base.frame.width), 0, 0)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }
    func popScaleAnimation() -> POPSpringAnimation?{
        let basic = POPBasicAnimation.init(propertyNamed: kPOPViewBackgroundColor)
        basic?.fromValue = UIColor.black.withAlphaComponent(0.0)
        basic?.toValue = UIColor.black.withAlphaComponent(0.4)
        basic?.duration = 0.25
        base.pop_add(basic, forKey: "view.backgroundColor")
        let pop = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
        pop?.fromValue = CGSize(width: 0.3, height: 0.3)
        pop?.toValue = CGSize(width: 1, height: 1)
        pop?.springSpeed = 20
        pop?.springBounciness = 12
        return pop
    }
}