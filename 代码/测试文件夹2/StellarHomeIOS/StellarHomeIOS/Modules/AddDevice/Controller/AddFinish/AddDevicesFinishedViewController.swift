import UIKit
class AddDevicesFinishedViewController: AddDeviceBaseViewController {
    var addSuccessDevices = [(BasicDeviceModel)]()
    var addFailDevices = [(BasicDeviceModel)]()
    var gateWayRoomId: Int = 1 
    let group = DispatchGroup.init()
    let devicesQueue = DispatchQueue(label: "com.defaultRoomQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fd_interactivePopDisabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkScenes()
        for device in addSuccessDevices {
            DevicesStore.instance.changeDeviceName(device: device, newName: device.name, success: nil, failure: nil)
        }
    }
    private func setupUI(){
        lineImage.isHidden = false
        navBar.titleLabel.text = StellarLocalizedString("ALERT_ADD_COMPLETE")
        navBar.backButton.isHidden = true
        navBar.exitButton.isHidden = true
        cardView.addSubview(bottomButton)
        bottomButton.snp.makeConstraints {
            $0.width.equalTo(291.fit)
            $0.height.equalTo(46.fit)
            $0.centerX.equalTo(cardView)
            $0.bottom.equalTo(cardView).offset(-31.fit)
        }
        cardView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.bottom.equalTo(bottomButton.snp.top).offset(-8.0)
        }
        bottomButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.setNoRoomDevecesDefaultRoom()
        }).disposed(by: disposeBag)
    }
    private func checkScenes() {
        let arr = StellarAppManager.sharedManager.user.mySceneModelArr
        if arr.count == 0 {
            QueryDeviceTool.creatScenes()
        }
    }
    private func goNextStep() {
        NotificationCenter.default.post(name: .NOTIFY_DEVICES_CHANGE, object: nil, userInfo: nil)
        if StellarAppManager.sharedManager.currentStep == .kAppStepMain {
            var rootVC = self.presentingViewController
            while let parent = rootVC?.presentingViewController {
                rootVC = parent
            }
            rootVC?.dismiss(animated: true, completion: nil)
        }else{
            StellarAppManager.sharedManager.nextStep()
        }
    }
    private func setNoRoomDevecesDefaultRoom() {
        let noRoomDevices = addSuccessDevices.filter({return $0.room == nil})
        if noRoomDevices.count == 0 {
            goNextStep()
        }else {
            StellarProgressHUD.showHUD()
            bottomButton.startIndicator()
            for idx in 0..<noRoomDevices.count {
                group.enter()
                devicesQueue.async(group: group, qos: .default, flags: []) { [weak self] in
                    DevicesStore.instance.changeDeviceRoom(device: noRoomDevices[idx], newRoomId: self?.gateWayRoomId ?? 1, success: {
                        self?.group.leave()
                    }) {
                        self?.group.leave()
                    }
                }
            }
            group.notify(queue: devicesQueue) { [weak self] in 
                self?.goNext()
            }
        }
    }
    private func goNext() {
        DispatchQueue.main.async(execute: { [weak self] in
            StellarProgressHUD.dissmissHUD()
            self?.bottomButton.startIndicator()
            TOAST_SUCCESS(message: StellarLocalizedString("ALERT_SETUP_SUCCESS")) {
                self?.goNextStep()
            }
        })
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: cardView.bounds,style:.grouped )
        tempView.showsVerticalScrollIndicator = false
        tempView.register(UINib(nibName: "AddDeviceStateCell", bundle: nil), forCellReuseIdentifier: "addDeviceStateCellID")
        tempView.separatorStyle = .none
        tempView.delegate = self
        tempView.dataSource = self
        tempView.layer.cornerRadius = 12.fit
        tempView.clipsToBounds = true
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var bottomButton: StellarButton = {
        let tempView = StellarButton.init()
        tempView.style = .normal
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        return tempView
    }()
}
extension AddDevicesFinishedViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddDeviceStateSectionView.addDeviceStateSectionView()
        if section == 0{
            view.setview(leftTitle: StellarLocalizedString("ALERT_ADD_SUCCESS") + "   \(addSuccessDevices.count)", isHiddenRightButton: true, clickBlock: nil)
        }else{
            view.setview(leftTitle: StellarLocalizedString("ALERT_ADD_FAIL") + "   \(addFailDevices.count)", isHiddenRightButton: false, clickBlock: { [weak self] in
                let vc = ConnectFailedViewController()
                vc.isFailedReson = true
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return addSuccessDevices.count
        }
        return addFailDevices.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if addSuccessDevices.count > 0 || addFailDevices.count > 0 {
            return 2
        }
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addDeviceStateCellID", for: indexPath) as! AddDeviceStateCell
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let model = addSuccessDevices[indexPath.row]
            cell.setData(device: (model,.success), defaultRoomId: gateWayRoomId)
        }else{
            let model = addFailDevices[indexPath.row]
            cell.setData(device:( model,.fail), defaultRoomId: gateWayRoomId)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = addSuccessDevices[indexPath.row]
            let vc = MultipleSuccessViewController()
            vc.device = model
            vc.gateWayRoomId = gateWayRoomId 
            vc.changeBlock = { [weak self] newDevice in
                self?.addSuccessDevices.remove(at: indexPath.row)
                self?.addSuccessDevices.insert(newDevice, at: indexPath.row)
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = ConnectFailedViewController()
            vc.isFailedReson = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}