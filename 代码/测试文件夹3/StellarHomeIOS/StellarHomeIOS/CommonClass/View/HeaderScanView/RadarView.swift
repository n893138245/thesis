import UIKit
class RadarView: UIView {
    let circleTinColor = UIColor.white.withAlphaComponent(0.4)
    let tinColor = UIColor.white
    let animatonKey = "animatonKey"
    override init(frame: CGRect) {
       super.init(frame: frame)
        backgroundColor = .clear
        addSubview(coverView)
        let centerPiontView = UIView.init()
        addSubview(centerPiontView)
        centerPiontView.backgroundColor = tinColor
        centerPiontView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self)
            $0.width.equalTo(frame.size.width*0.12)
            $0.height.equalTo(frame.size.width*0.12)
        }
        centerPiontView.layer.cornerRadius = frame.size.width*0.12*0.5
        centerPiontView.clipsToBounds = true
    }
    func startScan() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.toValue = Double.pi*2
        animation.duration = 1.0
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        coverView.layer.add(animation, forKey: animatonKey)
    }
    func stopScan() {
       coverView.layer.removeAnimation(forKey: animatonKey)
    }
    func pullToScan(progress: CGFloat) {
        let angle = CGFloat(Double.pi*2)*progress
        transform = CGAffineTransform.init(rotationAngle: angle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircles(rect: rect)
    }
    private func drawCircles(rect: CGRect) {
        let lineW = rect.size.width * 0.05
        let outR = rect.size.width/2 - lineW/2
        let inR = outR/2
        let center = CGPoint.init(x: rect.size.width/2, y: rect.size.height/2)
        let outCircle = UIBezierPath.init(arcCenter: center, radius: outR, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
        circleTinColor.set()
        outCircle.lineWidth = lineW
        outCircle.stroke()
        let inCircle = UIBezierPath.init(arcCenter: center, radius: inR, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
        circleTinColor.set()
        inCircle.lineWidth = lineW
        inCircle.stroke()
    }
   private lazy var coverView: SectorView = {
        let sectorView = SectorView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width*0.95, height: frame.size.height*0.95))
        sectorView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        return sectorView
    }()
}