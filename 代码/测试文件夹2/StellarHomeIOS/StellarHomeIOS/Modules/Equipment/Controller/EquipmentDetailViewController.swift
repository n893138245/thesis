import UIKit
enum DetailChildState {
    case power
    case breghtness
    case color
    case streamer
    case delayOff
    case detailInit
    case preSet
    case monitoring
}
enum BleState {
    case connectFeilure
    case connectSucess
    case poweroff
    case connecting
    case none
}
class EquipmentDetailViewController: BaseViewController {
    var lampModel: LightModel?
    private var isPowerOff: Bool = false
    private var isConnectedToBle = false 
    private var timer: SSTimeTask? 
    private var isPush = false
    var nextVC = UIViewController()
    var currentVC:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupDatas()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if lampModel?.remoteType == .locally && !isPush { 
            removeTimer()
            StellarHomeBleManger.sharedManager.cleanUp()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPush = false
    }
    var viewState: DetailChildState = .detailInit {
        didSet {
            if viewState == oldValue  {
                return
            }
            setupController(state: viewState)
        }
    }
    private var myBleState: BleState = .none { 
        didSet {
            if myBleState == oldValue  {
                return
            }
            setupBleConnecViews()
        }
    }
    func setupController(state: DetailChildState){
        switch state {
        case .detailInit:
            nextVC = powerViewController
            break
        case .power:
            nextVC = powerViewController
            break
        case .breghtness:
            nextVC = brightnessViewController
            break
        case .color:
            nextVC = colourModulationViewController
            break
        case .streamer:
            nextVC = streamerViewController
            break
        case .delayOff:
            nextVC = cutdownViewController
        case .preSet:
            nextVC = preSetViewController
        case .monitoring:
            nextVC = monitoringViewController
        }
        currentVC?.willMove(toParent: self)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        addChild(nextVC)
        nextVC.didMove(toParent: self)
        view.insertSubview(nextVC.view, belowSubview: self.tabBarView)
        nextVC.view.frame = view.bounds
        currentVC = nextVC
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.timingFunction = .init(name: .linear)
        view.layer.add(animation, forKey: "switchView")
    }
    private func setupBleConnecViews() {
        switch myBleState {
        case .connectFeilure: 
            bleNotConnectedTipLabel.isHidden = false
            bleTipDetailLabel.isHidden = false
            bleConnectView.isHidden = false
            bleConnectView.myConnectStatus = .failure
            break
        case .connectSucess: 
            bleNotConnectedTipLabel.isHidden = true
            bleTipDetailLabel.isHidden = true
            bleConnectView.isHidden = true
            break
        case .connecting: 
            bleNotConnectedTipLabel.isHidden = false
            bleTipDetailLabel.isHidden = true 
            bleConnectView.isHidden = false
            bleConnectView.myConnectStatus = .connecting
            break
        case .poweroff: 
            bleNotConnectedTipLabel.isHidden = false
            bleTipDetailLabel.isHidden = true 
            bleConnectView.isHidden = false
            bleConnectView.myConnectStatus = .poweroff
            break
        case .none: 
            bleNotConnectedTipLabel.isHidden = true
            bleTipDetailLabel.isHidden = true
            bleConnectView.isHidden = true
            break
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isPowerOff ? .lightContent : .default
    }
    func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        navBar.titleLabel.text = "卧室 球泡灯"
        view.addSubview(tabBarView)
        view.addSubview(hintLabel)
        view.addSubview(navBar)
        hintLabel.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.navBar.snp.bottom)
        }
        bleNotConnectedTipLabel.isHidden = true
        bleTipDetailLabel.isHidden = true
        view.addSubview(bleNotConnectedTipLabel)
        view.addSubview(bleTipDetailLabel)
        bleTipDetailLabel.snp.makeConstraints {
            $0.bottom.equalTo(tabBarView.snp.top).offset(-16.fit)
            $0.centerX.equalTo(view)
        }
        bleNotConnectedTipLabel.snp.makeConstraints {
            $0.width.equalTo(101.fit)
            $0.height.equalTo(38.fit)
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(bleTipDetailLabel.snp.top).offset(-8)
        }
        bleNotConnectedTipLabel.layer.cornerRadius = 19.fit
        bleNotConnectedTipLabel.layer.borderWidth = 1
        bleNotConnectedTipLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        bleNotConnectedTipLabel.clipsToBounds = true
    }
    func setupAction() {
        tabBarView.currentModeBlock = { [weak self] mode in
            self?.viewState = mode
            if mode == .color {
                self?.fd_interactivePopDisabled = true 
            }else {
                self?.fd_interactivePopDisabled = false
            }
            self?.navBar.style = mode == .power ?.whiteStyle : .defaultStyle
            self?.hintLabel.textColor = mode == .power ?STELLAR_COLOR_C3 : STELLAR_COLOR_C4
            self?.isPowerOff = mode == .power ? true : false
            self?.setNeedsStatusBarAppearanceUpdate()
        }
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        navBar.moreButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.isPush = true
                let vc = SetupViewController()
                vc.device = self?.lampModel
                vc.changeInfoBlock = { (name,roomId) in
                    self?.lampModel?.room = roomId
                    self?.lampModel?.name = name
                    let room = StellarRoomManager.shared.getRoom(roomId: roomId)
                    self?.navBar.titleLabel.text = "\(room.name ?? "") \(self?.lampModel?.name ?? "")"
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    private func setupDatas() {
        if lampModel?.remoteType == .locally { 
            setBleDatas()
        }else { 
            tabBarView.lightModel = lampModel
            brightnessViewController.lampModel = lampModel
            colourModulationViewController.lampModel = lampModel
            preSetViewController.light = lampModel
            monitoringViewController.lampModel = lampModel
        }
        setupNavTitle()
    }
    private func setupNavTitle() {
        var room = StellarRoomModel()
        if lampModel?.room != nil {
            room = StellarRoomManager.shared.getRoom(roomId: lampModel!.room!)
        }
        navBar.titleLabel.text = "\(room.name ?? "") \(lampModel?.name ?? "")"
    }
    private func setBleDatas() {
        self.isPowerOff = true
        self.viewState = .power
        setNeedsStatusBarAppearanceUpdate()
        view.addSubview(bleConnectView)
        if !StellarHomeBleManger.sharedManager.isOpenBlueTooth() { 
            self.myBleState = .poweroff
        }else { 
            StellarHomeBleManger.sharedManager.scan() 
            self.myBleState = .connecting
        }
        bleConnectView.clickBlock = { [weak self] in
            if self?.myBleState == .poweroff { 
                self?.bleTipView.showView()
            }else { 
                StellarHomeBleManger.sharedManager.scan()
                self?.myBleState = .connecting
            }
        }
        NotificationCenter.default.rx.notification(kBlueToothCentralLightOffLineNotification)
            .subscribe(onNext: { [weak self] (notify) in
                self?.receiveBleDeviceOffLineNotification()
                print("lr - ble 设备离线")
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(kBlueToothCentralDidUpdateStateNotification)
            .subscribe(onNext: { [weak self] (notify) in
                self?.getBleStatusChanged()
                print("lr - ble 连接状态改变")
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(kBlueToothCentralDiscoverPeripheralUpdateNotification)
            .subscribe(onNext: { [weak self] (notify) in
                self?.getScanDevicesNotification()
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_BLE_CUTDOWN_START)
            .subscribe(onNext: { [weak self] (notify) in
                self?.getBleCutdownNotification(info: notify.userInfo)
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_BLE_CUTDOWN_CLOSE)
            .subscribe(onNext: { [weak self] (notify) in
                self?.removeTimer()
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_BLE_RECONNECTED)
            .subscribe(onNext: { [weak self] (notify) in
                if self?.myBleState != .connectSucess {
                    self?.myBleState = .connectSucess
                }
            }).disposed(by: disposeBag)
    }
    private func getBleCutdownNotification(info: [AnyHashable : Any]?) {
        if let time = info?["time"] as? Int {
            removeTimer()
            startTimer(totalTime: time, restTime: time)
        }
    }
    private func getScanDevicesNotification() {
        let devices = StellarHomeBleManger.sharedManager.getScanDevices().filter({$0.mac == lampModel?.mac}) 
        if devices.isEmpty || isConnectedToBle {
            return
        }
        StellarHomeBleManger.sharedManager.stopScan() 
        isConnectedToBle = true
        StellarHomeBleManger.sharedManager.connectToLight(lightModel: lampModel ?? LightModel()) { [weak self] (uuidString, success) in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.getBleLightStatus()
                }
            }else {
                self?.connectFailure()
                print("lr - ble 连接失败（blcok）")
            }
        }
    }
    private func getBleStatusChanged() {
        switch StellarHomeBleManger.sharedManager.getBleManagerState() {
        case .poweredOn:
            if myBleState == .connectSucess {
                break
            }
            self.myBleState = .connecting
            StellarHomeBleManger.sharedManager.scan()
            break
        case .poweredOff:
            iphoneBlueToothPowerOff()
            break
        default:
            break
        }
    }
    private func receiveBleDeviceOffLineNotification() {
        if !StellarHomeBleManger.sharedManager.isOpenBlueTooth() {
            iphoneBlueToothPowerOff()
        }else {
            connectFailure()
        }
    }
    private func connectFailure() {
        isConnectedToBle = false
        myBleState = .connectFeilure
        tabBarView.isPowerOff = true
    }
    private func iphoneBlueToothPowerOff() {
        isConnectedToBle = false
        myBleState = .poweroff
        tabBarView.isPowerOff = true
    }
    private func connectSuccess() {
        tabBarView.lightModel = lampModel
        brightnessViewController.lampModel = lampModel
        colourModulationViewController.lampModel = lampModel
        cutdownViewController.lightModel = lampModel
        myBleState = .connectSucess
    }
    private func getBleLightStatus() {
        var lightStatus = LightStatus()
        lightStatus.onOff = "off" 
        lightStatus.currentMode = .cct
        let group = DispatchGroup.init()
        let devicesQueue = DispatchQueue(label: "com.devicesQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) { [weak self] in
            StellarHomeBleManger.sharedManager.queryOpenCloseLight(light: self?.lampModel ?? LightModel()) { (success, model) in
                if success {
                    lightStatus.onOff = model.status.onOff
                }
                group.leave()
            }
        }
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) { [weak self] in
            StellarHomeBleManger.sharedManager.queryBrightnessLight(light: self?.lampModel ?? LightModel()) { (success, model) in
                if success {
                    lightStatus.brightness = model.status.brightness
                }
                group.leave()
            }
        }
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) { [weak self] in
            StellarHomeBleManger.sharedManager.queryCCTLight(light: self?.lampModel ?? LightModel()) { (success, model) in
                if success {
                    lightStatus.cct = model.status.cct
                }
                group.leave()
            }
        }
        group.enter()
        devicesQueue.async(group: group, qos: .default, flags: []) { [weak self] in
            StellarHomeBleManger.sharedManager.queryInfoLight(light: self?.lampModel ?? LightModel()) { (success, model) in
                if success {
                    self?.lampModel?.swVersion = model.swVersion
                }
                group.leave()
            }
        }
        group.notify(queue: devicesQueue) { [weak self] in
            DispatchQueue.main.async {
                self?.lampModel?.status = lightStatus
                self?.getCurrentCutdownState() 
            }
        }
    }
    private func getCurrentCutdownState() {
        StellarHomeBleManger.sharedManager.queryDelayCloseLight(light: lampModel ?? LightModel()) { (success, light, totalTime, restTime) in
            self.connectSuccess()
            if let rest = restTime,let total = totalTime, rest != 0 {  
                self.tabBarView.isCurrentHaveDelayTask = true
                self.startTimer(totalTime: total, restTime: (total - rest))
            }
        }
    }
    private func startTimer(totalTime: Int, restTime: Int) {
        if timer == nil {
            timer = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { (task) in
                if task.repeatCount >= restTime {
                    self.removeTimer()
                    self.tabBarView.isPowerOff = true
                }
            }
        }
    }
    private func removeTimer() {
        if self.timer != nil {
            SSTimeManager.shared.removeTask(task: timer!)
            timer = nil
        }
    }
    lazy var tabBarView: DeviceDetailTabbar = {
        let tempView = DeviceDetailTabbar.init(frame: CGRect(x: 0, y: kScreenHeight - 126.fit - getAllVersionSafeAreaBottomHeight(), width: kScreenWidth, height: 126.fit))
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var bleConnectView: BleConnectBottomView = {
        let tempView = BleConnectBottomView.init(frame: CGRect(x: 0, y: kScreenHeight-126.fit - getAllVersionSafeAreaBottomHeight(), width: kScreenWidth, height: 126.fit))
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .whiteStyle
        return tempView
    }()
    lazy var hintLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var bleNotConnectedTipLabel: UILabel = {
        let tempView = UILabel()
        tempView.font = STELLAR_FONT_T15
        tempView.textColor = UIColor.white.withAlphaComponent(0.7)
        tempView.text = StellarLocalizedString("EQUIPMENT_UN_CONNECT")
        tempView.textAlignment = .center
        return tempView
    }()
    lazy var bleTipDetailLabel: UILabel = {
        let tempView = UILabel()
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = UIColor.white.withAlphaComponent(0.8)
        tempView.text = StellarLocalizedString("EQUIPMENT_CONNECT_TIP")
        return tempView
    }()
    lazy var powerViewController:PowerViewController = { 
        let vc = PowerViewController()
        return vc
    }()
    lazy var brightnessViewController:BrightnessViewController = { 
        let vc = BrightnessViewController()
        return vc
    }()
    lazy var colourModulationViewController:ColourModulationViewController = { 
        let vc = ColourModulationViewController()
        return vc
    }()
    lazy var streamerViewController:StreamerViewController = { 
        let vc = StreamerViewController()
        return vc
    }()
    lazy var cutdownViewController:BleCutdownViewController = { 
        let vc = BleCutdownViewController()
        return vc
    }()
    lazy var preSetViewController:PreSetViewController = { 
        let vc = PreSetViewController()
        return vc
    }()
    lazy var monitoringViewController:MonitoringViewController = { 
        let vc = MonitoringViewController()
        return vc
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