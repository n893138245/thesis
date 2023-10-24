import UIKit
class CommonGuideViewController: AddDeviceBaseViewController {
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel()
    var gateWayModel: GatewayModel?
    var fwType:Int  = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupStyle()
        setupRx()
    }
    private func setupUI() {
        cardView.snp.makeConstraints {
            $0.bottom.equalTo(self.view).offset(-64.fit - getAllVersionSafeAreaBottomHeight())
            $0.top.equalTo(navBar.snp.bottom).offset(10.fit)
            $0.left.equalTo(self.view).offset(9.fit)
            $0.right.equalTo(self.view).offset(-9.fit)
        }
        cardView.addSubview(placeholderPic)
        cardView.addSubview(fristTipLabel)
        cardView.addSubview(secondTipLabel)
        fristTipLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.cardView.snp.top).offset(46.fit)
        }
        secondTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(fristTipLabel.snp.bottom).offset(6.fit)
        }
        secondTipLabel.textColor = STELLAR_COLOR_C6
        secondTipLabel.numberOfLines = 0
        placeholderPic.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(240.fit)
        }
        placeholderPic.contentMode = .scaleAspectFill
        view.addSubview(needHelpButton)
        needHelpButton.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(self.cardView.snp.bottom).offset(22.fit)
        }
        cardView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.cardView.snp.bottom).offset(-40.fit)
            $0.left.equalTo(self.cardView.snp.left).offset(33.fit)
            $0.right.equalTo(self.cardView.snp.right).offset(-33.fit)
            $0.height.equalTo(46.fit)
        }
    }
    private func setupRx() {
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        navBar.exitButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        needHelpButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                if self?.deviceDetailModel.type == .hub {
                    let vc = CommonReSetViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else {
                    if self?.deviceDetailModel.type == .panel {
                        jumpTo(url: StellarHomeResourceUrl.sansi_io + "how_to_use_app/add_mesh_panels/")
                    }else if self?.deviceDetailModel.type == .light || self?.deviceDetailModel.type == .mainLight {
                        jumpTo(url: StellarHomeResourceUrl.sansi_io + "how_to_use_app/add_mesh_bulbs/")
                    }
                }
            }).disposed(by: disposeBag)
        confirmButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                if self?.deviceDetailModel.type == .hub && !DUIBleGatewayManager.sharedManager.isOpenBlueTooth() {
                    self?.bleTipView.showView()
                } else {
                    let vc = SearchDeviceViewController()
                    vc.deviceDetailModel = self?.deviceDetailModel ?? AddDeviceDetailModel()
                    if self?.deviceDetailModel.type != .hub {
                        vc.belongGateWayModel = self?.gateWayModel
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    private func setupStyle(){
        if deviceDetailModel.type == .light || deviceDetailModel.type == .mainLight { 
            navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_BULBLIGHT")
            navBar.exitButton.isHidden = true
        }else if deviceDetailModel.type == .panel{
            navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_PANEL")
            fristTipLabel.text = StellarLocalizedString("ADD_DEVICE_PANEL_GUIDE_TIP")
            secondTipLabel.text = StellarLocalizedString("ADD_DEVICE_PANEL_GUIDE_TIP_DETAIL")
            confirmButton.setTitle(StellarLocalizedString("ADD_DEVICE_PANEL_GUIDE_BUTTON_TITLE"), for: .normal)
            confirmButton.setTitle(StellarLocalizedString("ADD_DEVICE_PANEL_GUIDE_BUTTON_TITLE"), for: .highlighted)
            navBar.exitButton.isHidden = true
            setupPanelImage(pFwType: deviceDetailModel.fwType ?? 0)
        }else if deviceDetailModel.type == .hub{
            navBar.titleLabel.text = StellarLocalizedString("GATEWAY_CONNECT")
            placeholderPic.image = UIImage(named: "wangguan")
            navBar.exitButton.isHidden = true
            fristTipLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_TIP")
            secondTipLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_TIP_DETAIL")
            confirmButton.setTitle(StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_BUTTON_TITLE"), for: .normal)
            confirmButton.setTitle(StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_BUTTON_TITLE"), for: .highlighted)
            needHelpButton.setTitle("\(StellarLocalizedString("ADD_DEVICE_GATEWAY_GUIDE_HELP_TITLE")+"?")", for: .normal)
            secondTipLabel.textColor = STELLAR_COLOR_C1
            DUIBleGatewayManager.sharedManager.open()
        }
    }
    private func setupPanelImage(pFwType: Int) {
        let url = URL(string: getDeviceLargeIconBy(fwType: pFwType))
        placeholderPic.kf.setImage(with: url)
        var fingerX: CGFloat = 0
        switch pFwType {
        case 1:
            fingerX = 111.fit
        case 2:
            fingerX = 81.fit
        case 3:
            fingerX = 59.fit
        case 4:
            fingerX = 68.fit
        default:
            break
        }
        placeholderPic.addSubview(fingerImage)
        fingerImage.frame = CGRect(x: fingerX, y: 189.fit, width: 65.fit, height: 60.fit)
        fristTipLabel.addSubview(grayPoint)
        grayPoint.frame = CGRect(x: 55, y: 8, width: 11, height: 11)
    }
    private lazy var placeholderPic: UIImageView = {
        let tempView = UIImageView.init()
        return tempView
    }()
    private lazy var fristTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_MEDIUM_T20
        return tempView
    }()
    private lazy var secondTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T14
        return tempView
    }()
    private lazy var confirmButton: UIButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 0, y: 0, width: 291.fit, height: 46.fit))
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_MAKESURE_LIGHTING"), for: .normal)
        tempView.style = .border
        return tempView
    }()
    private lazy var needHelpButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_NEED_HELP"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T13
        return tempView
    }()
    private lazy var fingerImage: UIImageView = {
        let tempView = UIImageView.init()
        tempView.contentMode = .scaleAspectFit
        tempView.image = UIImage(named: "finger")
        return tempView
    }()
    private lazy var grayPoint: UIView = {
        let tempView = UIView.init()
        tempView.layer.cornerRadius = 5.5
        tempView.backgroundColor = STELLAR_COLOR_C7
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var bleTipView:StellarImageTitleAlertView = {
        let alertView = StellarImageTitleAlertView.stellarImageTitleAlertView()
        alertView.setImageContentType(content: StellarLocalizedString("ALERT_NEED_OPEN_BLE"), leftClickString: StellarLocalizedString("COMMON_FINE"), rightClickString: StellarLocalizedString("ALERT_TO_SETUP"), image: UIImage.init(named: "icon_bluetooth"))
        alertView.rightButtonBlock = {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)! , options: [:], completionHandler: nil)
        }
        self.view.addSubview(alertView)
        return alertView
    }()
}