import UIKit
class EquipmentViewController: NoEqipmentViewController {
    let HEADVIEW_HEIGHT:CGFloat = 164
    var currentPage = 0
    var collectionViewArr = [UICollectionView]()
    var equipmentVMArr = [EquipmentViewModel]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView(){
        loadSubViews()
        setupAction()
    }
    func loadSubViews(){
        if DevicesStore.sharedStore().allDevices.count > 0{
            reloadEquipmentsView()
        }
        else{
            showNoEqipmentView()
        }
    }
    func reloadEquipmentsView(){
        equipmentVMArr.removeAll()
        collectionViewArr.removeAll()
        for subView in (scrollview.subviews){
            subView.removeFromSuperview()
        }
        currentPage = 0
        scrollview.setContentOffset(CGPoint.zero, animated: false)
        view.addSubview(epuipmentsView)
        epuipmentsView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        epuipmentsView.addSubview(scrollview)
        var rooms = ["全部"]
        rooms += DevicesStore.sharedStore().hasDevicesAllRoomsName
        for index in 0..<rooms.count{
            let equipmentVM : EquipmentViewModel = EquipmentViewModel()
            equipmentVM.vMDelegate = self
            equipmentVMArr.append(equipmentVM)
            let roomName = rooms[index]
            if index == 0 {
                equipmentVM.selctedDevices = DevicesStore.sharedStore().allDevices
            }else{
                let roomID = StellarRoomManager.shared.getRoom(roomName: roomName).id ?? 0
                equipmentVM.selctedDevices = DevicesStore.sharedStore().sortedDevicesDic[roomID] ?? [BasicDeviceModel]()
            }
            let collectionViewFrame = CGRect(x:CGFloat(index) * kScreenWidth, y:0, width:scrollview.frame.size.width, height:scrollview.frame.size.height)
            let collectionView = initCollectionView(tag: index + 100,deviceCount: equipmentVM.selctedDevices.count,frame: collectionViewFrame)
            scrollview.addSubview(collectionView)
            collectionViewArr.append(collectionView)
            collectionView.delegate = equipmentVM
            collectionView.dataSource = equipmentVM
            setCollectionViewDelegateFunc(collectionView: collectionView,equipmentVM:equipmentVM)
            addHasEpuipmentsViewRefreshHeader(collectionView: collectionView)
        }
        scrollview.contentSize = CGSize.init(width: CGFloat(rooms.count) * kScreenWidth, height: 0)
        loadHeadView(rooms: rooms)
        showEqipmentView()
    }
    func loadHeadView(rooms:[String]){
        epuipmentsView.addSubview(headView)
        headView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: HEADVIEW_HEIGHT)
        headView.bottomView.setRoomsAndSelectedIndex(rooms: rooms) { [weak self] (index) in
            guard let equipmentVC = self else{
                return
            }
            if equipmentVC.equipmentVMArr.count <= index{
                return
            }
            equipmentVC.currentPage = index
            let equipmentVM = equipmentVC.equipmentVMArr[index]
            let roomName = rooms[index]
            if roomName == "全部" {
                equipmentVM.selctedDevices = DevicesStore.sharedStore().allDevices
            }else{
                let roomID = StellarRoomManager.shared.getRoom(roomName: roomName).id
                equipmentVM.selctedDevices = DevicesStore.sharedStore().sortedDevicesDic[roomID ?? 0] ?? [BasicDeviceModel]()
            }
            equipmentVC.scrollview.setContentOffset(CGPoint.init(x: CGFloat(index)*kScreenWidth, y: 0), animated: true)
        }
        updateHeadViewTitle()
        headView.setHeadViewClick(leftClickBlock: {
            if DevicesStore.instance.lights.filter({$0.status.online}).isEmpty {
                TOAST(message: StellarLocalizedString("ALERT_CHECK_NETWORD"))
            }else {
                ControlRoomsPopView.shareView()
            }
        }) { [weak self] in
            let nav = AddDeviceBaseNavController.init(rootViewController: AddDeviceVC.init())
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    private func updateHeadViewTitle(){
        let offLineList = DevicesStore.instance.lights.filter {
            $0.status.onOff == "on" && $0.status.online
        }
        headView.setRoomsTitles(" \(offLineList.count) " + StellarLocalizedString("EQUIPMENT_LAMP_CLOSED"))
    }
    func setupAction(){
        NotificationCenter.default.rx.notification(.NOTIFY_STATUS_UPDATED).subscribe({ [weak self] (notify) in
            let info = notify.element?.userInfo
            guard let model = info?["deviceState"] as? BasicDeviceModel else{
                return
            }
            self?.updateCollectionViewWith(model: model)
            self?.updateHeadViewTitle()
        }).disposed(by:disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICES_UPDATE).subscribe({ [weak self] (notify) in
            self?.updateHeadViewTitle()
            guard let vm = notify.element?.object else {
                for collectionView in self?.collectionViewArr ?? [UICollectionView](){
                    collectionView.reloadData()
                }
                return
            }
            guard let index = self?.equipmentVMArr.firstIndex(of: vm as? EquipmentViewModel ?? EquipmentViewModel()) else {
                return
            }
            guard let otherCollectionViewArr = self?.collectionViewArr.filter({ (collectionView) -> Bool in
                collectionView != self?.collectionViewArr[index]
            }) else{
                return
            }
            for collectionView in otherCollectionViewArr{
                collectionView.reloadData()
            }
        }).disposed(by:disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICES_CHANGE).subscribe({ [weak self] (_) in
            self?.loadNet(completion: {
                if DevicesStore.sharedStore().allDevices.count > 0{
                    self?.reloadDataAndSetDefaultContentOffset()
                }else{
                    self?.showNoEqipmentView()
                }
            })
        }).disposed(by:disposeBag)
    }
    func updateCollectionViewWith(model:BasicDeviceModel){
        if equipmentVMArr.count == 0 || collectionViewArr.count == 0{
            return
        }
        var roomName = ""
        if let room =  model.room {
           roomName = StellarRoomManager.shared.getRoom(roomId: room).name ?? ""
        }else{
            let firstVM = self.equipmentVMArr[0]
            let firstCollView = self.collectionViewArr[0]
            let firstArr = firstVM.selctedDevices
            if let allIndex = firstArr.map({ $0.sn}).firstIndex(of: model.sn){
                firstVM.selctedDevices[allIndex] = model
                firstCollView.reloadItems(at: [IndexPath.init(row: allIndex, section: 0)])
            }
        }
        if let index = self.headView.bottomView.titles.firstIndex(of: roomName){
            if index != 0 {
                let vm = self.equipmentVMArr[index]
                let collView = self.collectionViewArr[index]
                let arr = vm.selctedDevices
                if let roomIndex = arr.map({ $0.sn}).firstIndex(of: model.sn){
                    vm.selctedDevices[roomIndex] = model
                    collView.reloadItems(at: [IndexPath.init(row: roomIndex, section: 0)])
                }
            }
            let firstVM = self.equipmentVMArr[0]
            let firstCollView = self.collectionViewArr[0]
            let firstArr = firstVM.selctedDevices
            if let allIndex = firstArr.map({ $0.sn}).firstIndex(of: model.sn){
                firstVM.selctedDevices[allIndex] = model
                firstCollView.reloadItems(at: [IndexPath.init(row: allIndex, section: 0)])
            }
        }
    }
    func initCollectionView(tag:Int,deviceCount:Int,frame:CGRect) -> UICollectionView{
        let cLayout = UICollectionViewFlowLayout()
        let space:CGFloat = 9
        let width:CGFloat = (kScreenWidth - space * 3) / 2.0
        let height:CGFloat = width/174.0 * 114.0
        cLayout.itemSize = CGSize(width:width, height: height)
        cLayout.minimumLineSpacing = space
        cLayout.minimumInteritemSpacing = space
        cLayout.sectionInset = UIEdgeInsets.init(top: space, left: space, bottom: space, right: space)
        cLayout.headerReferenceSize = CGSize.init(width: kScreenWidth, height: HEADVIEW_HEIGHT)
        let collectionViewRow = deviceCount % 2 == 0 ? deviceCount/2 : (deviceCount/2+1)
        let collectionViewContentSizeHeight = CGFloat(collectionViewRow) * (height + 9)
        var visibleContentHeight:CGFloat = 0
        visibleContentHeight = kScreenHeight - getAllVersionSafeAreaTopHeight() - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA - BOTTOM_HEIGHT - getAllVersionSafeAreaBottomHeight() - space
        if collectionViewContentSizeHeight < visibleContentHeight{
            cLayout.footerReferenceSize = CGSize.init(width: kScreenWidth, height: visibleContentHeight - collectionViewContentSizeHeight)
        }
        let collectionView = UICollectionView.init(frame: frame, collectionViewLayout: cLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.tag = tag
        collectionView.register(UINib.init(nibName: "DeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DeviceCollectionViewCellID")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }
    func showEqipmentView(){
        epuipmentsView.isHidden = false
        noResultView.isHidden = true
    }
    func showNoEqipmentView() {
        addNoEpuipmentsViewRefreshHeader()
        noResultView.isHidden = false
        epuipmentsView.isHidden = true
    }
    func addHasEpuipmentsViewRefreshHeader(collectionView:UICollectionView){
        let hasEquipmentHeader = BaseRefreshHeader.init { [weak self] in
            guard let equipmentVC = self else{
                return
            }
            equipmentVC.loadNet(completion: {
                collectionView.mj_header?.endRefreshing()
                collectionView.mj_header?.endRefreshingCompletionBlock = {
                    collectionView.mj_header = nil
                    equipmentVC.updateHeadViewTitle()
                    if DevicesStore.sharedStore().allDevices.count > 0{
                        equipmentVC.reloadDataAndSetDefaultContentOffset()
                    }else{
                        equipmentVC.showNoEqipmentView()
                    }
                }
            })
        }
        hasEquipmentHeader.style = .blue
        collectionView.mj_header = hasEquipmentHeader
    }
    private func reloadDataAndSetDefaultContentOffset(){
        if currentPage == 0{
            reloadEquipmentsView()
        }else{
            let currentRoomName = headView.bottomView.titles[currentPage]
            let currentRoomID = StellarRoomManager.shared.getRoom(roomName: currentRoomName).id ?? 0
            reloadEquipmentsView()
            var currentIndex = DevicesStore.sharedStore().hasDevicesAllRoomsID.firstIndex(of: currentRoomID) ?? 0
            currentIndex += 1
            headView.bottomView.tapActionWith(index: Int(currentIndex),animated: false)
            scrollview.setContentOffset(CGPoint.init(x: currentIndex * Int(kScreenWidth), y: 0), animated: false)
            currentPage = Int(currentIndex)
        }
    }
    func addNoEpuipmentsViewRefreshHeader(){
        let hasEquipmentHeader = BaseRefreshHeader.init { [weak self] in
            self?.loadNet(completion: {
                self?.noResultView.scrollView.mj_header?.endRefreshing()
                self?.noResultView.scrollView.mj_header?.endRefreshingCompletionBlock = {
                    self?.updateHeadViewTitle()
                    if DevicesStore.sharedStore().allDevices.count > 0{
                        self?.reloadEquipmentsView()
                    }else{
                        self?.showNoEqipmentView()
                    }
                }
            })
        }
        hasEquipmentHeader.style = .blue
        noResultView.scrollView.mj_header = hasEquipmentHeader
    }
    func loadNet(completion: (() -> Void)? = nil){
        StellarRoomManager.shared.getRoomList(success: {
            self.loadAllDevices(completion: {
                completion?()
            })
        }, failure: { (message, code) in
            self.loadAllDevices(completion: {
                completion?()
            })
        })
    }
    func loadAllDevices(completion: (() -> Void)?){
        DevicesStore.sharedStore().getAllDeviceBasicInfo(success: { (arr) in
            DevicesStore.sharedStore().subscribeDevices = arr
            self.loadAllDevicesStatus(completion: { (statusDicArr) in
                DevicesStore.sharedStore().allDevices = self.supplementDevicesState(arr: arr, statusDicArr: statusDicArr)
                completion?()
            }, failure: {
                DevicesStore.sharedStore().allDevices = arr
                completion?()
            })
        }) { (_) in
            completion?()
        }
    }
    private func supplementDevicesState(arr:[BasicDeviceModel],statusDicArr:[[String : Any]]) -> [BasicDeviceModel]{
        for dic in statusDicArr {
            for device in arr {
                supplementState(device: device, statusDic: dic)
            }
        }
        return arr
    }
    private func supplementState(device:BasicDeviceModel,statusDic:[String : Any]){
        if device.sn == statusDic["sn"] as? String {
            if device.type == .hub {
                let status = statusDic.kj.model(GatewayStatus.self)
                if let hub = device as? GatewayModel {
                    hub.status = status
                }
            }else if device.type == .light || device.type == .mainLight {
                let status = statusDic.kj.model(LightStatus.self)
                if let light = device as? LightModel {
                    light.status = status
                }
            }else if device.type == .panel {
                let status = statusDic.kj.model(PanelStatus.self)
                if let panel = device as? PanelModel{
                    panel.status = status
                }
            }
        }
    }
    func loadAllDevicesStatus(completion:((_ arr: [[String: Any]]) ->Void)?, failure:(() ->Void)?) {
        DevicesStore.sharedStore().getAllDeviceStateInfo(success: { (jsonDic) in
            completion?(jsonDic)
        }) { (error) in
            failure?()
        }
    }
    lazy var headView:EquipmentHeadView = {
        let view = EquipmentHeadView()
        return view
    }()
    lazy var epuipmentsView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    lazy var scrollview:UIScrollView = {
        var scorllViewY:CGFloat = 0
        var collectViewHeight:CGFloat = 0
        scorllViewY = getAllVersionSafeAreaTopHeight()
        collectViewHeight = kScreenHeight - scorllViewY - BOTTOM_HEIGHT - getAllVersionSafeAreaBottomHeight()
        let scrollview = UIScrollView.init(frame: CGRect(x: 0, y:scorllViewY, width:kScreenWidth, height:collectViewHeight))
        scrollview.isPagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        return scrollview
    }()
}
extension EquipmentViewController{
    func setCollectionViewDelegateFunc(collectionView:UICollectionView,equipmentVM:EquipmentViewModel){
        collectionView.rx.contentOffset.subscribe { [weak self] (contentOffset) in
            if let contentOffsetY:CGFloat = contentOffset.element?.y {
                self?.setupCollectionScroll(contentOffsetY: contentOffsetY,currentCollectionView: collectionView)
            }
        }.disposed(by: disposeBag)
        collectionView.rx.didEndDecelerating.subscribe(onNext: { [weak self] (s) in
            self?.setupBorderCollectionViewStyle(collectionView: collectionView)
        }).disposed(by: disposeBag)
        collectionView.rx.didEndDragging.subscribe(onNext: { [weak self] (s) in
            self?.setupBorderCollectionViewStyle(collectionView: collectionView)
        }).disposed(by: disposeBag)
        scrollview.rx.didEndDecelerating.subscribe(onNext: { [weak self] (s) in
            if let contentOffsetX = self?.scrollview.contentOffset.x {
                self?.currentPage = Int(contentOffsetX / kScreenWidth)
                self?.headView.bottomView.tapActionWith(index: self?.currentPage ?? 0)
            }
        }).disposed(by: disposeBag)
    }
    func setupCollectionScroll(contentOffsetY:CGFloat,currentCollectionView:UICollectionView){
        if (currentCollectionView.tag - 100) != currentPage {
            return
        }
        if Int(contentOffsetY) < Int(HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA){
            if contentOffsetY == 0{
                scrollview.isScrollEnabled = true
            }else{
                scrollview.isScrollEnabled = false
            }
        }else{
            scrollview.isScrollEnabled = true
        }
        if Int(contentOffsetY) < Int(HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA){
            headView.frame.origin.y = -contentOffsetY + getAllVersionSafeAreaTopHeight()
            let topViewAlpha:CGFloat = 1 - (contentOffsetY)/(HEADVIEW_HEIGHT - (getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA))
            headView.setDownStyle(alpha:topViewAlpha)
        }
        else{
            headView.frame.origin.y = -(HEADVIEW_HEIGHT - (getAllVersionSafeAreaTopHeight() + NAVVIEW_HEIGHT_DISLODGE_SAFEAREA))
            headView.setUpStyle()
        }
    }
    func setupBorderCollectionViewStyle(collectionView:UICollectionView){
        let contentOffsetY = collectionView.contentOffset.y
        if collectionView.mj_header?.isRefreshing ?? false || contentOffsetY < 0{
            for col in self.collectionViewArr{
                if collectionView != col{
                    col.setContentOffset(CGPoint.zero, animated: false)
                }
            }
            return
        }
        if contentOffsetY < (self.HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA){
            if contentOffsetY < (self.HEADVIEW_HEIGHT - (NAVVIEW_HEIGHT_DISLODGE_SAFEAREA))/2.0{
                collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                for col in self.collectionViewArr{
                    if collectionView != col{
                        col.setContentOffset(CGPoint.zero, animated: false)
                    }
                }
            }else{
                collectionView.setContentOffset(CGPoint.init(x: 0, y: HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA), animated: true)
                for col in self.collectionViewArr{
                    if collectionView != col{
                        col.setContentOffset(CGPoint.init(x: 0, y: HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA), animated: false)
                    }
                }
            }
        }else{
            for col in self.collectionViewArr{
                if collectionView != col{
                    col.setContentOffset(CGPoint.init(x: 0, y: HEADVIEW_HEIGHT - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA), animated: false)
                }
            }
        }
    }
}
extension EquipmentViewController:EquipmentViewModelDelegate{
    func pushViewController(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}