import UIKit
class AddDeviceNavView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(exitButton)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self.snp.bottom).offset(-9.fit)
        }
        backButton.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.centerY.equalTo(titleLabel)
            $0.width.equalTo(44.fit)
            $0.height.equalTo(44.fit)
        }
        exitButton.snp.makeConstraints {
            $0.right.equalTo(self.snp.right)
            $0.centerY.equalTo(titleLabel)
            $0.width.equalTo(44.fit)
            $0.height.equalTo(44.fit)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var backButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "bar_icon_white"), for: .normal)
        return tempView
    }()
    lazy var exitButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "icon_close_white"), for: .normal)
        tempView.setImage(UIImage(named: "icon_close_gray"), for: .highlighted)
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C3
        tempView.font = STELLAR_FONT_MEDIUM_T18
        return tempView
    }()
}