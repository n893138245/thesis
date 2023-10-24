import UIKit
enum SceneDetailType {
    case detailType 
    case defaultType 
    case creatType 
}
class SceneDetailViewController: BaseViewController {
    var sceneModel = ScenesModel()
    var backImagePath = "/images/scene_4.png"
    var myDetailType: SceneDetailType = .creatType
    private let topBgHeight: CGFloat = isIphoneX_serious ? 213.fit:170.fit
    private let addOpreationBgHeight: CGFloat = 62.fit
    private var isPush = false
    private var scrollVisibleHeight: CGFloat = 0
    private var isShowNavTitle = false
    var dataList: [GroupModel] = [] {
        didSet {
            addButton.isHidden = dataList.count > 0 ? false:true
            updateFooterHeight()
            tableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDataIfNeed()
        setupActions()
        BackNetManager.sharedManager.copyDeviceList()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isPush {
            BackNetManager.sharedManager.restDeviceStatus()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPush = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isShowNavTitle ? .default:.lightContent
    }
    private func setupUI() {
        setupTopViews()
        setupTableView()
        setupBottom()
    }
    private func setupTopViews() {
        scrollVisibleHeight = topBgHeight - kNavigationH
        if #available(iOS 11.0, *) {
            self.tableview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(topBgImage)
        topBgImage.isUserInteractionEnabled = true
        topBgImage.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: topBgHeight)
        topBgImage.addSubview(editButton)
        topBgImage.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.right.equalTo(self.view).offset(-20.fit)
            $0.bottom.equalTo(topBgImage.snp.bottom).offset(-12.fit)
            $0.width.equalTo(78.fit)
            $0.height.equalTo(27.fit)
        }
        view.addSubview(addOpreationBgView)
        addOpreationBgView.frame = CGRect(x: 0, y: topBgHeight, width: kScreenWidth, height: addOpreationBgHeight)
        addOpreationBgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.left.equalTo(self.view).offset(20.fit)
            $0.top.equalTo(addOpreationBgView).offset(24.fit)
        }
        addOpreationBgView.addSubview(addButton)
        var buttonWidth = 90.fit
        if !isChinese() {
            buttonWidth = 120
        }
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(tipLabel)
            $0.right.equalTo(self.view).offset(-20.fit)
            $0.height.equalTo(20.fit)
            $0.width.equalTo(buttonWidth)
        }
        view.addSubview(navBar)
    }
    private func setupTableView() {
        view.addSubview(tableview)
        tableview.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT - 10)
        tableFooterView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 0)
        tableview.tableFooterView = tableFooterView
        tableview.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: topBgHeight + addOpreationBgHeight))
        view.sendSubviewToBack(tableview)
        updateFooterHeight()
    }
    private func setupBottom() {
        switch myDetailType {
        case .creatType:
            addBottomBotton()
            setEditTitle(title: StellarLocalizedString("SCENE_DEFAULT_TITLE"))
        case.defaultType:
            addBottomBotton()
            selectButton.isHidden = true
            editButton.snp.makeConstraints {
                $0.left.equalTo(self.view).offset(20.fit)
                $0.bottom.equalTo(topBgImage).offset(-58.fit)
            }
        case .detailType:
            leftBottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 73.fit - 80.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 146.fit , height: 46.fit)
            view.addSubview(leftBottomBtn)
            rightBottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 73.fit + 80.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 146.fit , height: 46.fit)
            view.addSubview(rightBottomBtn)
            rightBottomBtn.isEnabled = false
        }
    }
    private func addBottomBotton() {
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
        bottomBtn.isEnabled = false
    }
    private func setEditTitle(title: String) {
        editButton.setImage(UIImage(named: "icon_scene_edit-3"), for: .normal)
        let buttonRect = String.ss.getTextRectSize(text: title,font: STELLAR_FONT_BOLD_T24,size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 33.fit))
        editButton.setTitle(title, for: .normal)
        editButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 11.fit, bottom: 0, right: 0 )
        editButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right:0)
        var width: CGFloat = 0
        width = buttonRect.size.width > kScreenWidth - 60.fit ? kScreenWidth - 40.fit:buttonRect.width + 5.fit + 50
        editButton.snp.remakeConstraints {
            $0.left.equalTo(view).offset(10.fit)
            $0.bottom.equalTo(topBgImage).offset(-58.fit)
            $0.width.equalTo(width)
            $0.height.equalTo(33.fit)
        }
        topBgImage.layoutIfNeeded()
    }
    private func updateFooterHeight() {
        let visibleHeight = kScreenHeight - kNavigationH - BOTTOMBUTTON_BOTTOM_CONSTRAINT - 10 - addOpreationBgHeight
        var tableContent = 100
        if dataList.count > 1 {
            tableContent = dataList.count * 100
        }
        if CGFloat(tableContent) < visibleHeight {
            tableview.tableFooterView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: visibleHeight - CGFloat(tableContent))
        }else {
            tableview.tableFooterView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        selectButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.pushToSelectBgImage()
            }).disposed(by: disposeBag)
        editButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.showTextAlert()
            }).disposed(by: disposeBag)
        addButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.pushToScenseOperationViewController()
            }).disposed(by: disposeBag)
        bottomBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.doAddOrModifyActions()
            }).disposed(by: disposeBag)
        rightBottomBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.doAddOrModifyActions()
            }).disposed(by: disposeBag)
        leftBottomBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.showDeletTip()
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.Scenes_SetDeviceStatusComplete)
            .subscribe(onNext: { [weak self] (notify) in
                guard let newModel = notify.userInfo?["userInfo"] as? GroupModel else { return }
                guard let newData = self?.viewModel.filterGroup(newGroup: newModel) else { return }
                self?.dataList = newData
                self?.setButtonsEnabled()
            }).disposed(by: disposeBag)
        tableview.rx.contentOffset
            .subscribe { [weak self] (contentOffset) in
                guard let contentOffsetY = contentOffset.element?.y else { return }
                self?.tableViewDidScroll(contentOffsetY: contentOffsetY)
            }.disposed(by: disposeBag)
        tableview.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] (_) in
                self?.tableViewDidEndDecelerating()
            }).disposed(by: disposeBag)
        tableview.rx.didEndDragging
            .subscribe(onNext: { [weak self] (_) in
                self?.tableViewDidEndDecelerating()
            }).disposed(by: disposeBag)
    }
    private func setDataIfNeed() {
        viewModel.delegate = self
        if myDetailType == .creatType {
            return
        }
        if myDetailType == .defaultType {
            editButton.setTitle(sceneModel.name, for: .normal)
            editButton.isEnabled = false
        }else if myDetailType == .detailType {
            setEditTitle(title: sceneModel.name ?? "")
        }
        if let path = sceneModel.backImageUrl {
            backImagePath = path
            let url = URL(string: getScenesBgImage(path: path))
            topBgImage.kf.setImage(with: url)
        }else {
            topBgImage.image = UIImage(named: viewModel.getImageNameWithId(backImageId: sceneModel.backImageId ?? 0))
        }
        if let actions = sceneModel.actions, actions.count > 0 {
            dataList = viewModel.getDataWithAcions(actions: actions)
        }
    }
    private func tableViewDidScroll(contentOffsetY: CGFloat) {
        if contentOffsetY > 0 { 
            topBgImage.frame.origin.y = -contentOffsetY
        }else { 
            let height = topBgHeight - contentOffsetY
            let width = kScreenWidth * height / topBgHeight
            topBgImage.center = CGPoint.init(x: view.center.x, y: height / 2.0)
            topBgImage.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
        }
        if contentOffsetY >= scrollVisibleHeight { 
            addOpreationBgView.frame.origin.y = kNavigationH
            navBar.backgroundColor = STELLAR_COLOR_C3
        }else {
            addOpreationBgView.frame.origin.y = -contentOffsetY + topBgHeight
            let alpha = 1 - contentOffsetY/scrollVisibleHeight > 1 ? 1 : 1 - contentOffsetY/scrollVisibleHeight
            setTopAlpha(alpha: alpha)
        }
        navBar.titleLabel.text = contentOffsetY > NAVVIEW_HEIGHT_DISLODGE_SAFEAREA ? editButton.currentTitle:""
        isShowNavTitle = contentOffsetY > NAVVIEW_HEIGHT_DISLODGE_SAFEAREA
        navBar.style = isShowNavTitle ? .defaultStyle:.whiteStyle
        setNeedsStatusBarAppearanceUpdate()
    }
    private func tableViewDidEndDecelerating() {
        let contentOffsetY = tableview.contentOffset.y
        if contentOffsetY < 0 || contentOffsetY >= scrollVisibleHeight { 
            return
        }
        if contentOffsetY < scrollVisibleHeight/2 {
            tableview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else {
            tableview.setContentOffset(CGPoint(x: 0, y: scrollVisibleHeight), animated: true)
        }
    }
    private func setTopAlpha(alpha: CGFloat) {
        navBar.backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(1.0 - alpha)
        topBgImage.alpha = alpha
    }
    private func pushToSelectBgImage() {
        isPush = true
        let vc = SelectBgImageViewController.init()
        vc.backImageUrl = backImagePath
        vc.imageSelectBlock = { [weak self] (path) in
            self?.backImagePath = path
            self?.topBgImage.kf.setImage(with: URL(string: getScenesBgImage(path: path)))
            self?.setButtonsEnabled()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    private func showTextAlert() {
        let alert = StellarTextFieldAlertView.stellarTextFieldAlertView()
        alert.setTitleTextFieldType(title: StellarLocalizedString("SCENE_SET_NAME"), secondTitle: "", leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        view.addSubview(alert)
        alert.rightButtonBlock = { [weak self] (text) in
            if !text.isEmpty {
                self?.setEditTitle(title: text)
                self?.setButtonsEnabled()
            }
        }
        if (editButton.titleLabel?.text?.isEmpty ?? true) || (editButton.titleLabel?.text == StellarLocalizedString("SCENE_DEFAULT_TITLE")) {
            alert.showView()
        }else{
            alert.showView(text: editButton.titleLabel?.text ?? "")
        }
    }
    private func showDeletTip() {
        let alert = StellarMineAlertView.init(message: "\(StellarLocalizedString("SCENE_DELET_TIP"))“\(sceneModel.name ?? "")”\(StellarLocalizedString("SMART_MAKE_SURE"))", leftTitle: StellarLocalizedString("SMART_DELET_OK"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.show()
        alert.leftClickBlock = { [weak self] in
            self?.netRemoveScenes()
        }
    }
    private func doAddOrModifyActions() {
        let result = viewModel.judgeLightsAreSameRoom(datas: dataList)
        if result.sameRoom {
            viewModel.showTrunOffOtherLinghtsTipAlert(lights: result.restOfLights ?? [LightModel](), datas: dataList) { [weak self] in
                self?.myDetailType == .creatType ? self?.netAddScenes() : self?.netModifyScenes()
            }
        }else {
            myDetailType == .creatType ? netAddScenes() : netModifyScenes()
        }
    }
    private func netAddScenes() {
        bottomBtn.startIndicator()
        StellarProgressHUD.showHUD()
        let addScenesModel = AddScenesModel()
        addScenesModel.actions = viewModel.getAllActions(datas: dataList)
        addScenesModel.backImageUrl = backImagePath
        addScenesModel.name = editButton.currentTitle ?? ""
        addScenesModel.isDefault = false
        ScenesStore.sharedStore.addScenes(addScenesModel: addScenesModel, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            self?.bottomBtn.stopIndicator()
            let model = jsonDic.kj.model(ScenesModel.self)
            StellarAppManager.sharedManager.user.mySceneModelArr.append(model)
            DevicesStore.sharedStore().duiChangeApplianceName(devicesn: model.id ?? "", newName: self?.editButton.currentTitle ?? "", success: nil, failure: nil)
            TOAST_SUCCESS(message: StellarLocalizedString("SCENE_CREAT_SUCCESS")) {
                self?.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.bottomBtn.stopIndicator()
            if error.isEmpty {
                TOAST(message: StellarLocalizedString("SCENE_CREAT_FAIL"))
            }else {
                TOAST(message: error)
            }
        }
    }
    private func netModifyScenes() {
        if myDetailType == .detailType {
            rightBottomBtn.startIndicator()
        }else {
            bottomBtn.startIndicator()
        }
        StellarProgressHUD.showHUD()
        let changeScenseInfoModel = ChangeScenseInfoModel()
        changeScenseInfoModel.actions = viewModel.getAllActions(datas: dataList)
        changeScenseInfoModel.backImageUrl = backImagePath
        changeScenseInfoModel.name = editButton.currentTitle ?? ""
        changeScenseInfoModel.id = sceneModel.id ?? ""
        ScenesStore.sharedStore.modifyScene(changeScenseInfoModel: changeScenseInfoModel, id: sceneModel.id ?? "", mod: {[weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            self?.bottomBtn.stopIndicator()
            self?.rightBottomBtn.stopIndicator()
            let model = jsonDic.kj.model(ScenesModel.self)
            if let index = StellarAppManager.sharedManager.user.mySceneModelArr.firstIndex(where: { (sce) -> Bool in
                return sce.id == model.id
            }){
                StellarAppManager.sharedManager.user.mySceneModelArr.remove(at: index)
                StellarAppManager.sharedManager.user.mySceneModelArr.insert(model, at: index)
            }
            if self?.sceneModel.name != self?.editButton.currentTitle {
                DevicesStore.sharedStore().duiChangeApplianceName(devicesn: model.id ?? "", newName: self?.editButton.currentTitle ?? "", success: nil, failure: nil)
            }
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS")) {
                self?.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.bottomBtn.stopIndicator()
            self?.rightBottomBtn.stopIndicator()
            error.isEmpty ? TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL")):TOAST(message: error)
        }
    }
    private func netRemoveScenes() {
        leftBottomBtn.startIndicator()
        StellarProgressHUD.showHUD()
        ScenesStore.sharedStore.deleteScene(sn: sceneModel.id ?? "", success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            self?.leftBottomBtn.stopIndicator()
            let model = jsonDic.kj.model(CommonResponseModel.self)
            if model.code == 0 {
                StellarAppManager.sharedManager.user.mySceneModelArr.removeAll(where: { (model) -> Bool in
                    return model.id == self?.sceneModel.id
                })
                DUIManager.sharedManager().qureySmartHomeAppliances(success: nil, failure: nil)
                NotificationCenter.default.post(name: .NOTIFY_SCENE_CHANGE, object: nil, userInfo: nil)
                TOAST_SUCCESS(message: StellarLocalizedString("COMMON_DELETE_SUCCESS")) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }) {[weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            self?.leftBottomBtn.stopIndicator()
            TOAST(message: StellarLocalizedString("COMMON_DELETE_FAIL"))
        }
    }
    private func pushToScenseOperationViewController() {
        isPush = true
        let vc = AddOperationViewController()
        vc.creatGroupDataModel = viewModel.creatGroupDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    private func setButtonsEnabled() {
        switch myDetailType {
        case .defaultType:
            bottomBtn.isEnabled = dataList.count > 0 ? true : false
        case .creatType:
            bottomBtn.isEnabled = viewModel.isDataCanSave(title: editButton.currentTitle, data: dataList)
        case .detailType:
            rightBottomBtn.isEnabled = dataList.count > 0 ? true : false
        }
    }
    private lazy var viewModel: CreatScenesViewModel = {
        let temp = CreatScenesViewModel()
        return temp
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .whiteStyle
        tempView.titleLabel.text = ""
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var topBgImage: UIImageView = {
        let tempView = UIImageView.init()
        let url = URL(string: getScenesBgImage(path: "/images/scene_4.png"))
        tempView.kf.setImage(with: url)
        tempView.contentMode = .scaleAspectFill
        return tempView
    }()
    private lazy var editButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font = STELLAR_FONT_BOLD_T24
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        return tempView
    }()
    private lazy var selectButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: STELLAR_COLOR_C3), for: .normal)
        tempView.titleLabel?.font =  STELLAR_FONT_MEDIUM_T12
        tempView.setTitle(StellarLocalizedString("SCENE_SELECT_BG"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        tempView.layer.cornerRadius = 27.fit/2
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var tableFooterView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var addOpreationBgView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var addButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font =  STELLAR_FONT_MEDIUM_T14
        tempView.setTitle(StellarLocalizedString("ALERT_ADD_OPERATION"), for: .normal)
        tempView.setImage(UIImage(named: "icon_add_blue"), for: .normal)
        tempView.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 11.fit, bottom: 0, right: 0 )
        tempView.setTitleColor(UIColor.init(hexString: "#1E55B7"), for: .normal)
        tempView.layer.cornerRadius = 27.fit/2
        tempView.clipsToBounds = true
        tempView.isHidden = true
        return tempView
    }()
    private lazy var tipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_MEDIUM_T16
        tempView.textColor = STELLAR_COLOR_C4
        tempView.text = StellarLocalizedString("SCENE_OPREATION_TIP")
        return tempView
    }()
    lazy var tableview: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.delegate = self.viewModel
        view.dataSource = self.viewModel
        view.register(UINib(nibName: "OperationTableViewCell", bundle: nil), forCellReuseIdentifier: "OperationTableViewCell")
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var bottomBtn: StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("SMART_SAVE"), for: .normal)
        view.style = .normal
        return view
    }()
    lazy var leftBottomBtn: StellarButton = {
        let btn = StellarButton()
        btn.setTitle(StellarLocalizedString("SCENE_DELET"), for: .normal)
        btn.style = .gray
        btn.layer.borderWidth = 1
        btn.layer.borderColor = STELLAR_COLOR_C3.cgColor
        return btn
    }()
    lazy var rightBottomBtn: StellarButton = {
        let btn = StellarButton()
        btn.setTitle(StellarLocalizedString("SMART_SAVE"), for: .normal)
        btn.style = .normal
        return btn
    }()
}
extension SceneDetailViewController: AddOpreationViewModelDelegate {
    func pushViewController(vc: UIViewController) {
        isPush = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func present(vc: UIViewController) {
        isPush = true
        present(vc, animated: true, completion: nil)
    }
    func riceveDataChange(datas: [GroupModel]) {
        dataList = datas 
        setButtonsEnabled()
    }
}