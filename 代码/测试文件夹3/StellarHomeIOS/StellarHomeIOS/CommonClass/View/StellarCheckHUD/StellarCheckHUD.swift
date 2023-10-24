import UIKit
class StellarCheckHUD: UIView {
    var animationLayer = CALayer()
    var hideBlock: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let w = frame.width
        let h = frame.height
        if h > w {
            animationLayer.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        }else if h == w {
             animationLayer.bounds = CGRect(x: 0, y: 0, width: w, height: w)
        }else {
            animationLayer.bounds = CGRect(x: 0, y: 0, width: h, height: h)
        }
        animationLayer.position = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        layer.addSublayer(animationLayer)
    }
    class func show(inView: UIView, hideBlock:(() ->Void)?) {
        let hud = StellarCheckHUD.init(frame: inView.bounds)
        inView.addSubview(hud)
        hud.showSuccessAnimation()
        hud.hideBlock = {
            hud.hide(inView: inView)
            if let block = hideBlock {
                block()
            }
        }
    }
    class func showSuccessNotDismiss(inView: UIView, color: UIColor? = nil,duration:CFTimeInterval = 0.15) {
        let hud = StellarCheckHUD.init(frame: inView.bounds)
        inView.addSubview(hud)
        hud.showSuccessAnimation(duration: duration, color: color)
    }
    class func showFailNotDismiss(inView: UIView, hideBlock:(() ->Void)? = nil,duration:CFTimeInterval = 0.25) {
        let hud = StellarCheckHUD.init(frame: inView.bounds)
        inView.addSubview(hud)
        hud.showFailAnimation(duration:duration)
        hud.hideBlock = {
            if let block = hideBlock {
                block()
            }
        }
    }
    func showSuccessAnimation(duration:CFTimeInterval = 0.25, color: UIColor? = nil) {
        let layerW = animationLayer.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: layerW*2.7/10.0, y: layerW*5.4/10.0))
        path.addLine(to: CGPoint(x: layerW*4.5/10.0, y: layerW*7/10.0))
        path.addLine(to: CGPoint(x: layerW*7.8/10.0, y: layerW*3.8/10.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        if let pColor = color {
            shapeLayer.strokeColor = pColor.cgColor
        }else {
            shapeLayer.strokeColor = STELLAR_COLOR_C10.cgColor
        }
        shapeLayer.lineWidth = 4.0
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        animationLayer.addSublayer(shapeLayer)
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.delegate = self
        shapeLayer.add(animation, forKey: nil)
    }
    func showFailAnimation(duration:CFTimeInterval = 0.25) {
        let layerW = animationLayer.bounds.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: layerW*4.5/10.0, y: layerW*7/10.0))
        path.addLine(to: CGPoint(x: layerW*7.8/10.0, y: layerW*3.8/10.0))
        path.move(to: CGPoint(x: layerW*4.5/10.0, y: layerW*3.8/10.0))
        path.addLine(to: CGPoint(x: layerW*7.8/10.0, y: layerW*7/10.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = STELLAR_COLOR_C2.cgColor
        shapeLayer.lineWidth = 4.0
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        animationLayer.addSublayer(shapeLayer)
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.delegate = self
        shapeLayer.add(animation, forKey: nil)
    }
    private func showErrorAnimation() {
    }
    private func hide(inView :UIView) {
        for subView in inView.subviews {
            if subView.isKind(of: StellarCheckHUD.classForCoder()) {
                subView.layer.removeAllAnimations()
                subView.removeFromSuperview()
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension StellarCheckHUD: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:{
                if let block = self.hideBlock {
                    block()
                }
            })
        }
    }
}