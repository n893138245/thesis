import UIKit
class AddDeviceVC: AddDeviceBaseViewController {
    let SEARCHVIEW_HEIGHT:CGFloat = 60
    private var myAddDeviceModel = AddDeviceModel()
    private var locationManager = CLLocationManager()
    private var dataArr = [String:[AddDeviceDetailModel]]()
    private var allDataArr = [AddDeviceDetailModel]()
    private var appShownTypes = [String]()
    private var currentAppShownType:String?{
        didSet{
            self.tableView.reloadData()
        }
    }
    private var selectedIndexPath: IndexPath?
    private var selectList:[AddDeviceDetailModel]? {
        get{
            guard let type = currentAppShownType else {
                return nil
            }
            return dataArr[type]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navSearchView.isHidden = true
        navSearchBar.textfield.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    func setupUI() {
        navBar.titleLabel.text = StellarLocalizedString("ADD_DEVICE_ADD")
        navBar.titleLabel.textColor = STELLAR_COLOR_C3
        navBar.exitButton.isHidden = true
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        cardView.addSubview(navSearchBar)
        cardView.addSubview(tableView)
        cardView.addSubview(deviceListView)
        deviceListView.selectTypeBlock = { [weak self] type in
            self?.currentAppShownType = type
        }
        navSearchBar.editStateBlock = { [weak self] isSearching in
            self?.navSearchView.isHidden = !isSearching
            if isSearching {
                self?.searchingDevice()
            }
        }
        navSearchView.isHidden = true
        cardView.addSubview(navSearchView)
        navSearchView.selectDeviceBlock = { [weak self] model in
            self?.selectDeviceToJump(model)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func searchingDevice(){
        guard let content = navSearchBar.textfield.text else {
            navSearchView.selectList = [AddDeviceDetailModel]()
            return
        }
        var searchedDevices = [AddDeviceDetailModel]()
        allDataArr.forEach { (detailModel) in
            let isContainName = detailModel.name?.contains(content) ?? false
            let isContainModel = detailModel.model?.uppercased().contains(content.uppercased()) ?? false
            let isContainConnectType = getDeviceConnectionType(detailModel.connection).uppercased().contains(content.uppercased())
            if isContainName || isContainModel || isContainConnectType{
                searchedDevices.append(detailModel)
            }
        }
        navSearchView.selectList = searchedDevices
    }
    func setupData() {
        BleManager.sharedManager().open()
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().queryDevicesAddList(success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            self?.myAddDeviceModel = jsonDic.kj.model(AddDeviceModel.self)
            if let addDeviceModel = self?.myAddDeviceModel{
                self?.didReceiveAwsData(data: addDeviceModel)
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
        }
    }
    private func didReceiveAwsData(data: AddDeviceModel) {
        for device in data.ble ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .ble
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        for device in data.softAP ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .softAP
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        for device in data.mesh ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .mesh
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        for device in data.zigbee ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .zigbee
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        for device in data.smartConfig ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .smartConfig
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        for device in data.dui ?? [AddDeviceDetailModel](){
            if device.onSale {
                device.connection = .dui
                self.deviceDetailClassify(model: device)
                self.allDataArr.append(device)
            }
        }
        self.deviceListView.setTypes(types: self.appShownTypes)
        self.currentAppShownType = self.appShownTypes.first ?? ""
        self.tableView.reloadData()
    }
    func deviceDetailClassify(model:AddDeviceDetailModel) {
        guard let appShownType = model.appShownType else {
            return
        }
        var isInclude = false
        for type in dataArr.keys{
            if type == model.appShownType {
                isInclude = true
            }
        }
        if isInclude {
            dataArr[appShownType]?.append(model)
        }else{
            appShownTypes.append(appShownType)
            dataArr[appShownType] = [model]
        }
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 107, y: 10 + SEARCHVIEW_HEIGHT, width: self.cardView.width - 107, height: self.cardView.height - (10 + SEARCHVIEW_HEIGHT) - 10))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "AddDeviceCell", bundle: nil), forCellReuseIdentifier: "AddDeviceCell")
        tempView.separatorStyle = .none
        return tempView
    }()
    private lazy var navTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        tempView.text = StellarLocalizedString("ADD_DEVICE_ADD")
        tempView.font = STELLAR_FONT_T18
        tempView.textAlignment = .center
        tempView.textColor = STELLAR_COLOR_C4
        return tempView
    }()
    private lazy var navSearchBar: DevicesSearchBar = {
        let tempView = DevicesSearchBar.init()
        tempView.frame = CGRect(x: 18, y: 16, width: cardView.mj_w - 18*2, height: 34)
        return tempView
    }()
    private lazy var navSearchView: DevicesSearchView = {
        let tempView = DevicesSearchView.init(frame: CGRect(x: 0, y: SEARCHVIEW_HEIGHT, width: cardView.mj_w, height: cardView.mj_h - SEARCHVIEW_HEIGHT))
        return tempView
    }()
    private lazy var deviceListView: StellarSeleListView = {
        let view = StellarSeleListView(frame: CGRect(x: 0, y: SEARCHVIEW_HEIGHT, width: 107, height: self.cardView.height - SEARCHVIEW_HEIGHT))
        let bounds = CGRect(x: 0, y: 0, width: 107, height: self.cardView.height - SEARCHVIEW_HEIGHT)
        let maskPath = UIBezierPath(roundedRect: bounds,byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii:CGSize(width:12, height:12))
        let masklayer = CAShapeLayer()
        masklayer.frame = bounds
        masklayer.path = maskPath.cgPath
        view.layer.mask = masklayer
        return view
    }()
    private lazy var myAlertView: StellarContentTitleAlertView = {
        let tempView = StellarContentTitleAlertView.stellarContentTitleAlertView()
        tempView.setTitleAndContentType(content: StellarLocalizedString("ALERT_ADD_GATEWAY_FIRST"), leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("ADD_DECICE_ADD_GATEWAY"), title: "")
        tempView.rightButtonBlock = { [weak self] in
            guard let dataList = self?.selectList else {
                return
            }
            guard let indexPath = self?.selectedIndexPath else {
                if let model = self?.navSearchView.selectDevice{
                    self?.jumpCommonGuideViewController(model)
                }
                return
            }
            let model = dataList[indexPath.row]
            self?.jumpCommonGuideViewController(model)
            self?.selectedIndexPath = nil
        }
        tempView.leftButtonBlock = { [weak self] in
            self?.selectedIndexPath = nil
        }
        self.view.addSubview(tempView)
        return tempView
    }()
    private func jumpCommonGuideViewController(_ model:AddDeviceDetailModel){
        if model.remoteType == .needGateway,let detailModel = myAddDeviceModel.dui?.first,checkAuthorizationStatus() {
            let vc = CommonGuideViewController()
            vc.deviceDetailModel = detailModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private lazy var bleTipView: StellarImageTitleAlertView = {
        let alertView = StellarImageTitleAlertView.stellarImageTitleAlertView()
        alertView.setImageContentType(content: StellarLocalizedString("ALERT_NEED_OPEN_BLE"), leftClickString: StellarLocalizedString("COMMON_FINE"), rightClickString: StellarLocalizedString("ALERT_TO_SETUP"), image: UIImage.init(named: "icon_bluetooth"))
        alertView.rightButtonBlock = {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)! , options: [:], completionHandler: nil)
        }
        self.view.addSubview(alertView)
        return alertView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension AddDeviceVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AddDeviceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddDeviceCell
        cell.selectionStyle = .none
        if let model = selectList?[indexPath.row] {
            cell.setData(detailModel: model)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        guard let dataList = selectList else {
            return
        }
        let model = dataList[indexPath.row]
        if model.connection == .unknown {
            return
        }
        selectDeviceToJump(model)
    }
    func selectDeviceToJump(_ model:AddDeviceDetailModel){
        view.endEditing(true)
        if model.connection == .mesh {
            self.addLights(model)
        }else if model.connection == .softAP && checkAuthorizationStatus() {
            self.getDeviceRegisterToken()
        }else if model.connection == .ble && checkAuthorizationStatus() {
            if !StellarHomeBleManger.sharedManager.isOpenBlueTooth() {
                self.bleTipView.showView()
            }else {
                let vc = SearchBleLampVC()
                vc.deviceDetailModel = model
                navigationController?.pushViewController(vc, animated: true)
            }
        }else if model.connection == .zigbee {
            self.addLights(model)
        }else if model.connection == .dui && checkAuthorizationStatus() {
            let vc = CommonGuideViewController()
            vc.deviceDetailModel = model
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func addLights(_ model: AddDeviceDetailModel) {
        let gateways = DevicesStore.instance.gateways.filter { (gatewayModel) -> Bool in
            gatewayModel.status.online
        }
        if gateways.count == 0 {
            myAlertView.showView()
        }else if gateways.count > 1 {
            let vc = AddToGatwayViewController()
            vc.hubList = gateways
            vc.deviceDetailModel = model
            navigationController?.pushViewController(vc, animated: true)
        }else {
            if model.type == .panel {
                let vc = CommonGuideViewController()
                vc.deviceDetailModel = model
                vc.gateWayModel = gateways.first!
                navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = SearchDeviceViewController()
                vc.deviceDetailModel = model
                vc.belongGateWayModel = gateways.first!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
extension AddDeviceVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let dataList = selectList else {
            return
        }
        if status == .authorizedWhenInUse {
            guard let indexPath = selectedIndexPath else { return  }
            let model = dataList[indexPath.row]
            if model.connection == .softAP {
                self.getDeviceRegisterToken()
            }else if model.connection == .ble && model.type == .hub {
                let vc = CommonGuideViewController()
                vc.deviceDetailModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    private func getDeviceRegisterToken() {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().getDeviceRegisterToken(success: { [weak self] (dic) in
            StellarProgressHUD.dissmissHUD()
            guard let token: String = dic["registerToken"] as? String else {
                TOAST(message: "token获取失败")
                return
            }
            let vc = AddWiFiOrResetLightViewController()
            if let index = self?.selectedIndexPath?.row,let list = self?.selectList {
                let model = list[index]
                vc.detailModel = model
            }
            vc.isAddWifiDevice = true
            vc.deviceToken = token
            self?.navigationController?.pushViewController(vc, animated: true)
        }) { (err) in
            StellarProgressHUD.dissmissHUD()
            print("qqtt - \(err)")
            TOAST(message: "网络错误")
        }
    }
    private func checkAuthorizationStatus() -> Bool{
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse {
                return true
            } else if status == .denied {
                showSystemAlert()
                return false
            }else {
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
                return false
            }
        }
        return true
    }
    private func showSystemAlert() {
        let alertController: UIAlertController = UIAlertController(title: StellarLocalizedString("ADD_DEVICE_REMINDER"), message: StellarLocalizedString("ALERT_SETTING_TURNON"), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:StellarLocalizedString("COMMON_CANCEL"), style: UIAlertAction.Style.default, handler: nil))
        alertController.addAction(UIAlertAction(title:StellarLocalizedString("COMMON_FINE"), style: UIAlertAction.Style.cancel, handler:{ (UIAlertAction) in
            guard let url: URL = URL.init(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
}