import UIKit
class SelectLightsListView: UIView {
    private let disposeBag = DisposeBag()
    private let all = "全部"
    private var dataList = [(light:LightModel,selected:Bool)]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        setupUI()
        loadData(title: title)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = STELLAR_COLOR_C3
        addSubview(tableview)
        let TABLE_HAED_HEIGHT: CGFloat = 114+46
        let TABLE_HEIGT = kScreenHeight - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA - getAllVersionSafeAreaBottomHeight() - getAllVersionSafeAreaTopHeight() - 46.fit - 32.fit - 30.0
        tableview.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: TABLE_HEIGT)
        tableview.showsVerticalScrollIndicator = false
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: TABLE_HAED_HEIGHT))
        tableview.tableHeaderView = headerView
        tableview.register(UINib(nibName: "ElementTableViewCell", bundle: nil), forCellReuseIdentifier: "ElementTableViewCell")
        NotificationCenter.default.rx.notification (.NOTIFY_SELECTDEVICES_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let list = notify.userInfo?["seclectDevice"] as? [(light:LightModel,selected:Bool)] else {
                    return
                }
                for model in list {
                    for index in 0..<(self?.dataList.count ?? 0) {
                        if self?.dataList[index].light.sn == model.light.sn {
                            self?.dataList[index].selected = model.selected
                        }
                    }
                }
                self?.tableview.reloadData()
            }).disposed(by: disposeBag)
        addSubview(emptyDeviceView)
        emptyDeviceView.frame = CGRect(x: 0, y: TABLE_HAED_HEIGHT, width: kScreenWidth, height: kScreenHeight - TABLE_HAED_HEIGHT - BOTTOMBUTTON_BOTTOM_CONSTRAINT - kNavigationH - 10)
        emptyDeviceView.isHidden = true
    }
    private func loadData(title: String) {
        if DevicesStore.instance.lights.isEmpty {
            emptyDeviceView.isHidden = false
            tableview.isScrollEnabled = false
            return
        }
        if title == all {
            let allLights = DevicesStore.instance.lights
            for light in allLights {
                dataList.append((light: light, selected: false))
            }
        }else {
            let roomId = StellarRoomManager.shared.getRoom(roomName: title).id ?? 0
            guard let roomLights = DevicesStore.instance.sortedLightsDic[roomId] else {
                return
            }
            for light in roomLights {
                dataList.append((light: light, selected: false))
            }
        }
        dataList.sort { (model, _) -> Bool in
            return model.light.status.online
        }
        addFooterIfNeed()
        tableview.reloadData()
    }
    private func addFooterIfNeed() {
        let TOP_VIEW_HEIGHT: CGFloat = 46
        let BOTTOM_SPACE: CGFloat = 46.fit+32+30
        let visibleHeight = kScreenHeight - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA - getAllVersionSafeAreaTopHeight() - getAllVersionSafeAreaBottomHeight() - TOP_VIEW_HEIGHT - BOTTOM_SPACE 
        let tableContentHeight = 85*dataList.count
        if CGFloat(tableContentHeight) < visibleHeight {
            let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: visibleHeight - CGFloat(tableContentHeight)))
            tableview.tableFooterView = footerView
        }
    }
    func allSelect(select: Bool) {
        for index in 0..<dataList.count {
            dataList[index].selected = select
        }
        tableview.reloadData()
    }
    deinit {
        print(classForCoder)
    }
    lazy var tableview: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        return view
    }()
    private lazy var emptyDeviceView: NoEnabledSceneView = {
        let view = NoEnabledSceneView.NoEnabledSceneView()
        view.setupViews(title: StellarLocalizedString("EQUIPMENT_NODEVICE_CONTROLL"))
        return view
    }()
}
extension SelectLightsListView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElementTableViewCell", for: indexPath) as! ElementTableViewCell
        cell.setUpDatas(model: dataList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataList[indexPath.row].light.remoteType == .locally {
            TOAST(message: StellarLocalizedString("SCENE_SELECT_DEVICE_UNSUPPORT"))
            return
        }
        dataList[indexPath.row].selected = !dataList[indexPath.row].selected
        if let cell = tableView.cellForRow(at: indexPath) as? ElementTableViewCell {
            dataList[indexPath.row].selected ? cell.setSelected():cell.setUnselected()
        }
        NotificationCenter.default.post(name: .NOTIFY_SELECTDEVICES_CHANGE, object: nil, userInfo: ["seclectDevice":dataList])
    }
}