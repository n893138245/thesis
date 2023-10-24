import UIKit
enum MyAlertType {
    case aboutSansiType 
    case longinExpressType 
    case exitAddDeviceType 
    case scenseTrunOffType 
    case deletDeviceType   
    case unknowningType
}
class StellarMineAlertView: UIView {
    let disposeBag = DisposeBag()
    var leftClickBlock: (() ->Void)?
    var rightClickBlock: (() ->Void)?
    var myType: MyAlertType = .unknowningType
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(title: String, message: String, icon: UIImage, confimTitle: String) {
        self.init(frame: UIScreen.main.bounds)
        myType = .aboutSansiType
        setupSubViews(title: title, message: message, leftTitle: confimTitle, ringhtTitle: nil, icon: icon, content: nil)
        setupActions()
    }
    convenience init(message: String, leftTitle: String, rightTile: String, showExitButton: Bool) {
        self.init(frame: UIScreen.main.bounds)
        myType = .exitAddDeviceType
        setupSubViews(title: nil, message: message, leftTitle: leftTitle, ringhtTitle: rightTile, icon: nil, content: nil)
        setupActions()
    }
    convenience init(title: String, message: String, confimTitle: String) {
        self.init(frame: UIScreen.main.bounds)
        myType = .longinExpressType
        setupSubViews(title: title, message: message, leftTitle: confimTitle, ringhtTitle: nil, icon: nil, content: nil)
        setupActions()
    }
    convenience init(icon: UIImage, message: String, leftTitle: String, rightTitle: String) {
        self.init(frame: UIScreen.main.bounds)
        myType = .scenseTrunOffType
        setupSubViews(title: nil, message: message, leftTitle: leftTitle, ringhtTitle: rightTitle, icon: icon, content: nil)
        setupActions()
    }
    convenience init(title: String, message: String, leftTitle: String, rightTitle: String, contentTip: String?) {
        self.init(frame: UIScreen.main.bounds)
        myType = .deletDeviceType
        setupSubViews(title: title, message: message, leftTitle: leftTitle, ringhtTitle: rightTitle, icon: nil, content: contentTip)
        setupActions()
    }
    private func setupSubViews(title: String?, message: String, leftTitle: String, ringhtTitle: String?, icon: UIImage?, content: String?) {
        var bgViewWidth: CGFloat = 316.fit
        var iconSize = CGSize.zero
        var topSpace = 40.fit
        var iconTitleSpace = 13.fit
        var titleMessageSpace = 12.fit
        var messageLineSpace = 32.fit
        var titleSize = String.ss.getTextRectSize(text: title ?? "", font: STELLAR_FONT_MEDIUM_T17, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
        var messageSize = String.ss.getTextRectSize(text: message, font: STELLAR_FONT_T17, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
        addSubview(bgView)
        bgView.backgroundColor = STELLAR_COLOR_C3
        bgView.layer.cornerRadius = 12.fit
        bgView.clipsToBounds = true
        switch myType {
        case .aboutSansiType:
            iconImg.image = icon
            iconSize = icon?.size ?? CGSize.zero
            titleSize = String.ss.getTextRectSize(text: title ?? "", font: STELLAR_FONT_MEDIUM_T20, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
            messageSize = String.ss.getTextRectSize(text: message, font: STELLAR_FONT_T15, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.text = title
            messageLabel.text = message
            setupAboutSansiUI(topSpace: topSpace, iconTitleSpace: iconTitleSpace, titleMessageSpace: titleMessageSpace)
            break
        case .longinExpressType:
            iconTitleSpace = 0
            topSpace = 23.5.fit
            titleMessageSpace = 8.fit
            messageLineSpace = 18.fit
            bgViewWidth = 294.fit
            titleLabel.text = title
            messageLabel.text = message
            messageSize = String.ss.getTextRectSize(text: message, font: STELLAR_FONT_T14, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
            messageLabel.font = STELLAR_FONT_T14
            titleLabel.font = STELLAR_FONT_MEDIUM_T17
            comfrimButton.titleLabel?.font = STELLAR_FONT_T17
            comfrimButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            setupLoginExpressUI(topSpace: topSpace, titleMessageSpace: titleMessageSpace)
            break
        case .exitAddDeviceType:
            iconTitleSpace = 0
            titleMessageSpace = 0
            messageLabel.text = message
            topSpace = 38.5.fit
            messageLineSpace = 38.fit
            titleSize = CGRect.zero
            messageLabel.font = STELLAR_FONT_T17
            messageLabel.textColor = STELLAR_COLOR_C4
            cancleButton.titleLabel?.font = STELLAR_FONT_T17
            comfrimButton.titleLabel?.font = STELLAR_FONT_T17
            cancleButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            comfrimButton.setTitleColor(STELLAR_COLOR_C2, for: .normal)
            setupExitAddDeviceUI(topSpace: topSpace)
            break
        case .scenseTrunOffType:
            messageSize = String.ss.getTextRectSize(text: message, font: STELLAR_FONT_MEDIUM_T17, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
            titleMessageSpace = 0
            iconImg.image = icon
            iconSize = icon?.size ?? CGSize.zero
            messageLabel.text = message
            messageLabel.font = STELLAR_FONT_MEDIUM_T17
            topSpace = 23.fit
            iconTitleSpace = 17.fit
            messageLineSpace = 20.fit
            cancleButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            comfrimButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            cancleButton.titleLabel?.font = STELLAR_FONT_T17
            comfrimButton.titleLabel?.font = STELLAR_FONT_T17
            messageLabel.textColor = STELLAR_COLOR_C4
            setupScenseTrunOffUI(topSpace: topSpace)
            break
        case .deletDeviceType:
            topSpace = 24.fit
            titleMessageSpace = 8.fit
            messageLineSpace = 24.fit
            messageSize = String.ss.getTextRectSize(text: message, font: STELLAR_FONT_T14, size: CGSize(width: kScreenWidth-120.fit, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.font = STELLAR_FONT_MEDIUM_T17
            titleLabel.text = title
            if let aMessage = content {
                messageLabel.text = aMessage
            }else {
                let attText = NSMutableAttributedString.init(string: message)
                attText.lineSpacing = 3.fit
                attText.font = STELLAR_FONT_T14
                attText.color = STELLAR_COLOR_C2
                attText.alignment = .center
                messageLabel.attributedText = attText
            }
            cancleButton.titleLabel?.font = STELLAR_FONT_T17
            comfrimButton.titleLabel?.font = STELLAR_FONT_T17
            cancleButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            comfrimButton.setTitleColor(STELLAR_COLOR_C2, for: .normal)
            setDeletDeviceUI()
            break
        default:
            break
        }
        let bgViewHeight = topSpace+iconSize.height+iconTitleSpace+titleSize.height+titleMessageSpace+messageSize.height+messageLineSpace+48.fit
        bgView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        bgView.bounds = CGRect(x: 0, y: 0, width: bgViewWidth, height: bgViewHeight)
        setupBottom(leftTitle: leftTitle, rightTitle: ringhtTitle)
        layoutIfNeeded()
    }
    private func setDeletDeviceUI() {
        bgView.addSubview(titleLabel)
        bgView.addSubview(messageLabel)
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(bgView.top).offset(24.5.fit)
            $0.centerX.equalTo(bgView)
        })
        messageLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.fit)
            $0.centerX.equalTo(bgView)
        })
    }
    private func setupAboutSansiUI(topSpace: CGFloat, iconTitleSpace: CGFloat,titleMessageSpace: CGFloat) {
        bgView.addSubview(iconImg)
        bgView.addSubview(titleLabel)
        bgView.addSubview(messageLabel)
        iconImg.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(bgView).offset(topSpace)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(iconImg.snp.bottom).offset(iconTitleSpace)
            $0.width.width.equalTo(kScreenWidth-120.fit)
        }
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleMessageSpace)
            $0.width.width.equalTo(kScreenWidth-120.fit)
        }
    }
    private func setupLoginExpressUI(topSpace: CGFloat, titleMessageSpace: CGFloat) {
        bgView.addSubview(titleLabel)
        bgView.addSubview(messageLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(topSpace)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(kScreenWidth-120.fit)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(titleMessageSpace)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(kScreenWidth-120.fit)
        }
    }
    private func setupExitAddDeviceUI(topSpace: CGFloat) {
        bgView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(topSpace)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(kScreenWidth-120.fit)
        }
    }
    private func setupScenseTrunOffUI(topSpace: CGFloat) {
        bgView.addSubview(iconImg)
        bgView.addSubview(messageLabel)
        iconImg.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(bgView).offset(topSpace)
        }
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(bgView)
            $0.top.equalTo(iconImg.snp.bottom).offset(17.fit)
            $0.width.width.equalTo(kScreenWidth-120.fit)
        }
    }
    private func setupBottom(leftTitle: String, rightTitle: String?) {
        let topLine = UIView()
        bgView.addSubview(topLine)
        topLine.backgroundColor = STELLAR_COLOR_C8
        topLine.snp.makeConstraints {
            $0.bottom.equalTo(bgView).offset(-48.fit)
            $0.height.equalTo(1)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(bgView)
        }
        if myType == .exitAddDeviceType || myType == .scenseTrunOffType || myType == .deletDeviceType { 
            let lineCenter = UIView.init()
            lineCenter.backgroundColor = STELLAR_COLOR_C8
            bgView.addSubview(lineCenter)
            lineCenter.snp.makeConstraints {
                $0.bottom.equalTo(bgView)
                $0.top.equalTo(topLine.snp.bottom)
                $0.centerX.equalTo(bgView)
                $0.width.equalTo(1)
            }
            bgView.addSubview(comfrimButton)
            bgView.addSubview(cancleButton)
            comfrimButton.snp.makeConstraints {
                $0.width.equalTo(316.fit/2)
                $0.left.equalTo(bgView)
                $0.bottom.equalTo(bgView)
                $0.height.equalTo(48.fit)
            }
            cancleButton.setTitle(rightTitle, for: .normal)
            cancleButton.snp.makeConstraints {
                $0.width.equalTo(316.fit/2)
                $0.right.equalTo(bgView)
                $0.bottom.equalTo(bgView)
                $0.height.equalTo(48.fit)
            }
        }else { 
            bgView.addSubview(comfrimButton)
            comfrimButton.snp.makeConstraints {
                $0.width.equalTo(bgView)
                $0.centerX.equalTo(bgView)
                $0.bottom.equalTo(bgView)
                $0.height.equalTo(48.fit)
            }
        }
        comfrimButton.setTitle(leftTitle, for: .normal)
    }
    private func setupActions() {
        comfrimButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.leftClickBlock?()
            self?.dissmiss()
        }).disposed(by: disposeBag)
        cancleButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.rightClickBlock?()
            self?.dissmiss()
        }).disposed(by: disposeBag)
        exitButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.dissmiss()
        }).disposed(by: disposeBag)
    }
    func show() {
        getKeyboardWindow().addSubview(self)
        bgView.pop_add(self.ss.popScaleAnimation(), forKey: "scale")
    }
    private func dissmiss() {
        self.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    private lazy var iconImg: UIImageView = { 
        let tempView = UIImageView.init()
        return tempView
    }()
    private lazy var bgView: UIView = { 
        let tempView = UIView.init()
        return tempView
    }()
    private lazy var titleLabel: UILabel = { 
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_MEDIUM_T20
        tempView.textColor = STELLAR_COLOR_C4
        tempView.textAlignment = .center
        return tempView
    }()
    private lazy var messageLabel: UILabel = { 
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T15
        tempView.textColor = STELLAR_COLOR_C6
        tempView.numberOfLines = 0
        tempView.textAlignment = .center
        return tempView
    }()
    private lazy var comfrimButton: UIButton = { 
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font = STELLAR_FONT_MEDIUM_T17
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        return tempView
    }()
    private lazy var cancleButton: UIButton = { 
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font = STELLAR_FONT_MEDIUM_T17
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        return tempView
    }()
    private lazy var exitButton: UIButton = { 
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "icon_close_gray"), for: .normal)
        return tempView
    }()
}