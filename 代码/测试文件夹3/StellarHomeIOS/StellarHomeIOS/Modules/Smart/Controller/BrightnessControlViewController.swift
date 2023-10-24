import UIKit
class BrightnessControlViewController: BaseViewController {
    var isModify = false
    var modifyBlock:((_ group: GroupModel) ->Void)?
    var creatGroupDataModel = CreatGroupDataModel()
    var lampModel: LightModel? {
        didSet {
            brightnessView.light = lampModel
            navBar.titleLabel.text = lampModel?.name
        }
    }
    var lightGroup: [LightModel]? {
        didSet {
            for light in lightGroup ?? [LightModel]() {
                if !(BackNetManager.sharedManager.needRestSns.contains(light.sn)) {
                    BackNetManager.sharedManager.needRestSns.append(light.sn)
                }
            }
            brightnessView.lightGroup = lightGroup!
            if lightGroup!.count > 1 {
                navBar.titleLabel.text = "\(lightGroup!.count)\(StellarLocalizedString("SMART_DEVICE_COUNT"))"
            }else {
                navBar.titleLabel.text = lampModel?.name
            }
        }
    }
    var excution: ExecutionModel? {
        didSet {
            setupStatusWithAction()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewAction()
    }
    func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(brightnessView)
        brightnessView.snp.makeConstraints {
            $0.centerY.equalTo(self.view).offset(-17.fit)
            $0.centerX.equalTo(self.view)
            $0.width.equalTo(187.fit)
            $0.height.equalTo(366.fit)
        }
        view.addSubview(navBar)
        view.addSubview(confrimBtn)
        confrimBtn.snp.makeConstraints {
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view)
            $0.height.equalTo(54.fit + getAllVersionSafeAreaBottomHeight())
        }
    }
    private func setupViewAction() {
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        confrimBtn.rx.tap.subscribe(onNext:{ [weak self] in
            self?.creatBrightnessExcutions()
        }).disposed(by: disposeBag)
    }
    private func setupStatusWithAction() {
        if let action = excution {
            copySns(execution: action)
            if let roomId = action.room {
                let room = StellarRoomManager.shared.getRoom(roomId: roomId).name ?? StellarLocalizedString("SMART_ALL")
                navBar.titleLabel.text = room
                brightnessView.action = action
            }
        }
    }
    private func copySns(execution: ExecutionModel) {
        if let room = execution.room {
            if room == 0 {
                for light in DevicesStore.sharedStore().lights {
                    if !(BackNetManager.sharedManager.needRestSns.contains(light.sn)) {
                        BackNetManager.sharedManager.needRestSns.append(light.sn)
                    }
                }
            }else {
                let lights = DevicesStore.sharedStore().sortedLightsDic[room] ?? [LightModel]()
                for light in lights {
                    if !(BackNetManager.sharedManager.needRestSns.contains(light.sn)) {
                        BackNetManager.sharedManager.needRestSns.append(light.sn)
                    }
                }
            }
        }else {
            guard let sn = execution.device else { return  }
            if !(BackNetManager.sharedManager.needRestSns.contains(sn)) {
                BackNetManager.sharedManager.needRestSns.append(sn)
            }
        }
    }
    private func creatBrightnessExcutions() {
        let group = getNewGroup()
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
            case .creatScense:
                popToViewController(withClass: SceneDetailViewController.className())
            default:
                break
            }
        }
    }
    private func getNewGroup() -> GroupModel {
        let params = ExecutionDetailParams()
        params.brightness = brightnessView.currentBrightness
        if let action = excution {
            return GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: params, command: .brightness, roomId: action.room)
        }
        if lightGroup == nil {
            lightGroup = [LightModel]()
            lightGroup?.append(lampModel ?? LightModel())
        }
        return GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: params, command: .brightness, lights: lightGroup)
    }
    lazy var brightnessView: TheBrightnessView = {
        let tempView = TheBrightnessView.init(frame: CGRect(x: 0, y: 0, width: 187.fit, height: 366.fit))
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.titleLabel.text = StellarLocalizedString("SMART_MODIFY_BRIGHTNESS")
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var confrimBtn: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#1E55B7")), for: .normal)
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T16
        return tempView
    }()
}