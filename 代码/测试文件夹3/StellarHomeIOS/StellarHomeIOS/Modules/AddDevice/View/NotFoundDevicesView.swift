import UIKit
class NotFoundDevicesView: UIView {
    let disposeBag = DisposeBag()
    var reSetBlock: (() -> Void)?
    var searchAginBlock: (() -> Void)?
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel(){
        didSet{
            if deviceDetailModel.connection == .ble && deviceDetailModel.type == DeviceType.light {
                reSetBtn.setTitle(StellarLocalizedString("ALERT_SURE_ELECTRICITY"), for: .normal)
                reSetBtn.setTitleColor(STELLAR_COLOR_C6, for: .normal)
                reSetBtn.titleLabel?.font = STELLAR_FONT_T16
            }
            if deviceDetailModel.type == .panel {
                reSetBtn.isHidden = true
            }
            if deviceDetailModel.type == .hub  {
                firstTipLabel.text = StellarLocalizedString("ALERT_NO_SEARCH_GATEWAY")
            }else {
                firstTipLabel.text = StellarLocalizedString("ALERT_NO_SEARCH_DEVICE")
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        layer.cornerRadius = 12.fit
        clipsToBounds = true
        backgroundColor = STELLAR_COLOR_C3
        addSubview(firstTipLabel)
        placeholderPic.snp.makeConstraints {
            $0.top.equalTo(self).offset(121.fit)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.equalTo(158.fit)
            $0.width.equalTo(142.fit)
        }
        firstTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(placeholderPic.snp.bottom).offset(46.fit)
        }
        addSubview(bottomBtn)
        addSubview(reSetBtn)
        bottomBtn.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.width.equalTo(291.fit)
            $0.bottom.equalTo(self).offset(-32.fit)
            $0.height.equalTo(46.fit)
        }
        reSetBtn.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(bottomBtn.snp.top).offset(-24.fit)
        }
    }
    private func setupActions() {
        bottomBtn.rx.tap.subscribe(onNext:{ [weak self] in
            if let block = self?.searchAginBlock {
                block()
            }
        }).disposed(by: disposeBag)
        reSetBtn.rx.tap.subscribe(onNext:{ [weak self] in
            if let block = self?.reSetBlock {
                block()
            }
        }).disposed(by: disposeBag)
    }
    private lazy var placeholderPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "nogateway")
        tempView.contentMode = .scaleToFill
        addSubview(tempView)
        return tempView
    }()
    private lazy var firstTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_T18
        return tempView
    }()
    private lazy var reSetBtn: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font = STELLAR_FONT_T16
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        tempView.setTitle(StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_HELP_TITLE") + "?", for: .normal)
        return tempView
    }()
    private lazy var bottomBtn: StellarButton = {
        let tempView = StellarButton()
        tempView.style = .normal
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T15
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_SEARCH_AGAIN"), for: .normal)
        return tempView
    }()
}