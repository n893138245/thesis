import UIKit
class TrajectoryView: UIView {
    private let disposeBag = DisposeBag()
    var isOpeningRealTime = false
    var clickStartBlock: (() ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRx()
        setupUI()
    }
    private func setupRx() {
        switchButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.clickStartBlock?()
            }).disposed(by: disposeBag)
    }
    private func setupUI() {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            $0.top.bottom.equalTo(self)
        }
        addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(17)
            $0.top.equalTo(contentView).offset(20)
        }
        addSubview(lastTimeLabel)
        lastTimeLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(54)
            $0.left.equalTo(contentView).offset(17)
        }
        addSubview(switchButton)
        switchButton.snp.makeConstraints {
            $0.centerY.equalTo(topTitleLabel)
            $0.right.equalTo(contentView).offset(-30)
            $0.width.height.equalTo(44)
        }
        addSubview(statusTitleLabel)
        statusTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(switchButton)
            $0.centerY.equalTo(lastTimeLabel)
        }
        addSubview(bgImage)
        bgImage.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(self).offset(83)
            $0.height.equalTo(226)
            $0.width.equalTo(357)
        }
        addSubview(radisView) 
        bringSubviewToFront(switchButton)
    }
    func openRealTimeMode() {
        isOpeningRealTime = true
        lastTimeLabel.textColor = STELLAR_COLOR_C1
        statusTitleLabel.textColor = STELLAR_COLOR_C1
        switchButton.setImage(UIImage(named: "btn_ssjc_off"), for: .normal)
        showRealTimeStatus()
    }
    func showNormalMode() {
        isOpeningRealTime = false
        lastTimeLabel.textColor = STELLAR_COLOR_C6
        statusTitleLabel.textColor = STELLAR_COLOR_C6
        switchButton.setImage(UIImage(named: "btn_ssjc_on"), for: .normal)
        showNormalStatus()
    }
    func addNormalPointViews(locations: [RadarLocationInfo]) {
        updateTime()
        radisView.addPointViews(locations: locations)
    }
    func addAnimationPoints(locations: [RadarLocationInfo]) {
        updateTime() 
        radisView.addAnimationPoints(locations: locations)
    }
    func showRealTimeStatus() {
        radisView.startAnimations()
    }
    func showNormalStatus() {
        radisView.stopAnimations()
    }
    func startLoading() {
        switchButton.ss.startActivityIndicator()
    }
    func stopLoading() {
        switchButton.ss.stopActivityIndicator()
    }
    func updateTime() {
        let textColor = isOpeningRealTime ? STELLAR_COLOR_C1 : STELLAR_COLOR_C6
        let textStyle = Style {
            $0.font = STELLAR_FONT_T12
            $0.color = textColor
        }
        let timeStyle = Style {
            $0.font = STELLAR_FONT_NUMBER_T12
            $0.color = textColor
        }
        let text = "上次监测"
        lastTimeLabel.attributedText = text.set(style: textStyle) + getCurrentTime().set(style: timeStyle)
    }
    private lazy var radisView: PositionView = {
        let tempView = PositionView.init(frame: CGRect(x: (kScreenWidth - 172) / 2, y: 108, width: 172, height: 172))
        return tempView
    }()
    private lazy var contentView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C9
        tempView.layer.cornerRadius = 8
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var topTitleLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "运动轨迹"
        tempView.font = STELLAR_FONT_MEDIUM_T18
        tempView.textColor = STELLAR_COLOR_C4
        return tempView
    }()
    lazy var lastTimeLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "上次监测 暂无时间信息"
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C6
        return tempView
    }()
    lazy var statusTitleLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "实时监测"
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C6
        return tempView
    }()
    lazy var switchButton: UIButton = {
        let tempView = UIButton(type: .custom)
        tempView.setImage(UIImage(named: "btn_ssjc_on"), for: .normal)
        return tempView
    }()
    lazy var bgImage: UIImageView = {
        let tempView = UIImageView(image: UIImage(named: "ydgj_bg_round"))
        tempView.contentMode = .scaleToFill
        return tempView
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}