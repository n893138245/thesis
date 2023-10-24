import UIKit
class TheColorPickerView: UIView {
    var pickerEndCallBack: ((_ color: UIColor) -> Void)?
    var rgb: RGB?
    private var selectedEnable = false
    private var selectedEnd = false
    lazy var indicatorView: UIView = {
        let dimension: CGFloat = 46
        let edgeColor = UIColor(white: 1, alpha: 1)
        let indicatorView = UIView()
        indicatorView.layer.cornerRadius = dimension / 2
        indicatorView.layer.borderColor = edgeColor.cgColor
        indicatorView.layer.borderWidth = 3
        indicatorView.backgroundColor = UIColor.white
        indicatorView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        indicatorView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        indicatorView.layer.contentsScale = UIScreen.main.scale
        return indicatorView
    }()
    convenience init(frame: CGRect, theRGB: RGB){
        self.init(frame: frame)
        layer.shadowColor = STELLAR_COLOR_C8.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 20
        rgb = theRGB
        let dimension: CGFloat = min(self.bounds.width, self.bounds.height)
        guard let bitmapData = CFDataCreateMutable(nil, 0) else {
            return
        }
        CFDataSetLength(bitmapData, CFIndex(dimension*dimension*4))
        self.colorWheelBitmap(bitmap: CFDataGetMutableBytePtr(bitmapData), withSize: CGSize(width: dimension, height: dimension))
        if let image = self.imageWithRGBAData(data: bitmapData, width: Int(dimension), height: Int(dimension)) {
            self.layer.contentsScale = UIScreen.main.scale
            self.layer.contents = image
        }
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = UIColor.white.cgColor
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width), cornerRadius: bounds.width/2)
        circleLayer.path = bezierPath.cgPath
        layer.addSublayer(circleLayer)
        addSubview(indicatorView)
        setupIndicatPosition()
    }
    func setupIndicatPosition() {
        guard let pRgb = rgb else { return }
        let rgbValue = RGB(pRgb.red < 0 ? 0:pRgb.red, pRgb.green < 0 ? 0:pRgb.green, pRgb.blue < 0 ? 0:pRgb.blue, 1.0) 
        let selectedColor = UIColor(red: rgbValue.red, green: rgbValue.green, blue: rgbValue.blue, alpha: 1)
        let hsb = EFRGB2HSB(rgb: pRgb)
        indicatorView.backgroundColor = selectedColor
        indicatorView.center = convert(calculatePoint(), from: self)
        layer.shadowColor = hsb.saturation < 0.2 ? STELLAR_COLOR_C8.cgColor : selectedColor.cgColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == nil {
            for subV in subviews {
                if subV == indicatorView {
                    return subV
                }
            }
        }
        return view
    }
    func pointInCircle(_ point: CGPoint) -> Bool {
        let dimension: CGFloat = min(bounds.width, bounds.height)
        let radius: CGFloat = dimension / 2
        let center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        let dx = abs(point.x - center.x);
        let dy = abs(point.y - center.y);
        let dis = hypot(dx, dy);
        return dis <= radius;
    }
    func touchIndicatorView(_ point: CGPoint) -> Bool {
        if indicatorView.frame.contains(point) {
            return true
        }
        return false
    }
    private func getTouchPoint(touches: Set<UITouch>) ->CGPoint? {
        if let point = touches.first?.location(in: self) {
            return point
        }
        return nil
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.tapCount == 1 {
            guard let position = getTouchPoint(touches: touches) else { return }
            if pointInCircle(position) || touchIndicatorView(position) {
                selectedEnable = true
                setSelectedColor(position)
                let spring = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
                spring?.fromValue = CGSize.init(width: 1.0, height: 1.0)
                spring?.toValue = CGSize.init(width: 2.0, height: 2.0)
                spring?.springSpeed = 20
                spring?.springBounciness = 20
                indicatorView.pop_add(spring, forKey: kPOPViewScaleXY)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ControlResponse"), object: nil)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = getTouchPoint(touches: touches) else { return }
        if selectedEnable {
            setSelectedColor(position)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = getTouchPoint(touches: touches) else { return }
        if selectedEnable {
            selectedEnd = true
            setSelectedColor(position)
            let selectedColor = indicatorView.backgroundColor
            if let tempBlock = pickerEndCallBack {
                tempBlock(selectedColor!)
            }
            let spring = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
            spring?.fromValue = CGSize.init(width: 2.0, height: 2.0)
            spring?.toValue = CGSize.init(width: 1.0, height: 1.0)
            spring?.springSpeed = 20
            spring?.springBounciness = 10
            indicatorView.pop_add(spring, forKey: kPOPViewScaleXY)
        }
        selectedEnable = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedEnable = false
    }
    func setSelectedColor(_ ppoint: CGPoint) {
        if pointInCircle(ppoint) {
            let convertPoint = convert(ppoint, to: self)
            var hue: CGFloat = 0, saturation: CGFloat = 0
            colorWheelValueWithPosition(position: convertPoint, hue: &hue, saturation: &saturation)
            let selectedColor: UIColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1)
            layer.shadowColor = saturation < 0.2 ? STELLAR_COLOR_C8.cgColor : selectedColor.cgColor
            indicatorView.backgroundColor = selectedColor
            indicatorView.center = CGPoint(x: ppoint.x, y: ppoint.y-40)
            if selectedEnd {
                selectedEnd = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.indicatorView.center = ppoint
                }) { (isfinished) in
                }
            }
        }else{
            selectedEnd = true
            let point = judgePoint(ppoint)
            let convertPoint = convert(point, to: self)
            if selectedEnd {
                selectedEnd = false
                self.indicatorView.center = point
            }
            var hue: CGFloat = 0, saturation: CGFloat = 0
            colorWheelValueWithPosition(position: convertPoint, hue: &hue, saturation: &saturation)
            let selectedColor: UIColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1)
            layer.shadowColor = selectedColor.cgColor
            indicatorView.backgroundColor = selectedColor
        }
    }
    func judgePoint(_ point: CGPoint) -> CGPoint {
        let dimension: CGFloat = min(bounds.width, bounds.height)
        let radius: CGFloat = dimension / 2
        let center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        let mx = center.x - point.x
        let my = center.y - point.y
        let dist: CGFloat = CGFloat(sqrt(mx*mx + my*my))
        let Y = center.y - ((center.y-point.y)/dist*radius)
        let X = center.x - ((center.x-point.x)/dist*radius)
        let point = CGPoint(x: X, y: Y)
        return point
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
struct RGB {
    var red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat
    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
struct HSB {
    var hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat
    init(_ hue: CGFloat, _ saturation: CGFloat, _ brightness: CGFloat, _ alpha: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
}
extension TheColorPickerView {
    func colorWheelBitmap(bitmap: UnsafeMutablePointer<UInt8>?, withSize size: CGSize) {
        if size.width <= 0 || size.height <= 0 {
            return
        }
        for y in 0 ..< Int(size.width) {
            for x in 0 ..< Int(size.height) {
                var hue: CGFloat = 0, saturation: CGFloat = 0, a: CGFloat = 0.0
                self.colorWheelValueWithPosition(position: CGPoint(x: x, y: y), hue: &hue, saturation: &saturation)
                var rgb: RGB = RGB(1, 1, 1, 0)
                if saturation < 1.0 {
                    if saturation > 0.99 {
                        a = (1.0 - saturation) * 100
                    }else{
                        a = 1.0
                    }
                    let hsb: HSB = HSB(hue, saturation, 1.0, a)
                    rgb = EFHSB2RGB(hsb: hsb)
                }
                let i: Int = 4 * (x + y * Int(size.width))
                bitmap?[i] = UInt8(rgb.red * 0xff)
                bitmap?[i + 1] = UInt8(rgb.green * 0xff)
                bitmap?[i + 2] = UInt8(rgb.blue * 0xff)
                bitmap?[i + 3] = UInt8(rgb.alpha * 0xff)
            }
        }
    }
    func calculatePoint() -> CGPoint {
        let theRGB = rgb!
        let theHSB: HSB = EFRGB2HSB(rgb: theRGB)
        let hue = theHSB.hue
        let saturation = theHSB.saturation
        let angle = hue * CGFloat(2.0*Double.pi)
        let radius = (bounds.width/2)
        let center = CGPoint(x: radius, y: radius)
        let pointX = cos(angle) * saturation * radius + center.x
        let pointY = sin(angle) * saturation * radius + center.y
        return CGPoint(x: pointX, y: pointY)
    }
    func colorWheelValueWithPosition(position: CGPoint, hue: inout CGFloat, saturation: inout CGFloat) {
        let c: Int = Int(self.bounds.width / 2)
        let dx: CGFloat = (position.x - CGFloat(c)) / CGFloat(c)
        let dy: CGFloat = (position.y - CGFloat(c)) / CGFloat(c)
        let d: CGFloat = CGFloat(sqrt(Double(dx*dx + dy*dy)))
        saturation = d
        if d == 0 {
            hue = 0
        }else{
            hue = acos(dx / d) / CGFloat.pi / 2.0
            if dy < 0 {
                hue = 1.0 - hue
            }
        }
    }
    func imageWithRGBAData(data: CFData, width: Int, height: Int) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data) else {
            return nil
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let imageRef = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue), provider: dataProvider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef
    }
    func EFHSB2RGB(hsb: HSB) -> RGB {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        let i: Int = Int(hsb.hue * 6)
        let f = hsb.hue * 6 - CGFloat(i)
        let p = hsb.brightness * (1 - hsb.saturation)
        let q = hsb.brightness * (1 - f * hsb.saturation)
        let t = hsb.brightness * (1 - (1 - f) * hsb.saturation)
        switch i % 6 {
        case 0:
            r = hsb.brightness
            g = t
            b = p
            break
        case 1:
            r = q
            g = hsb.brightness
            b = p
            break
        case 2:
            r = p
            g = hsb.brightness
            b = t
            break
        case 3:
            r = p
            g = q
            b = hsb.brightness
            break
        case 4:
            r = t
            g = p
            b = hsb.brightness
            break
        case 5:
            r = hsb.brightness
            g = p
            b = q
            break
        default:
            break
        }
        return RGB(r, g, b, hsb.alpha)
    }
    func EFRGB2HSB(rgb: RGB) -> HSB {
        let rd = Double(rgb.red)
        let gd = Double(rgb.green)
        let bd = Double(rgb.blue)
        let max = fmax (rd, fmax(gd, bd))
        let min = fmin(rd, fmin(gd, bd))
        var h = 0.0, b = max
        let d = max - min
        let s = max == 0 ? 0 : d / max
        if max == min {
            h = 0 
        } else {
            if max == rd {
                h = (gd - bd) / d + (gd < bd ? 6 : 0)
            } else if max == gd {
                h = (bd - rd) / d + 2
            } else if max == bd {
                h = (rd - gd) / d + 4
            }
            h /= 6
        }
        return HSB(CGFloat(h), CGFloat(s), CGFloat(b), CGFloat(rgb.alpha))
    }
}