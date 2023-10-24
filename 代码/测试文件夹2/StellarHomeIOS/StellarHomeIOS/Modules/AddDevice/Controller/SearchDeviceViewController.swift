import UIKit
enum MySearchStatus {
    case searching
    case noResults
    case findDeviecesWithSingleAdd 
    case findDeviecesWithMultiAdd 
    case unKonwing
}
class SearchDeviceViewController: AddDeviceBaseViewController {
    var belongGateWayModel: GatewayModel?
    var timeTask:SSTimeTask?
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel(){
        didSet {
            if deviceDetailModel.type == .light || deviceDetailModel.type == .mainLight {
                navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_LIGHT")
            }else if deviceDetailModel.type == .panel {
                navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_PANEL")
            }else if deviceDetailModel.type == .hub {
                navBar.titleLabel.text = StellarLocalizedString("GATEWAY_CONNECT")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DUIBleGatewayManager.sharedManager.stopScan()
        NotificationCenter.default.removeObserver(self, name: .NOTIFY_DEVICE_SEARCHED, object: nil)
        if timeTask != nil {
            SSTimeManager.shared.removeTask(task: timeTask!)
        }
        guard let hun = belongGateWayModel else {
            return
        }
        DevicesStore.sharedStore().unsubscribeGatewaySearchDevice(sn: hun.sn)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_interactivePopDisabled = true
        setupUI()
        setupActions()
        begainSearchDevices()
        receiveNewDevices()
        findDevicesView.myDeviceType = deviceDetailModel.type ?? .unknown
    }
    func setupUI() {
        cardView.addSubview(findBleDevicesView)
        cardView.addSubview(findDevicesView)
        cardView.addSubview(notFoundView)
        cardView.addSubview(scanView)
        view.addSubview(rightButton)
        navBar.exitButton.isHidden = true
        notFoundView.deviceDetailModel = deviceDetailModel
        scanView.type = deviceDetailModel.type ?? .unknown
        rightButton.snp.makeConstraints {
            $0.right.equalTo(view).offset(-20.fit)
            $0.centerY.equalTo(navBar.titleLabel)
        }
    }
    private func setupActions() {
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                if self?.deviceDetailModel.type ?? .unknown != .hub{
                    DevicesStore.sharedStore().stopSearch(sn: self?.belongGateWayModel?.sn ?? "", success: { (_) in
                        print("停止扫描")
                    }) { (_) in
                        print("停止扫描失败")
                    }
                }
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        findBleDevicesView.clickForRowBlock = { [weak self] row in
            let vc = InputWiFiInfoViewController.init()
            vc.bleEquipmentModel = self?.findBleDevicesView.bleEquipmentsArr[row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        notFoundView.reSetBlock = { [weak self] in
            if self?.deviceDetailModel.type == .hub {
                let vc = CommonReSetViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = AddWiFiOrResetLightViewController()
                vc.detailModel = self?.deviceDetailModel
                vc.isAddWifiDevice = false
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        notFoundView.searchAginBlock = { [weak self] in
            self?.begainSearchDevices()
        }
        rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.begainSearchDevices()
            }).disposed(by: disposeBag)
        findDevicesView.bottomBtn.rx.tap
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                let selectedDevice = self?.findDevicesView.devices.filter({ devices -> Bool in
                    devices.1
                }).map({ devices -> BasicDeviceModel in
                    return devices.0
                })
                guard let devices = selectedDevice  else {
                    return
                }
                self?.setupOneKeyAdd(devices)
            }).disposed(by: disposeBag)
    }
    private func setupOneKeyAdd(_ selectedDevice:[BasicDeviceModel]){
        if selectedDevice.count > 1{
            StellarProgressHUD.showHUD()
            DevicesStore.sharedStore().adddevicesToGateway(devices: selectedDevice, success: { (arr) in
                StellarProgressHUD.dissmissHUD()
                let addDevices = self.addRequestResult(selectedDevice: selectedDevice, responseDeviceModels: arr)
                if addDevices.count == 0{
                    let vc = ConnectFailedViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if addDevices.count >= 1{
                    let vc = AddingDevicesVC()
                    vc.selectDevices = addDevices
                    vc.myDeviceType = self.deviceDetailModel.type ?? .unknown
                    vc.gateWayRoomId = self.belongGateWayModel?.room ?? 1
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
                let vc = ConnectFailedViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if selectedDevice.count == 1{
                let vc = PairGatewayViewController()
                vc.myDeviceType = deviceDetailModel.type ?? .unknown
                vc.pairDevice = selectedDevice.first!
                vc.belongGatewayModel = belongGateWayModel ?? GatewayModel() 
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    private func addRequestResult(selectedDevice:[BasicDeviceModel],responseDeviceModels:[ResponseDeviceModel]) -> [(BasicDeviceModel,AddDeviceState)]{
        var addDevices = [(BasicDeviceModel,AddDeviceState)]()
        for model in responseDeviceModels{
            if model.code == 0 {
                for device in selectedDevice{
                    if device.mac == model.mac{
                        addDevices.append((device, AddDeviceState.wait))
                    }
                }
            }else{
                for device in selectedDevice{
                    if device.mac == model.mac{
                        addDevices.append((device, AddDeviceState.fail))
                    }
                }
            }
        }
        return addDevices
    }
    private func receiveNewDevices(){
        if deviceDetailModel.type ?? .unknown != .hub{
            _ = NotificationCenter.default.rx
                .notification(.NOTIFY_DEVICE_SEARCHED)
                .takeUntil(self.rx.deallocated)
                .subscribe(onNext: { [weak self] notification in
                    self?.receiveSearchDevices()
                })
        }
    }
    private func receiveSearchDevices(){
        for device in DevicesStore.sharedStore().searchDevices{
            if device.fwType == -1 || device.fwType != deviceDetailModel.fwType{
                return
            }
            let arr = findDevicesView.devices.filter({ (devicesModel) -> Bool in
                if devicesModel.0.mac == device.mac{
                    return true
                }else{
                    return false
                }
            })
            if arr.count == 0 {
                findDevicesView.addDevice(model:device)
                setViewState(myViewState: .findDeviecesWithMultiAdd)
            }
        }
    }
    private func begainSearchDevices(){
        setViewState(myViewState: .searching)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setSearchTimer()
        }
    }
    private func setSearchTimer() {
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            let isHub = self?.deviceDetailModel.type ?? .unknown == .hub
            if isHub {
                self?.setupTimeTaskForHub()
            }else{
                self?.setupTimeTaskForNotHub()
            }
        }
        if deviceDetailModel.type == .hub {
            DUIBleGatewayManager.sharedManager.scan()
        }else{
            begainSearchNotHubs()
        }
    }
    private func setupTimeTaskForHub(){
        let timeout = 5
        guard let currentTimeTask = self.timeTask else {
            return
        }
        if currentTimeTask.repeatCount >= timeout {
            currentTimeTask.isStop = true
            if DUIBleGatewayManager.sharedManager.getScanDevices().count > 0{
                if DUIBleGatewayManager.sharedManager.getScanDevices().count == 1{
                    let vc = InputWiFiInfoViewController.init()
                    vc.deviceDetailModel = deviceDetailModel
                    if let bleEquipmentModel = DUIBleGatewayManager.sharedManager.getScanDevices().first{
                        vc.bleEquipmentModel = bleEquipmentModel
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    findBleDevicesView.bleEquipmentsArr = DUIBleGatewayManager.sharedManager.getScanDevices()
                    setViewState(myViewState: .findDeviecesWithSingleAdd)
                }
            }else{
                setViewState(myViewState: .noResults)
            }
        }
    }
    private func setupTimeTaskForNotHub(){
        let timeout = 60
        guard let currentTimeTask = self.timeTask else {
            return
        }
        if currentTimeTask.repeatCount >= timeout {
            currentTimeTask.isStop = true
            guard let belongGateWayModelSn = belongGateWayModel?.sn else {
                return
            }
            DevicesStore.sharedStore().stopSearch(sn: belongGateWayModelSn, success: { (_) in
                print("停止扫描")
            }) { (_) in
                print("停止扫描失败")
            }
            if findDevicesView.devices.count == 0{
                setViewState(myViewState: .noResults)
            }
        }
    }
    private func begainSearchNotHubs(){
        if let hun = belongGateWayModel {
            DevicesStore.sharedStore().subscribeGatewaySearchDevice(sn: hun.sn,searchDetailModel: deviceDetailModel, success: {
            }) { (_) in
            }
        }
        DevicesStore.sharedStore().startSearch(sn: belongGateWayModel?.sn ?? "",time:60, success: { (_) in
            print("开始扫描")
        }) { (_) in
            print("开始扫描失败")
            self.setViewState(myViewState: .noResults)
        }
    }
    private func setViewState(myViewState: MySearchStatus) {
        switch myViewState {
        case .searching:
            scanView.isHidden = false
            findDevicesView.isHidden = true
            notFoundView.isHidden = true
            findBleDevicesView.isHidden = true
            rightButton.isHidden = true
        case .findDeviecesWithSingleAdd:
            rightButton.isHidden = true
            findBleDevicesView.isHidden = false
            scanView.isHidden = true
            notFoundView.isHidden = true
            findDevicesView.isHidden = true
        case .noResults:
            DUIBleGatewayManager.sharedManager.stopScan()
            rightButton.isHidden = false
            notFoundView.isHidden = false
            scanView.isHidden = true
            findBleDevicesView.isHidden = true
            findDevicesView.isHidden = true
        case .findDeviecesWithMultiAdd:
            rightButton.isHidden = true
            findDevicesView.isHidden = false
            scanView.isHidden = true
            notFoundView.isHidden = true
            findBleDevicesView.isHidden = true
        case .unKonwing:
            break
        }
    }
    private lazy var scanView: ScanView = {
        let tempView = ScanView.init(frame: cardView.bounds)
        return tempView
    }()
    private lazy var notFoundView: NotFoundDevicesView = {
        let tempView = NotFoundDevicesView.init(frame: cardView.bounds)
        return tempView
    }()
    private lazy var findBleDevicesView: FindBleDevicesView = {
        let tempView = FindBleDevicesView.init(frame: cardView.bounds)
        return tempView
    }()
    private lazy var findDevicesView: FindDeviceView = {
        let tempView = FindDeviceView.init(frame: cardView.bounds)
        return tempView
    }()
    private lazy var rightButton: UIButton = {
        let tempView = UIButton()
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_SEARCH_AGAIN"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T16
        return tempView
    }()
}