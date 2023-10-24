import UIKit
import Alamofire
private enum FirmwareUpgradState {
    case kNoNewVersion 
    case kHaveNewVersion 
    case kUpgradingVersion 
    case kInstalling 
    case kUpgradeFailed
    case kUpgradeSuccess 
}
class FirmwareUpgradingViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var hasNewVersion: UILabel!
    @IBOutlet weak var newVersionLabel: UILabel!
    @IBOutlet weak var newVersionDetailLabel: UILabel!
    @IBOutlet weak var newVersionLabelBgView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var upgradeResultView: UIView!
    @IBOutlet weak var resultTitleLable: UILabel!
    @IBOutlet weak var resultDetailLabel: UILabel!
    @IBOutlet weak var resultIcon: UIImageView!
    @IBOutlet weak var upgradingTitleLabel: UILabel!
    @IBOutlet weak var upgradingDetailLabel: UILabel!
    @IBOutlet weak var noNewVersionLabel: UILabel!
    var device: BasicDeviceModel?
    var upgradeModel: UpgradeDeviceModel?
    private var firmBinData: Data?
    private var isBleConnected = true 
    private var timeTask: SSTimeTask?
    private var myState: FirmwareUpgradState = .kNoNewVersion {
        didSet {
            setupState(state: myState)
        }
    }
    var upgradeSuccessBlock: (()->Void)?
    private func setupState(state:FirmwareUpgradState) {
        switch state {
        case .kHaveNewVersion:
            clickButton.isHidden = false
            clickButton.setTitle(StellarLocalizedString("EQUIPMENT_UPDATE"), for: .normal)
            noNewVersionLabel.isHidden = true
            progressView.isHidden = true
            upgradeResultView.isHidden = true
            upgradingTitleLabel.isHidden = true
            upgradingDetailLabel.isHidden = true
            newVersionLabel.isHidden = false
            newVersionLabelBgView.isHidden = false
            newVersionDetailLabel.isHidden = false
            hasNewVersion.isHidden = false
            break
        case .kNoNewVersion:
            clickButton.isHidden = false
            clickButton.setTitle(StellarLocalizedString("EQUIPMENT_BACK"), for: .normal)
            noNewVersionLabel.isHidden = false
            progressView.isHidden = true
            upgradeResultView.isHidden = true
            upgradingTitleLabel.isHidden = true
            upgradingDetailLabel.isHidden = true
            newVersionLabel.isHidden = true
            newVersionLabelBgView.isHidden = true
            newVersionDetailLabel.isHidden = true
            hasNewVersion.isHidden = true
            break
        case .kUpgradingVersion:
            clickButton.isHidden = true
            noNewVersionLabel.isHidden = true
            progressView.isHidden = false
            upgradeResultView.isHidden = true
            upgradingTitleLabel.isHidden = false
            upgradingDetailLabel.isHidden = false
            upgradingTitleLabel.text = StellarLocalizedString("EQUIPMENT_UPDATING")
            upgradingDetailLabel.text = StellarLocalizedString("EQUIPMENT_UPDATING_TIP")
            newVersionLabel.isHidden = true
            newVersionLabelBgView.isHidden = true
            newVersionDetailLabel.isHidden = true
            hasNewVersion.isHidden = true
            break
        case .kInstalling:
            clickButton.isHidden = true
            noNewVersionLabel.isHidden = true
            progressView.isHidden = false
            upgradeResultView.isHidden = true
            upgradingTitleLabel.isHidden = false
            upgradingDetailLabel.isHidden = false
            upgradingTitleLabel.text = StellarLocalizedString("EQUIPMENT_INSTALLING")
            upgradingDetailLabel.text = StellarLocalizedString("EQUIPMENT_INSTALLING_TIP")
            newVersionLabel.isHidden = true
            newVersionLabelBgView.isHidden = true
            newVersionDetailLabel.isHidden = true
            hasNewVersion.isHidden = true
            break
        case .kUpgradeSuccess:
            clickButton.isHidden = false
            clickButton.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
            noNewVersionLabel.isHidden = true
            progressView.isHidden = true
            upgradeResultView.isHidden = false
            upgradingTitleLabel.isHidden = true
            upgradingDetailLabel.isHidden = true
            resultTitleLable.text = StellarLocalizedString("EQUIPMENT_UPDATE_SUCCESS")
            resultDetailLabel.text = StellarLocalizedString("EQUIPMENT_UPDATE_SUCCESS_TIP") 
            resultDetailLabel.textColor = STELLAR_COLOR_C7
            resultDetailLabel.font = STELLAR_FONT_T14
            resultIcon.image = UIImage(named: "icon_add_success_small")
            newVersionLabel.isHidden = true
            newVersionLabelBgView.isHidden = true
            newVersionDetailLabel.isHidden = true
            hasNewVersion.isHidden = true
            break
        case .kUpgradeFailed:
            clickButton.isHidden = false
            clickButton.setTitle(StellarLocalizedString("EQUIPMENT_RETRY"), for: .normal)
            noNewVersionLabel.isHidden = true
            progressView.isHidden = true
            upgradeResultView.isHidden = false
            upgradingTitleLabel.isHidden = true
            upgradingDetailLabel.isHidden = true
            resultTitleLable.text = StellarLocalizedString("EQUIPMENT_UPDATE_FAIL")
            resultDetailLabel.text = StellarLocalizedString("EQUIPMENT_UPDATE_FAIL_TIP")
            resultDetailLabel.textColor = STELLAR_COLOR_C4
            resultDetailLabel.font = STELLAR_FONT_T14
            resultIcon.image = UIImage(named: "icon_add_failure_small")
            newVersionLabel.isHidden = true
            newVersionLabelBgView.isHidden = true
            newVersionDetailLabel.isHidden = true
            hasNewVersion.isHidden = true
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    private func setupViews(){
        fd_interactivePopDisabled = true
        view.insertSubview(topBgView, at: 0)
        let layer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#1E55B7").cgColor,STELLAR_COLOR_C1.cgColor])
        layer.frame = topBgView.bounds
        topBgView.layer.insertSublayer(layer, at: 0)
        titleLabel.font = STELLAR_FONT_BOLD_T18
        titleLabel.textColor = STELLAR_COLOR_C3
        titleLabel.text = StellarLocalizedString("EQUIPMENT_FIMWARE_VERSION")
        currentVersionLabel.font = STELLAR_FONT_T14
        currentVersionLabel.textColor = STELLAR_COLOR_C3
        currentVersionLabel.alpha = 0.6
        currentVersionLabel.text = "\(StellarLocalizedString("EQUIPMENT_CURRENT_VERSION")) \(String.ss.trasformToHexVersion(versionNum: device?.swVersion ?? 0))"
        hasNewVersion.font = STELLAR_FONT_BOLD_T14
        hasNewVersion.textColor = STELLAR_COLOR_C3
        hasNewVersion.text = StellarLocalizedString("EQUIPMENT_HAVE_NEW_VERSION")
        noNewVersionLabel.text = StellarLocalizedString("EQUIPMENT_UPDATE_SUCCESS_TIP")
        let newVersionrAttributes1 = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C4,NSAttributedString.Key.font:STELLAR_FONT_BOLD_T20]
        let newVersionrString1 = "\(StellarLocalizedString("EQUIPMENT_NEW_VERSION_CONTENT"))    "
        let newVersionrAttributeString = NSMutableAttributedString.init(string: newVersionrString1, attributes: newVersionrAttributes1)
        let newVersionrAttributes2 = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C4,NSAttributedString.Key.font:STELLAR_FONT_NUMBER_T16]
        var newVersionrString2 = "\(String.ss.trasformToHexVersion(versionNum: upgradeModel?.newVersion ?? 0))"
        if device?.remoteType != .locally {
            newVersionrString2 = "\(String.ss.trasformToHexVersion(versionNum: device?.latestSwVersion ?? 0))"
        }
        newVersionrAttributeString.append(NSMutableAttributedString.init(string: newVersionrString2, attributes: newVersionrAttributes2))
        newVersionLabel.attributedText = newVersionrAttributeString
        progressView.progress = 0
        progressView.progressTintColor = STELLAR_COLOR_C1
        progressView.trackTintColor = STELLAR_COLOR_C9
        clickButton.titleLabel?.font = STELLAR_FONT_T17
        clickButton.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        noNewVersionLabel.textColor = STELLAR_COLOR_C6
        noNewVersionLabel.font = STELLAR_FONT_T14
        upgradingTitleLabel.textColor = STELLAR_COLOR_C4
        upgradingTitleLabel.font = STELLAR_FONT_MEDIUM_T18
        upgradingDetailLabel.textColor = STELLAR_COLOR_C2
        upgradingDetailLabel.font = STELLAR_FONT_T14
        resultTitleLable.textColor = STELLAR_COLOR_C4
        resultTitleLable.font = STELLAR_FONT_MEDIUM_T18
        resultDetailLabel.textColor = STELLAR_COLOR_C7
        resultDetailLabel.font = STELLAR_FONT_T14
    }
    private func setNewVerionDetails(details: String) {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 13
        let newVersionDetailAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C5,NSAttributedString.Key.font:STELLAR_FONT_T15,NSAttributedString.Key.paragraphStyle: paraph]
        let newVersionDetailString = details
        let newVersionDetailAttributeString = NSAttributedString.init(string: newVersionDetailString, attributes: newVersionDetailAttributes)
        newVersionDetailLabel.attributedText = newVersionDetailAttributeString
    }
    private func setupData() {
        if device?.remoteType == .locally {
            checkBleNewVersion()
        }else {
            checkNormalDeviceNewVersion()
        }
        if device?.remoteType == .locally { 
            NotificationCenter.default.rx.notification(kBlueToothCentralLightOffLineNotification)
                .subscribe(onNext: { [weak self] (notify) in
                    self?.isBleConnected = false
                }).disposed(by: disposeBag)
        }else if device?.remoteType == .directly && device?.type == .light {
            NotificationCenter.default.rx.notification(.NOTIFY_UPGRADEPROGRESS)
                .subscribe(onNext: { [weak self] (notify) in
                    guard let dic = notify.userInfo as? [String: Any] else {
                        return
                    }
                    guard let sn = dic["sn"] as? String else {
                        return
                    }
                    if self?.device?.sn != sn {
                        return
                    }
                    guard let progress = dic["upgradeProgress"] as? Int else {
                        return
                    }
                    self?.progressView.progress = Float(progress) * 0.01
                    if progress >= 95 {
                        self?.myState = .kInstalling
                    }
                }).disposed(by: disposeBag)
        }
        NotificationCenter.default.rx.notification(.NOTIFY_STATUS_UPDATED)
            .subscribe({ [weak self] (notify) in
                let info = notify.element?.userInfo
                guard let model = info?["deviceState"] as? BasicDeviceModel else {
                    return
                }
                if model.sn != self?.device?.sn {
                    return
                }
                if model.swVersion == self?.upgradeModel?.newVersion { 
                    self?.normalDeviceUpgradeSuccess(model: model)
                }
            }).disposed(by:disposeBag)
    }
    private func normalDeviceUpgradeSuccess(model: BasicDeviceModel) {
        timerStop()
        myState = .kInstalling
        UIView.animate(withDuration: 0.5, animations: {
            self.progressView.progress = 1.0
        }) { (_) in
            self.myState = .kUpgradeSuccess
            self.currentVersionLabel.text = "\(StellarLocalizedString("EQUIPMENT_CURRENT_VERSION")) \(String.ss.trasformToHexVersion(versionNum: model.swVersion))"
            self.device?.swVersion = model.swVersion
            self.upgradeSuccessBlock?()
        }
    }
    private func checkBleNewVersion() {
        if let model = upgradeModel {
            if device?.swVersion != model.newVersion {
                setNewVerionDetails(details: model.descriptionZhs)
                myState = .kHaveNewVersion
            }else {
                myState = .kNoNewVersion
            }
        }
    }
    private func checkNormalDeviceNewVersion() {
        if let lastVersion = device?.latestSwVersion,lastVersion != device?.swVersion {
            myState = .kHaveNewVersion
            setNewVerionDetails(details: upgradeModel?.descriptionZhs ?? "")
        }else {
            myState = .kNoNewVersion
        }
    }
    @IBAction func clickAction(_ sender: Any) {
        switch myState {
        case .kNoNewVersion:
            pop()
            break
        case .kHaveNewVersion:
            clickNewVersion()
            break
        case .kUpgradeFailed:
            clickUpgradeFailure()
            break
        case .kUpgradeSuccess:
            pop()
            break
        default:
            break
        }
    }
    private func pop() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func backAction(_ sender: Any) {
        if myState == .kUpgradingVersion || myState == .kInstalling {
            let alert = StellarMineAlertView.init(title: StellarLocalizedString("EQUIPMENT_REM"), message: StellarLocalizedString("EQUIPMENT_REM_CONTENT"), leftTitle: StellarLocalizedString("MINE_INFO_CONFIRM_LOGOUT"), rightTitle: StellarLocalizedString("COMMON_CANCEL"), contentTip: nil)
            alert.show()
            alert.leftClickBlock = { [weak self] in
                self?.pop()
            }
        }else {
            pop()
        }
    }
    private func clickNewVersion() {
        if device?.remoteType == .locally {
            netDownloadFirmware()
        }else {
            netNormalDeviceStartUpgrade()
        }
    }
    private func netNormalDeviceStartUpgrade() {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().start_upgrade(sn: device?.sn ?? "", latestSwVersion: device?.latestSwVersion ?? 0, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let response = jsonDic.kj.model(CommonResponseModel.self)
            if response.code != 0 {
                self.myState = .kUpgradeFailed
                self.timerStop()
            }else {
                self.myState = .kUpgradingVersion
                var timeOut = 20
                if self.device?.type == .hub {
                    timeOut = 120
                }else if self.device?.remoteType == .directly && self.device?.type == .light { 
                    timeOut = 180
                }
                self.timerStart(timeOut: timeOut)
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            self.myState = .kUpgradeFailed
        }
    }
    private func clickUpgradeFailure() {
        if device?.remoteType == .locally {
            if self.firmBinData != nil {
                progressView.progress = 0.4
                sendDataToDevice()
            }else {
                progressView.progress = 0
                netDownloadFirmware()
            }
        }else {
            progressView.progress = 0
            netNormalDeviceStartUpgrade()
        }
    }
    private func netDownloadFirmware() {
        self.myState = .kUpgradingVersion
        UpgradeManager.shared.removeData()
        UpgradeManager.shared.dowloadData(url: upgradeModel?.profiles.first?.url ?? "", responseBlock: { (data) in
            if data.md5().toHexString() == self.upgradeModel?.profiles.first?.md5 { 
                self.firmBinData = data
                self.sendDataToDevice()
            }else {
                self.myState = .kUpgradeFailed
            }
        }, errorBlock: {
            self.myState = .kUpgradeFailed
        }) { (progress) in
            self.progressView.progress = Float(progress*0.4)
        }
    }
    private func sendDataToDevice() {
        guard let light = device as? LightModel else { return  }
        StellarHomeBleManger.sharedManager.begainBLEFirmwareUpgrade(light: light, upgradeSwVersion: upgradeModel?.newVersion ?? -1, data: self.firmBinData ?? Data()) { [weak self] (state,per) in
            self?.receiveSendResult(state: state, progress: Float(per))
        }
    }
    private func receiveSendResult(state: BLEFirmwareUpgradeState,progress: Float) {
        if state == .kStateUpgradeSuccess { 
            self.myState = .kInstalling 
            DispatchQueue.main.asyncAfter(deadline: .now()+5) { 
                self.reConnectLight { (success) in
                    if success {
                        self.queryNewVerSion()
                    }else {
                        self.myState = .kUpgradeFailed
                    }
                }
            }
        }else if state == .kStateUpgradeFail {
            self.myState = .kUpgradeFailed
        }
        if progress > 0 {
            self.progressView.progress = progress*0.4 + 0.4
        }
    }
    private func reConnectLight(completion: ((_ isSucess: Bool)->Void)?) {
        guard let light = self.device as? LightModel else { return }
        StellarHomeBleManger.sharedManager.connectToLight(lightModel: light) { (_, success) in
            if success { 
                NotificationCenter.default.post(name: .NOTIFY_BLE_RECONNECTED, object: nil)
                self.isBleConnected = true
            }
            completion?(success)
        }
    }
    private func queryNewVerSion() {
        if device?.remoteType == .locally {
            bleDeviceQueryNewVersion()
        }else {
            normalDeviceQueryNewVersion()
        }
    }
    private func bleDeviceQueryNewVersion() {
        guard let light = self.device as? LightModel else { return }
        StellarHomeBleManger.sharedManager.queryInfoLight(light: light) { (success, model) in
            if model.swVersion == self.upgradeModel?.newVersion { 
                self.progressView.progress = 1.0
                self.myState = .kUpgradeSuccess
                self.currentVersionLabel.text = "\(StellarLocalizedString("EQUIPMENT_CURRENT_VERSION")) \(String.ss.trasformToHexVersion(versionNum: model.swVersion))"
                self.device?.swVersion = model.swVersion
                self.upgradeSuccessBlock?()
            }else { 
                self.myState = .kUpgradeFailed
            }
        }
    }
    private func normalDeviceQueryNewVersion() {
        DevicesStore.sharedStore().getSingleDeviceInfo(sn: device?.sn ?? "", success: { (jsonDic) in
            let model = jsonDic.kj.model(BasicDeviceModel.self)
            if model.latestSwVersion == model.swVersion {
                self.myState = .kUpgradeSuccess
                self.currentVersionLabel.text = "\(StellarLocalizedString("EQUIPMENT_CURRENT_VERSION")) \(String.ss.trasformToHexVersion(versionNum: model.swVersion))"
                self.device?.swVersion = model.swVersion
                self.upgradeSuccessBlock?()
            }else {
                self.myState = .kUpgradeFailed
            }
        }) { (error) in
            self.myState = .kUpgradeFailed
        }
    }
    private func timerStart(timeOut: Int) {
        timerStop()
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            if self?.device?.remoteType == .directly && self?.device?.type == .light { 
                if task.repeatCount >= timeOut - 1 {
                    self?.myState = .kInstalling
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.timerStop()
                        self?.queryNewVerSion()
                    }
                }
                return
            }
            if task.repeatCount >= timeOut {
                self?.timerStop()
            }else {
                self?.checkInstall(repeatCount: task.repeatCount, timeOut: timeOut)
                self?.progressView.progress += 1.0/Float(timeOut)
            }
        }
    }
    private func checkInstall(repeatCount: Int, timeOut: Int) {
        if repeatCount == timeOut - 2 {
            myState = .kInstalling
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.queryNewVerSion()
            }
        }
    }
    private func timerStop() {
        if let task = timeTask {
            SSTimeManager.shared.removeTask(task: task)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    private lazy var topBgView: UIView = {
        let tempView = UIView()
        let height: CGFloat = 242 + getAllVersionSafeAreaTopHeight()
        tempView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
        return tempView
    }()
}