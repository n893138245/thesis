import UIKit
class SelectScenesViewController: BaseViewController {
    var creatGroupDataModel = CreatGroupDataModel()
    var isModify = false
    var modifyBlock:((_ group: GroupModel) ->Void)?
    var selectScenseId: String?
    private let HEAD_HEIGHT: CGFloat = 114 
    private let NORMAL_NAV_HEIGHT: CGFloat = 44 
    private let TITLE_SCROLL_HEIGHT: CGFloat = 46 
    private var currentPage = 0
    private var tableArr = [UITableView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
    }
    func loadSubViews(){
        loadHead()
        loadContent()
        setupActions()
        loadData()
    }
    func loadHead(){
        view.addSubview(bgScrollView)
        view.addSubview(titleBgView)
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: getAllVersionSafeAreaTopHeight()+NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        titleView.frame = CGRect.init(x: 0, y: navView.frame.maxY, width: kScreenWidth, height: 114)
        titleView.backgroundColor = STELLAR_COLOR_C3
        let titleLabel = UILabel()
        titleLabel.text = StellarLocalizedString("SCENE_EXECUTE")
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-20, height: 58)
        titleView.addSubview(titleLabel)
        titleView.addSubview(tipView)
        view.addSubview(titleView)
        titleBgView.addSubview(titleScrollView)
        titleScrollView.backgroundColor = STELLAR_COLOR_C3
    }
    private func loadContent() {
        view.addSubview(comfirmButton)
        comfirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-32.fit-getAllVersionSafeAreaBottomHeight())
            $0.width.equalTo(291.fit)
            $0.height.equalTo(46.fit)
            $0.centerX.equalTo(view)
        }
        comfirmButton.isEnabled = false
        bgScrollView.addSubview(myDefaultView)
        bgScrollView.addSubview(myCustomView)
        setupTableViewDelegateFunc(tableView: myDefaultView.tableview)
        setupTableViewDelegateFunc(tableView: myCustomView.tableview)
        myDefaultView.tableview.tag = 100
        myCustomView.tableview.tag = 101
        tableArr.append(myDefaultView.tableview)
        tableArr.append(myCustomView.tableview)
        view.addSubview(navView)
    }
    private func setBgOffset(page: Int) {
        var offset = bgScrollView.contentOffset
        offset.x = kScreenWidth * CGFloat(page)
        UIView.animate(withDuration: 0.25) {
            self.bgScrollView.contentOffset = offset
        }
        currentPage = page
    }
    private func setTitleSelectedIndex() {
        let offset = bgScrollView.contentOffset
        let page = offset.x/kScreenWidth
        Int(page) == 0 ? titleScrollView.switchDefaultState():titleScrollView.switchCustomState()
        currentPage = Int(page)
    }
    private func setupActions() {
        titleScrollView.leftClickBlock = { [weak self] in
            self?.titleScrollView.switchDefaultState()
            self?.setBgOffset(page: 0)
        }
        titleScrollView.rightClickBlock = {
            self.titleScrollView.switchCustomState()
            self.setBgOffset(page: 1)
        }
        bgScrollView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] (_) in
                self?.setTitleSelectedIndex()
            })
            .disposed(by: disposeBag)
        comfirmButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.creatScenesExecution()
        }).disposed(by: disposeBag)
        myDefaultView.selctedBlock = { [weak self] (selectId) in 
            self?.selectScenseId = selectId
            self?.myCustomView.clearCurrentSelect()
            self?.comfirmButton.isEnabled = true
        }
        myCustomView.selctedBlock = { [weak self] (selectId) in 
            self?.selectScenseId = selectId
            self?.myDefaultView.clearCurrentSelect()
            self?.comfirmButton.isEnabled = true
        }
    }
    private func setupTableViewDelegateFunc(tableView: UITableView) {
        tableView.rx.contentOffset.subscribe { [weak self] (contentOffset) in
            let contentOffsetY:CGFloat = contentOffset.element!.y
            self?.setupTableViewScroll(contentOffsetY: contentOffsetY, currentTableView: tableView)
        }.disposed(by: disposeBag)
        tableView.rx.didEndDecelerating.subscribe(onNext: { [weak self] (s) in
            self?.setupBorderTableViewStyle(currentTableView: tableView)
        }).disposed(by: disposeBag)
        tableView.rx.didEndDragging.subscribe(onNext: { [weak self] (s) in
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
            titleBgView.frame.origin.y = -contentOffsetY + getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT + HEAD_HEIGHT
            let topViewAlpha:CGFloat = 1 - (contentOffsetY)/(HEAD_HEIGHT+TITLE_SCROLL_HEIGHT - (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT))
            titleView.alpha = topViewAlpha
            navView.setTitle(title: "")
        }
        else{
            titleView.frame.origin.y = -(HEAD_HEIGHT + (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT))
            titleBgView.frame.origin.y = (getAllVersionSafeAreaTopHeight() + NORMAL_NAV_HEIGHT)
            navView.setTitle(title: StellarLocalizedString("SCENE_EXECUTE"))
        }
    }
    private func setupBorderTableViewStyle(currentTableView: UITableView) {
        let contentOffsetY = currentTableView.contentOffset.y
        if contentOffsetY < 0 {
            setOtherTableContentOffset(currentTableView: currentTableView, offset: CGPoint.zero)
            return
        }
        if contentOffsetY < (HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT){
            if contentOffsetY < (HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT)/2.0{
                currentTableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                setOtherTableContentOffset(currentTableView: currentTableView, offset: CGPoint.zero)
            }else{
                currentTableView.setContentOffset(CGPoint.init(x: 0, y: HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT), animated: true)
                setOtherTableContentOffset(currentTableView: currentTableView, offset:CGPoint.init(x: 0, y: HEAD_HEIGHT + self.TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT))
            }
        }else{
            setOtherTableContentOffset(currentTableView: currentTableView, offset: CGPoint.init(x: 0, y: HEAD_HEIGHT + TITLE_SCROLL_HEIGHT - NORMAL_NAV_HEIGHT))
        }
    }
    private func setOtherTableContentOffset(currentTableView: UITableView, offset: CGPoint) {
        for table in tableArr {
            if table != currentTableView {
                table.setContentOffset(offset, animated: false)
            }
        }
    }
    func loadData() {
        selectScenseId = creatGroupDataModel.selectedScenseId
        if StellarAppManager.sharedManager.user.mySceneModelArr.count == 0 {
            ScenesStore.sharedStore.queryAllScenes(success: {[weak self] (arr) in
                StellarProgressHUD.dissmissHUD()
                StellarAppManager.sharedManager.user.mySceneModelArr = arr
                self?.myCustomView.executeScenesType = .customType
                self?.myDefaultView.executeScenesType = .defaultType
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
            }
        }else {
            myCustomView.executeScenesType = .customType
            myDefaultView.executeScenesType = .defaultType
        }
        if let selectId = selectScenseId {
            myCustomView.setDefultSelectId(id: selectId)
            myDefaultView.setDefultSelectId(id: selectId)
            comfirmButton.isEnabled = true
        }
    }
    private func creatScenesExecution() {
        let group = GroupModel.creatGroupMoel(groupId: 0, param: ExecutionDetailParams(), command: .execute, sceneId: selectScenseId ?? "")
        if isModify {
            if let block = modifyBlock {
                block(group)
            }
            navigationController?.popViewController(animated: true)
        }else {
            let userInfo = ["userInfo":group]
            NotificationCenter.default.post(name: .Scenes_SetDeviceStatusComplete, object: nil, userInfo: userInfo)
            switch creatGroupDataModel.sourceVc {
            case .panelSetting:
                popToViewController(withClass: SwitchSettingViewController.className())
            case .creatSmart:
                popToViewController(withClass: CreateSmartViewController.className())
            default:
                break
            }
        }
    }
    lazy var navView:NavView = {
        let view = NavView()
        view.backgroundColor = STELLAR_COLOR_C3
        return view
    }()
    lazy var titleView:UIView = {
        let view = UIView()
        return view
    }()
    lazy var comfirmButton: StellarButton = {
        let tempView = StellarButton()
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.style = .normal
        return tempView
    }()
    lazy var titleBgView: UIView = {
        let titleY = 114 + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA + getAllVersionSafeAreaTopHeight()
        let tempView = UIView.init(frame: CGRect(x: 0, y: titleY, width: kScreenWidth, height: 46))
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var titleScrollView: SmartAndSceneHeadView = {
        let tempView = SmartAndSceneHeadView.init(frame: CGRect(x: 10, y: 0, width: kScreenWidth/2, height: 28))
        tempView.setTitles(leftTitle: StellarLocalizedString("SCENE_DEFAULT"), rightTitle: StellarLocalizedString("SCENE_CUSTOM"))
        tempView.addBtn.isHidden = true
        return tempView
    }()
    lazy var tipView:ScenseTitleTipView = {
        let view = ScenseTitleTipView.init(frame: CGRect(x: 0, y: 42, width: kScreenWidth, height: 72),title: StellarLocalizedString("ALERT_SELECT_SCENE"))
        return view
    }()
    private lazy var bgScrollView: UIScrollView = {
        let view = UIScrollView()
        let scorllViewY: CGFloat = getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA
        let collectViewHeight: CGFloat = kScreenHeight - scorllViewY - getAllVersionSafeAreaBottomHeight()
        view.frame = CGRect(x: 0, y: scorllViewY, width: kScreenWidth, height: collectViewHeight)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentSize = CGSize(width: kScreenWidth*2, height: 0)
        return view
    }()
    private lazy var myDefaultView: SelectScenseListView = {
        let scorllViewY: CGFloat = getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA
        let collectViewHeight: CGFloat = kScreenHeight - scorllViewY - getAllVersionSafeAreaBottomHeight()
        let view = SelectScenseListView.init(frame: CGRect(x: 0, y: 0 , width: kScreenWidth, height: collectViewHeight))
        return view
    }()
    private lazy var myCustomView: SelectScenseListView = {
        let scorllViewY: CGFloat = getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA
        let collectViewHeight: CGFloat = kScreenHeight - scorllViewY - getAllVersionSafeAreaBottomHeight()
        let view = SelectScenseListView.init(frame: CGRect(x: kScreenWidth, y: 0 , width: kScreenWidth, height: collectViewHeight))
        return view
    }()
}