import UIKit
class CircleProgressView: UIView {
    struct Constant {
        static let lineWidth: CGFloat = 2
        static let trackColor = STELLAR_COLOR_C9
        static let progressColoar = STELLAR_COLOR_C10
    }
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            }else if progress < 0 {
                progress = 0
            }
            self.titleLabel.text = "\(progress)%"
            self.titleLabel.sizeToFit()
            self.titleLabel.center = self.center
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func draw(_ rect: CGRect) {
        let diameter = bounds.size.width > bounds.size.height ? bounds.size.height : bounds.size.width
        let radius = diameter/2.0 -  Constant.lineWidth/2.0
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: diameter/2.0, y: diameter/2.0),
                    radius: radius,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        layer.addSublayer(progressLayer)
    }
    func setProgress(_ pro: Int,time:CFTimeInterval = 0.5,completion:(() ->Void)? = nil) {
        progress = pro
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        CATransaction.setAnimationDuration(time)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut))
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        CATransaction.commit()
        DispatchQueue.main.asyncAfter(deadline: .now() + time + 0.5) {
            completion?()
        }
    }
    fileprivate func angleToRadian(_ angle: Double)->CGFloat {
        return CGFloat(angle/Double(180.0) * .pi)
    }
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = STELLAR_COLOR_C6
        label.font = STELLAR_FONT_T11
        self.addSubview(label)
        return label
    }()
}