import UIKit
class SceneViewController: BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        isShowNoDeviceView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
        addRefreshHeader()
        let arr = StellarAppManager.sharedManager.user.mySceneModelArr
        defaultView.defaultDataList = arr.filter({ model -> Bool in
            return model.isDefault ?? false
        })
        customView.customDataList = arr.filter({ model -> Bool in
            if model.isDefault ?? false {
                return false
            }else{
                return true
            }
        })
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICES_CHANGE)
            .subscribe({ [weak self] (_) in
                self?.loadData(isNeedLoadingView: false)
            }).disposed(by:disposeBag)
    }
    func loadSubViews(){
        headview.leftClickBlock = { [weak self]  in
            self?.scrollview.setContentOffset(CGPoint.zero, animated: true)
        }
        headview.rightClickBlock = { [weak self]  in
            self?.scrollview.setContentOffset(CGPoint.init(x: kScreenWidth, y: 0), animated: true)
        }
        headview.addClickBlock = { [weak self] isDefault in
            let vc = SceneDetailViewController.init()
            vc.myDetailType = .creatType
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.addSubview(headview)
        headview.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.equalTo(getAllVersionSafeAreaTopHeight())
            $0.height.equalTo(NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        }
        scrollview.delegate = self
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { (make) in
            make.top.equalTo(headview.snp.bottom).offset(16.fit)
            make.left.right.equalTo(view)
            make.bottom.equalTo(-49.fit - getAllVersionSafeAreaBottomHeight())
        }
        scrollview.addSubview(defaultView)
        defaultView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(scrollview)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(scrollview.snp.height)
        }
        scrollview.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.left.equalTo(kScreenWidth)
            make.top.equalTo(scrollview)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(scrollview.snp.height)
        }
    }
    func loadData(isNeedLoadingView: Bool = true){
        if isNeedLoadingView {
            StellarProgressHUD.showHUD()
        }
        ScenesStore.sharedStore.queryAllScenes(success: {[weak self] (arr) in
            StellarProgressHUD.dissmissHUD()
            StellarAppManager.sharedManager.user.mySceneModelArr = arr
            self?.defaultView.defaultDataList = arr.filter({ model -> Bool in
                return model.isDefault ?? false
            })
            self?.customView.customDataList = arr.filter({ model -> Bool in
                if model.isDefault ?? false {
                    return false
                }else{
                    return true
                }
            })
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
        }
    }
    func isShowNoDeviceView(){
        DevicesStore.instance.checkUserLightList { (isHaveLight) in
            if isHaveLight {
                self.showNormalViews()
            }else {
                self.showAddDeviceViews()
            }
        }
    }
    func showAddDeviceViews() {
        headview.addBtn.isHidden = true
        customView.showAddDeviceView()
        defaultView.showAddView()
    }
    func showNormalViews() {
        headview.addBtn.isHidden = false
        customView.hiddenTopViews()
        defaultView.hiddenAddView()
        let arr = StellarAppManager.sharedManager.user.mySceneModelArr
        self.defaultView.defaultDataList = arr.filter({ model -> Bool in
            return model.isDefault ?? false
        })
        self.customView.customDataList = arr.filter({ model -> Bool in
            if model.isDefault ?? false {
                return false
            }else{
                return true
            }
        })
    }
    func addRefreshHeader(){
        let defaultRefreshHeader = BaseRefreshHeader.init { [weak self]  in
            self?.loadData()
            self?.defaultView.tableview.mj_header?.endRefreshing()
        }
        defaultRefreshHeader.style = .blue
        defaultView.tableview.mj_header = defaultRefreshHeader
        let customRefreshHeader = BaseRefreshHeader.init { [weak self]  in
            self?.loadData()
            self?.customView.tableview.mj_header?.endRefreshing()
        }
        customRefreshHeader.style = .blue
        customView.tableview.mj_header = customRefreshHeader
    }
    lazy var headview:SmartAndSceneHeadView = {
        let view = SmartAndSceneHeadView()
        view.setTitles(leftTitle: StellarLocalizedString("SCENE_DEFAULT"), rightTitle: StellarLocalizedString("SCENE_CUSTOM"))
        return view
    }()
    lazy var defaultView:SceneDefaultView = {
        let view = SceneDefaultView()
        view.pushBlock = {[weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    lazy var customView:SceneCustomView = {
        let view = SceneCustomView()
        view.pushBlock = {[weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    lazy var scrollview:UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.contentSize = CGSize.init(width: kScreenWidth*2, height: 0)
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension SceneViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetX:CGFloat = scrollView.contentOffset.x
        if contentOffsetX/kScreenWidth == 0{
            headview.switchDefaultState()
        }
        else if contentOffsetX/kScreenWidth >= 1{
            headview.switchCustomState()
        }
    }
}