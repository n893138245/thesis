import UIKit
extension MBProgressHUD{
    class func showStellarHudSuccessfulWith(_ title: String,successBlock: (() ->Void)? = nil) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: getFrontWindow() ?? UIWindow(), animated: true)
            hud.customView = UIImageView.init(image: UIImage.init(named: "icon_window_success48"))
            hud.mode = .customView
            hud.label.text = title
            hud.label.textColor = STELLAR_COLOR_C3
            hud.label.font = STELLAR_FONT_T16
            hud.isSquare = true
            hud.bezelView.style = .solidColor
            hud.bezelView.layer.cornerRadius = 12
            hud.bezelView.layer.masksToBounds = true
            hud.bezelView.backgroundColor = STELLAR_COLOR_C4.withAlphaComponent(0.96)
            hud.hide(animated: true, afterDelay: 1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                successBlock?()
            })
        }
    }
    class func showStellarHud() {
        guard let rootvc = StellarAppManager.sharedManager.currVc?.view else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: rootvc, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = STELLAR_COLOR_C8.withAlphaComponent(0.94)
        var tempArr: [UIImage] = []
        for i in 1..<44{
            let image = UIImage.init(named: "loading_gif_\(i)")!.ss.reSizeImage(reSize: CGSize.init(width: 43*1.6, height: 28*1.6))
            tempArr.append(image)
        }
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 142, height: 155))
        imageView.animationImages = tempArr
        imageView.animationDuration = 1.0
        imageView.startAnimating()
        hud.customView = imageView
        hud.mode = .customView
        hud.backgroundView.layer.cornerRadius = 12
        hud.backgroundView.layer.masksToBounds = true
        hud.hide(animated: true, afterDelay: 10.0)
    }
}