import UIKit
enum CurrentMode {
    case color
    case temperature
}
class ColourModulationViewController: BaseViewController {
    var isSmart = false
    var lampModel: LightModel? {
        didSet {
            setupViewsWithLight()
        }
    }
    var excution: ExecutionModel? {
        didSet {
            setupSubViewsWithAction()
        }
    }
    var currentMode: CurrentMode = .color {
        didSet {
            if currentMode == .color {
                setBgContenOffset(xWith: 0)
            }else {
                setBgContenOffset(xWith: kScreenWidth)
            }
            NotificationCenter.default.post(name: .NOTIFY_CURRENTMODE_CHANGE, object: nil, userInfo: ["currentMode": currentMode])
        }
    }
    var deviceGroup: [LightModel]? {
        didSet {
            setupViewsWithGroup()
        }
    }
    var tabbarIsHidden = false {
        didSet {
            if tabbarIsHidden {
                switchButton.snp.remakeConstraints {
                    $0.bottom.equalTo(self.view).offset(-getAllVersionSafeAreaBottomHeight() - 54.fit - 27.fit)
                    $0.right.equalTo(self.view).offset(-19.fit)
                }
                bgScrollView.frame = CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - 54.fit - kNavigationH - getAllVersionSafeAreaBottomHeight())
                colorPickView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: bgScrollView.frame.height)
                temperatureView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: bgScrollView.frame.height)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(bgScrollView)
        view.addSubview(switchButton)
        bgScrollView.addSubview(colorPickView)
        bgScrollView.addSubview(temperatureView)
        var bottomSpace: CGFloat = 0
        if isSmart {
            bottomSpace = 54.fit
        }
        switchButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view).offset(-153.fit - getAllVersionSafeAreaBottomHeight() - bottomSpace)
            $0.right.equalTo(self.view).offset(-19.fit)
        }
    }
    func setupAction() {
        switchButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.switchButton.isSelected = !(self?.switchButton.isSelected ?? false)
                if self?.currentMode == .color {
                    self?.currentMode = .temperature
                }else {
                    self?.currentMode = .color
                }
            }).disposed(by: disposeBag)
    }
    private func setupViewsWithGroup() {
        guard let lightGroup = deviceGroup else {
            return
        }
        colorPickView.lightGroup = lightGroup
        temperatureView.lightGroup = lightGroup
        for light in lightGroup {
            if !(BackNetManager.sharedManager.needRestSns.contains(light.sn)) {
                BackNetManager.sharedManager.needRestSns.append(light.sn)
            }
        }
        checkUIWithLights(lights: lightGroup)
    }
    private func setupViewsWithLight() {
        guard let light = self.lampModel else {
            return
        }
        colorPickView.light = light
        temperatureView.light = light
        setupSubViews(lightModel: light)
    }
    private func setupSubViewsWithAction() {
        guard let action = excution else {
            return
        }
        copySns(execution: action)
        temperatureView.actionModel = action
        colorPickView.actionModel = action
        guard let detail = action.execution.first else {
            self.currentMode = .color
            return
        }
        if detail.command == .color {
            self.currentMode = .color
        }else if detail.command == .colorTemperature {
            self.currentMode = .temperature
            switchButton.isSelected = true
        }else {
            self.currentMode = .color
        }
        guard let roomId = action.room else {
            return
        }
        checkUIWithRoom(roomId: roomId)
    }
    private func checkUIWithRoom(roomId: Int) {
        var triats = [Traits]()
        if roomId == 0 {
            triats = DevicesStore.instance.getSumOfTriats(lights: DevicesStore.instance.lights)
        }else {
            triats = DevicesStore.instance.getSumOfTriats(lights: DevicesStore.instance.sortedLightsDic[roomId] ?? [LightModel]())
        }
        showStateWithTriats(triats: triats)
    }
    private func checkUIWithLights(lights: [LightModel]) {
        showStateWithTriats(triats: DevicesStore.instance.getSumOfTriats(lights: lights))
        guard let light = lights.first else { return }
        currentMode = light.status.currentMode == .color ? .color:.temperature
        if currentMode == .temperature {
            switchButton.isSelected = true
        }
    }
    private func showStateWithTriats(triats: [Traits]) {
        if !triats.contains(.color) {
            switchButton.isHidden = true
            self.currentMode = .temperature
        }else if !triats.contains(.colorTemperature) {
            switchButton.isHidden = true
            self.currentMode = .color
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
    private func setupSubViews(lightModel: LightModel) {
        if lightModel.remoteType == .locally {
            switchButton.isHidden = true
            self.currentMode = .temperature
        }else {
            var colorTriats = [Traits]()
            for trait in lightModel.traits ?? [Traits]() {
                if trait == .colorTemperature || trait == .color {
                    colorTriats.append(trait)
                }
            }
            if colorTriats.count == 1 { 
                switchButton.isHidden = true
                if let trait = colorTriats.first,trait == .colorTemperature {
                    currentMode = .temperature
                    return
                }
            }
            if lightModel.status.currentMode == .cct {
                switchButton.isSelected = true
                self.currentMode = .temperature
            }else {
                self.currentMode = .color
            }
        }
    }
    private func setBgContenOffset(xWith: CGFloat) {
        var offset = bgScrollView.contentOffset
        offset.x = xWith
        let animation = CATransition()
        animation.duration = 0.4
        animation.type = .init(rawValue: "rippleEffect")
        animation.subtype = .fromTop
        animation.timingFunction = .init(name: .easeInEaseOut)
        bgScrollView.layer.add(animation, forKey: "transition")
        self.bgScrollView.setContentOffset(offset, animated: false)
    }
    lazy var bgScrollView: UIScrollView = {
        let tempView = UIScrollView.init()
        var frame = CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - 126.fit
            - kNavigationH - getAllVersionSafeAreaBottomHeight())
        if isSmart {
            frame.size.height -= 54.fit
        }
        tempView.frame = frame
        tempView.contentSize = CGSize(width: kScreenWidth*2, height: 0)
        tempView.isPagingEnabled = true
        tempView.showsHorizontalScrollIndicator = false
        tempView.isScrollEnabled = false
        return tempView
    }()
    lazy var switchButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_change_color"), for: .selected)
        tempView.setImage(UIImage(named: "btn_change_temperature"), for: .normal)
        return tempView
    }()
    lazy var colorPickView: ColorView = {
        let tempView = ColorView()
        tempView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: bgScrollView.frame.size.height)
        return tempView
    }()
    lazy var temperatureView: TemperatureView = {
        let tempView = TemperatureView.init(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: bgScrollView.frame.size.height))
        return tempView
    }()
}