import UIKit
class OfflineStarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        let imgView = UIImageView.init()
        imgView.bounds = self.bounds
        imgView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        var imgsAry = [Any]()
        for i in 1...22 {
            let image = UIImage(named: "star_\(i)")
            imgsAry.append(image!)
        }
        imgView.animationImages = imgsAry as? [UIImage]
        imgView.animationDuration = 1.8
        imgView.animationRepeatCount = 0
        addSubview(imgView)
        imgView.startAnimating()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
    }
}