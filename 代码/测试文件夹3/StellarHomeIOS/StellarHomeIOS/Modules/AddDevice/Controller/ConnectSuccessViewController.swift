import UIKit
class ConnectSuccessViewController: AddDeviceBaseViewController {
    var myDeviceType:DeviceType = .unknown
    var device = BasicDeviceModel()
    var hubRoomId: Int? 
    private var dataSource = [(roomModel: StellarRoomModel,isSelected: Bool)]()
    var selectRoomId :Int?
    private var lastSelectIndex: Int?
    private var header: ConnectSucessHeadView = ConnectSucessHeadView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        setupData()
        checkScenes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
    }
    private func setupUI() {
        lineImage.isHidden = true
        navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_CONNECT_SUCCESS")
        navBar.backButton.isHidden = true
        navBar.exitButton.isHidden = true
        cardView.addSubview(tableView)
        tableView.tableHeaderView = headView
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().getSingleDeviceInfo(sn: device.sn, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            self.reloadDevice(jsonDic: jsonDic)
        }) { (err) in
            StellarProgressHUD.dissmissHUD()
        }
        headView.changeNameButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.showChangeNameAlertView(title: self?.headView.changeNameButton.titleLabel?.text ?? "")
        }).disposed(by: disposeBag)
        header = headView
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.cardView).offset(-32.fit)
            $0.left.equalTo(self.cardView.snp.left).offset(33.fit)
            $0.right.equalTo(self.cardView.snp.right).offset(-33.fit)
            $0.height.equalTo(46.fit)
        }
        hintPic.snp.makeConstraints {
            $0.top.equalTo(self.cardView).offset(-10.fit)
            $0.centerX.equalTo(self.cardView)
        }
    }
    private func reloadDevice(jsonDic:JSONDictionary){
        switch myDeviceType {
        case .hub:
            let hub = jsonDic.kj.model(GatewayModel.self)
            self.headView.deviceNameLabel.text = hub.name
            var devices = DevicesStore.sharedStore().allDevices
            devices.append(hub)
            DevicesStore.sharedStore().allDevices = devices
        case .light:
            let light = jsonDic.kj.model(LightModel.self)
            self.headView.deviceNameLabel.text = light.name
            var devices = DevicesStore.sharedStore().allDevices
            devices.append(light)
            DevicesStore.sharedStore().allDevices = devices
        case .panel:
            let panel = jsonDic.kj.model(PanelModel.self)
            self.headView.deviceNameLabel.text = panel.name
            var devices = DevicesStore.sharedStore().allDevices
            devices.append(panel)
            DevicesStore.sharedStore().allDevices = devices
        default:
            break
        }
    }
    private func setupRx() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.netSettingDeviceRoom()
            }).disposed(by: disposeBag)
    }
    private func setupData() {
        for roomModel in StellarRoomManager.shared.myRooms {
            dataSource.append((roomModel,false))
        }
        setDeviceDefaultRoom()
        if let lastIdx = lastSelectIndex {
            dataSource[lastIdx].isSelected = true
        }
        tableView.reloadData()
        if device.type == .light || device.type == .mainLight { 
            DevicesStore.instance.changeDeviceName(device: device, newName: device.name, success: nil, failure: nil)
        }
    }
    private func setDeviceDefaultRoom() {
        if myDeviceType == .hub || self.hubRoomId == nil {
            lastSelectIndex = 0
            if dataSource.count > 0 {
                selectRoomId = dataSource[0].roomModel.id
            }
        }else {
            if let defaultRoom = self.hubRoomId {
                lastSelectIndex = dataSource.firstIndex(where: {$0.roomModel.id == defaultRoom})
                selectRoomId = defaultRoom
            }
        }
    }
    private func showChangeNameAlertView(title:String = "") {
        let alert = StellarTextFieldAlertView.stellarTextFieldAlertView()
        alert.setTitleTextFieldType(title: StellarLocalizedString("EQUIPMENT_DEVICE_NAME"), secondTitle: StellarLocalizedString("ALERT_SET_CURRECT_EASY_NAME"), leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        alert.rightButtonBlock = { [weak self] (newName) in
            self?.netModifyName(name: newName)
        }
        view.addSubview(alert)
        alert.showView(text: title)
    }
    private func netModifyName(name: String) {
        StellarProgressHUD.showHUD()
        DevicesStore.instance.changeDeviceName(device: self.device, newName: name, success: { (model) in
            DispatchQueue.main.async {
                StellarProgressHUD.dissmissHUD()
                self.device = model
                self.header.deviceNameLabel.text = model.name
                self.tableView.reloadData()
            }
        }, failure: {
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
        })
    }
    private func netSettingDeviceRoom() {
        if selectRoomId == nil { 
            dissmissToMainVc()
            return
        }
        StellarProgressHUD.showHUD()
        confirmButton.startIndicator()
        DevicesStore.instance.changeDeviceRoom(device: device, newRoomId: selectRoomId!, success: {
            StellarProgressHUD.dissmissHUD()
            self.confirmButton.stopIndicator()
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_SET_ROOM_SUCCESS"))
            self.dissmissToMainVc()
        }) {
            StellarProgressHUD.dissmissHUD()
            self.confirmButton.stopIndicator()
            TOAST(message: StellarLocalizedString("ALERT_SET_ROOM_FAIL") + "." + StellarLocalizedString("ALERT_SET_ROOM_ON_DETAIL"))
            self.dissmissToMainVc()
        }
    }
    private func checkScenes() {
        let arr = StellarAppManager.sharedManager.user.mySceneModelArr
        if arr.count == 0 && (device.type == .light || device.type == .mainLight) {
            QueryDeviceTool.creatScenes()
        }
    }
    private func dissmissToMainVc() {
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: nil)
        if StellarAppManager.sharedManager.currentStep == .kAppStepMain
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            StellarAppManager.sharedManager.nextStep()
        }
    }
    private lazy var tableView: UITableView = {
        var frame = self.cardView.bounds
        frame.size.height -= 46.fit + 32.fit
        let tableView = UITableView.init(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConnectSuccessCell", bundle: nil), forCellReuseIdentifier: "ConnectSuccessCellID")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12.fit
        tableView.clipsToBounds = true
        return tableView
    }()
    private lazy var confirmButton: StellarButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 0, y: 0, width: 291.fit, height: 46.fit))
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.style = .normal
        return tempView
    }()
    private lazy var headView: ConnectSucessHeadView = {
        let tempView = ConnectSucessHeadView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 130.fit))
        return tempView
    }()
    private lazy var hintPic: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "icon_add_success_small")
        tempView.contentMode = .scaleToFill
        view.addSubview(tempView)
        return tempView
    }()
}
extension ConnectSuccessViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectSuccessCellID", for: indexPath) as! ConnectSuccessCell
        cell.selectionStyle = .none
        cell.setupViewsWithData(model: dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.fit
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastSelectIdx = lastSelectIndex { 
            if indexPath.row == lastSelectIdx {
                return
            } 
            dataSource[lastSelectIdx].isSelected = false
            if let lasatCell = tableView.cellForRow(at: IndexPath(row: lastSelectIdx, section: 0)) as? ConnectSuccessCell {
                lasatCell.setUnselected()
            }
        }
        dataSource[indexPath.row].isSelected = true
        if let cell = tableView.cellForRow(at: indexPath) as? ConnectSuccessCell {
            cell.setSelected()
        }
        selectRoomId = dataSource[indexPath.row].roomModel.id
        lastSelectIndex = indexPath.row
    }
}