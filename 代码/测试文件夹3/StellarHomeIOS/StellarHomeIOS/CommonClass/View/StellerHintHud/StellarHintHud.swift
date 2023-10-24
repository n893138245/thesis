import UIKit
enum HintType { 
    case hud
    case toast
}
enum ToastContentType {
    case bottom
    case center
}
class StellarHintHud: UIView {
    static let shared = StellarHintHud.init(frame: UIScreen.main.bounds) 
    private var hintType: HintType = .hud {
        didSet {
            switch hintType {
            case .hud:
                messageLabel.isHidden = false
                bgView.isHidden = false
                iconImage.isHidden = false
                toastContentLabel.isHidden = true
                toastBgView.isHidden = true
            case .toast:
                messageLabel.isHidden = true
                bgView.isHidden = true
                iconImage.isHidden = true
                toastContentLabel.isHidden = false
                toastBgView.isHidden = false
            }
        }
    }
    class func toast(message: String,contentType :ToastContentType, completeBlock:(() ->Void)?) {
        _ = getToastInWindow(message: message, contentType: contentType)
        dissmiss(delay: 0.9) {
            if let block = completeBlock {
                block()
            }
        }
    }
    class func showSuccess(message: String, completeBlock:(() ->Void)?) {
        _ = getHudInWindow(msseage: message, iconName: "")
        dissmiss(delay: 0.75) {
            if let block = completeBlock {
                block()
            }
        }
    }
    class func showStatus(message: String, iconName: String, completeBlock:(() ->Void)?) {
        _ = getHudInWindow(msseage: message, iconName: iconName)
        dissmiss(delay: 0.75) {
            if let block = completeBlock {
                block()
            }
        }
    }
    class func showStatus(message: String, iconName: String, dissmissTime: TimeInterval, completeBlock:(() ->Void)?) {
        _ = getHudInWindow(msseage: message, iconName: iconName)
        dissmiss(delay: dissmissTime-0.25) {
            if let block = completeBlock {
                block()
            }
        }
    }
    class func showSuccess(message: String, dissmissTime: TimeInterval, completeBlock:(() ->Void)?) {
        _ = getHudInWindow(msseage: message, iconName: "")
        dissmiss(delay: dissmissTime-0.25) {
            if let block = completeBlock {
                block()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private class func getHudInWindow(msseage: String, iconName: String) ->StellarHintHud {
        let view = StellarHintHud.shared
        view.hintType = .hud
        view.messageLabel.text = msseage
        if iconName.count > 0 {
            if let image = UIImage(named: iconName) {
                view.iconImage.image = image
            }
        }
        DispatchQueue.main.async {
            let window = getFrontWindow() ?? UIWindow()
            window.addSubview(view)
        }
        return view
    }
    private class func getToastInWindow(message: String, contentType: ToastContentType) ->StellarHintHud {
        let view = StellarHintHud.shared
        view.hintType = .toast
        var lineSapcing :CGFloat = 0
        let textRect = String.ss.getTextRectSize(text: message ,font: STELLAR_FONT_T13,size: CGSize.init(width: kScreenWidth - 160 , height: CGFloat.greatestFiniteMagnitude))
        if textRect.width >= kScreenWidth - 163 {
            lineSapcing = 5
        }
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = lineSapcing
        paraph.alignment = .center
        let atrributes = [NSAttributedString.Key.font:STELLAR_FONT_T13,
                          NSAttributedString.Key.paragraphStyle: paraph]
        view.toastContentLabel.attributedText = NSAttributedString(string: message, attributes: atrributes)
        if contentType == .center {
            view.toastContentLabel.snp.remakeConstraints {
                $0.center.equalTo(view)
                $0.left.equalTo(view).offset(80)
                $0.right.equalTo(view).offset(-80)
            }
            view.toastBgView.snp.remakeConstraints {
                $0.center.equalTo(view)
                $0.bottom.equalTo(view.toastContentLabel).offset(9)
                $0.top.equalTo(view.toastContentLabel).offset(-9)
                $0.width.equalTo(textRect.width+18)
            }
            view.layoutIfNeeded()
        }else {
            view.toastContentLabel.snp.remakeConstraints {
                $0.bottom.equalTo(view).offset(-80)
                $0.left.equalTo(view).offset(80)
                $0.right.equalTo(view).offset(-80)
            }
            view.toastBgView.snp.remakeConstraints {
                $0.center.equalTo(view.toastContentLabel)
                $0.bottom.equalTo(view.toastContentLabel).offset(9)
                $0.top.equalTo(view.toastContentLabel).offset(-9)
                $0.width.equalTo(textRect.width+18)
            }
            view.layoutIfNeeded()
        }
        DispatchQueue.main.async {
            let window = getFrontWindow() ?? UIWindow()
            window.addSubview(view)
        }
        return view
    }
    private func setupUI() {
        bgView.center = CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0)
        bgView.bounds = CGRect(x: 0, y: 0, width: 155, height: 142)
        addSubview(bgView)
        bgView.addSubview(iconImage)
        bgView.addSubview(messageLabel)
        iconImage.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(bgView).offset(30)
            $0.width.height.equalTo(48)
        }
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(iconImage.snp.bottom).offset(8)
        }
        addSubview(toastBgView)
        addSubview(toastContentLabel)
    }
    private class func dissmiss(delay: TimeInterval,completeBlock: (() ->Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            let view = StellarHintHud.shared
            view.superview?.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                if view.hintType == .hud {
                    view.bgView.alpha = 0
                }else {
                    view.toastBgView.alpha = 0
                    view.toastContentLabel.textColor = .clear
                }
            }, completion: { (_) in
                if view.hintType == .hud {
                    view.bgView.alpha = 1
                }else {
                    view.toastBgView.alpha = 1
                    view.toastContentLabel.textColor = STELLAR_COLOR_C3
                }
                view.removeFromSuperview()
                if let block = completeBlock {
                    block()
                }
            })
        })
    }
    private lazy var iconImage: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "icon_window_success48")
        return tempView
    }()
    private lazy var bgView: UIView = {
        let tempView = UIView.init()
        tempView.layer.cornerRadius = 12
        tempView.layer.masksToBounds = true
        tempView.backgroundColor = STELLAR_COLOR_C4.withAlphaComponent(0.96)
        return tempView
    }()
    private lazy var messageLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C3
        tempView.font = STELLAR_FONT_T16
        return tempView
    }()
    private lazy var toastBgView: UIView = {
        let tempView = UIView.init()
        tempView.layer.cornerRadius = 2
        tempView.layer.masksToBounds = true
        tempView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return tempView
    }()
    private lazy var toastContentLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C3
        tempView.font = STELLAR_FONT_T13
        tempView.textAlignment = .center
        tempView.numberOfLines = 0
        return tempView
    }()
}