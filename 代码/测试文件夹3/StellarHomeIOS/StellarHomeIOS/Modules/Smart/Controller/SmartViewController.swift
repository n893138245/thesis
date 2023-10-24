import UIKit
class SmartViewController: BaseViewController {
    var dataList = [IntelligentDetailModel]()
    private let TAG_START = 100
    private var isUserHaveLight = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        DevicesStore.instance.checkUserLightList { (isHaveLight) in
            self.noDeviceView.isHidden = isHaveLight
            self.navBar.moreButton.isHidden = !isHaveLight
            self.isUserHaveLight = isHaveLight
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    private func setupUI() {
        tableview.register(UINib(nibName: "SmartStateTableViewCell", bundle: nil), forCellReuseIdentifier: "SmartStateTableViewCell")
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        view.addSubview(noCustomSmart)
        view.addSubview(tableview)
        let bottomH = BOTTOM_HEIGHT.fit + getAllVersionSafeAreaBottomHeight()
        noCustomSmart.frame = CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - kNavigationH - bottomH)
        tableview.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(10)
            $0.left.right.equalTo(view)
            $0.bottom.equalTo(view).offset(-bottomH-10)
        }
        view.addSubview(noDeviceView)
        noDeviceView.frame = CGRect(x: 0, y: kNavigationH + 16.fit, width: kScreenWidth, height: kScreenHeight-kNavigationH-bottomH - 16.fit)
        noDeviceView.isHidden = true
        if DevicesStore.sharedStore().lights.isEmpty {
            noDeviceView.isHidden = false
            navBar.moreButton.isHidden = true
        }
    }
    private func setupActions() {
        let defaultMjHeader = BaseRefreshHeader.init { [weak self] in
            self?.netLoadData(delayChange: false)
        }
        tableview.mj_header = defaultMjHeader
        if !DevicesStore.instance.lights.isEmpty { 
            tableview.mj_header?.beginRefreshing()
        }
        navBar.rightBlock = { [weak self] in
            let vc = CreateSmartViewController()
            vc.changeBlock = {
                self?.netLoadData(delayChange: true)
            }
            vc.myDetailType = .creatType
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        noDeviceView.clickBlock = { [weak self] in
            let nav = AddDeviceBaseNavController.init(rootViewController: AddDeviceVC.init())
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICES_CHANGE)
            .subscribe({ [weak self] (_) in
                self?.netLoadData(delayChange: true)
            }).disposed(by:disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_SCENE_CHANGE)
            .subscribe({ [weak self] (_) in
                self?.netLoadData(delayChange: true)
            }).disposed(by:disposeBag)
    }
    private func pushToDetail(index: Int) {
        let model = dataList[index]
        let vc = CreateSmartViewController()
        vc.myDetailType = .detailType
        vc.smartDetailModel = model
        vc.changeBlock = { [weak self] in
            self?.removeAllTasks()
            self?.netLoadData(delayChange: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    private func removeAllTasks() {
        for index in 0..<dataList.count {
            stopTimer(index: index)
        }
    }
    private func uiReloadData(isNeedAllReload:Bool = true) {
        if isNeedAllReload {
            tableview.reloadData()
        }
        checkIntellgntCutdowns() 
    }
    private func checkIntellgntCutdowns() {
        for index in 0..<dataList.count {
            let model = dataList[index]
            if let conditon = model.condition.first {
                switch conditon.type {
                case .countdown:
                    if model.enable && model.available { 
                        startTimeWithIndex(index: index, model: model)
                    }else {
                        stopTimer(index: index)
                    }
                case .timing:
                    if model.enable && conditon.params.weekdays == nil && model.available { 
                        startOnlyOnceTimer(index: index, model: model)
                    }else {
                        stopTimer(index: index)
                    }
                default:
                    break
                }
            }
        }
    }
    private func stopTimer(index: Int) {
        let taskList = SSTimeManager.shared.taskArray.filter({$0.id == index + TAG_START})
        if !taskList.isEmpty {
            removeTimerWithIndex(index: index)
        }
    }
    private func startTimeWithIndex(index: Int, model: IntelligentDetailModel) {
        let arr = SSTimeManager.shared.taskArray.filter({$0.id == index + TAG_START})
        if !arr.isEmpty { 
            removeTimerWithIndex(index: index)
        }
        let totalTime = model.condition.first?.params.countdownTime 
        let restTime = totalTime! - String.ss.getTimeralWithUTCString(UTCtimeString: model.enableTime) 
        let timer = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] (task) in
            let count = task.repeatCount
            if count >= restTime {
                self?.removeTimerWithIndex(index: index)
                model.enable = false
                self?.tableview.reloadRow(at: IndexPath(row: index, section: 0) , with: .none)
            }else {
                guard let cell = self?.tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? SmartStateTableViewCell else {
                    return
                }
                cell.controlLabel.text = "\(StellarLocalizedString("SMART_CUTDOWN")) \(getFormatRestTime(secounds: Double(restTime - count)))"
            }
        }
        timer.id = index + TAG_START
    }
    private func startOnlyOnceTimer(index: Int,model: IntelligentDetailModel) {
        let arr = SSTimeManager.shared.taskArray.filter({$0.id == index+TAG_START})
        if !arr.isEmpty { 
            removeTimerWithIndex(index: index)
        }
        let totalTime = String.ss.getTodayTimeralWithString(timeString: model.condition.first?.params.time ?? "")
        if totalTime < 0 {
            return
        }
        let timer = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] (task) in
            let count = task.repeatCount
            print(count)
            if count >= totalTime {
                model.enable = false
                self?.tableview.reloadRow(at: IndexPath(row: index, section: 0) , with: .none)
            }
        }
        timer.id = index + TAG_START
    }
    private func removeTimerWithIndex(index: Int) {
        SSTimeManager.shared.removeTask(id: index + TAG_START)
    }
    private func netLoadData(delayChange: Bool) {
        if !delayChange {
            StellarProgressHUD.showHUD()
        }
        SmartStore.sharedStore.queryAllIntelligents(success: { [weak self] (arr) in
            StellarProgressHUD.dissmissHUD()
            self?.tableview.mj_header?.endRefreshing()
            if arr.count > 0 {
                StellarAppManager.sharedManager.user.myIntelligentsModelArr = arr
                self?.noCustomSmart.isHidden = true
                self?.dataList = arr
                self?.uiReloadData()
            }else {
                self?.dataList = []
                self?.tableview.reloadData()
                self?.noCustomSmart.isHidden = false
            }
        }) {[weak self] (err) in
            self?.tableview.mj_header?.endRefreshing()
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("SMART_NET_ERROR"))
        }
    }
    private func netQueryIntell(id: String) {
        StellarProgressHUD.showHUD()
        SmartStore.sharedStore.queryDetailIntelligent(id: id, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(IntelligentDetailModel.self)
            guard let index = self.dataList.firstIndex(where: {$0.id == id}) else {
                self.openFailure()
                return
            }
            self.dataList.remove(at: index)
            self.dataList.insert(model, at: index)
            self.openSuccess(index: index)
        }) { (_) in
            StellarProgressHUD.dissmissHUD()
            self.openFailure()
        }
    }
    private func netEnable(index: Int) {
        StellarProgressHUD.showHUD()
        let model = dataList[index]
        SmartStore.sharedStore.excuteDetailIntelligent(id: model.id, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let cmmModel = jsonDic.kj.model(CommonResponseModel.self)
            if cmmModel.code == 0 {
                self?.netQueryIntell(id: model.id)
            }else {
                self?.openFailure()
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.openFailure()
        }
    }
    private func netDisable(index: Int) {
        StellarProgressHUD.showHUD()
        let model = dataList[index]
        SmartStore.sharedStore.disableDetailIntelligent(id: model.id, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let cmmModel = jsonDic.kj.model(CommonResponseModel.self)
            if cmmModel.code == 0 {
                model.enable = false
                self?.closeSuccess(index: index)
            }else {
                self?.closeFailure()
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.closeFailure()
        }
    }
    private func openFailure() {
        tableview.reloadData()
        TOAST(message: StellarLocalizedString("SMART_OPEN_FAIL"))
    }
    private func closeFailure() {
        tableview.reloadData()
        TOAST(message: StellarLocalizedString("SMART_CLOSE_FAIL"))
    }
    private func openSuccess(index: Int) {
        guard let cell = tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? SmartStateTableViewCell else {
            return
        }
        let model = dataList[index]
        cell.openBgAnimation(model: model, index: index) { [weak self] in 
            guard let condition = model.condition.first else { return }
            self?.tableview.reloadRow(at: IndexPath(row: index, section: 0), with: .none)
            if condition.type == .countdown {
                self?.startTimeWithIndex(index: index, model: model)
            }else {
                if condition.params.weekdays == nil { 
                    self?.startOnlyOnceTimer(index: index, model: model)
                }
            }
        }
    }
    private func closeSuccess(index: Int) {
        guard let cell = tableview.cellForRow(at: IndexPath(row: index, section: 0)) as? SmartStateTableViewCell else {
            return
        }
        cell.closeBgAnimation { [weak self] in
            self?.removeTimerWithIndex(index: index)
            self?.tableview.reloadRow(at: IndexPath(row: index, section: 0), with: .none)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    lazy var noCustomSmart:NoCustomSmartView = {
        let view = NoCustomSmartView.NoCustomSmartView()
        view.isHidden = true
        return view
    }()
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.separatorColor = UIColor.clear
        return view
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backButton.isHidden = true
        tempView.moreButton.setImage(UIImage(named: "icon_add_scene"), for: .normal)
        tempView.titleLabel.text = StellarLocalizedString("SMART_TITLE")
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var noDeviceView:NoDeviceView = {
        let view = NoDeviceView.noDeviceView()
        return view
    }()
}
extension SmartViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isUserHaveLight {
            return 0
        }
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmartStateTableViewCell", for: indexPath) as! SmartStateTableViewCell
        cell.selectionStyle = .none
        let model = dataList[indexPath.row]
        cell.setupData(model: model, index: indexPath.row)
        cell.pushToDetailBlock = { [weak self] in
            self?.pushToDetail(index: indexPath.row)
        }
        cell.switchBlock = { [weak self] (on) in
            if on {
                self?.netEnable(index: indexPath.row)
            }else {
                self?.netDisable(index: indexPath.row)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        guard let condition = model.condition.first else {
            return
        }
        if condition.type == .countdown && model.available && model.enable {
            let totalTime = condition.params.countdownTime 
            let restTime = totalTime - String.ss.getTimeralWithUTCString(UTCtimeString: String.ss.getUTCEnableTimeWithNow()) - String.ss.getTimeralWithUTCString(UTCtimeString: model.enableTime) 
            guard let pCell = cell as? SmartStateTableViewCell else {
                return
            }
            pCell.controlLabel.text = "\(StellarLocalizedString("SMART_CUTDOWN")) \(getFormatRestTime(secounds: Double(restTime)))"
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else{
            return
        }
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.pushToDetail(index: indexPath.row)
            }
        }
    }
}