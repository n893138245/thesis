import UIKit
class FindGetWayHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        findTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(46.fit)
        }
        selectTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(findTitleLabel.snp.bottom).offset(6.fit)
        }
    }
    lazy var findTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_MEDIUM_T20
        tempView.textColor = STELLAR_COLOR_C4
        addSubview(tempView)
        return tempView
    }()
    lazy var selectTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ADD_DEVICE_SELECT_NEED_GATEWAY")
        tempView.font = STELLAR_FONT_T14
        tempView.textColor = STELLAR_COLOR_C6
        addSubview(tempView)
        return tempView
    }()
}