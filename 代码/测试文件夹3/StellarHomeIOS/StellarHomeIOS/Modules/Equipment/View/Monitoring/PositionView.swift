import UIKit
class PositionView: UIView {
    private let tagStart = 1000
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        for animateView in animationViews {
            addSubview(animateView)
            animateView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            animateView.isHidden = true
        }
    }
    func addPointViews(locations: [RadarLocationInfo]) {
        hiddenPointViews()
        for index in 0..<locations.count {
            guard let view = animationViews.first(where: {$0.tag == tagStart + index}) else {
                return
            }
            let location = locations[index]
            let position = getLocation(angle: location.angle, distance: location.distance)
            view.center = CGPoint(x: position.x, y: position.y)
            view.isHidden = false
        }
    }
    func addAnimationPoints(locations: [RadarLocationInfo]) {
        addPointViews(locations: locations)
        startAnimations()
    }
    func hiddenPointViews() {
        animationViews.forEach({
            $0.stopAnimating()
            $0.isHidden = true
        })
    }
    func startAnimations() {
        animationViews.forEach({
            if !$0.isHidden {
                $0.startAnimating()
            }
        })
    }
    func stopAnimations() {
        animationViews.forEach({
            if !$0.isHidden {
                $0.stopAnimating()
            }
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func getLocation(angle: Int, distance: Int) ->(x: CGFloat,y: CGFloat) {
        let pDistance = Int(ceil(Double(distance) / 100))
        let A = Double.pi / 180 
        let alpha = 180 * A + Double(Double(angle) / 100) * A 
        let R = size.width / 2.0 
        let realDistance = Double(pDistance) / 13 * Double(R) 
        let y = Double(R) + realDistance * sin(alpha) 
        let x = Double(R) + cos(alpha) * realDistance 
        return (CGFloat(x),CGFloat(y))
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let R = rect.width / 2
        let startAngle = 0
        let endAngle = Double.pi * 2
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let path = UIBezierPath(arcCenter: center, radius: R, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        path.addLine(to: center)
        UIColor.clear.set()
        path.fill()
    }
    private lazy var animationImages: [UIImage] = {
        var tempArr: [UIImage] = []
        for idx in 0...20 {
            let image = UIImage(named: "shan_\(idx)")!
            tempArr.append(image)
        }
        return tempArr
    }()
    private lazy var animationViews: [UIImageView] = {
        var tempArr: [UIImageView] = []
        for idx in 0...600 {
            let image = UIImage(named: "shan_0")!
            let view = UIImageView(image: image)
            view.tag = tagStart + idx
            view.animationImages = animationImages
            tempArr.append(view)
        }
        return tempArr
    }()
}