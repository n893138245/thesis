import UIKit
class SectorView: UIView {
    let shadeColor = UIColor.white.withAlphaComponent(0.2)
    let lineColor = UIColor.white
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let R = rect.size.width/2
        let statA = CGFloat(Double.pi*7/6)
        let endA = statA + CGFloat(Double.pi*0.25)
        let path = UIBezierPath(arcCenter: center, radius: R, startAngle: statA, endAngle: endA, clockwise: true)
        path.addLine(to: center)
        shadeColor.set()
        path.fill()
        let W = rect.size.width
        let X = W/2+CGFloat(Double(W/2)*cos(Double(endA)))
        let Y = W/2+CGFloat(Double(W/2)*sin(Double(endA)))
        let lineEndPt = CGPoint(x: X, y: Y)
        let linePath = UIBezierPath()
        linePath.move(to: center)
        linePath.addLine(to: lineEndPt)
        linePath.lineWidth = rect.size.width*0.05
        lineColor.set()
        linePath.stroke()
    }
}