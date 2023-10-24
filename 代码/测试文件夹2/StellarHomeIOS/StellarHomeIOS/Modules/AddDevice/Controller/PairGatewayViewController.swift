import UIKit
class PairGatewayViewController: AddDeviceBaseViewController {
    var myDeviceType:DeviceType = .unknown
    var networkInfo = Dictionary<String, String>()
    var bleEquipmentModel:BleEquipmentModel?
    var pairDevice = BasicDeviceModel()
    var belongGatewayModel = GatewayModel()
    private var timeTask:SSTimeTask?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animatePic.stopAnimating()
        SSTimeManager.shared.removeTask(task: timeTask!)
        DevicesStore.sharedStore().unsubscribeNoGatewaySearchDevice(sn: DUIBleGatewayManager.sharedManager.addingHubsn)
        DUIBleGatewayManager.sharedManager.addingHubsn = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDatas()
    }
    private func setupUI() {
        animatePic.snp.makeConstraints {
            $0.top.equalTo(self.cardView).offset(106.fit)
            $0.height.equalTo(164.fit)
            $0.width.equalTo(220.fit)
            $0.centerX.equalTo(self.view)
        }
        topTipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(animatePic.snp.bottom).offset(24.fit)
        }
        tipContentLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(topTipLabel.snp.bottom).offset(8.fit)
        }
        view.addSubview(bottomProgress)
        bottomProgress.snp.makeConstraints {
            $0.top.equalTo(tipContentLabel.snp.bottom).offset(20.fit)
            $0.centerX.equalTo(view)
            $0.width.equalTo(195.fit)
        }
        navBar.backButton.isHidden = true
        animatePic.startAnimating()
        setupViews()
        navBar.exitButton.isHidden = true
    }
    private func setupViews(){
        if myDeviceType == .hub {
            navBar.titleLabel.text = StellarLocalizedString("GATEWAY_CONNECT")
            let ssid = networkInfo["ssid"] ?? ""
            let password = networkInfo["password"] ?? ""
            DUIBleGatewayManager.sharedManager.begainMatch(ssidString: ssid, pskString: password,bleEquipmentModel:bleEquipmentModel ?? BleEquipmentModel())
        }else if myDeviceType == .light || myDeviceType == .mainLight {
            navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_LIGHT")
        }else if myDeviceType == .panel {
            navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_PANEL")
        }
    }
    private func setDatas() {
        setupTimeTask()
        if myDeviceType == .hub{
            NotificationCenter.default.rx.notification(.NOTIFY_DEVICE_ADD_DEVICE_RESULT)
                .subscribe({ [weak self] (notify) in
                    let info = notify.element?.userInfo
                    guard let result = info?["addDeviceResult"] as? (device:BasicDeviceModel,isSuccess:Bool) else{
                        return
                    }
                    self?.setupNotificationForHub(result)
                }).disposed(by:disposeBag)
        }
        else{
            DevicesStore.sharedStore().adddevicesToGateway(devices: [pairDevice], success: { _ in
            }) {[weak self] (error) in
                let vc = ConnectFailedViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            NotificationCenter.default.rx.notification(.NOTIFY_DEVICE_ADD_DEVICE_RESULT)
                .subscribe({ [weak self] (notify) in
                    let info = notify.element?.userInfo
                    guard let result = info?["addDeviceResult"] as? (device:BasicDeviceModel,isSuccess:Bool) else{
                        return
                    }
                    self?.setupNotificationForNotHub(result)
                }).disposed(by:disposeBag)
        }
    }
    private func setupNotificationForNotHub(_ tempResult:(device:BasicDeviceModel,isSuccess:Bool)){
        var result = tempResult
        if result.device.mac != pairDevice.mac{
            return
        }
        bottomProgress.setProgress(1.0, animated: true)
        timeTask?.isStop = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if result.isSuccess{
                self.pairDevice.sn = result.device.sn
                result.device = self.pairDevice
                self.setSuccessfulResult(device: result.device )
            }else{
                self.setFailResult(device: result.device )
            }
        }
    }
    private func setupNotificationForHub(_ result:(device:BasicDeviceModel,isSuccess:Bool)){
        if result.device.sn != DUIBleGatewayManager.sharedManager.addingHubsn{
            return
        }
        bottomProgress.setProgress(1.0, animated: true)
        timeTask?.isStop = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if result.isSuccess{
                self.setSuccessfulResult(device: result.device)
            }else{
                DUIBleGatewayManager.sharedManager.disconnect()
                self.setFailResult(device: result.device )
            }
        }
    }
    private func setupTimeTask(){
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            guard let vcSelf = self else{
                return
            }
            let timeOut = (vcSelf.myDeviceType == .hub) ? 120 : 60
            if vcSelf.timeTask!.repeatCount >= timeOut {
                vcSelf.timeTask?.isStop = true
                if vcSelf.myDeviceType == .hub{
                    DUIBleGatewayManager.sharedManager.disconnect()
                }
                let vc = ConnectFailedViewController()
                vcSelf.navigationController?.pushViewController(vc, animated: true)
            }else{
                if vcSelf.timeTask != nil{
                    vcSelf.bottomProgress.setProgress(Float((vcSelf.timeTask!.repeatCount )*2)/100.0, animated: true)
                }
            }
        }
    }
    private func setFailResult(device:BasicDeviceModel){
        DispatchQueue.main.async { [weak self] in
            let vc = ConnectFailedViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func setSuccessfulResult(device:BasicDeviceModel){
        DispatchQueue.main.async { [weak self] in
            let vc = ConnectSuccessViewController()
            vc.myDeviceType = self?.myDeviceType ?? .unknown
            vc.device = device
            vc.hubRoomId = self?.belongGatewayModel.room
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private lazy var animatePic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.contentMode = .scaleToFill
        var imgsAry = [Any]()
        for i in 1...39 {
            let image = UIImage(named:"lianjie_"+String(i))
            imgsAry.append(image!)
        }
        tempView.animationImages = imgsAry as? [UIImage]
        tempView.animationDuration = 1.0
        tempView.animationRepeatCount = 0
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var topTipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_MATCHING")
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_T18
        view.addSubview(tempView)
        return tempView
    }()
    private lazy var tipContentLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.text = StellarLocalizedString("ALERT_NO_POWEROFF_MATCHING")
        tempView.numberOfLines = 0
        tempView.textAlignment = .center
        tempView.textColor = STELLAR_COLOR_C6
        tempView.font = STELLAR_FONT_T14
        view.addSubview(tempView)
        return tempView
    }()
    lazy var bottomProgress: UIProgressView = {
        let tempView = UIProgressView()
        tempView.trackTintColor = STELLAR_COLOR_C8
        tempView.progressTintColor = STELLAR_COLOR_C10
        return tempView
    }()
}