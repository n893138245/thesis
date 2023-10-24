import UIKit
class ControlColorViewController: BaseViewController {
    var isModify = false
    var modifyBlock:((_ group: GroupModel) ->Void)?
    var creatGroupDataModel = CreatGroupDataModel()
    var currentLight: LightModel? {
        didSet {
            colourModulationViewController.lampModel = currentLight
            navBar.titleLabel.text = currentLight?.name
        }
    }
    var lightGroup: [LightModel]? {
        didSet {
            colourModulationViewController.deviceGroup = lightGroup
            if lightGroup!.count > 1 {
                navBar.titleLabel.text = "\(lightGroup!.count)\(StellarLocalizedString("SMART_DEVICE_COUNT"))"
            }else {
                guard let light = lightGroup?.first else { return }
                navBar.titleLabel.text = light.name
            }
        }
    }
    var nextVC = UIViewController()
    var currentVC:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewAction()
    }
    var viewState: DetailChildState = .detailInit {
        didSet {
            if viewState == oldValue  {
                return
            }
            setupController(state: viewState)
        }
    }
    func setupController(state: DetailChildState){
        switch state {
        case .detailInit:
            nextVC = colourModulationViewController
        case .color:
            nextVC = colourModulationViewController
            fd_interactivePopDisabled = true
        case .streamer:
            nextVC = streamerViewController
            fd_interactivePopDisabled = false
        default:
            break
        }
        currentVC?.willMove(toParent: self)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        addChild(nextVC)
        nextVC.didMove(toParent: self)
        view.insertSubview(nextVC.view, belowSubview: self.tabBarView)
        nextVC.view.frame = view.bounds
        currentVC = nextVC
        let animation = CATransition()
        animation.duration = 0.25
        animation.type = .fade
        animation.subtype = .fromBottom
        animation.timingFunction = .init(name: .linear)
        view.layer.add(animation, forKey: "switchView")
    }
    var excution: ExecutionModel?
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tabBarView)
        view.addSubview(navBar)
        view.addSubview(confrimBtn)
        confrimBtn.snp.makeConstraints {
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view)
            $0.height.equalTo(54.fit + getAllVersionSafeAreaBottomHeight())
        }
        if excution != nil {
            setupStatusWithAction()
        }else {
            setupStatusWithLight()
        }
    }
    private func setupViewAction() {
        tabBarView.currentModeBlock = { [weak self] (mode) in
            self?.viewState = mode
        }
        navBar.backButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        confrimBtn.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.creatColorOrTempExcutions()
            }).disposed(by: disposeBag)
        if currentLight != nil {
            colourModulationViewController.lampModel = currentLight
        }
    }
    private func setupStatusWithAction() {
        if let action = excution {
            if let roomId = action.room {
                let room = StellarRoomManager.shared.getRoom(roomId: roomId).name ?? StellarLocalizedString("SMART_ALL")
                navBar.titleLabel.text = room
            }
            colourModulationViewController.excution = action
            self.viewState = .color
            tabBarView.isHidden = true
            colourModulationViewController.tabbarIsHidden = true
        }
    }
    private func setupStatusWithLight() {
        self.viewState = .color
        self.tabBarView.isHidden = true
        colourModulationViewController.tabbarIsHidden = true
    }
    private func creatColorOrTempExcutions() {
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
        var command: Traits = .other
        if colourModulationViewController.currentMode == .color {
            command = .color
            guard let color = colourModulationViewController.colorPickView.colorPicker?.indicatorView.backgroundColor else {
                params.color = (255,255,255)
                return GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: params, command: command, lights: lightGroup)
            }
            params.color = (Int(color.red < 0 ? 0:color.red * 255),Int(color.green < 0 ? 0:color.green * 255),Int(color.blue < 0 ? 0:color.blue * 255))
        }else {
            command = .colorTemperature
            params.cct = colourModulationViewController.temperatureView.currentCCT
        }
        if let action = excution {
            return GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: params, command: command, roomId: action.room)
        }
        var lights = [LightModel]()
        if lightGroup == nil {
            lights = [currentLight ?? LightModel()]
        }else {
            lights = lightGroup ?? [LightModel]()
        }
        return GroupModel.creatGroupMoel(groupId: creatGroupDataModel.groupId, param: params, command: command, lights: lights)
    }
    private lazy var confrimBtn: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setBackgroundImage(UIColor.ss.getImageWithColor(color: UIColor.init(hexString: "#1E55B7")), for: .normal)
        tempView.setTitle(StellarLocalizedString("COMMON_CONFIRM"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T16
        return tempView
    }()
    private lazy var tabBarView: ColorTabbar = {
        let tempView = ColorTabbar.init(frame: CGRect(x: 0, y: kScreenHeight - 126.fit - 54.fit - getAllVersionSafeAreaBottomHeight(), width: kScreenWidth, height: 126.fit))
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.titleLabel.text = StellarLocalizedString("SMART_MODIFY_COLOR")
        tempView.moreButton.isHidden = true
        return tempView
    }()
    private lazy var colourModulationViewController:ColourModulationViewController = {
        let vc = ColourModulationViewController()
        vc.isSmart = true
        return vc
    }()
    private lazy var streamerViewController:StreamerViewController = {
        let vc = StreamerViewController()
        vc.isSmart = true
        return vc
    }()
}