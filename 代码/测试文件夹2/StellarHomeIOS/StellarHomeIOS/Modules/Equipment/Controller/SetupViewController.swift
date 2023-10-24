import UIKit
class SetupViewController: BaseViewController {
    var device: BasicDeviceModel?
    var upgradeModel: UpgradeDeviceModel?
    var changeInfoBlock: ((_ deviceName: String, _ roomId: Int) -> Void)?
    var titles:[[String:String]] = [["leftTitle":StellarLocalizedString("EQUIPMENT_DEVICE_NAME"),"rightTitle":""],["leftTitle":StellarLocalizedString("ADD_DEVICE_LOCATION_DEVICE"),"rightTitle":StellarLocalizedString("EQUIPMENT_NO_ROOM")],["leftTitle":StellarLocalizedString("EQUIPMENT_FIMWARE_VERSION"),"rightTitle":""],
                                    ["leftTitle":"SN","rightTitle":""],
                                    ["leftTitle":StellarLocalizedString("EQUIPMENT_MAC"),"rightTitle":""]]
    var tableview:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ss.rgbColor(243, 244, 249)
        checkInfoData()
        setupSubViews()
        netGetNewVersionInfo()
    }
    private func setupSubViews(){
        loadNav()
        loadBottombtn()
        loadTableView()
    }
    private func loadNav(){
        view.addSubview(navView)
        navView.snp.makeConstraints {
            $0.left.right.top.equalTo(0)
            $0.height.equalTo(getAllVersionSafeAreaTopHeight().fit + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        }
        let titleLabel = UILabel()
        titleLabel.font = STELLAR_FONT_BOLD_T18
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.text = StellarLocalizedString("EQUIPMENT_SETTING")
        navView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo((getAllVersionSafeAreaTopHeight()+22).fit)
            $0.centerX.equalTo(navView)
        }
        let leftButton = UIButton.init(type: .custom)
        leftButton.setImage(UIImage.init(named: "bar_icon_back"), for: .normal)
        leftButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.left.bottom.equalTo(0)
            $0.height.equalTo(44)
            $0.width.equalTo(40)
        }
    }
    @objc func backAction(){
        navigationController?.popViewController(animated: true)
    }
    private func loadTableView(){
        tableview = UITableView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableview?.backgroundColor = UIColor.ss.rgbColor(243, 244, 249)
        view.addSubview(tableview!)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        tableview?.separatorColor = STELLAR_COLOR_C9
        tableview?.snp.makeConstraints {
            $0.left.right.equalTo(0)
            $0.bottom.equalTo(bottomBtn.snp.top)
            $0.top.equalTo(navView.snp.bottom).offset(0)
        }
        tableview?.register(UINib(nibName: "TitleAndNameTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleAndNameTableViewCell")
    }
    func loadBottombtn(){
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).offset(-24.fit - getAllVersionSafeAreaBottomHeight())
            $0.width.equalTo(291.fit)
            $0.height.equalTo(46.fit)
            $0.centerX.equalTo(view)
        }
        bottomBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.doDeletDevice()
            }).disposed(by: disposeBag)
    }
    private func checkInfoData() {
        if self.device?.type == .mainLight {
            titles.insert(["leftTitle":"运动轨迹历史","rightTitle":""], at: 2)
        }
    }
    private func doDeletDevice() {
        if device?.type == .mainLight || device?.type == .light {
            showHaveRelationDeletTip()
        }else {
            showNormalDeletTip()
        }
    }
    private func netGetNewVersionInfo() {
        if device?.remoteType == .locally {
            netGetUpgradeInfo()
        }else {
            StellarProgressHUD.showHUD()
            DevicesStore.sharedStore().getSingleDeviceInfo(sn: device?.sn ?? "", success: { (jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let model = jsonDic.kj.model(BasicDeviceModel.self)
                guard let lastVersion = model.latestSwVersion else {
                    return
                }
                if lastVersion != self.device?.swVersion {
                    self.device?.latestSwVersion = lastVersion
                    self.tableview?.reloadData()
                    self.netGetUpgradeInfo()
                }
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
            }
        }
    }
    private func netGetUpgradeInfo() {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().devicesUpgradeInfo(fwType: "\(device?.fwType ?? -1)", hwVersion: "\(device?.hwVersion ?? -1)", success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(UpgradeDeviceModel.self)
            if !model.profiles.isEmpty {
                self.upgradeModel = model
                self.tableview?.reloadData()
            }
        }) { (err) in
            StellarProgressHUD.dissmissHUD()
        }
    }
    private func netDeletDevice() {
        StellarProgressHUD.showHUD()
        DevicesStore.instance.deletDevice(device: device!, success: {
            StellarProgressHUD.dissmissHUD()
            NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: nil)
            TOAST_SUCCESS(message: StellarLocalizedString("EQUIPMENT_REMOVE_SUCCESS")) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }) {
            StellarProgressHUD.dissmissHUD()
            self.hintView.showAnimationWithTitle(StellarLocalizedString("EQUIPMENT_REMOVE_FAIL"), duration: 2)
        }
    }
    private func netModifyDeviceInfo(deviceName: String) {
        StellarProgressHUD.showHUD()
        DevicesStore.instance.changeDeviceName(device: device!, newName: deviceName, success: { [weak self] (newDevice) in
            StellarProgressHUD.dissmissHUD()
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS")) {
                self?.device = newDevice
                self?.tableview?.reloadData()
                if let block = self?.changeInfoBlock {
                    block((self?.device?.name) ?? "",self?.device?.room ?? 0)
                }
                self?.postChangenotification()
            }
        }) {
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
        }
    }
    private func postChangenotification() {
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: ["device":[self.device ?? BasicDeviceModel()]])
    }
    private func showNormalDeletTip() {
        let alert = StellarMineAlertView.init(message: StellarLocalizedString("ALERT_DOUBT_REMOVE_DEVICE"), leftTitle: StellarLocalizedString("ALERT_SURE_REMOVE"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.show()
        alert.leftClickBlock = {
            self.netDeletDevice()
        }
    }
    private func showHaveRelationDeletTip() {
        let alert = StellarMineAlertView.init(title: StellarLocalizedString("ALERT_DOUBT_REMOVE_DEVICE"), message: StellarLocalizedString("ALERT_REMOVE_AFTER_SCENE_SMART_PANEL"), leftTitle: StellarLocalizedString("ALERT_SURE_REMOVE"), rightTitle: StellarLocalizedString("COMMON_CANCEL"), contentTip: nil)
        alert.show()
        alert.leftClickBlock = {
            self.netDeletDevice()
        }
    }
    lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        view.addSubview(hView)
        return hView
    }()
    lazy var navView:UIView = {
        let view = UIView()
        view.backgroundColor = STELLAR_COLOR_C3
        return view
    }()
    lazy var confirmNameView:StellarTextFieldAlertView = {
        let secondTitle = self.device?.type == .light || device?.type == .mainLight ? StellarLocalizedString("ALERT_SET_CURRECT_EASY_NAME"):""
        let view = StellarTextFieldAlertView.stellarTextFieldAlertView()
        view.setTitleTextFieldType(title: StellarLocalizedString("EQUIPMENT_MODIFY_NAME"), secondTitle: secondTitle, leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        self.view.addSubview(view)
        return view
    }()
    lazy var bottomBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle(StellarLocalizedString("EQUIPMENT_REMOVE_CONNECT"), for: .normal)
        button.setTitleColor(STELLAR_COLOR_C2, for: .normal)
        button.titleLabel?.font = STELLAR_FONT_T17
        button.backgroundColor = STELLAR_COLOR_C3
        button.layer.cornerRadius = 23.fit
        button.layer.masksToBounds = true
        return button
    }()
}
extension SetupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.fit
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleAndNameTableViewCell", for: indexPath) as! TitleAndNameTableViewCell
        let dic:Dictionary = titles[indexPath.row]
        switch dic["leftTitle"] {
        case StellarLocalizedString("EQUIPMENT_DEVICE_NAME"): 
            cell.setlabelTitles(left: dic["leftTitle"]!, right: device?.name ?? "", isHiddenArrow: false,isShowReddot: false)
            cell.rightLabel.font = STELLAR_FONT_T14
        case StellarLocalizedString("ADD_DEVICE_LOCATION_DEVICE"): 
            if device?.room == nil {
                cell.setlabelTitles(left: dic["leftTitle"]!, right:StellarLocalizedString("EQUIPMENT_NO_ROOM"), isHiddenArrow: false,isShowReddot: false)
            }else {
                let room = StellarRoomManager.shared.getRoom(roomId: (device?.room!)!)
                cell.setlabelTitles(left: dic["leftTitle"]!, right: room.name ?? "" , isHiddenArrow: false,isShowReddot: false)
            }
            cell.rightLabel.font = STELLAR_FONT_T14
        case StellarLocalizedString("EQUIPMENT_FIMWARE_VERSION"): 
            cell.rightLabel.font = STELLAR_FONT_NUMBER_T14
            if device?.type == .panel {
                cell.setlabelTitles(left: dic["leftTitle"] ?? "", right: "\(String.ss.trasformToHexVersion(versionNum: device!.swVersion))" , isHiddenArrow: true, isShowReddot: false)
                break
            }
            var isShowRedView = false
            if let version = upgradeModel, version.newVersion != device?.swVersion { 
                isShowRedView = true
            }else {
                if let lastVersion = device?.latestSwVersion, device?.swVersion != lastVersion {
                    isShowRedView = true
                }
            }
            cell.setlabelTitles(left: dic["leftTitle"]!, right: "\(String.ss.trasformToHexVersion(versionNum: device!.swVersion))", isHiddenArrow: false,isShowReddot: isShowRedView)
        case "SN": 
            cell.setlabelTitles(left: dic["leftTitle"]!, right: device?.sn ?? "", isHiddenArrow: true,isShowReddot: false)
            cell.rightLabel.font = STELLAR_FONT_NUMBER_T14
        case StellarLocalizedString("EQUIPMENT_MAC"): 
            cell.setlabelTitles(left: dic["leftTitle"]!, right: device?.mac ?? "", isHiddenArrow: true,isShowReddot: false)
            cell.rightLabel.font = STELLAR_FONT_NUMBER_T14
        default:
            cell.setlabelTitles(left: dic["leftTitle"]!, right: "", isHiddenArrow: false,isShowReddot: false)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic:Dictionary = titles[indexPath.row]
        switch dic["leftTitle"] {
        case StellarLocalizedString("EQUIPMENT_DEVICE_NAME"): 
            if self.device?.name == nil {
                confirmNameView.showView()
            }else{
                confirmNameView.showView(text:self.device?.name ?? "")
            }
            confirmNameView.rightButtonBlock = { [weak self] text in
                if text.count > 0 {
                    self?.netModifyDeviceInfo(deviceName: text)
                }
            }
        case StellarLocalizedString("ADD_DEVICE_LOCATION_DEVICE"): 
            let vc = DeviceLocationViewController()
            vc.device = device ?? BasicDeviceModel()
            vc.selectRoomId = device?.room ?? 0
            vc.modifyBlock = { [weak self] (id) in
                self?.device?.room = id
                self?.tableview?.reloadData()
                if let block = self?.changeInfoBlock {
                    block((self?.device?.name ?? ""),(self?.device?.room) ?? 0)
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case StellarLocalizedString("EQUIPMENT_FIMWARE_VERSION"): 
            if device?.type == .panel {
                return
            }
            let vc = FirmwareUpgradingViewController()
            vc.device = device
            vc.upgradeModel = self.upgradeModel
            vc.upgradeSuccessBlock = { [weak self] in
                self?.tableview?.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        case "监测报警设置":
            let vc = MonitorClockViewController()
            vc.device = self.device
            navigationController?.pushViewController(vc, animated: true)
        case "运动轨迹历史":
            let vc = SelectDateViewController()
            vc.device = self.device
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}