import UIKit
protocol CircleSliderDelegate: NSObjectProtocol {
    func progressDidChange(progress: Float)
    func progressChangeEnd(progress: Float)
}
class CircleSlider: UIView {
    var cWidth: CGFloat = 66
    var cAngle: Double = Double.pi/1.5
    var outBorder: CGFloat = 10
    var progress: Float = 0.0
    var currentColor: UIColor{
        get{
            return UIColor.init(cgColor: self.layer.shadowColor ?? UIColor.white.cgColor)
        }
    }
    var sliderEndBlock :((_ color: UIColor) ->Void)?
    var isTouchBegin: Bool{
        return touchBegin
    }
    private var touchBegin: Bool = false
    weak var delegate: CircleSliderDelegate?
    var colorArray: [UIColor] =
        [UIColor(hexString: "#FFB161"),
         UIColor(hexString: "#FFC78B"),
         UIColor(hexString: "#FFD3A5"),
         UIColor(hexString: "#FFDDBC"),
         UIColor(hexString: "#FFE6D0"),
         UIColor(hexString: "#FFEDE1"),
         UIColor(hexString: "#FFF3F0"),
         UIColor(hexString: "#FEF8FF")
        ]{
        didSet{
            self.setNeedsDisplay()
        }
    }
    private var panGesture: UIPanGestureRecognizer?
    private var tapGesture: UITapGestureRecognizer?
    private lazy var uperView: UperView = {
        let width = cWidth - outBorder - 2
        let tempView = UperView.init(frame: CGRect.init(x: 0, y: 0, width: width*2, height: width*2))
        return tempView
    }()
    private var leftAngle: Double {
        return cAngle/2.0
    }
    private var rightAngle: Double {
        return 2 * .pi - cAngle/2.0
    }
    private var currentAngle: Double = 0{
        willSet{
            moveCircle(start: currentAngle, end: newValue)
        }
    }
    private var outerRadius: CGFloat{
        return self.bounds.size.width/2.0
    }
    private var innerRadius: CGFloat{
        return (self.bounds.size.width - cWidth * 2)/2.0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentAngle = leftAngle
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
        self.addSubview(self.uperView)
        self.transform = CGAffineTransform.init(rotationAngle: .pi / 2)
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(gesture:)))
        panGesture?.delegate = self
        panGesture?.maximumNumberOfTouches = 1
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(gesture:)))
        tapGesture?.delegate = self
        tapGesture?.numberOfTapsRequired = 1
        tapGesture?.numberOfTouchesRequired = 1
        panGesture?.require(toFail: tapGesture!)
        self.addGestureRecognizer(panGesture!)
        self.addGestureRecognizer(tapGesture!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        uperView.center = getPoint(frame: bounds, angle: CGFloat(currentAngle), radius: outerRadius - cWidth/2 - outBorder/2)
        self.setShadow()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let center = CGPoint.init(x: layer.frame.size.width/2.0, y: layer.frame.size.height/2.0)
        let outR = outerRadius - outBorder/2.0
        let inR = innerRadius - outBorder/2.0
        let leftCenter = getPoint(frame: rect, angle: CGFloat(leftAngle), radius: outerRadius - cWidth/2.0 - outBorder/2.0)
        let rightCenter = getPoint(frame: rect, angle: CGFloat(rightAngle), radius: outerRadius - cWidth/2.0 - outBorder/2.0)
        ctx.setLineWidth(outBorder)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.addArc(center: center, radius: outR, startAngle: CGFloat(rightAngle), endAngle: CGFloat(leftAngle), clockwise: true)
        ctx.addArc(center: leftCenter, radius: cWidth/2.0, startAngle: CGFloat(leftAngle), endAngle: CGFloat(leftAngle - Double.pi), clockwise: true)
        ctx.addArc(center: center, radius: inR, startAngle: CGFloat(leftAngle), endAngle: CGFloat(rightAngle), clockwise: false)
        ctx.addArc(center: rightCenter, radius: cWidth/2.0, startAngle: CGFloat(rightAngle + .pi), endAngle: CGFloat(rightAngle), clockwise: true)
        ctx.closePath()
        ctx.strokePath()
        let path = CGMutablePath()
        path.addArc(center: center, radius: outR, startAngle: CGFloat(rightAngle), endAngle: CGFloat(leftAngle), clockwise: true)
        path.addArc(center: leftCenter, radius: cWidth/2.0, startAngle: CGFloat(leftAngle), endAngle: CGFloat(leftAngle - Double.pi), clockwise: true)
        path.addArc(center: center, radius: inR, startAngle: CGFloat(leftAngle), endAngle: CGFloat(rightAngle), clockwise: false)
        path.addArc(center: rightCenter, radius: cWidth/2.0, startAngle: CGFloat(rightAngle + .pi), endAngle: CGFloat(rightAngle), clockwise: true)
        path.closeSubpath()
        ctx.addPath(path)
        ctx.clip()
        ctx.closePath()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var compoents: [CGFloat] = []
        var locations:[CGFloat] = []
        for color in colorArray {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            compoents.append(r)
            compoents.append(g)
            compoents.append(b)
            compoents.append(a)
            let location: CGFloat = CGFloat(colorArray.firstIndex(of: color)!)/CGFloat(colorArray.count - 1)
            locations.append(location)
        }
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        let start = CGPoint(x: layer.bounds.minX, y: layer.bounds.maxY)
        let end = CGPoint(x: layer.bounds.minX, y: layer.bounds.minY)
        ctx.drawLinearGradient(gradient, start: start, end: end,
                               options: .drawsBeforeStartLocation)
    }
    func setShadow() {
        self.layer.masksToBounds = false
        let currentCenter = getPoint(frame: frame, angle: CGFloat(currentAngle), radius: outerRadius - cWidth/2.0)
        self.layer.shadowColor = self.color(of: currentCenter).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 10.0
        let path = CGMutablePath()
        let outR = outerRadius + outBorder/2.0
        let inR = innerRadius - outBorder*1.5
        let borderR = cWidth/2 + outBorder
        let leftCenter = getPoint(frame: frame, angle: CGFloat(leftAngle), radius: outerRadius - cWidth/2.0 - outBorder/2.0)
        let rightCenter = getPoint(frame: frame, angle: CGFloat(rightAngle), radius: outerRadius - cWidth/2.0 - outBorder/2.0)
        let center = CGPoint.init(x: bounds.size.width/2.0, y: bounds.size.width/2.0)
        path.addArc(center: center, radius: outR, startAngle: CGFloat(rightAngle), endAngle: CGFloat(leftAngle), clockwise: true)
        path.addArc(center: leftCenter, radius: borderR, startAngle: CGFloat(leftAngle), endAngle: CGFloat(leftAngle - Double.pi), clockwise: true)
        path.addArc(center: center, radius: inR, startAngle: CGFloat(leftAngle), endAngle: CGFloat(rightAngle), clockwise: false)
        path.addArc(center: rightCenter, radius: borderR, startAngle: CGFloat(rightAngle + .pi), endAngle: CGFloat(rightAngle), clockwise: true)
        path.closeSubpath()
        self.layer.shadowPath = path
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
    func moveCircle(start: Double, end: Double) {
        let r = outerRadius - cWidth/2.0 - outBorder/2.0
        self.uperView.center = getPoint(frame: bounds, angle: CGFloat(end), radius: r)
    }
    func getPoint(frame: CGRect ,angle: CGFloat, radius: CGFloat) -> CGPoint {
        let point = CGPoint.init(x: cos(angle) * radius + frame.size.width/2.0, y: sin(angle)*radius+frame.size.height/2.0)
        return point
    }
    func getRadius(point: CGPoint) -> CGFloat {
        let center = CGPoint.init(x: frame.size.width/2.0, y: frame.size.height/2.0)
        let h = point.x - center.x
        let w = point.y - center.y
        let result = CGFloat(sqrt(h*h + w*w))
        return result
    }
    func getAngle(point: CGPoint) -> Double {
        let center = CGPoint.init(x: frame.size.width/2.0, y: frame.size.height/2.0)
        let w = point.x - center.x
        let h = point.y - center.y
        let result = atan2(Double(h), Double(w))
        return result
    }
    func setProgress(value: Float) {
        progress = value
        currentAngle = leftAngle + (rightAngle - leftAngle) * Double(value)
    }
    @objc func panAction(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            touchBegin = true
            fallthrough
        case .changed:
            var tempAngle = getAngle(point: gesture.location(in: self))
            if tempAngle < 0 {
                tempAngle = tempAngle + 2 * .pi
            }
            var tempProgress = (tempAngle - leftAngle)/(rightAngle - leftAngle)
            if tempProgress >= 1.0{
                tempProgress = 1.0
                tempAngle = rightAngle
            }else if tempProgress <= 0.0{
                tempProgress = 0.0
                tempAngle = leftAngle
            }
            if fabs(tempAngle-currentAngle) > 1{
                return
            }
            currentAngle = tempAngle
            progress = Float(tempProgress)
            let currentCenter = getPoint(frame: frame, angle: CGFloat(currentAngle), radius: outerRadius - cWidth/2.0)
            layer.shadowColor = self.color(of: currentCenter).cgColor
            self.delegate?.progressDidChange(progress: self.progress)
        case .ended, .failed:
            self.delegate?.progressChangeEnd(progress: self.progress)
            if let block = self.sliderEndBlock {
                block(self.currentColor)
            }
            touchBegin = false
        default:
            break
        }
    }
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            touchBegin = true
            var tempAngle = getAngle(point: gesture.location(in: self))
            if tempAngle < 0 {
                tempAngle = tempAngle + 2 * .pi
            }
            var tempProgress = (tempAngle - leftAngle)/(rightAngle - leftAngle)
            if tempProgress >= 1.0{
                tempProgress = 1.0
                tempAngle = rightAngle
            }else if tempProgress <= 0.0{
                tempProgress = 0.0
                tempAngle = leftAngle
            }
            currentAngle = tempAngle
            progress = Float(tempProgress)
            let currentCenter = getPoint(frame: frame, angle: CGFloat(currentAngle), radius: outerRadius - cWidth/2.0)
            layer.shadowColor = self.color(of: currentCenter).cgColor
            if let block = sliderEndBlock {
                block(color(of: currentCenter))
            }
            self.delegate?.progressChangeEnd(progress: self.progress)
            touchBegin = false
        default:
            break
        }
    }
}
extension CircleSlider: UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture || gestureRecognizer == tapGesture{
            let currentPoint = gestureRecognizer.location(in: self)
            let currentRadius = self.getRadius(point: currentPoint)
            if outerRadius - currentRadius > cWidth || outerRadius - currentRadius < 0{
                return false
            }
            guard getAngle(point: currentPoint) >= leftAngle || getAngle(point: currentPoint) <= rightAngle else{
                return false
            }
            return true
        }
        return true
    }
}
class UperView: UIView {
    var inBorder: CGFloat = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let outR = rect.size.width/4.0
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.setShadow(offset: CGSize.init(width: 0, height: 2), blur: 4, color: UIColor.ss.rgbA(r: 0, g: 0, b: 0, a: 0.18).cgColor)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(inBorder)
        ctx.addEllipse(in: CGRect.init(origin: CGPoint.init(x: outR, y: outR), size: CGSize.init(width: outR*2, height: outR*2)))
        ctx.closePath()
        ctx.strokePath()
    }
}