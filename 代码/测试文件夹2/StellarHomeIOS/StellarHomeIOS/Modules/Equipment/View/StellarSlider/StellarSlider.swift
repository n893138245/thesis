import UIKit
class StellarSlider: UIView {
    private var origPoint: CGPoint = CGPoint.zero
    var sliderBlock:((_ sliderValue: CGFloat) -> Void)?
    var value: CGFloat = 0.01 {
        didSet {
            if value < 0 || value > 1.0{
                return
            }
            progressView.progress = Float(value)
            let totalW = sliderBgView.frame.width
            let centerX = value * totalW
            let thumViewCenter = CGPoint(x: centerX, y: sliderBgView.frame.height/2)
            thumView.center = thumViewCenter
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    convenience init(frame: CGRect, completeBlock: ((_ sliderValue :CGFloat) ->Void)?) {
        self.init(frame: frame)
        sliderBlock = { (sValue) in
            completeBlock!(sValue)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        sliderBgView.frame = CGRect(x: 10, y: 0, width: frame.width-20, height: frame.height)
        addSubview(progressView)
        addSubview(sliderBgView)
        progressView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.height.equalTo(16)
            $0.width.equalTo(self)
        }
        sliderBgView.addSubview(thumView)
        thumView.bounds = CGRect(x: 0, y: 0, width: 90, height: 90)
        thumView.center = CGPoint(x: 0, y: sliderBgView.frame.height/2.0)
        let image = UIImageView.init(image: UIImage(named: "slider_circle-1"))
        thumView.addSubview(image)
        image.snp.makeConstraints {
            $0.center.equalTo(thumView)
        }
    }
    private func stretImage(with aImage:UIImage) -> UIImage {
        var image = UIImage()
        let leftCapWidth: Int = Int(aImage.size.width/2)
        let topCapHeight: Int = Int(aImage.size.height/2)
        image = aImage.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        return image
    }
    private func setValues(x: CGFloat) {
        var centerP = thumView.center
        centerP.x += x
        var currentX = centerP.x
        let totalWidth = sliderBgView.frame.width
        if centerP.x < 0 {
            centerP.x = 0
            currentX = 0
        }else if centerP.x > totalWidth {
            centerP.x = totalWidth
            currentX = totalWidth
        }
        thumView.center = centerP
        let pValue = currentX/totalWidth
        progressView.progress = Float(pValue)
        if let block = sliderBlock {
            block(pValue)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: thumView) {
            origPoint = position
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: thumView) {
            let offsetX = position.x - origPoint.x
            setValues(x: offsetX)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: thumView) {
            let offsetX = position.x - origPoint.x
            setValues(x: offsetX)
            origPoint = position
        }
    }
    private lazy var progressView: UIProgressView = {
        let slider = UIProgressView.init()
        slider.progressImage = stretImage(with: UIImage(named:"slider_color-1")!)
        slider.trackImage = stretImage(with: UIImage(named:"slider_bg-1")!)
        return slider
    }()
    private lazy var thumView: UIView = {
        let tempView = UIView.init()
        return tempView
    }()
    private lazy var sliderBgView: UIView = {
        let tempView = UIView.init()
        return tempView
    }()
}