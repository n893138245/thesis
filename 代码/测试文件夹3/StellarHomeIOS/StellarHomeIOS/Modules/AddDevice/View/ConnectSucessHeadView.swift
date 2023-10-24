import UIKit
class ConnectSucessHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var isMultipleSuccess = false {
        didSet {
            if isMultipleSuccess {
                addSubview(hintLable)
                addSubview(hintColorView)
                hintLable.snp.makeConstraints {
                    $0.left.equalTo(self).offset(94.fit)
                    $0.top.equalTo(self).offset(16.fit)
                }
                hintColorView.snp.makeConstraints {
                    $0.left.equalTo(hintLable.snp.right).offset(9.fit)
                    $0.centerY.equalTo(hintLable)
                    $0.width.height.equalTo(17)
                }
            }
        }
    }
    private func setupUI() {
        deviceNameTitleLabel.snp.makeConstraints {
            $0.left.equalTo(self).offset(19.fit)
            $0.top.equalTo(self).offset(63.fit)
        }
        let topArrow = UIImageView.init()
        topArrow.image = UIImage(named: "icon_gray_right_arrow")
        topArrow.contentMode = .scaleToFill
        addSubview(topArrow)
        topArrow.snp.makeConstraints {
            $0.right.equalTo(self).offset(-21.fit)
            $0.centerY.equalTo(deviceNameLabel)
            $0.width.equalTo(22.fit)
            $0.height.equalTo(22.fit)
        }
        deviceNameLabel.snp.makeConstraints {
            $0.right.equalTo(topArrow.snp.left).offset(-8.fit)
            $0.centerY.equalTo(deviceNameTitleLabel)
            $0.left.lessThanOrEqualTo(deviceNameTitleLabel.snp.right).offset(20.fit)
        }
        selectLocationLabel.snp.makeConstraints {
            $0.top.equalTo(deviceNameTitleLabel.snp.bottom).offset(39.fit)
            $0.left.equalTo(self).offset(19.fit)
        }
        addSubview(changeNameButton)
        changeNameButton.snp.makeConstraints {
            $0.left.right.equalTo(self)
            $0.height.equalTo(44)
            $0.centerY.equalTo(deviceNameLabel)
        }
    }
    private lazy var deviceNameTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("EQUIPMENT_DEVICE_NAME")
        tempView.font = STELLAR_FONT_T16
        tempView.textColor = STELLAR_COLOR_C4
        addSubview(tempView)
        return tempView
    }()
    lazy var deviceNameLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T14
        tempView.textColor = STELLAR_COLOR_C6
        addSubview(tempView)
        return tempView
    }()
    private lazy var selectLocationLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("COMMON_SELECT") + StellarLocalizedString("ADD_DEVICE_LOCATION_DEVICE")
        tempView.font = STELLAR_FONT_T14
        tempView.textColor = STELLAR_COLOR_C6
        addSubview(tempView)
        return tempView
    }()
    lazy var hintLable: UILabel = {
        let tempView = UILabel()
        tempView.textColor = STELLAR_COLOR_C1
        tempView.font = STELLAR_FONT_T16
        tempView.text = ""
        return tempView
    }()
    lazy var hintColorView: UIView = {
        let tempView = UIView()
        tempView.layer.cornerRadius = 8.5
        return tempView
    }()
    lazy var changeNameButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        return tempView
    }()
}