import UIKit
class BubbleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createBubbleLayer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createBubbleLayer() {
        let emitterLayer = CAEmitterLayer.init()
        emitterLayer.emitterShape = .line
        emitterLayer.renderMode = .unordered
        emitterLayer.emitterSize = frame.size
        emitterLayer.emitterPosition = CGPoint.init(x: frame.size.width/2, y: frame.size.height);
        let emitterCell = CAEmitterCell.init()
        emitterCell.name = "Circle"
        emitterCell.isEnabled = true
        emitterCell.contents = UIImage.init(color: UIColor.ss.rgbA(r: 255, g: 255, b: 255, a: 0.6), size: CGSize.init(width: 10, height: 10))?.ss.toCircle().cgImage
        emitterCell.birthRate = 1;
        emitterCell.lifetime = 8;
        emitterCell.velocity = 10;
        emitterCell.velocityRange = -10;
        emitterCell.yAcceleration = -15;
        emitterCell.emissionRange = -.pi;
        emitterCell.scale = 0.1;
        emitterCell.scaleRange = 0.1;
        emitterCell.scaleSpeed = 0.2;
        emitterCell.alphaSpeed = -0.125
        emitterCell.alphaRange = 0.5
        emitterCell.magnificationFilter = CALayerContentsFilter.nearest.rawValue;
        emitterCell.minificationFilter = CALayerContentsFilter.trilinear.rawValue;
        emitterLayer.emitterCells = [emitterCell]
        layer.addSublayer(emitterLayer)
    }
}