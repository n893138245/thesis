import UIKit
import YYKit
class DeviceOffLineAlertView: UIView {
    private var device: BasicDeviceModel?
    var deletBlock: (() ->Void)?
    var resetBlock: (() ->Void)?
    let disposeBag = DisposeBag()
    convenience init(device: BasicDeviceModel) {
        self.init(frame: UIScreen.main.bounds)
        self.device = device
        setupSubViews()
        setupActions()
    }
    private func setupSubViews() {
        addSubview(bgView)
        bgView.addSubview(icon)
        let url = URL(string: getDeviceNormalIconBy(fwType: self.device?.fwType ?? -1))
        icon.kf.setImage(with: url)
        icon.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(32.fit)
            $0.centerX.equalTo(self)
            $0.width.height.equalTo(72.fit)
        }
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(16.fit)
            $0.centerX.equalTo(self)
        }
        bgView.addSubview(contentLabel)
        let contentTipString: NSString = StellarLocalizedString("ALERT_DEVICE_OFFLINE_TIP") as NSString
        let linkString = StellarLocalizedString("ALERT_RESET_DEVICE")
        let attributedString = NSMutableAttributedString.init(string: contentTipString as String)
        attributedString.lineSpacing = 6.fit
        attributedString.font = STELLAR_FONT_T14
        attributedString.color = STELLAR_COLOR_C6
        let lineStyle = YYTextDecoration(style: .single)
        lineStyle.color = STELLAR_COLOR_C1
        attributedString.setTextUnderline(lineStyle, range: contentTipString.range(of: linkString))
        attributedString.setTextHighlight(contentTipString.range(of: linkString), color: STELLAR_COLOR_C1, backgroundColor: nil) { (_, _, _, _) in
            self.dismiss()
            self.resetBlock?()
        }
        contentLabel.attributedText = attributedString
        let contentTextHeight = contentTipString.heightParagraphSpeace(6.fit, with: STELLAR_FONT_T14, andWidth: kScreenWidth-118.fit)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15.fit)
            $0.left.equalTo(bgView).offset(28.fit)
            $0.right.equalTo(bgView).offset(-28.fit)
            $0.height.equalTo(contentTextHeight)
        }
        bgView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.width.equalTo(kScreenWidth-60.fit)
            $0.height.equalTo(contentTextHeight+244.fit)
        }
        let topLine = UIView()
        bgView.addSubview(topLine)
        topLine.backgroundColor = STELLAR_COLOR_C8
        topLine.snp.makeConstraints {
            $0.bottom.equalTo(bgView).offset(-48.fit)
            $0.height.equalTo(1)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(bgView)
        }
        let lineCenter = UIView.init()
        lineCenter.backgroundColor = STELLAR_COLOR_C8
        bgView.addSubview(lineCenter)
        lineCenter.snp.makeConstraints {
            $0.bottom.equalTo(bgView)
            $0.top.equalTo(topLine.snp.bottom)
            $0.centerX.equalTo(bgView)
            $0.width.equalTo(1)
        }
        bgView.addSubview(leftButton)
        bgView.addSubview(rightButton)
        leftButton.snp.makeConstraints {
            $0.width.equalTo(315.fit/2)
            $0.left.equalTo(bgView)
            $0.bottom.equalTo(bgView)
            $0.height.equalTo(48.fit)
        }
        rightButton.snp.makeConstraints {
            $0.width.equalTo(315.fit/2)
            $0.right.equalTo(bgView)
            $0.bottom.equalTo(bgView)
            $0.height.equalTo(48.fit)
        }
    }
    private func setupActions() {
        leftButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.deletBlock?()
            self?.dismiss()
        }).disposed(by: disposeBag)
        rightButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.dismiss()
        }).disposed(by: disposeBag)
    }
    func show() {
        DispatchQueue.main.async {
            let window = getFrontWindow() ?? UIWindow()
            window.addSubview(self)
        }
        bgView.pop_add(self.ss.popScaleAnimation(), forKey: "scale")
    }
    private func dismiss() {
        subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        removeFromSuperview()
    }
    private lazy var bgView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.layer.cornerRadius = 12.fit
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var titleLabel: UILabel = {
        let tempView = UILabel()
        tempView.font = STELLAR_FONT_MEDIUM_T17
        tempView.textColor = STELLAR_COLOR_C4
        tempView.text = StellarLocalizedString("ALERT_DEVICE_OFFLINE")
        return tempView
    }()
    private lazy var contentLabel: YYLabel = {
        let tempView = YYLabel()
        tempView.numberOfLines = 0
        return tempView
    }()
    private lazy var leftButton: UIButton = {
        let tempView = UIButton()
        tempView.titleLabel?.font = STELLAR_FONT_T17
        tempView.setTitleColor(STELLAR_COLOR_C2, for: .normal)
        tempView.setTitle(StellarLocalizedString("ALERT_DELETE_DEVICE"), for: .normal)
        return tempView
    }()
    private lazy var rightButton: UIButton = {
        let tempView = UIButton()
        tempView.titleLabel?.font = STELLAR_FONT_T17
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        return tempView
    }()
    private lazy var icon: UIImageView = {
        let tempView = UIImageView()
        return tempView
    }()
}