import UIKit
class ScenseTitleTipView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        addSubview(bgView)
        addSubview(leftIcon)
        addSubview(titleLabel)
        titleLabel.text = title
        leftIcon.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.left.equalTo(self).offset(20)
            $0.centerY.equalTo(self)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(leftIcon.snp.right).offset(8)
            $0.centerY.equalTo(self)
        }
        bgView.snp.makeConstraints {
            $0.left.equalTo(leftIcon)
            $0.right.equalTo(titleLabel.snp.right).offset(16)
            $0.height.equalTo(24)
            $0.centerY.equalTo(self)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var titleLabel: UILabel = {
        let tempView = UILabel()
        tempView.textColor = STELLAR_COLOR_C1
        tempView.font = STELLAR_FONT_T14
        return tempView
    }()
    private lazy var leftIcon: UIImageView = {
        let tempView = UIImageView()
        tempView.image = UIImage(named: "icon_tishib")
        return tempView
    }()
    private lazy var bgView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(hexString: "#ECF3FF")
        tempView.layer.cornerRadius = 12
        tempView.clipsToBounds = true
        return tempView
    }()
}