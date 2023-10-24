import UIKit
let BOTTOMBUTTON_BOTTOM_CONSTRAINT = 24.fit + 46.fit + kBottomArcH
class CreateSmartViewController: BaseViewController {
    private var condition:IntelligentDetailModelCondition?
    var smartDetailModel: IntelligentDetailModel?
    var changeBlock: (() ->Void)?
    private var timer: SSTimeTask?
    private var dataList: [GroupModel] = [] { 
        didSet {
            didReciveDataChange()
        }
    }
    var myDetailType: SceneDetailType = .creatType
    private var fristHeadHeight: CGFloat = 162.fit + getAllVersionSafeAreaTopHeight()
    private var isPush = false
    private var style: UIStatusBarStyle = .lightContent {
        didSet{
            if style != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        bindViewModel()
        loadSubViews()
        setupNotifiCations()
        setupActions()
        setupData()
        BackNetManager.sharedManager.copyDeviceList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPush = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isPush {
            removeTimer()
            BackNetManager.sharedManager.restDeviceStatus() 
        }
    }
    private func bindViewModel() {
        viewModel.delegate = self
        viewModel.myDetailType = myDetailType
        viewModel.updateSmartModel(model: smartDetailModel)
    }
    private func loadSubViews(){
        loadTableView()
        loadHeadView()
        loadConditionView()
        loadOperationView()
        loadBottom()
    }
    private func loadTableView(){
        tableview.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kBottomArcH)
        view.addSubview(tableview)
        tableHeadView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 262.fit)
        tableview.tableHeaderView = tableHeadView
        tableview.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: BOTTOMBUTTON_BOTTOM_CONSTRAINT + 10))
    }
    private func loadHeadView(){
        view.insertSubview(headImageView, at: 0)
        headImageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: fristHeadHeight)
        if myDetailType == .detailType {
            navView.setTitle(title: StellarLocalizedString("SMART_CREAT_TITLE"),imageName: "icon_edit-2")
        }else{
            navView.setTitle(title: StellarLocalizedString("SMART_CREAT_TITLE"))
        }
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH)
        navBottomLabel.text = StellarLocalizedString("SMART_CONDITIONS_MET")
        tableHeadView.addSubview(navBottomLabel)
        navBottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(18.fit+NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
            make.left.equalTo(20.fit)
        }
    }
    private func loadConditionView(){
        tableHeadView.addSubview(conditionView)
        conditionView.frame = tableHeadView.bounds
        conditionView.setupViews(topString: StellarLocalizedString("SMART_ADD_CONDITION"), bottomString: StellarLocalizedString("SMART_ADD_CUTDOWN_EXAMPLE"), imageName: "icon_scence_if")
        conditionView.snp.makeConstraints { (make) in
            make.top.equalTo(navBottomLabel.snp.bottom).offset(16.fit)
            make.left.equalTo(9.fit)
            make.width.equalTo(kScreenWidth - 18.fit)
            make.height.equalTo(90)
        }
    }
    private func loadOperationView(){
        tableHeadView.addSubview(operationHintView)
        operationHintView.operationRightBtn.isHidden = true
        operationHintView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(conditionView.snp.bottom).offset(40.fit)
            make.height.equalTo(25.fit)
        }
    }
    private func loadBottom() {
        if myDetailType == .creatType {
            view.addSubview(bottomBtn)
            bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
            bottomBtn.isEnabled = false
        }else{
            if viewModel.isOpeningTimer() { 
                loadBottomButtonByTimer()
            }
            confirmLeftBottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 73.fit - 80.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 146.fit , height: 46.fit)
            view.addSubview(confirmLeftBottomBtn)
            confirmRightBottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 73.fit + 80.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 146.fit , height: 46.fit)
            view.addSubview(confirmRightBottomBtn)
        }
    }
    private func loadBottomButtonByTimer() {
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
        bottomBtn.isEnabled = true
        bottomBtn.isHidden = false
        bottomBtn.setTitle(StellarLocalizedString("SMART_STOP_CUTDOWN"), for: .normal)
        confirmLeftBottomBtn.isHidden = true
        confirmRightBottomBtn.isHidden = true
    }
    private func updateConditionView() {
        guard let conditon = self.condition else {
            return
        }
        checkButtonsEanbled()
        if viewModel.isOpeningTimer() {
            bottomBtn.isEnabled = true
            guard let model = smartDetailModel else { return }
            let totalTime = conditon.params.countdownTime 
            let restTime = totalTime - String.ss.getTimeralWithUTCString(UTCtimeString: String.ss.getUTCEnableTimeWithNow()) - String.ss.getTimeralWithUTCString(UTCtimeString: model.enableTime) 
            conditionView.setupViews(topString:"\(getFormatRestTime(secounds: Double(restTime)))" , bottomString: StellarLocalizedString("SMART_CUTDOWN"), imageName: "icon_scence_countdown")
            conditionView.arrow.isHidden = true
            startTimer()
        }else {
            conditionView.arrow.isHidden = false
            conditionView.setupData(condition: conditon)
        }
    }
    private func didReciveDataChange() {
        checkButtonsEanbled()
        operationHintView.operationRightBtn.isHidden = viewModel.isHiddenRightTopButton()
        tableview.reloadData()
    }
    private func checkButtonsEanbled() {
        let isEable = viewModel.isEanbleToSave(actions: dataList, condition: condition, title: navView.titleBtn.currentTitle ?? "")
        bottomBtn.isEnabled = isEable
        confirmRightBottomBtn.isEnabled = isEable
    }
    private func didScrollTableView() {
        let contentOffsetY: CGFloat = tableview.contentOffset.y
        var alphaView: CGFloat = 0
        if contentOffsetY > -getAllVersionSafeAreaTopHeight() {
            headImageView.frame = CGRect(x: 0, y: -contentOffsetY - getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: fristHeadHeight)
            alphaView = (contentOffsetY + getAllVersionSafeAreaTopHeight())/40 > 1 ? 1 :(contentOffsetY + getAllVersionSafeAreaTopHeight())/40
            navView.backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(alphaView)
            navView.myState = .kNavBlack
            style = .default
            if myDetailType == .detailType {
                navView.setTitle(title: navView.titleBtn.currentTitle ?? "", imageName: "icon_edit-1")
            }
        }else{
            headImageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: fristHeadHeight - contentOffsetY - getAllVersionSafeAreaTopHeight())
            navView.backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(0)
            navView.myState = .kNavWhite
            style = .lightContent
            if myDetailType == .detailType {
                navView.setTitle(title: navView.titleBtn.currentTitle ?? "", imageName: "icon_edit-2")
            }
        }
    }
    private func setupNotifiCations() {
        NotificationCenter.default.rx.notification (.Scenes_SetDeviceStatusComplete)
            .subscribe(onNext: { [weak self] (notify) in
                guard let newGroupModel = notify.userInfo?["userInfo"] as? GroupModel else { return }
                guard let newData = self?.viewModel.filterGroup(newGroup: newGroupModel) else { return }
                self?.dataList = newData
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.Smart_SetConditionsComplete)
            .subscribe(onNext: { [weak self] (notify) in
                guard let notifyCondition = notify.userInfo?["info"] as? IntelligentDetailModelCondition else { return }
                self?.condition = notifyCondition
                self?.updateConditionView()
            }).disposed(by: disposeBag)
    }
    private func setupActions() {
        bottomBtn.rx.tap
            .subscribe(onNext:{ [weak self] in
                guard let copySelf = self else { return }
                if copySelf.viewModel.isOpeningTimer() { 
                    self?.netDisable()
                }else {
                    self?.navView.titleBtn.currentTitle == "创建智能" ? self?.showAddNameAlert():self?.addOrModifyActions()
                }
            }).disposed(by: disposeBag)
        confirmLeftBottomBtn.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.showDeletAlert()
            }).disposed(by: disposeBag)
        confirmRightBottomBtn.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.addOrModifyActions()
            }).disposed(by: disposeBag)
        if myDetailType == .detailType {
            navView.titleClickBlock = { [weak self] title in
                guard let copySelf = self else { return }
                if copySelf.viewModel.isOpeningTimer() {
                    TOAST(message: StellarLocalizedString("ALERT_OFF_COUNTER"))
                }else {
                    self?.showAddNameAlert(text: title)
                }
            }
        }
        operationHintView.operationRightBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let copySelf = self else { return }
                if copySelf.viewModel.isOpeningTimer() {
                    TOAST(message: StellarLocalizedString("ALERT_OFF_COUNTER"))
                }else {
                    self?.pushToAddOperationViewController()
                }
            }).disposed(by: disposeBag)
        conditionView.clickBlock = { [weak self] in
            guard let copySelf = self else { return }
            if copySelf.viewModel.isOpeningTimer() {
                TOAST(message: StellarLocalizedString("ALERT_OFF_COUNTER"))
            }else {
                self?.isPush = true
                let vc = AddConditionViewController()
                vc.condition = self?.condition
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableview.rx.didScroll
            .subscribe(onNext: { [weak self] (_) in
                self?.didScrollTableView()
            }).disposed(by: disposeBag)
    }
    private func showAddNameAlert(text:String = "") {
        let alert = StellarTextFieldAlertView.stellarTextFieldAlertView()
        alert.isVoiceControl = false
        alert.setTitleTextFieldType(title: StellarLocalizedString("SMART_NAME"), secondTitle: "", leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        alert.rightButtonBlock = { [weak self] (name) in
            self?.confirmName(name: name.ss.spaceNewLineString())
        }
        view.addSubview(alert)
        alert.showView(text: text)
    }
    private func confirmName(name: String) {
        if myDetailType == .creatType {
            navView.setTitle(title: name)
            addOrModifyActions()
        }else {
            navView.setTitle(title: name, imageName: "icon_edit-2")
            checkButtonsEanbled()
        }
    }
    private func showDeletAlert() {
        let alert = StellarMineAlertView.init(message: "\(StellarLocalizedString("SMART_MAKE_SURE_DELET")) “\(smartDetailModel?.name ?? "")” \(StellarLocalizedString("SMART_MAKE_SURE"))", leftTitle: StellarLocalizedString("SMART_DELET_OK"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.leftClickBlock = { [weak self] in
            self?.netDeletIntelligents()
        }
        alert.show()
    }
    private func setupData() {
        guard let detailModel = smartDetailModel else { return }
        navView.setTitle(title: detailModel.name, imageName: "icon_edit-2")
        condition = detailModel.condition.first
        if detailModel.actions.count > 0 {
            dataList = viewModel.getDataWithAcions(actions: detailModel.actions)
        }
        updateConditionView()
    }
    private func startTimer() {
        if timer != nil {
            return
        }
        let totalTime = smartDetailModel?.condition.first?.params.countdownTime ?? 0 
        let restTime = totalTime - String.ss.getTimeralWithUTCString(UTCtimeString: smartDetailModel?.enableTime ?? "") 
        timer = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] (task) in
            self?.setupUIWithTimer(repeatCount: task.repeatCount, restTime: restTime)
        }
    }
    private func setupUIWithTimer(repeatCount: Int, restTime: Int) {
        if repeatCount >= restTime {
            clearData()
        }else {
            DispatchQueue.main.async {
                self.conditionView.setupViews(topString:"\(getFormatRestTime(secounds: Double(restTime - repeatCount)))" , bottomString: StellarLocalizedString("SMART_CUTDOWN"), imageName: "icon_scence_countdown")
            }
        }
    }
    private func removeTimer() {
        guard let timerTask = timer else { return }
        SSTimeManager.shared.removeTask(task: timerTask)
        timer = nil
    }
    private func pushToAddOperationViewController() {
        self.isPush = true
        let vc = AddOperationViewController.init()
        vc.creatGroupDataModel = viewModel.creatGroupDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    private func addOrModifyActions() {
        let result = viewModel.judgeLightsAreSameRoom(datas: dataList)
        if result.sameRoom {
            viewModel.showTrunOffOtherLinghtsTipAlert(lights: result.restOfLights ?? [LightModel()], datas: dataList) { [weak self] in
                self?.myDetailType == .creatType ? self?.netAddIntelligents() : self?.netModifyIntelligents()
            }
        }else {
            myDetailType == .creatType ? self.netAddIntelligents() : self.netModifyIntelligents()
        }
    }
    private func netAddIntelligents() {
        bottomBtn.startIndicator()
        viewModel.addIntelligents(condition: condition, name: navView.titleBtn.currentTitle ?? "", datas: dataList, success: {
            self.bottomBtn.stopIndicator()
            self.changeBlock?()
            self.navigationController?.popViewController(animated: true)
        }) {
            self.bottomBtn.stopIndicator()
        }
    }
    private func netModifyIntelligents() {
        confirmRightBottomBtn.startIndicator()
        viewModel.modifyIntelligents(smartModel: smartDetailModel, name: navView.titleBtn.currentTitle ?? "", condition: condition, datas: dataList, success: {
            self.changeBlock?()
            self.navigationController?.popViewController(animated: true)
        }) {
            self.confirmRightBottomBtn.stopIndicator()
        }
    }
    private func netDeletIntelligents() {
        confirmLeftBottomBtn.startIndicator()
        viewModel.deletIntelligents(id: smartDetailModel?.id ?? "", success: { [weak self] in
            self?.confirmLeftBottomBtn.stopIndicator()
            self?.changeBlock?()
            self?.navigationController?.popViewController(animated: true)
        }) { [weak self] in
            self?.confirmLeftBottomBtn.stopIndicator()
        }
    }
    private func netDisable() {
        bottomBtn.startIndicator()
        viewModel.disable(model: smartDetailModel ?? IntelligentDetailModel() , success: { [weak self] in
            self?.bottomBtn.stopIndicator()
            self?.clearData()
        }) { [weak self] in
            self?.bottomBtn.stopIndicator()
        }
    }
    private func clearData() {
        smartDetailModel?.enable = false
        bottomBtn.isHidden = true
        confirmLeftBottomBtn.isHidden = false
        confirmRightBottomBtn.isHidden = false
        removeTimer()
        updateConditionView()
        confirmRightBottomBtn.isEnabled = false
        viewModel.updateSmartModel(model: smartDetailModel ?? IntelligentDetailModel())
        changeBlock?()
    }
    private lazy var viewModel: IntelligentsViewModel = {
        let viewModel = IntelligentsViewModel()
        return viewModel
    }()
    private lazy var navBottomLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = STELLAR_COLOR_C3
        lab.font = STELLAR_FONT_BOLD_T16
        return lab
    }()
    private lazy var conditionView: CurrentConditionView = {
        let view = CurrentConditionView.CurrentConditionView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 15
        return view
    }()
    private lazy var tableview: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.clear
        view.delegate = self.viewModel
        view.dataSource = self.viewModel
        view.register(UINib(nibName: "OperationTableViewCell", bundle: nil), forCellReuseIdentifier: "OperationTableViewCell")
        view.separatorColor = UIColor.clear
        return view
    }()
    private lazy var bottomBtn: StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("SMART_SAVE"), for: .normal)
        view.style = .normal
        return view
    }()
    private lazy var confirmLeftBottomBtn: StellarButton = {
        let btn = StellarButton()
        btn.setTitle(StellarLocalizedString("SMART_DELET_SELF"), for: .normal)
        btn.style = .gray
        btn.layer.borderWidth = 1
        btn.layer.borderColor = STELLAR_COLOR_C3.cgColor
        return btn
    }()
    private lazy var confirmRightBottomBtn: StellarButton = {
        let btn = StellarButton()
        btn.setTitle(StellarLocalizedString("SMART_SAVE"), for: .normal)
        btn.style = .normal
        btn.isEnabled = false
        return btn
    }()
    private lazy var tableHeadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    private lazy var headImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "add_smart_bg")
        return view
    }()
    private lazy var navView: NavView = {
        let view = NavView()
        return view
    }()
    private lazy var operationHintView: OperationHintView = {
        let tempView = OperationHintView()
        return tempView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return self.style
    }
}
extension CreateSmartViewController: AddOpreationViewModelDelegate {
    func riceveDataChange(datas: [GroupModel]) {
        self.dataList = datas
    }
    func pushViewController(vc: UIViewController) {
        isPush = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func present(vc: UIViewController) {
        isPush = true
        present(vc, animated: true, completion: nil)
    }
}