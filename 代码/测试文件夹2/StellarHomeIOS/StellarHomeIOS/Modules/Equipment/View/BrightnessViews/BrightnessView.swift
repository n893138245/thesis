import UIKit
class BrightnessView: UIView {
    var touchEndClosure: ((_ brightness: Int) -> Void)?
    private var origPoint: CGPoint = CGPoint.zero
    private var currentValue: Int = 0{
        didSet{
            if currentValue != oldValue {
                feedback.impactOccurred()
            }
        }
    }
    private var feedback: UIImpactFeedbackGenerator
    lazy var theMaskView: UIView = {
        let bgView = UIView(frame: CGRect(x: 4, y: 4, width: bounds.width-8, height: bounds.height-8))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    lazy var thumbView: UIView = {
        let view = UIView(frame: CGRect(x: (theMaskView.bounds.width-42)/2, y: theMaskView.frame.maxY + 6, width: 42, height: 6))
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var bubbleView: BubbleView = {
        let tempView = BubbleView.init(frame: CGRect(x: 4, y: 4, width: bounds.width-8, height: bounds.height-8))
        return tempView
    }()
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: thumbView.frame.maxY+4, width: bounds.width, height: 25))
        label.textColor = STELLAR_COLOR_C5
        label.text = ""
        label.font = STELLAR_FONT_NUMBER_T26
        label.textAlignment = .center
        return label
    }()
    lazy var contentView: UIView = {
        let shapeLayer = UIView()
        shapeLayer.backgroundColor = UIColor.orange
        shapeLayer.frame = CGRect(x: 4, y: 4, width: bounds.width-8, height: bounds.height-8)
        return shapeLayer
    }()
    override init(frame: CGRect) {
        feedback = UIImpactFeedbackGenerator.init(style: .medium)
        super.init(frame: frame)
        backgroundColor = UIColor.white
        layer.cornerRadius = 12.fit
        layer.shadowColor = UIColor.init(hexString: "#FFC000").cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 20
        layer.borderWidth = 4
        layer.borderColor = UIColor.white.cgColor
        addSubview(contentView)
        addSubview(bubbleView)
        addSubview(theMaskView)
        addSubview(thumbView)
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self.snp.bottom).offset(32.fit)
        }
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor.init(hexString: "#FFC700")
        let endColor = UIColor.init(hexString: "#FFAD00")
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setBgViewFrame(_ value: Int) {
        let pValue = CGFloat(value)/100
        theMaskView.frame = CGRect(x: 4, y: 4, width: bounds.width-8, height: (bounds.height-8 - 18) * (1.0-pValue))
        thumbView.frame = CGRect(x: (theMaskView.bounds.width-42)/2+2, y: theMaskView.frame.maxY + 6, width: 42, height: 6)
        valueLabel.text = "\(value)%"
        layer.shadowRadius = 10 + 10*pValue
        layer.shadowOpacity = Float(0.3 + 0.4*pValue)
    }
    private func setOffsetY(_ offsetY: CGFloat) -> CGFloat{
        let totalH = bounds.height-8 - 18
        let h = offsetY + theMaskView.frame.height
        var value = 1.0 - (h / totalH)
        if value < 0.01 {
            value = 0.01
            theMaskView.frame = CGRect(x: 4, y: 4, width: bounds.width-8, height: (bounds.height-8 - 18)*(1.0-0.01))
            thumbView.frame = CGRect(x: (theMaskView.bounds.width-42)/2+2, y: theMaskView.frame.maxY + 6, width: 42, height: 6)
            setProgressValue(Int(value*100))
            return value
        }else if value > 1.0 {
            value = 1.0
            theMaskView.frame = CGRect(x: 4, y: 4, width: bounds.width-8, height: 0)
            thumbView.frame = CGRect(x: (theMaskView.bounds.width-42)/2+2, y: theMaskView.frame.maxY + 6, width: 42, height: 6)
            setProgressValue(Int(value*100))
            return value
        }
        theMaskView.frame = CGRect(x: 4, y: 4, width: bounds.width-8, height: h)
        thumbView.frame = CGRect(x: (theMaskView.bounds.width-42)/2+2, y: theMaskView.frame.maxY + 6, width: 42, height: 6)
        setProgressValue(Int(value*100))
        return value
    }
    private func setProgressValue(_ value: Int) {
        currentValue = value
        valueLabel.text = "\(value)" + "%"
        layer.shadowRadius = 10 + 10*CGFloat(value)/CGFloat(100)
        layer.shadowOpacity = Float(0.3 + 0.4*CGFloat(value)/CGFloat(100))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            origPoint = position
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            let offsetY = position.y - origPoint.y
            let _ = setOffsetY(offsetY)
            origPoint = position
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            let offsetY = position.y - origPoint.y
            let value = setOffsetY(offsetY)
            origPoint = position
            if let tempClosure = touchEndClosure {
                tempClosure(Int(value*100))
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    func startLayerShdowAnimation() {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.repeatCount = MAXFLOAT
        animation.duration = 0.4
        animation.fromValue = 0.4
        animation.toValue = 0.8
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        layer.add(animation, forKey: "shadowOpacityAni")
    }
    func stopLayerShdowAnimation() {
        layer.removeAnimation(forKey: "shadowOpacityAni")
    }
}