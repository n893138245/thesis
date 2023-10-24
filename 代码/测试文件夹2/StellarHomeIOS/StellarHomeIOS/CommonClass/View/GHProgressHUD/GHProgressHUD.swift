import UIKit
enum TextHUDPositionType {
    case top
    case center
    case bottom
}
class GHProgressHUD: UIView {
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        return tap
    }()
    private var allowTapOutsideDismiss = false
    private var contentView: UIView?
    private var delayTask: Task?
    private var customView: UIView?
    fileprivate static let progressHUD = GHProgressHUD(frame: CGRect.zero)
    private override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tap)
        backgroundColor = UIColor.black.withAlphaComponent(0)
        contentView = UIView(frame: CGRect.zero)
        addSubview(contentView!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func dismissAction() {
        if allowTapOutsideDismiss {
            let bgView = tap.view as! GHProgressHUD
            let point = tap.location(in: tap.view)
            if (bgView.contentView != nil && (bgView.contentView?.frame.contains(point))!) || (bgView.customView != nil && (bgView.customView?.frame.contains(point))!) {
            }else{
                allowTapOutsideDismiss = false
                GHProgressHUD.dismissCustomView {
                }
            }
        }
    }
    static func dismissCustomView(_ complete: (()->Void)? = nil) {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let bgView = window?.ghHUD
        if bgView?.customView != nil {
            bgView?.customView?.removeFromSuperview()
            bgView?.customView = nil
            bgView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            bgView?.removeFromSuperview()
            if let temp = complete {
                temp()
            }
            if bgView?.contentView == nil {
                bgView?.removeFromSuperview()
            }
        }
    }
    static func showCustom(_ customView: UIView, allowTapOutsideDismiss: Bool = false) {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let bgView = window?.ghHUD
        bgView?.removeFromSuperview()
        bgView?.frame = (window?.bounds)!
        window?.addSubview(bgView!)
        bgView?.allowTapOutsideDismiss = allowTapOutsideDismiss
        bgView?.customView?.removeFromSuperview()
        bgView?.customView = customView
        bgView?.customView?.center = CGPoint(x: (bgView?.bounds.width)!/2, y: (bgView?.bounds.height)!/2)
        bgView?.addSubview(bgView!.customView!)
        UIView.animate(withDuration: 0.25, animations: {
            bgView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
        let spring = CASpringAnimation(keyPath: "transform")
        spring.damping = 40;
        spring.stiffness = 800;
        spring.mass = 2;
        spring.initialVelocity = 10;
        spring.fromValue = CATransform3DMakeScale(0.3, 0.3, 1)
        spring.toValue = CATransform3DMakeScale(1, 1, 1)
        spring.fillMode = .both
        spring.isRemovedOnCompletion = false
        spring.duration = spring.settlingDuration;
        bgView?.customView?.layer.add(spring, forKey: spring.keyPath);
    }
    static func showStellarHud() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let bgView = window?.ghHUD
        if bgView?.delayTask != nil {
            cancel(bgView?.delayTask)
        }
        bgView?.removeFromSuperview()
        bgView?.frame = (window?.bounds)!
        window?.addSubview(bgView!)
        bgView?.contentView?.removeFromSuperview()
        bgView?.contentView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        bgView?.contentView?.layer.cornerRadius = 8
        bgView?.contentView?.layer.masksToBounds = true
        bgView?.contentView?.backgroundColor = UIColor(red: 224/255.0, green: 235/255.0, blue: 255/255.0, alpha: 1.0)
        bgView?.contentView?.center = CGPoint(x: (bgView?.bounds.width)!/2, y: (bgView?.bounds.height)!/2)
        bgView?.addSubview(bgView!.contentView!)
        var tempArr: [UIImage] = []
        for i in 0..<38{
            var index = 18 + i
            index = index > 38 ? index - 38 : index
            let image = UIImage.init(named: "blue_\(String(format: "%05d", index))")!
            tempArr.append(image)
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        imageView.center = CGPoint(x: (bgView?.contentView?.bounds.width)!/2, y: (bgView?.contentView?.bounds.height)!/2)
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = tempArr
        imageView.animationDuration = 1.0
        imageView.startAnimating()
        bgView?.contentView?.addSubview(imageView)
        bgView?.delayTask = delay(10) {
            UIView.animate(withDuration: 0.15, animations: {
                bgView?.contentView?.alpha = 0
            }, completion: { (finished) in
                bgView?.contentView?.removeFromSuperview()
                bgView?.contentView = nil
                if bgView?.customView == nil {
                    bgView?.removeFromSuperview()
                }
            })
        }
    }
    static func showStellarErrorHud(_ code: Int, _ position: TextHUDPositionType = .bottom) {
        let errorInfo = getErrorInfo(code: code)
        showStellarTextHud(errorInfo, position)
    }
    static func showStellarTextHud(_ text: String, _ position: TextHUDPositionType = .bottom) {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let bgView = window?.ghHUD
        if bgView?.delayTask != nil {
            cancel(bgView?.delayTask)
        }
        bgView?.removeFromSuperview()
        bgView?.frame = (window?.bounds)!
        window?.addSubview(bgView!)
        bgView?.contentView?.removeFromSuperview()
        let w = NSString(string: text).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 30), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil).size.width
        let h: CGFloat = 30
        var contentViewWidth: CGFloat = w + 40
        var contentViewHeight: CGFloat = h + 20
        if contentViewWidth > kScreenWidth - 30*2 {
            contentViewWidth = kScreenWidth - 30*2
           let h = NSString(string: text).boundingRect(with: CGSize(width: contentViewWidth - 40, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil).size.height
            contentViewHeight = h + 20
        }
        var y: CGFloat = 0
        switch position {
        case .top:
            y = CGFloat(kNavigationH + 30)
        case .center:
            y = (bgView?.center.y)! - (contentViewHeight*0.5)
        case .bottom:
            y = (bgView?.bounds.height)! - contentViewHeight - CGFloat(kBottomArcH + 10 + 25)
        }
        let frame = CGRect(x: ((bgView?.bounds.width)! - contentViewWidth)/2, y: y, width: contentViewWidth, height: contentViewHeight)
        bgView?.contentView = UIView(frame: frame)
        bgView?.contentView?.backgroundColor = UIColor(red: 224/255.0, green: 235/255.0, blue: 255/255.0, alpha: 1.0)
        bgView?.contentView?.layer.cornerRadius = 8
        bgView?.contentView?.layer.masksToBounds = true
        bgView?.addSubview(bgView!.contentView!)
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: frame.width - 40, height: frame.height - 20))
        label.text = text
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "PingFangSC-Medium", size: 16)
        label.textAlignment = .center
        bgView?.contentView?.addSubview(label)
        bgView?.delayTask = delay(1) {
            UIView.animate(withDuration: 0.15, animations: {
                bgView?.contentView?.alpha = 0
            }, completion: { (finished) in
                bgView?.contentView?.removeFromSuperview()
                bgView?.contentView = nil
                if bgView?.customView == nil {
                    bgView?.removeFromSuperview()
                }
            })
        }
    }
    static func hideStellarHud() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        let bgView = window?.ghHUD
        if bgView?.contentView != nil {
            if bgView?.delayTask != nil {
                cancel(bgView?.delayTask)
            }
            bgView?.contentView?.removeFromSuperview()
            bgView?.contentView = nil
            if bgView?.customView == nil {
                bgView?.removeFromSuperview()
            }
        }
    }
    private class func getErrorInfo(code: Int) -> String {
        var info = StellarLocalizedString("ERR_UNKNOWN_ERROR")
        let errorPath = Bundle.main.path(forResource: "ErrorCode", ofType: "plist")!
        let errorDic = NSDictionary.init(contentsOfFile: errorPath)
        if let tempStr = errorDic?.value(forKey: "\(code)") as! String? {
            info = StellarLocalizedString(tempStr)
        }
        return info
    }
    static func currentViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.keyWindow
        let vc = keyWindow?.rootViewController
        if vc != nil {
            let controller = vc
            if (controller?.isKind(of: UINavigationController.self))! {
                let nav = controller as! UINavigationController
                if let topVC = nav.topViewController {
                    if topVC.presentedViewController != nil {
                        let presentedVC = topVC.presentedViewController
                        if (presentedVC?.isKind(of: UINavigationController.self))! {
                            let nav = presentedVC as! UINavigationController
                            return nav.topViewController!
                        }
                        return presentedVC
                    }else{
                        return topVC
                    }
                }
            }else if (controller?.isKind(of: UITabBarController.self))! {
                let tabbar = controller as! UITabBarController
                if (tabbar.selectedViewController?.isKind(of: UINavigationController.self))! {
                    let nav = tabbar.selectedViewController as! UINavigationController
                    if let topVC = nav.topViewController {
                        if topVC.presentedViewController != nil {
                            let presentedVC = topVC.presentedViewController
                            if (presentedVC?.isKind(of: UINavigationController.self))! {
                                let nav = presentedVC as! UINavigationController
                                return nav.topViewController!
                            }
                            return presentedVC
                        }else{
                            return topVC
                        }
                    }
                }
            }
        }
        return nil
    }
    private typealias Task = (_ cancel: Bool) -> Void
    @discardableResult
    private static func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
        func dispatch_later(block: @escaping () -> ()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (() -> Void)? = task
        var result: Task?
        let delayedClosure: Task = { cancel in
            if let internalClosure = closure {
                if cancel == false {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    private static func cancel(_ task: Task?) {
        task?(true)
    }
}
extension UIWindow {
    var ghHUD: GHProgressHUD {
        return GHProgressHUD.progressHUD
    }
}