import UIKit
class StallerScanCoverView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let endA = CGFloat(-Double.pi * 0.5)
        let W = frame.size.width/0.8 * 0.4
        let X = W/2 + CGFloat(Double(W/2) * cos(Double(endA)))
        let Y = W/2 + CGFloat(Double(W/2) * sin(Double(endA)))
        let ePonint = CGPoint(x: X, y: Y)
        addSubview(centerCircle)
        centerCircle.bounds = CGRect(x: 0, y: 0, width: W, height: W)
        centerCircle.center = CGPoint(x: frame.width/2, y: frame.height/2)
        centerCircle.layer.cornerRadius = centerCircle.bounds.height/2
        bluePoint.frame = CGRect(x: ePonint.x - 4, y: ePonint.y - 4, width: 8, height: 8)
        bluePoint.layer.cornerRadius = 4
        centerCircle.addSubview(bluePoint)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var bluePoint: UIView = {
        let tempView = UIView.init()
        tempView.clipsToBounds = true
        tempView.backgroundColor = UIColor.init(red: 39/255, green: 85/255, blue: 179/255, alpha: 1.0)
        return tempView
    }()
    private lazy var centerCircle: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = .clear
        return tempView
    }()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let endA = CGFloat(-Double.pi * 0.5)
        let startA = endA - CGFloat(Double.pi * 0.35)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let center = CGPoint.init(x: layer.frame.size.width/2.0, y: layer.frame.size.height/2.0)
        ctx.move(to: center)
        let W = rect.size.width
        let X = W/2 + CGFloat(Double(W/2) * cos(Double(startA)))
        let Y = W/2 + CGFloat(Double(W/2) * sin(Double(startA)))
        let startPonint = CGPoint(x: X, y: Y)
        ctx.setStrokeColor(UIColor.clear.cgColor)
        ctx.move(to: center)
        ctx.addLine(to: startPonint)
        ctx.addArc(center: center, radius: W/2, startAngle: startA, endAngle: endA, clockwise: false)
        ctx.addLine(to: center)
        ctx.strokePath()
        let path = CGMutablePath()
        path.move(to: center)
        path.addLine(to: startPonint)
        path.addArc(center: center, radius: W/2, startAngle: startA, endAngle: endA, clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        ctx.addPath(path)
        ctx.clip()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let compoents:[CGFloat] = [
            39/255, 85/255, 179/255, 0,
            39/255, 85/255, 179/255, 0.75,
        ]
        let locations:[CGFloat] = [0,1]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        let eX = W/2+CGFloat(Double(W/2)*cos(Double(endA)))
        let eY = W/2+CGFloat(Double(W/2)*sin(Double(endA)))
        let endPoint = CGPoint(x: eX, y: eY)
        ctx.drawLinearGradient(gradient, start: center, end: endPoint,
                               options: .drawsBeforeStartLocation)
    }
}