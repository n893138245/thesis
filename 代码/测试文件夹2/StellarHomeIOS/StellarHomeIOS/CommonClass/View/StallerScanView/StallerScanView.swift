import UIKit
class StallerScanView: UIView {
    private let rotateKey = "rotateKey"
    private let drawLineKey = "drawLineKey"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(waterView)
        addSubview(centerCircle)
        let size = frame.size
        let pWidth: CGFloat = 0.4 * size.width
        centerCircle.bounds = CGRect(x: 0, y: 0, width: pWidth, height: pWidth)
        centerCircle.center = CGPoint(x: size.width/2, y: size.height/2)
        centerCircle.layer.cornerRadius = centerCircle.bounds.height/2
        addSubview(coverView)
        waterView.snp.makeConstraints {
            $0.center.equalTo(centerCircle.snp.center)
            $0.width.height.equalTo(pWidth)
        }
        startScan()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startScan() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.toValue = Double.pi*2
        animation.duration = 2
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        coverView.layer.add(animation, forKey: rotateKey)
    }
    func stopScan() {
        coverView.layer.removeAnimation(forKey: rotateKey)
        drawCircleLayer.removeAnimation(forKey: drawLineKey)
    }
    private func startLayerAnimate() {
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.fromValue = NSNumber.init(value: 0)
        animation.toValue = NSNumber.init(value: 1.0)
        animation.duration = 2
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        drawCircleLayer.add(animation, forKey: drawLineKey)
    }
    lazy var waterView: StellarWaterAnimateView = {
        let tempView = StellarWaterAnimateView()
        tempView.backgroundColor = .white
        return tempView
    }()
    private lazy var drawCircleLayer: CAShapeLayer = {
        let tempView = CAShapeLayer()
        tempView.fillColor = UIColor.clear.cgColor
        tempView.strokeColor = UIColor.init(red: 39/255, green: 85/255, blue: 179/255, alpha: 1.0).cgColor
        tempView.lineWidth = 2
        tempView.lineJoin = .bevel
        return tempView
    }()
    private lazy var centerCircle: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = .white
        tempView.layer.shadowColor = UIColor.black.cgColor
        tempView.layer.shadowOpacity = 0.2
        tempView.layer.shadowOffset = CGSize.zero
        return tempView
    }()
    private lazy var coverView: StallerScanCoverView = {
        let coverView = StallerScanCoverView.init(frame: CGRect(x: 0, y: 0, width:frame.size.width*0.8, height: frame.size.width*0.8))
        coverView.center = CGPoint(x:frame.size.width/2, y: frame.size.height/2)
        coverView.backgroundColor = .clear
        return coverView
    }()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let contenx = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let path = UIBezierPath()
        path.lineWidth = 1.0
        let R = rect.size.width * 0.4 * 0.5
        let startA = -Double.pi * 0.5
        let endA = startA + Double.pi * 2
        path.addArc(withCenter: center, radius: R, startAngle: CGFloat(startA), endAngle: CGFloat(endA), clockwise: true)
        UIColor.clear.set()
        contenx?.addPath(path.cgPath)
        contenx?.strokePath()
        drawCircleLayer.frame = rect
        drawCircleLayer.path = path.cgPath
        layer.addSublayer(drawCircleLayer)
        startLayerAnimate()
    }
}