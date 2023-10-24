import UIKit
class AddingDevicesVC: AddDeviceBaseViewController {
    var myDeviceType:DeviceType = .unknown
    var selectDevices = [(device:BasicDeviceModel,addDeviceState:AddDeviceState)]()
    var timeTask:SSTimeTask?
    var currentTime = 0
    var gateWayRoomId = 1
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let time = timeTask{
            SSTimeManager.shared.removeTask(task: time)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTime()
        setupData()
    }
    private func setupUI(){
        lineImage.isHidden = false
        navBar.titleLabel.text = StellarLocalizedString("ADD_DEVICE_ADDING_DEVICE") + "..."
        navBar.backButton.isHidden = true
        let min = selectDevices.count
        hintLabel.text = StellarLocalizedString("ADD_DEVICE_PROCESS_TAKE_MIN1") + "\(min)" + StellarLocalizedString("ADD_DEVICE_PROCESS_TAKE_MIN2")
        scrollview.frame = CGRect.init(x: 0, y: 40, width: cardView.frame.size.width, height: cardView.frame.size.height - 40)
        var index:CGFloat = 0
        for selectDevice in selectDevices{
            let addingDeviceView = AddingDeviceView.AddingDeviceView()
            addingDeviceView.tag = Int(100 + index)
            addingDeviceView.frame = CGRect.init(x: 12.0, y: index * 84.0, width: scrollview.frame.size.width, height: 84.0)
            addingDeviceView.setData(device: selectDevice)
            scrollview.addSubview(addingDeviceView)
            index += 1
        }
        scrollview.contentSize = CGSize.init(width: scrollview.frame.size.width, height:CGFloat(84 * selectDevices.count))
        navBar.exitButton.isHidden = true
    }
    private func setupData(){
        guard let firstDeviceView = scrollview.viewWithTag(100) as? AddingDeviceView else {
            return
        }
        selectDevices[0].addDeviceState = .adding
        firstDeviceView.showAddingState()
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICE_ADD_DEVICE_RESULT).subscribe({ [weak self] (notify) in
            guard let vcSelf = self else{
                return
            }
            let userInfo = notify.element?.userInfo
            guard let result = userInfo?["addDeviceResult"] as? (device:BasicDeviceModel,isSuccess:Bool) else{
                return
            }
            let mac = result.device.mac
            let hasMacArr = vcSelf.selectDevices.map({ (seleDevice) -> String in
                return seleDevice.device.mac
            })
            guard let addIndex = hasMacArr.firstIndex(of: mac) else{
                return
            }
            let notifyDeviceState = vcSelf.selectDevices[addIndex].addDeviceState
            if notifyDeviceState == .success || notifyDeviceState == .fail {
                return
            }
            guard let deviceView = vcSelf.scrollview.viewWithTag(addIndex + 100) as? AddingDeviceView else {
                return
            }
            if result.isSuccess{
                let sn = result.device.sn
                vcSelf.timeTask?.repeatCount = 0
                vcSelf.selectDevices[addIndex].addDeviceState = .success
                vcSelf.selectDevices[addIndex].device.sn = sn
                deviceView.showAddedSuccessState()
                vcSelf.nextDeviceViewAnimation(nextIndex:addIndex + 1)
            }else{
                vcSelf.cuuentDeviceViewFail(addIndex:addIndex)
            }
        }).disposed(by:disposeBag)
    }
    private func nextDeviceViewAnimation(nextIndex:Int){
        guard let nextDeviceView = scrollview.viewWithTag(nextIndex + 100) as? AddingDeviceView else {
            gotoFinishedResult()
            return
        }
        selectDevices[nextIndex].addDeviceState = .adding
        nextDeviceView.showAddingState()
    }
    private func cuuentDeviceViewFail(addIndex:Int){
        guard let deviceView = scrollview.viewWithTag(addIndex + 100) as? AddingDeviceView else {
            return
        }
        timeTask?.repeatCount = 0
        selectDevices[addIndex].addDeviceState = .fail
        deviceView.showAddedFailState()
        nextDeviceViewAnimation(nextIndex:addIndex + 1)
    }
    func setupTime(){
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            guard let vcSelf = self else{
                return
            }
            if vcSelf.timeTask!.repeatCount >= 60{
                var index = 0
                var addDeviceIndex = -1
                for device in vcSelf.selectDevices{
                    if device.addDeviceState == .adding{
                        guard let deviceView = vcSelf.scrollview.viewWithTag(index + 100) as? AddingDeviceView else {
                            return
                        }
                        addDeviceIndex = index
                        vcSelf.selectDevices[index].1 = .fail
                        deviceView.showAddedFailState()
                    }
                    index += 1
                }
                vcSelf.timeTask?.repeatCount = 0
                if addDeviceIndex != -1 {
                    guard let nextDeviceView = vcSelf.scrollview.viewWithTag(addDeviceIndex + 101) as? AddingDeviceView else {
                        vcSelf.gotoFinishedResult()
                        return
                    }
                    vcSelf.selectDevices[addDeviceIndex+1].addDeviceState = .adding
                    nextDeviceView.showAddingState()
                }else{
                    vcSelf.gotoFinishedResult()
                }
            }
        }
    }
    func gotoFinishedResult(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc = AddDevicesFinishedViewController()
            vc.addFailDevices = self.selectDevices.filter({ (addFailDevice) -> Bool in
                addFailDevice.1 == .fail
            }).map({ (addFailDevice) -> BasicDeviceModel in
                addFailDevice.0
            })
            vc.addSuccessDevices = self.selectDevices.filter({ (addFailDevice) -> Bool in
                addFailDevice.1 == .success
            }).map({ (addFailDevice) -> BasicDeviceModel in
                addFailDevice.0
            })
            vc.gateWayRoomId = self.gateWayRoomId
            let nav = AddDeviceBaseNavController.init(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
    }
    override func setupExitButtonTap() {
        navBar.exitButton.rx.tap.subscribe(onNext:{ [weak self] in
            let alert = StellarMineAlertView.init(message: StellarLocalizedString("ADD_DEVICE_END_ADD"), leftTitle: StellarLocalizedString("ADD_DEVICE_SURE_END_ADD"), rightTile: StellarLocalizedString("ADD_DEVICE_BACKGROUND"), showExitButton: true)
            alert.show()
            alert.leftClickBlock = { 
                if StellarAppManager.sharedManager.currentStep == .kAppStepMain {
                    self?.dismiss(animated: true, completion: nil)
                }else{
                    StellarAppManager.sharedManager.nextStep()
                }
            }
            alert.rightClickBlock = { 
                if StellarAppManager.sharedManager.currentStep == .kAppStepMain {
                    self?.dismiss(animated: true, completion: nil)
                }else{
                    StellarAppManager.sharedManager.nextStep()
                }
            }
        }).disposed(by: disposeBag)
    }
    lazy var hintLabel: UILabel = {
        let label = UILabel.init()
        label.frame = CGRect.init(x: 0, y: 20, width: kScreenWidth - 40, height: 20)
        label.textColor = STELLAR_COLOR_C1
        label.textAlignment = .center
        label.font = STELLAR_FONT_T14
        cardView.addSubview(label)
        return label
    }()
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView.init()
        view.showsVerticalScrollIndicator = false
        cardView.addSubview(view)
        view.layer.masksToBounds = true
        return view
    }()
}