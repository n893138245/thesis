import UIKit
class VitalSignsView: UIView {
    private let disposeBag = DisposeBag()
    var isOpenRealTime = false
    var clickBlock: (() ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRx()
        setupUI()
    }
    private func setupRx() {
        startButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.clickBlock?()
            }).disposed(by: disposeBag)
    }
    private func setupUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            $0.top.bottom.equalTo(self)
        }
        addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalTo(bgView).offset(17)
            $0.top.equalTo(bgView).offset(20)
        }
        addSubview(mDetailLabel)
        mDetailLabel.snp.makeConstraints {
            $0.top.equalTo(bgView).offset(54)
            $0.left.equalTo(bgView).offset(17)
        }
        addSubview(statusBgView)
        addSubview(mStatusLabel)
        statusBgView.snp.makeConstraints {
            $0.left.equalTo(mStatusLabel).offset(-13)
            $0.right.equalTo(mStatusLabel).offset(13)
            $0.height.equalTo(24)
            $0.top.equalTo(mDetailLabel.snp.bottom).offset(13)
        }
        mStatusLabel.snp.makeConstraints {
            $0.left.equalTo(bgView).offset(30).offset(30)
            $0.top.equalTo(mDetailLabel.snp.bottom).offset(17)
        }
        addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.centerY.equalTo(mTitleLabel)
            $0.right.equalTo(bgView).offset(-30)
            $0.width.height.equalTo(44)
        }
        addSubview(mStatusTitleLabel)
        mStatusTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(startButton)
            $0.centerY.equalTo(mDetailLabel)
        }
    }
    func showStatus(isNormal: Bool) {
        updateLocalTime() 
        if isNormal {
            mStatusLabel.text = "正常"
            statusBgView.backgroundColor = STELLAR_COLOR_C10
        }else {
            mStatusLabel.text = "未检测到"
            statusBgView.backgroundColor = STELLAR_COLOR_C2
        }
    }
    func showNormalState() {
        mDetailLabel.textColor = STELLAR_COLOR_C6
        mStatusTitleLabel.textColor = STELLAR_COLOR_C6
        startButton.setImage(UIImage(named: "btn_ssjc_on"), for: .normal)
        isOpenRealTime = false
    }
    func showRealTimeState() {
        mDetailLabel.textColor = STELLAR_COLOR_C1
        mStatusTitleLabel.textColor = STELLAR_COLOR_C1
        startButton.setImage(UIImage(named: "btn_ssjc_off"), for: .normal)
        isOpenRealTime = true
    }
    func showLoading() {
        startButton.ss.startActivityIndicator()
    }
    func stopLoading() {
        startButton.ss.stopActivityIndicator()
    }
    func updateLocalTime() {
        let color = isOpenRealTime ? STELLAR_COLOR_C1 : STELLAR_COLOR_C6
        let textStyle = Style {
            $0.font = STELLAR_FONT_T12
            $0.color = color
        }
        let timeStyle = Style {
            $0.font = STELLAR_FONT_NUMBER_T12
            $0.color = color
        }
        let text = isOpenRealTime ? "实时监测" : "上次监测"
        mDetailLabel.attributedText = text.set(style: textStyle) + getCurrentTime().set(style: timeStyle)
    }
    private lazy var bgView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C9
        tempView.layer.cornerRadius = 8
        tempView.clipsToBounds = true
        return tempView
    }()
    lazy var statusBgView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C2
        tempView.layer.cornerRadius = 3
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var mTitleLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "生命体征"
        tempView.font = STELLAR_FONT_MEDIUM_T18
        tempView.textColor = STELLAR_COLOR_C4
        return tempView
    }()
    lazy var mDetailLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "上次监测 暂无时间信息"
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C6
        return tempView
    }()
    lazy var mStatusLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "未检测到"
        tempView.font = STELLAR_FONT_MEDIUM_T13
        tempView.textColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var mStatusTitleLabel: UILabel = {
        let tempView = UILabel()
        tempView.text = "实时监测"
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C6
        return tempView
    }()
    lazy var startButton: UIButton = {
        let tempView = UIButton(type: .custom)
        tempView.setImage(UIImage(named: "btn_ssjc_on"), for: .normal)
        return tempView
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}