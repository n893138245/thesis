import UIKit
class ControllRoomViewController: BaseViewController {
    var dataList = [[String]]()
    var creatGroupDataModel = CreatGroupDataModel()
    var isModify = false
    var modifyBlock: ((_ roomId :Int) ->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
    }
    private func setupUI() {
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 114))
        header.addSubview(titleLabel)
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth - 20, height: 45)
        tableView.tableHeaderView = header
        header.addSubview(hintView)
        view.addSubview(emptyRoomView)
        emptyRoomView.frame = CGRect(x: 0, y: 114 + 42 + getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: kScreenHeight - kNavigationH - 114 - 42 - getAllVersionSafeAreaBottomHeight())
        emptyRoomView.isHidden = true
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func setupData() {
        if DevicesStore.instance.lights.isEmpty {
            emptyRoomView.isHidden = false
            tableView.isScrollEnabled = false
            return
        }
        var arr = DevicesStore.instance.hasLightsAllRoomsName
        dataList.append(["全部"])
        for room in arr {
            var lights = [LightModel]()
            if room == "全部" {
                lights = DevicesStore.sharedStore().lights.filter({$0.remoteType != .locally})
            }else {
                lights = DevicesStore.sharedStore().sortedLightsDic[StellarRoomManager.shared.getRoom(roomName: room).id ?? 1]?.filter({$0.remoteType != .locally}) ?? [LightModel]()
            }
            if lights.isEmpty {
                arr.removeAll(where: {$0 == room})
            }
        }
        dataList.append(arr)
        tableView.reloadData()
    }
    private func showActionView(roomName: String) {
        let bottomPopView = SSBottomPopView.SSBottomPopView()
        let fac = HBottomSelectionDetailLightsFactory()
        fac.actions = getAcions(roomName: roomName)
        let allLights = DevicesStore.instance.lights
        if roomName == "全部" {
            fac.devices = allLights.filter({$0.remoteType != .locally})
        }else {
            let roomId = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
            fac.devices = allLights.filter({$0.room == roomId && $0.remoteType != .locally})
        }
        bottomPopView.setDisplayFactory(factory: fac)
        bottomPopView.setupViews(title: roomName, leftClick: nil)
        bottomPopView.setContentHeight(height: CGFloat(155 + 75 * fac.actions.count))
        bottomPopView.show()
        fac.actionChangeBlock = { [weak self, weak bottomPopView] actionType in
            bottomPopView?.hidden {
                switch actionType {
                case .on:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "on", roomName: roomName)
                case .off:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "off", roomName: roomName)
                case .autoOnOff:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "autoOnOff", roomName: roomName)
                case.brightness:
                    self?.pushToBritness(roomName: roomName)
                case.color:
                    self?.pushToColor(roomName: roomName)
                }
            }
        }
    }
    private func getAcions(roomName: String) -> [ActionTriats] {
        var actions: [ActionTriats] = [.on,.off,.autoOnOff,.brightness] 
        let roomId = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
        var triats = [Traits]()
        if roomId == 0 {
            triats = DevicesStore.instance.getSumOfTriats(lights: DevicesStore.instance.lights)
        }else {
            triats = DevicesStore.instance.getSumOfTriats(lights: DevicesStore.instance.sortedLightsDic[roomId] ?? [LightModel]())
        }
        if triats.contains(.color) || triats.contains(.colorTemperature) {
            if !actions.contains(.color) {
                actions.append(.color)
            }
        }
        return actions
    }
    private func creatOnOffOrAutoOnOffGroup(onOffString: String, roomName: String) {
        let param = ExecutionDetailParams()
        param.onOff = onOffString
        let roomId = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
        let group = GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: param, command: .onOff, roomId: roomId)
        let userInfo = ["userInfo":group]
        NotificationCenter.default.post(name: .Scenes_SetDeviceStatusComplete, object: nil, userInfo: userInfo)
        switch creatGroupDataModel.sourceVc {
        case .panelSetting:
            popToViewController(withClass: SwitchSettingViewController.className())
        case .creatScense:
            popToViewController(withClass: SceneDetailViewController.className())
        case .creatSmart:
            popToViewController(withClass: CreateSmartViewController.className())
        default:
            break
        }
    }
    private func pushToBritness(roomName: String) {
        let vc = BrightnessControlViewController()
        vc.excution = getInitBrightnessAction(roomName: roomName)
        vc.creatGroupDataModel = creatGroupDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    private func pushToColor(roomName: String) {
        let vc = ControlColorViewController()
        vc.creatGroupDataModel = creatGroupDataModel
        vc.excution = getInitRGBAction(roomName: roomName)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func getInitBrightnessAction(roomName: String) -> ExecutionModel {
        let execution = ExecutionModel()
        execution.room = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
        let detail = ExecutionDetail()
        detail.command = .brightness
        let params = ExecutionDetailParams()
        params.brightness = 50
        detail.params = params
        execution.execution.append(detail)
        return execution
    }
    private func getInitRGBAction(roomName: String) -> ExecutionModel {
        let execution = ExecutionModel()
        execution.room = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
        let detail = ExecutionDetail()
        detail.command = .color
        let params = ExecutionDetailParams()
        params.color = (255,255,255)
        detail.params = params
        execution.execution.append(detail)
        return execution
    }
    lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "ControlRoomCell", bundle: nil), forCellReuseIdentifier: "ControlRoomCell")
        tempView.separatorStyle = .none
        return tempView
    }()
    lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.moreButton.isHidden = true
        tempView.titleLabel.text = ""
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.text = "控制房间"
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
    private lazy var hintView:ScenseTitleTipView = {
        let tempView = ScenseTitleTipView.init(frame: CGRect(x: 0, y: 42, width: kScreenWidth, height: 72),title: "请选择房间")
        return tempView
    }()
    private lazy var emptyRoomView: NoEnabledSceneView = {
        let view = NoEnabledSceneView.NoEnabledSceneView()
        view.setupViews(title: StellarLocalizedString("EQUIPMENT_NOROOM_CONTROLL"))
        return view
    }()
}
extension ControllRoomViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataArray = dataList[section]
        return dataArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ControlRoomCell", for: indexPath) as! ControlRoomCell
        cell.selectionStyle = .none
        let room = dataList[indexPath.section][indexPath.row]
        var isConflict = false
        if creatGroupDataModel.controlRoomType == .allRoom && indexPath.section == 1 {
            isConflict = true
        }else if creatGroupDataModel.controlRoomType == .otherRoom && indexPath.section == 0 {
            isConflict = true
        }
        cell.setData(room: room, conflict: isConflict)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isConflict = false
        if creatGroupDataModel.controlRoomType == .allRoom && indexPath.section == 1 {
            isConflict = true
        }else if creatGroupDataModel.controlRoomType == .otherRoom && indexPath.section == 0 {
            isConflict = true
        }
        if isConflict {
            TOAST_BOTTOM(message: "全部和其余房间不能同时存在一个场景中\n请删除房间操作后再添加")
            return
        }
        if isModify { 
            indexPath.section == 0 ? modifyBlock?(0):modifyBlock?(StellarRoomManager.shared.getRoom(roomName: dataList[indexPath.section][indexPath.row]).id ?? 0)
            navigationController?.popViewController(animated: true)
        }else {
            showActionView(roomName: dataList[indexPath.section][indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        let label = UILabel.init(frame: CGRect(x: 20, y: 14, width: kScreenWidth - 20, height: 20))
        label.textColor = STELLAR_COLOR_C6
        label.text = "单个房间控制"
        label.font = STELLAR_FONT_T14
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 50
    }
}
extension ControllRoomViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 45 - kNavigationH {
            navBar.titleLabel.text = ""
        }else
        {
            navBar.titleLabel.text = "控制房间"
        }
    }
}