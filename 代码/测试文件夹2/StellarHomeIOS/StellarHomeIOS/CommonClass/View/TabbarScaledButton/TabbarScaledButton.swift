import UIKit
class TabbarScaledButton: UIButton {
    override var isSelected: Bool{
        didSet{
            if isSelected == false{
                return
            }
            let animation = CABasicAnimation(keyPath: "transform.scale")
            if isSelected{
                animation.fromValue = NSNumber(value: 0.75)
                animation.toValue = NSNumber(value: 1)
            }
            else{
                animation.fromValue = NSNumber(value: 1)
                animation.toValue = NSNumber(value: 0.75)
            }
            animation.duration = 0.1
            animation.repeatCount = 1
            layer.add(animation, forKey: "scale-layer")
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.sizeToFit()
        titleLabel?.sizeToFit()
        imageView?.center = CGPoint.init(x: kScreenWidth/8.0, y: 17)
        titleLabel?.center = CGPoint.init(x: kScreenWidth/8.0, y: 34 + (titleLabel?.bounds.size.height ?? 0)/2.0)
    }
}