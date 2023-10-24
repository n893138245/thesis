import UIKit
enum SelectType {
    case select,change
}
class SelectLightsViewController: BaseViewController {
    var sigalExtutionBlock: ((_ lightOnOff: GroupModel) ->Void)?
    var creatGroupDataModel = CreatGroupDataModel()
    var selectedType: SelectType = .select 
    var selctedLights = [LightModel]()
    var selectCompleteBlock: ((_ selectLights: [LightModel]) -> Void)? 
    private var currentPage = 0
    private let HEAD_HEIGHT: CGFloat = 114 
    private let NORMAL_NAV_HEIGHT: CGFloat = 44 
    private let TITLE_SCROLL_HEIGHT: CGFloat = 46 
    private var tableArr = [UITableView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        setupData()
    }
    private func setupUI() {
        setupHeader()
    }
    private func setupHeader() {
        view.backgroundColor = STELLAR_COLOR_C3
        navView.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(bgScrollView)
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 44 + getAllVersionSafeAreaTopHeight())
        titleView.frame = CGRect.init(x: 0, y: navView.frame.maxY, width: kScreenWidth, height: 114)
        titleView.addSubview(tipView)
        let titleLabel = UILabel()
        titleLabel.text = StellarLocalizedString("SMART_CONTROL_DEVICE")
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-100, height: 45)
        titleView.addSubview(titleLabel)
        view.addSubview(titleView)
        titleScrollView.frame = CGRect.init(x: 0, y: navView.frame.maxY + 114, width: kScreenWidth, height: 46)
        lineView.frame = CGRect.init(x: 0, y: titleScrollView.frame.maxY, width: kScreenWidth, height: 20)
        let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.ss.rgbColor(222, 222, 222).cgColor,UIColor.ss.rgbColor(255, 255, 255).cgColor])
        gradientLayer.frame = lineView.bounds
        lineView.layer.insertSublayer(gradientLayer, at: 0)
        lineView.alpha = 0.4
        lineView.isHidden = true
        view.addSubview(lineView)
        var rooms = DevicesStore.instance.hasLightsAllRoomsName
        rooms.insert("全部", at: 0)
        titleScrollView.setRoomsAndSelectedIndex(rooms: rooms) { [weak self] (page) in
            self?.setBgOffset(page: page)
        }
        titleScrollView.backgroundColor = STELLAR_COLOR_C3
        titleScrollView.style = .upStyle
        view.addSubview(titleScrollView)
        setupContent(rooms: rooms)
        view.addSubview(navView)
        view.addSubview(allSelectButton)
        if isChinese() {
            allSelectButton.frame = CGRect(x: kScreenWidth - 90, y: navView.frame.maxY + 18, width: 66, height: 22 )
        }else {
            allSelectButton.frame = CGRect(x: kScreenWidth - 150, y: navView.frame.maxY + 18, width: 130, height: 22 )
        }
    }
    private func setupContent(rooms: [String]) {
        view.addSubview(bottomButton)
        if selectedType == .select {
            bottomButton.setTitle(StellarLocalizedString("COMMON_NEXT"), for: .normal)
        }else if selectedType == .change {
            bottomButton.setTitle(StellarLocalizedString("COMMON_CPMPLETE"), for: .normal)
        }
        bottomButton.isEnabled = false
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-32.fit-getAllVersionSafeAreaBottomHeight())
            $0.width.equalTo(291.fit)
            $0.height.equalTo(46.fit)
            $0.centerX.equalTo(view)
        }
        bgScrollView.clipsToBounds = false
        bgScrollView.contentSize = CGSize(width: kScreenWidth*CGFloat(rooms.count), height: 0)
        for idx in 0..<rooms.count {
            let listView = SelectLightsListView.init(frame: CGRect(x: kScreenWidth*CGFloat(idx), y: 0 , width: kScreenWidth, height: bgScrollView.frame.height), title: rooms[idx])
            listView.tableview.tag = 100 + idx
            bgScrollView.addSubview(listView)
            self.tableArr.append(listView.tableview)
            setupTableViewDelegateFunc(tableView: listView.tableview)
            listView.clipsToBounds = false
        }
    }
    private func setupTableViewDelegateFunc(tableView: UITableView) {
        tableView.rx.contentOffset
            .subscribe { [weak self] (contentOffset) in
                let contentOffsetY:CGFloat = contentOffset.element!.y
                self?.setupTableViewScroll(contentOffsetY: contentOffsetY, currentTableView: tableView)
        }.disposed(by: disposeBag)
        tableView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] (_) in
                self?.setupBorderTableViewStyle(currentTableView: tableView)
            }).disposed(by: disposeBag)
        tableView.rx.didEndDragging
            .subscribe(onNext: { [weak self] (_) in
                self?.setupBorderTableViewStyle(currentTableView: tableView)
            }).disposed(by: disposeBag)
    }
    private func setupTableViewScroll(contentOffsetY: CGFloat, currentTableView: UITableView) {
        if (currentTableView.tag - 100) != currentPage {
            return
        }
        if Int(contentOffsetY) < Int(HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT){
            if contentOffsetY == 0{
                bgScrollView.isScrollEnabled = true
            }else{
                bgScrollView.isScrollEnabled = false
            }
        }else{
            bgScrollView.isScrollEnabled = true
        }
        if Int(contentOffsetY) < Int(HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT){
            titleView.frame.origin.y = -contentOffsetY + getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT
            titleScrollView.frame.origin.y = -contentOffsetY + getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT + HEAD_HEIGHT
            let allSeletcY = -contentOffsetY + getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT + 18
            if allSeletcY < 11+getAllVersionSafeAreaTopHeight() {
                allSelectButton.frame.origin.y = 13+getAllVersionSafeAreaTopHeight()
                navView.titleLabel.text = StellarLocalizedString("SMART_CONTROL_DEVICE")
            }else {
                allSelectButton.frame.origin.y = allSeletcY
                navView.titleLabel.text = ""
            }
            let topViewAlpha:CGFloat = 1 - (contentOffsetY)/(HEAD_HEIGHT+TITLE_SCROLL_HEIGHT - (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT))
            titleView.alpha = topViewAlpha
        }
        else{
            titleView.frame.origin.y = -(HEAD_HEIGHT + (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT))
            titleScrollView.frame.origin.y = (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT)
            allSelectButton.frame.origin.y = 13+getAllVersionSafeAreaTopHeight()
            navView.titleLabel.text = StellarLocalizedString("SMART_CONTROL_DEVICE")
        }
    }
    private func setupBorderTableViewStyle(currentTableView: UITableView) {
        let contentOffsetY = currentTableView.contentOffset.y
        if contentOffsetY < 0 {
            setOtherOffset(offset: CGPoint.zero, currentTable: currentTableView)
            return
        }
        if contentOffsetY < (HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT){
            if contentOffsetY < (HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT)/2.0{
                currentTableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                setOtherOffset(offset: CGPoint.zero, currentTable: currentTableView)
            }else{
                currentTableView.setContentOffset(CGPoint.init(x: 0, y: HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT), animated: true)
                setOtherOffset(offset: CGPoint(x: 0, y: HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT), currentTable: currentTableView)
            }
        }else{
            setOtherOffset(offset: CGPoint(x: 0, y: HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT), currentTable: currentTableView)
        }
    }
    private func setOtherOffset(offset: CGPoint, currentTable: UITableView) {
        for tableView in tableArr {
            if tableView != currentTable {
                tableView.setContentOffset(offset, animated: false)
            }
        }
    }
    private func setupRx() {
        bgScrollView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] (_) in
                self?.setTitleSelectedIndex()
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification (.NOTIFY_SELECTDEVICES_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                let list = notify.userInfo?["seclectDevice"] as? [(light:LightModel,selected:Bool)] ?? [(LightModel,Bool)]()
                self?.didReceiveResult(result: list)
            }).disposed(by: disposeBag)
        bottomButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                if self?.selectedType == .select {
                    self?.showBottomView()
                }else {
                    self?.changeCompelet()
                }
            }).disposed(by: disposeBag)
        allSelectButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.allSelectButton.isSelected = !(self?.allSelectButton.isSelected ?? false)
                var selectData = [(LightModel,Bool)]()
                for light in (self?.getOnlineLightsByPage(page: self?.currentPage ?? 0)) ?? [LightModel]() {
                    selectData.append((light,(self?.allSelectButton.isSelected)!))
                }
                NotificationCenter.default.post(name: .NOTIFY_SELECTDEVICES_CHANGE, object: nil, userInfo: ["seclectDevice":selectData])
            }).disposed(by: disposeBag)
    }
    private func didReceiveResult(result: [(light:LightModel,selected:Bool)]) {
        result.forEach { (model) in
            if model.selected {
                if !(selctedLights.contains(where: {$0.sn == model.light.sn})) {
                    selctedLights.append(model.light)
                }
            }else {
                if selctedLights.contains(where: {$0.sn == model.light.sn}) {
                    selctedLights.removeAll(where: {$0.sn == model.light.sn})
                }
            }
        }
        allSelectButton.isSelected = (isAllSelect(page: currentPage ))
        bottomButton.isEnabled = selctedLights.count > 0 ? true:false
    }
    private func setupData() {
        if selctedLights.count > 0 {
            var list = [(LightModel,Bool)]()
            for light in selctedLights {
                list.append((light,true))
            }
            NotificationCenter.default.post(name: .NOTIFY_SELECTDEVICES_CHANGE, object: nil, userInfo: ["seclectDevice":list])
        }
        if isAllSelect(page: 0) {
            allSelectButton.isSelected = true
        }
        allSelectButton.isHidden = DevicesStore.instance.lights.filter({$0.remoteType != .locally}).count == 0
    }
    private func setBgOffset(page: Int) {
        var offset = bgScrollView.contentOffset
        offset.x = kScreenWidth * CGFloat(page)
        UIView.animate(withDuration: 0.25) {
            self.bgScrollView.contentOffset = offset
        }
        self.currentPage = page
        allSelectButton.isSelected = isAllSelect(page: Int(page))
    }
    private func setTitleSelectedIndex() {
        let offset = bgScrollView.contentOffset
        let page = offset.x/kScreenWidth
        titleScrollView.tapActionWith(index: Int(page), animated: true)
        self.currentPage = Int(page)
        allSelectButton.isSelected = isAllSelect(page: Int(page))
    }
    private func getOnlineLightsByPage(page: Int) -> [LightModel] {
        var rooms = DevicesStore.instance.hasLightsAllRoomsName
        rooms.insert("全部", at: 0)
        var roomLights = [LightModel]()
        if page == 0 {
            roomLights = DevicesStore.instance.lights
        }else {
            let room = rooms[page]
            if let roomId = StellarRoomManager.shared.getRoom(roomName: room).id {
                roomLights = DevicesStore.instance.sortedLightsDic[roomId] ?? [LightModel]()
            }
        }
        return roomLights.filter({$0.remoteType != .locally})
    }
    private func isAllSelect(page: Int) -> Bool {
        var allSelect = true
        let lights = getOnlineLightsByPage(page: page)
        let onlineLightSn = lights.map {$0.sn}
        let selectSn = selctedLights.map{$0.sn}
        for onlineSn in onlineLightSn {
            if !selectSn.contains(onlineSn) {
                allSelect = false
                break
            }
        }
        return allSelect
    }
    private func showBottomView() {
        let devices = selctedLights
        let bottomPopView = SSBottomPopView.SSBottomPopView()
        let fac = HBottomSelectionDetailLightsFactory()
        fac.actions = getBottomActions()
        fac.devices = devices
        bottomPopView.setDisplayFactory(factory: fac)
        bottomPopView.setupViews(title: "\(devices.count)\(StellarLocalizedString("SMART_DEVICE_COUNT"))", leftClick: nil)
        bottomPopView.setContentHeight(height: CGFloat(155 + 75 * fac.actions.count))
        bottomPopView.show()
        fac.actionChangeBlock = { [weak self, weak bottomPopView] actionType in
            bottomPopView?.hidden {
                switch actionType {
                case .on:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "on")
                case .off:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "off")
                case .autoOnOff:
                    self?.creatOnOffOrAutoOnOffGroup(onOffString: "autoOnOff")
                case.brightness:
                    self?.pushToBritness()
                case.color:
                    self?.pushToColor()
                }
            }
        }
    }
    private func getBottomActions() -> [ActionTriats] {
        var actions: [ActionTriats] = [.on,.off,.autoOnOff,.brightness] 
        for light in selctedLights {
            for triat in light.traits ?? [Traits]() {
                if triat == .color || triat == .colorTemperature || triat == .internalScene, !actions.contains(.color) {
                    actions.append(.color) 
                    break
                }
            }
        }
        return actions
    }
    private func changeCompelet() {
        selectCompleteBlock?(selctedLights)
        navigationController?.popViewController(animated: true)
    }
    private func creatOnOffOrAutoOnOffGroup(onOffString: String) {
        let param = ExecutionDetailParams()
        param.onOff = onOffString
        let group = GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: param, command: .onOff, lights: selctedLights)
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
    private func pushToBritness() {
        let vc = BrightnessControlViewController()
        vc.lampModel = selctedLights.first
        vc.lightGroup = selctedLights
        vc.creatGroupDataModel = creatGroupDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    private func pushToColor() {
        let vc = ControlColorViewController()
        vc.creatGroupDataModel = creatGroupDataModel
        vc.lightGroup = selctedLights
        navigationController?.pushViewController(vc, animated: true)
    }
    private lazy var navView:DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var titleScrollView:TitleScrollView = {
        let view = TitleScrollView()
        return view
    }()
    private lazy var bgScrollView: UIScrollView = {
        let view = UIScrollView()
        let scorllViewY: CGFloat = getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA
        let collectViewHeight: CGFloat = kScreenHeight - scorllViewY - getAllVersionSafeAreaBottomHeight()
        view.frame = CGRect(x: 0, y: scorllViewY, width: kScreenWidth, height: collectViewHeight)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private lazy var titleView:UIView = {
        let view = UIView()
        return view
    }()
    private lazy var lineView:UIView = {
        let view = UIView()
        return view
    }()
    private lazy var bottomButton:StellarButton = {
        let view = StellarButton.init()
        view.style = .normal
        return view
    }()
    private lazy var allSelectButton:UIButton = {
        let view = UIButton.init(type: .custom)
        view.setTitle(StellarLocalizedString("ADD_DEVICE_FUTRURE_GENERATION"), for: .normal)
        view.setTitle(StellarLocalizedString("ADD_DEVICE_CANCEL_ALL"), for: .selected)
        view.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        view.titleLabel?.font = STELLAR_FONT_MEDIUM_T16
        return view
    }()
    lazy var tipView:ScenseTitleTipView = {
        let view = ScenseTitleTipView.init(frame: CGRect(x: 0, y: 42, width: kScreenWidth, height: 72),title: StellarLocalizedString("SCENE_SELECT_DEVICE_TIP"))
        return view
    }()
}