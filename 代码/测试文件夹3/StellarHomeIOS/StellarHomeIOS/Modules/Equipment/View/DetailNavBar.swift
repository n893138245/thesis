import UIKit
class DetailNavBar: UIView {
    let disposeBag = DisposeBag()
    var leftBlock: (() ->Void)?
    var rightBlock: (() ->Void)?
    enum barStyle {
        case whiteStyle
        case defaultStyle
    }
    var style: barStyle = .defaultStyle {
        didSet {
            self.setupStyle()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(moreButton)
        setupUI()
        setupActions()
    }
    private func setupUI() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self.snp.bottom).offset(-9)
            $0.width.equalTo(kScreenWidth - 44*2)
        }
        backButton.snp.makeConstraints {
            $0.left.equalTo(self.snp.left)
            $0.centerY.equalTo(self.snp.bottom).offset(-21)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        moreButton.snp.makeConstraints {
            $0.right.equalTo(self.snp.right).offset(-11)
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
    }
    private func setupActions() {
        backButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.leftBlock != nil{
                self?.leftBlock!()
            }
        }).disposed(by: disposeBag)
        moreButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.rightBlock != nil{
                self?.rightBlock!()
            }
        }).disposed(by: disposeBag)
    }
    private func setupStyle() {
        switch style {
        case .defaultStyle:
            backButton.setImage(UIImage(named: "bar_icon_back"), for: .normal)
            moreButton.setImage(UIImage(named: "icon_device_details_black"), for: .normal)
            titleLabel.textColor = STELLAR_COLOR_C4
        case .whiteStyle:
            backButton.setImage(UIImage(named: "bar_icon_white"), for: .normal)
            moreButton.setImage(UIImage(named: "icon_device_details_white"), for: .normal)
            titleLabel.textColor = STELLAR_COLOR_C3
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var backButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "bar_icon_back"), for: .normal)
        return tempView
    }()
    lazy var moreButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "icon_device_details_black"), for: .normal)
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C3
        tempView.font = STELLAR_FONT_MEDIUM_T18
        tempView.textAlignment = .center
        return tempView
    }()
}