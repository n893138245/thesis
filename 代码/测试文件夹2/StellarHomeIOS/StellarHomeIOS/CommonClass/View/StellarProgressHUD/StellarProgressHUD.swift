import UIKit
class StellarProgressHUD: UIView {
    private static let sharedHud = StellarProgressHUD.init(frame: UIScreen.main.bounds)
    class func showHUD() {
        let view = gethud()
        view.imageView.startAnimating()
    }
    private class func gethud() -> StellarProgressHUD {
        let view = StellarProgressHUD.sharedHud
        DispatchQueue.main.async {
            let window = getFrontWindow() ?? UIWindow()
            window.addSubview(view)
        }
        return view
    }
    class func showHUD(delay: TimeInterval, completeBlock:(() ->Void)?) {
        gethud().imageView.startAnimating()
        dissmissHUD(delay: delay) {
            if let block = completeBlock {
                block()
            }
        }
    }
    class func dissmissHUD(delay: TimeInterval, completeBlock:(() ->Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            let view = StellarProgressHUD.sharedHud
            view.removeFromSuperview()
            completeBlock?()
        })
    }
    class func dissmissHUD(finish: (() ->Void)? = nil) {
        let view = StellarProgressHUD.sharedHud
        view.removeFromSuperview()
        finish?()
    }
    class func dissmiss(completeBlock:(() ->Void)?) {
        let view = StellarProgressHUD.sharedHud
        view.removeFromSuperview()
        completeBlock?()
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.width.equalTo(111)
            $0.height.equalTo(85)
        }
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: 111, height: 85)
        blurView.alpha = 0.8
        bgView.addSubview(blurView)
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    private lazy var bgView: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = STELLAR_COLOR_C8.withAlphaComponent(0.6)
        tempView.layer.cornerRadius = 8
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var imageView: UIImageView = {
        var tempArr: [UIImage] = []
        for i in 1..<44{
            let image = UIImage.init(named: "loading_gif_\(i)")!.ss.reSizeImage(reSize: CGSize.init(width: 43*1.6, height: 28*1.6))
            tempArr.append(image)
        }
        let imageView = UIImageView.init()
        imageView.animationImages = tempArr
        imageView.animationDuration = 1.0
        return imageView
    }()
}