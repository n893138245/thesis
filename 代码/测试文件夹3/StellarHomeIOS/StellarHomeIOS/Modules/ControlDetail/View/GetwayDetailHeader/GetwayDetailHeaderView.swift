import UIKit
class GetwayDetailHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = STELLAR_COLOR_C3
        let bgImage = UIImageView.init(image: UIImage(named: "gateway_bg"))
        addSubview(bgImage)
        let topLabel = UILabel.init()
        addSubview(topLabel)
        topLabel.font = STELLAR_FONT_MEDIUM_T14
        topLabel.textColor = STELLAR_COLOR_C5
        topLabel.text = "请用"
        topLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(4.fit)
        }
        let nameLabel = UILabel.init()
        addSubview(nameLabel)
        nameLabel.font = STELLAR_FONT_MEDIUM_T30
        nameLabel.textColor = STELLAR_COLOR_C4
        nameLabel.text = "“ 智能家居 ”"
        nameLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(topLabel.snp.bottom).offset(4.fit)
        }
        let speakLabel = UILabel.init()
        addSubview(speakLabel)
        speakLabel.font = STELLAR_FONT_T12
        speakLabel.textColor = STELLAR_COLOR_C6
        speakLabel.text = "唤醒语音网关"
        speakLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4.fit)
        }
        let getwayImage = UIImageView.init(image: UIImage(named: "gateway_icon"))
        getwayImage.contentMode = .scaleAspectFit
        addSubview(getwayImage)
        getwayImage.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(speakLabel.snp.bottom).offset(8.fit)
        }
        bgImage.snp.makeConstraints {
            $0.center.equalTo(getwayImage)
            $0.width.equalTo(kScreenWidth-2)
            $0.height.equalTo(156.fit)
        }
        leftButton.snp.makeConstraints {
            $0.left.equalTo(self).offset(9.fit)
            $0.width.equalTo(174.fit)
            $0.height.equalTo(74.fit)
            $0.top.equalTo(bgImage.snp.bottom).offset(17.fit)
        }
        rightButton.snp.makeConstraints {
            $0.right.equalTo(self).offset(-9.fit)
            $0.width.equalTo(174.fit)
            $0.height.equalTo(74.fit)
            $0.top.equalTo(bgImage.snp.bottom).offset(17.fit)
        }
        let bottomLabel = UILabel.init()
        addSubview(bottomLabel)
        bottomLabel.font = STELLAR_FONT_MEDIUM_T20
        bottomLabel.textColor = STELLAR_COLOR_C4
        bottomLabel.text = "设备语音指令"
        bottomLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(20.fit)
            $0.top.equalTo(rightButton.snp.bottom).offset(40.fit)
        }
    }
    lazy var leftButton: GetwayShadowButton = {
        let tempView = GetwayShadowButton.init()
        tempView.mTitleLabel.text = "接入设备"
        tempView.subTitleLabel.text = "共3个"
        tempView.leftImage.image = UIImage(named: "icon_gateway_2")
        tempView.layer.cornerRadius = 6.fit
        tempView.layer.shadowColor = UIColor.black.cgColor
        tempView.layer.shadowOpacity = 0.1
        tempView.layer.shadowOffset = CGSize(width: 0, height: 5)
        tempView.layer.shadowRadius = 8.fit
        tempView.backgroundColor = STELLAR_COLOR_C3
        addSubview(tempView)
        return tempView
    }()
    lazy var rightButton: GetwayShadowButton = {
        let tempView = GetwayShadowButton.init()
        tempView.mTitleLabel.text = "发现技能"
        tempView.subTitleLabel.text = "“我想听相声”"
        tempView.leftImage.image = UIImage(named: "icon_gateway_1")
        tempView.layer.cornerRadius = 6.fit
        tempView.layer.shadowColor = UIColor.black.cgColor
        tempView.layer.shadowOpacity = 0.1
        tempView.layer.shadowOffset = CGSize(width: 0, height: 5)
        tempView.layer.shadowRadius = 8.fit
        tempView.backgroundColor = STELLAR_COLOR_C3
        addSubview(tempView)
        return tempView
    }()
}
class GetwayShadowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    private func setupUI() {
        leftImage.snp.makeConstraints {
            $0.left.equalTo(self).offset(19.fit)
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(34.fit)
        }
        mTitleLabel.snp.makeConstraints {
            $0.top.equalTo(leftImage)
            $0.left.equalTo(leftImage.snp.right).offset(15.fit)
        }
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(leftImage)
            $0.left.equalTo(mTitleLabel)
        }
    }
    lazy var leftImage: UIImageView = {
        let tempView = UIImageView.init()
        addSubview(tempView)
        return tempView
    }()
    lazy var mTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_MEDIUM_T14
        tempView.textColor = STELLAR_COLOR_C4
        addSubview(tempView)
        return tempView
    }()
    lazy var subTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C6
        addSubview(tempView)
        return tempView
    }()
}
