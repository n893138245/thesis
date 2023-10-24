import UIKit
class DeviceLocationViewController: BaseViewController {
    var selectRoomId: Int?
    private var lastSelectIndex: Int?
    var device = BasicDeviceModel()
    var modifyBlock: ((_ roomId: Int) ->Void)?
    private var dataList: [(room: StellarRoomModel, isSelected: Bool)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        netGetRoomList()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C8
        view.addSubview(navBar)
        view.addSubview(tableView)
        var height: CGFloat = 50
        if !isChinese() {
            height = 70
        }
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height))
        let label = UILabel.init()
        label.font = STELLAR_FONT_T13
        label.textColor = STELLAR_COLOR_C4
        label.numberOfLines = 0
        label.text = StellarLocalizedString("EQUIPMENT_ROOM_TIP")
        header.addSubview(label)
        if isChinese() {
            label.snp.makeConstraints {
                $0.left.equalTo(header).offset(20)
                $0.centerY.equalTo(header)
            }
        }else {
            label.snp.makeConstraints {
                $0.left.equalTo(header).offset(40)
                $0.centerY.equalTo(header)
                $0.width.equalTo(kScreenWidth - 40)
            }
        }
        tableView.tableHeaderView = header
        view.addSubview(confirmButton)
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.netChangeDeviceRoom()
            }).disposed(by: disposeBag)
    }
    private func netGetRoomList() {
        StellarProgressHUD.showHUD()
        StellarRoomManager.shared.getRoomList(success: { [weak self] in
            StellarProgressHUD.dissmissHUD()
            for roomModel in StellarRoomManager.shared.myRooms {
                self?.dataList.append((roomModel,false))
            }
            if let index = self?.dataList.firstIndex(where: {$0.room.id == self?.selectRoomId}) {
                self?.dataList[index].isSelected = true
                self?.lastSelectIndex = index
            }
            self?.tableView.reloadData()
        }) { (message, code) in
            StellarProgressHUD.dissmissHUD()
        }
    }
    private func netChangeDeviceRoom() {
        if selectRoomId == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        StellarProgressHUD.showHUD()
        confirmButton.startIndicator()
        DevicesStore.instance.changeDeviceRoom(device: device, newRoomId: selectRoomId!, success: { [weak self] in
            NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: nil)
            StellarProgressHUD.dissmissHUD()
            self?.confirmButton.stopIndicator()
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS"))
            self?.modifyBlock?(self?.selectRoomId ?? 0)
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] in
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
            StellarProgressHUD.dissmissHUD()
            self?.confirmButton.stopIndicator()
        }
    }
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.titleLabel.text = StellarLocalizedString("ADD_DEVICE_LOCATION_DEVICE")
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - kNavigationH - 32.fit - 50.fit - getAllVersionSafeAreaBottomHeight()), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = STELLAR_COLOR_C8
        tableView.register(UINib(nibName: "SelectRoomCell", bundle: nil), forCellReuseIdentifier: "SelectRoomCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var confirmButton: StellarButton = {
        var frame = CGRect(x: 42.fit, y: kScreenHeight - 46.fit - 32.fit - getAllVersionSafeAreaBottomHeight(), width: 291.fit, height: 46.fit)
        let tempView = StellarButton.init(frame: frame)
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.style = .normal
        return tempView
    }()
}
extension DeviceLocationViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectRoomCell", for: indexPath) as! SelectRoomCell
        cell.setupData(model: dataList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == lastSelectIndex {
            return
        }
        if let lastSelectIdx = lastSelectIndex {
            dataList[lastSelectIdx].isSelected = false
            if let lasatCell = tableView.cellForRow(at: IndexPath(row: lastSelectIdx, section: 0)) as? SelectRoomCell {
                lasatCell.setUnselected()
            }
        }
        dataList[indexPath.row].isSelected = true
        if let cell = tableView.cellForRow(at: indexPath) as? SelectRoomCell {
            cell.setSelected()
        }
        selectRoomId = dataList[indexPath.row].room.id
        lastSelectIndex = indexPath.row
    }
}