import UIKit
class DelayOffProgressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    private func setupSubViews() {
        backgroundColor = STELLAR_COLOR_C3
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.height.width.equalTo(207.fit)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        let circleBezierPath = UIBezierPath(arcCenter: CGPoint.init(x: bounds.size.width/2, y: bounds.size.height/2), radius: 207.fit/2, startAngle: -.pi, endAngle: .pi, clockwise: true)
        circleLayer.path = circleBezierPath.cgPath
        circleLayer.shadowColor = STELLAR_COLOR_C1.withAlphaComponent(0.24).cgColor
        circleLayer.shadowOpacity = 1 
        circleLayer.shadowOffset = CGSize(width: 0, height: 3) 
        circleLayer.shadowRadius = 10 
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
        let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#155FEA").cgColor,UIColor.init(hexString: "#4098FF").cgColor])
        gradientLayer.frame = bounds
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
        return CAShapeLayerLineCap(rawValue: input)
    }
    func updateProgress(remainingProgress: CGFloat, duration: CFTimeInterval) {
        progressLayer.removeAllAnimations()
        CATransaction.setDisableActions(true)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = remainingProgress
        animation.toValue = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = duration
        progressLayer.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
    func cancelCutDwon() {
        progressLayer.removeAllAnimations()
        progressLayer.strokeEnd = 1
    }
    lazy var progressLayer: CAShapeLayer = {
        let tempProgressLayer = CAShapeLayer()
        tempProgressLayer.fillColor = UIColor.clear.cgColor
        tempProgressLayer.strokeColor = UIColor.red.cgColor
        tempProgressLayer.lineWidth = 12
        tempProgressLayer.lineCap = convertToCAShapeLayerLineCap("round")
        tempProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: 207.fit/2, startAngle: .pi*1.5, endAngle: .pi*1.5 + .pi*2, clockwise: true).cgPath
        tempProgressLayer.strokeStart = 0
        tempProgressLayer.strokeEnd = 1.0
        return tempProgressLayer
    }()
    lazy var circleLayer: CAShapeLayer = {
        let tempCircleLayer = CAShapeLayer()
        tempCircleLayer.fillColor = UIColor.clear.cgColor
        tempCircleLayer.strokeColor = STELLAR_COLOR_C9.cgColor
        tempCircleLayer.lineWidth = 12
        return tempCircleLayer
    }()
    lazy var bgImageView: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "cd_bg"))
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let tempView = UILabel()
        tempView.textColor = STELLAR_COLOR_C5
        tempView.font = STELLAR_FONT_MEDIUM_T18
        return tempView
    }()
}