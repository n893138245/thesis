import UIKit
class EquipmentLoadingVC: BaseViewController {
    let HEADVIEW_HEIGHT:CGFloat = 164
    let group = DispatchGroup.init()
    let devicesQueue = DispatchQueue(label: "com.devicesQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    func setupView(){
        loadBgView()
        loadCollectionViews()
    }
    func loadBgView(){
        let imageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        imageview.image = UIImage.init(named: "equipment_bg")
        view.addSubview(imageview)
        imageview.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.bottom.equalTo(view)
        }
        let headView = EquipmentLoadingHeadView.equipmentLoadingHeadView()
        headView.backgroundColor = UIColor.clear
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.height.equalTo(HEADVIEW_HEIGHT)
            $0.top.equalTo(getAllVersionSafeAreaTopHeight())
        }
        let bottomView = EquipmentLoadingBottomView.equipmentLoadingBottomView()
        bottomView.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.bottom.equalTo(0)
            $0.height.equalTo(49.fit + getAllVersionSafeAreaBottomHeight())
        }
    }
    func loadCollectionViews(){
        collectionView.register(UINib.init(nibName: "EquipmentLoadingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EquipmentLoadingCollectionViewCell")
        view.addSubview(collectionView)
    }
    func loadData(){
        StellarRoomManager.shared.getRoomList(success: { [weak self] in
            self?.loadAllDevices(completion: {
                StellarAppManager.sharedManager.nextStep()
            })
        }, failure: { [weak self] (message, code) in
            self?.loadAllDevices(completion: {
                StellarAppManager.sharedManager.nextStep()
            })
        })
        BackNetManager.sharedManager.prepareLoadingDatas()
    }
    func loadAllDevices(completion: (() -> Void)? = nil){
        DevicesStore.sharedStore().getAllDeviceBasicInfo(success: { [weak self](arr) in
            DevicesStore.sharedStore().subscribeDevices = arr
            self?.loadAllDevicesStatus(completion: { (statusDicArr) in
                for dic in statusDicArr {
                    for device in arr {
                        if device.sn == dic["sn"] as? String {
                            if device.type == .hub {
                                let status = dic.kj.model(GatewayStatus.self)
                                let hub = device as! GatewayModel
                                hub.status = status
                            }else if device.type == .light || device.type == .mainLight {
                                let status = dic.kj.model(LightStatus.self)
                                let light = device as! LightModel
                                light.status = status
                            }else if device.type == .panel {
                                let status = dic.kj.model(PanelStatus.self)
                                let panel = device as! PanelModel
                                panel.status = status
                            }
                        }
                    }
                }
                DevicesStore.sharedStore().allDevices = arr
                self?.queryScene(completion: {
                    completion?()
                })
            }, failure: {
                DevicesStore.sharedStore().allDevices = arr
                completion?()
            })
        }) { (error) in
            completion?()
        }
    }
    private func isNeedCreateDefaultScene(_ arr:[BasicDeviceModel],completion: (() -> Void)? = nil){
        var ishasLight = false
        arr.forEach { (basicModel) in
            if basicModel.type == .light || basicModel.type == .mainLight {
                ishasLight = true
            }
        }
        if ishasLight,StellarAppManager.sharedManager.user.mySceneModelArr.count == 0{
            QueryDeviceTool.creatScenes {
                completion?()
            }
        }else{
            completion?()
        }
    }
    private func queryScene(completion: (() -> Void)? = nil) {
        ScenesStore.sharedStore.queryAllScenes(success: { (arr) in
            StellarAppManager.sharedManager.user.mySceneModelArr = arr
            self.isNeedCreateDefaultScene(DevicesStore.sharedStore().allDevices) {
                completion?()
            }
        }) { (error) in
            completion?()
        }
    }
    func loadAllDevicesStatus(completion:((_ arr: [[String: Any]]) ->Void)?, failure:(() ->Void)?) {
        DevicesStore.sharedStore().getAllDeviceStateInfo(success: { (jsonDic) in
            completion?(jsonDic)
        }) { (error) in
            failure?()
        }
    }
    private lazy var layout:UICollectionViewFlowLayout = {
        let cLayout = UICollectionViewFlowLayout()
        let space:CGFloat = 9
        var width:CGFloat = (kScreenWidth - space * 3) / 2.0
        var height:CGFloat = width/174.0 * 114.0
        cLayout.itemSize = CGSize(width:width, height: height)
        cLayout.minimumLineSpacing = space
        cLayout.minimumInteritemSpacing = space
        cLayout.scrollDirection = .vertical
        cLayout.sectionInset = UIEdgeInsets.init(top: space, left: space, bottom: space, right: space)
        return cLayout
    }()
    private lazy var collectionView:UICollectionView = {
        layout.headerReferenceSize = CGSize.init(width: kScreenWidth, height: HEADVIEW_HEIGHT)
        var y:CGFloat = 0
        var height:CGFloat = 0
        if #available(iOS 11.0, *) {
            y = getAllVersionSafeAreaTopHeight()
            height = kScreenHeight - y - BOTTOM_HEIGHT - getAllVersionSafeAreaBottomHeight()
        } else {
            y = getAllVersionSafeAreaTopHeight()
            height = kScreenHeight - y - BOTTOM_HEIGHT
        }
        let view = UICollectionView.init(frame: CGRect(x:0, y:y, width:kScreenWidth, height:height), collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension EquipmentLoadingVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EquipmentLoadingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EquipmentLoadingCollectionViewCell", for: indexPath) as!EquipmentLoadingCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}