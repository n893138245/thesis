import UIKit
class ThirdLoginBtnView: UIView {
    private let disposeBag = DisposeBag()
    var clickTypeBlock:((ThirdPartType)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupviews(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(0)
            make.width.equalTo(80)
        }
        addSubview(leftline)
        leftline.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(titleLabel.snp.left).offset(-14)
            make.left.equalTo(48)
            make.height.equalTo(1)
        }
        addSubview(rightline)
        rightline.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(14)
            make.right.equalTo(-48)
            make.height.equalTo(1)
        }
        addSubview(contentBtnView)
        contentBtnView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(71)
        }
        layoutLoginViews()
        weChatButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.clickTypeBlock?(.wechat)
        }).disposed(by: disposeBag)
        appleButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.clickTypeBlock?(.apple)
        }).disposed(by: disposeBag)
    }
    func layoutLoginViews() {
        titleLabel.isHidden = false
        leftline.isHidden = false
        rightline.isHidden = false
        if #available(iOS 13.0, *) {
            contentBtnView.addSubview(appleButton)
            weChatButton.isHidden = !isContainWeChat()
            if isContainWeChat() {
                appleButton.snp.remakeConstraints { (make) in
                    make.left.bottom.equalTo(0)
                    make.top.equalTo(0)
                    make.width.equalTo(46)
                    make.height.equalTo(71)
                }
                contentBtnView.addSubview(weChatButton)
                weChatButton.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(contentBtnView.snp.bottom)
                    make.left.equalTo(appleButton.snp.right).offset(49)
                    make.top.right.equalTo(0)
                    make.width.equalTo(46)
                    make.height.equalTo(71)
                }
            }else{
                appleButton.snp.remakeConstraints { (make) in
                    make.left.right.bottom.equalTo(0)
                    make.top.equalTo(0)
                    make.width.equalTo(46)
                    make.height.equalTo(71)
                }
            }
        }else{
            appleButton.removeFromSuperview()
            weChatButton.isHidden = !isContainWeChat()
            if isContainWeChat() {
                contentBtnView.addSubview(weChatButton)
                weChatButton.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(contentBtnView.snp.bottom)
                    make.left.top.right.equalTo(0)
                    make.width.equalTo(46)
                    make.height.equalTo(71)
                }
            }else{
                titleLabel.isHidden = true
                leftline.isHidden = true
                rightline.isHidden = true
            }
        }
    }
    private lazy var weChatButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        button.titleLabel?.font = STELLAR_FONT_T14
        button.setImage(UIImage.init(named: "wechat_logo"), for: .normal)
        button.titleLabel?.sizeToFit()
        button.imageView?.sizeToFit()
        button.layoutSubviews()
        return button
    }()
    private lazy var titleLabel:UILabel = {
        let view = UILabel()
        view.text = "其他账号登录"
        view.textColor = STELLAR_COLOR_C3
        view.font = STELLAR_FONT_T12
        view.textAlignment = .center
        return view
    }()
    private lazy var leftline:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    private lazy var rightline:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    private lazy var contentBtnView:UIView = {
        let view = UIView()
        return view
    }()
    private lazy var appleButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        button.titleLabel?.font = STELLAR_FONT_T14
        button.setImage(UIImage.init(named: "apple_logo"), for: .normal)
        button.titleLabel?.sizeToFit()
        button.imageView?.sizeToFit()
        button.layoutSubviews()
        return button
    }()
}