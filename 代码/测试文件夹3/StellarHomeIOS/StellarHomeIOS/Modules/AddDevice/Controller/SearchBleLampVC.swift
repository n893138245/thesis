import UIKit
class SearchBleLampVC: AddDeviceBaseViewController {
    var timeTask:SSTimeTask?
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: kBlueToothCentralDiscoverPeripheralUpdateNotification, object: nil)
        if timeTask != nil {
            SSTimeManager.shared.removeTask(task: timeTask!)
        }
        StellarHomeBleManger.sharedManager.stopScan()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        begainSearchDevices()
    }
    func setupUI() {
        fd_interactivePopDisabled = true
        navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_DESK_LIGHT")
        cardView.addSubview(findBleDevicesView)
        cardView.addSubview(notFoundView)
        cardView.addSubview(scanView)
        view.addSubview(scanAgainButton)
        navBar.exitButton.isHidden = true
        notFoundView.deviceDetailModel = deviceDetailModel
        scanView.type = deviceDetailModel.type ?? .unknown
        scanAgainButton.snp.makeConstraints {
            $0.right.equalTo(view).offset(-20.fit)
            $0.centerY.equalTo(navBar.titleLabel)
        }
    }
    private func setupActions() {
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        findBleDevicesView.clickForRowBlock = { [weak self] row in
            guard let equipmentModel = self?.findBleDevicesView.bleEquipmentsArr[row] else {
                return
            }
            var light = LightModel()
            light.kj_m.convert(from: self?.deviceDetailModel.kj.JSONObject() ?? [String: Any]())
            StellarProgressHUD.showHUD()
            StellarHomeBleManger.sharedManager.connectToEquipment(model: equipmentModel) { (uuid, isConnectSuccess) in
                if isConnectSuccess{
                    DispatchQueue.global().asyncAfter(deadline: .now()+0.1) {
                        self?.addDeviceAfterConnected(light: light)
                    }
                }else{
                    self?.failedAction()
                }
            }
        }
        notFoundView.searchAginBlock = { [weak self] in
            self?.begainSearchDevices()
        }
        scanAgainButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.begainSearchDevices()
        }).disposed(by: disposeBag)
        _ = NotificationCenter.default.rx
            .notification(kBlueToothCentralDiscoverPeripheralUpdateNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] notification in
                self?.reloadSearchDevices()
            })
    }
    private func awsComplementInfo(complementLight:LightModel,complementBlock:((LightModel,Bool)->Void)?) {
        var light = complementLight
        DevicesStore.sharedStore().queryDevicesVersionDescription(fwType: "\(light.fwType)", hwVersion: "\(light.hwVersion)", swVersion: "\(light.swVersion)", success: { (completionJson) in
            if light.name.isEmpty{
                light.name = completionJson["description"].stringValue
            }
            light.kj_m.convert(from: completionJson.dictionaryObject ?? [:])
            complementBlock?(light,true)
        }) { (error) in
            print("补全请求失败")
            complementBlock?(light,false)
        }
    }
    private func addDeviceAfterConnected(light:LightModel){
        StellarHomeBleManger.sharedManager.queryInfoLight(light: light) { isSuccess,querylight in
            if isSuccess{
                StellarHomeBleManger.sharedManager.querySNLight(light: light,resultBlock: { isSuccess,querylight in
                    if isSuccess{
                        light.sn = querylight.sn
                        self.awsComplementInfo(complementLight: light, complementBlock: { (awsLight,isSuccess) in
                            if isSuccess{
                                self.addLightAction(light: awsLight)
                            }else{
                                self.failedAction()
                            }
                        })
                    }else{
                        self.failedAction()
                    }
                })
            }else{
                self.failedAction()
            }
        }
    }
    private func addLightAction(light:LightModel){
        if light.mac.isEmpty || light.fwType == -1 || light.swVersion == -1 || light.sn.isEmpty {
            self.failedAction()
        }else{
            DevicesStore.sharedStore().addSingleDevice(device: light, success: { [weak self] (jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let model = jsonDic.kj.model(BasicDeviceModel.self)
                let vc = ConnectSuccessViewController()
                vc.myDeviceType = self?.deviceDetailModel.type ?? .unknown
                vc.device = model
                self?.navigationController?.pushViewController(vc, animated: true)
            }) { [weak self] (error) in
                self?.failedAction()
            }
        }
    }
    private func failedAction(){
        StellarProgressHUD.dissmiss {
            let vc = ConnectFailedViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func reloadSearchDevices(){
        var needAddArr = [BleEquipmentModel]()
        let scanStandardArr = StellarHomeBleManger.sharedManager.getScanDevices().filter{$0.fwType == "\(deviceDetailModel.fwType ?? -1)"}
        for scanDevice in scanStandardArr {
            let containArr = findBleDevicesView.bleEquipmentsArr.filter{$0.peripheral == scanDevice.peripheral}
            if containArr.count == 0 {
                needAddArr.append(scanDevice)
            }
        }
        if needAddArr.count > 0 {
            findBleDevicesView.bleEquipmentsArr += needAddArr
            setViewState(myViewState: .findDeviecesWithSingleAdd)
        }
    }
    private func begainSearchDevices(){
        setViewState(myViewState: .searching)
        StellarHomeBleManger.sharedManager.scan()
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            let timeout = 5
            if self?.timeTask?.repeatCount ?? 0 >= timeout {
                self?.timeTask?.isStop = true
                if self?.findBleDevicesView.bleEquipmentsArr.count == 0{
                    self?.setViewState(myViewState: .noResults)
                }else{
                    self?.setViewState(myViewState: .findDeviecesWithSingleAdd)
                }
            }
        }
    }
    private func setViewState(myViewState: MySearchStatus) {
        switch myViewState {
        case .searching:
            scanView.isHidden = false
            notFoundView.isHidden = true
            findBleDevicesView.isHidden = true
            scanAgainButton.isHidden = true
        case .findDeviecesWithSingleAdd:
            scanAgainButton.isHidden = true
            findBleDevicesView.isHidden = false
            scanView.isHidden = true
            notFoundView.isHidden = true
        case .noResults:
            scanAgainButton.isHidden = false
            notFoundView.isHidden = false
            scanView.isHidden = true
            findBleDevicesView.isHidden = true
        case .findDeviecesWithMultiAdd:
            break
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
        tempView.deviceDetailModel = deviceDetailModel
        return tempView
    }()
    private lazy var scanAgainButton: UIButton = {
        let tempView = UIButton()
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_SEARCH_AGAIN"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T16
        return tempView
    }()
}