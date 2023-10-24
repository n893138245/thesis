import UIKit
class MultipleSuccessViewController: AddDeviceBaseViewController {
    var device = BasicDeviceModel()
    private var dataList = [(roomModel: StellarRoomModel,isSelected: Bool)]()
    private var selectRoomId: Int?
    private var lastSelectIndex: Int?
    var gateWayRoomId = 1
    var changeBlock:((_ device: BasicDeviceModel) ->Void)?
    var userSetName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sendRadomColorToLight()
        setupUI()
        setupRx()
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = false
    }
    private func setupUI() {
        lineImage.isHidden = true
        navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_CONNECT_SUCCESS")
        navBar.exitButton.isHidden = true
        cardView.addSubview(tableView)
        tableView.tableHeaderView = headerView
        headerView.deviceNameLabel.text = device.name
        if device.type != .light {
            headerView.hintLable.text = ""
            headerView.hintColorView.backgroundColor = .clear
        }
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.cardView).offset(-32.fit)
            $0.left.equalTo(self.cardView.snp.left).offset(33.fit)
            $0.right.equalTo(self.cardView.snp.right).offset(-33.fit)
            $0.height.equalTo(46.fit)
        }
        headerView.changeNameButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.showChangeNameAlertView(title: self?.headerView.changeNameButton.titleLabel?.text ?? "")
            }).disposed(by: disposeBag)
    }
    private func setupRx() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.netSettingDeviceRoom()
            }).disposed(by: disposeBag)
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    private func setupData() {
        for roomModel in StellarRoomManager.shared.myRooms {
            dataList.append((roomModel,false))
        }
        var defaultRoomId = device.room
        if device.room == nil {
            defaultRoomId = gateWayRoomId
        }
        guard let index = dataList.firstIndex(where: { $0.roomModel.id == defaultRoomId }) else {
            return
        }
        dataList[index].isSelected = true
        selectRoomId = defaultRoomId
        lastSelectIndex = index
        tableView.reloadData()
    }
    private func showChangeNameAlertView(title:String = "") {
        let alert = StellarTextFieldAlertView.stellarTextFieldAlertView()
        alert.setTitleTextFieldType(title: StellarLocalizedString("EQUIPMENT_DEVICE_NAME"), secondTitle: StellarLocalizedString("ALERT_SET_CURRECT_EASY_NAME"), leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        alert.rightButtonBlock = { [weak self] (newName) in
            self?.netChangeName(newName: newName)
        }
        view.addSubview(alert)
        alert.showView(text: title)
    }
    private func netChangeName(newName: String) {
        StellarProgressHUD.showHUD()
        DevicesStore.instance.changeDeviceName(device: self.device, newName: newName) { [weak self] (baseModel) in
            StellarProgressHUD.dissmissHUD()
            TOAST_SUCCESS(message: "修改成功")
            self?.device = baseModel
            self?.headerView.deviceNameLabel.text = baseModel.name
            self?.changeBlock?(baseModel)
            self?.tableView.reloadData()
        } failure: {
            StellarProgressHUD.dissmissHUD()
            TOAST(message: "名称修改失败，请重试")
        }
    }
    private func netSettingDeviceRoom() {
        guard let room = selectRoomId else {
            navigationController?.popViewController(animated: true)
            return
        }
        if room == device.room {
            navigationController?.popViewController(animated: true)
            return
        }
        StellarProgressHUD.showHUD()
        confirmButton.startIndicator()
        DevicesStore.instance.changeDeviceRoom(device: device, newRoomId: room) { [weak self] in
            StellarProgressHUD.dissmissHUD()
            self?.confirmButton.stopIndicator()
            self?.device.room = room
            self?.changeBlock?(self?.device ?? BasicDeviceModel())
            TOAST_SUCCESS(message: "修改成功") {
                self?.navigationController?.popViewController(animated: true)
            }
        } failure: {
            StellarProgressHUD.dissmissHUD()
            self.confirmButton.stopIndicator()
            TOAST(message: "房间修改失败，请重试")
        }
    }
    private func sendRadomColorToLight() {
        if device.type != .light {
            return
        }
        guard let light = device as? LightModel else {
            return
        }
        guard let triats = light.traits else {
            return
        }
        if !triats.contains(.color) {
            return
        }
        StellarProgressHUD.showHUD()
        let RGB = (r: Int(randomCustom(min: 0, max: 255)),g:Int(randomCustom(min: 0, max: 255)),b:Int(randomCustom(min: 0, max: 255)))
        CommandManager.shared.creatColorCommandAndSend(deviceGroup: [light], color: RGB, success: { [weak self] (pResPonse) in
            StellarProgressHUD.dissmissHUD()
            guard let list = pResPonse as? [[CommonResponseModel]] else { return }
            let failure = list[1]
            if failure.count > 0 {
                print("发送随机色失败")
                self?.headerView.hintColorView.backgroundColor = .clear
                self?.headerView.hintLable.text = ""
            }else {
                self?.headerView.hintColorView.backgroundColor = UIColor.ss.rgbA(r: CGFloat(RGB.r), g: CGFloat(RGB.g), b: CGFloat(RGB.b), a: 1.0)
                self?.headerView.hintLable.text = StellarLocalizedString("EQUIPMENT_SET_LIGHT_COLOR")
            }
        }) { (code, message) in
            StellarProgressHUD.dissmissHUD()
            print("发送随机色失败")
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
    private lazy var headerView: ConnectSucessHeadView = {
        let headView = ConnectSucessHeadView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 130.fit))
        headView.isMultipleSuccess = true
        return headView
    }()
}
extension MultipleSuccessViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectSuccessCellID", for: indexPath) as! ConnectSuccessCell
        cell.selectionStyle = .none
        cell.setupViewsWithData(model: dataList[indexPath.row])
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
            dataList[lastSelectIdx].isSelected = false
            if let lasatCell = tableView.cellForRow(at: IndexPath(row: lastSelectIdx, section: 0)) as? ConnectSuccessCell {
                lasatCell.setUnselected()
            }
        }
        dataList[indexPath.row].isSelected = true
        if let cell = tableView.cellForRow(at: indexPath) as? ConnectSuccessCell {
            cell.setSelected()
        }
        selectRoomId = dataList[indexPath.row].roomModel.id
        lastSelectIndex = indexPath.row
    }
}