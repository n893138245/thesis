import UIKit
class DeviceDetailTabbar: UIView {
    private let TAG_START = 1000
    private var selectedButton: UIButton?
    private var buttonCount = 0 
    var currentModeBlock: ((_ mode: DetailChildState) -> Void)?
    var isPowerOff: Bool = false {
        didSet {
            setPowerStatus()
        }
    }
    var isCurrentHaveDelayTask: Bool = false {
        didSet {
          setDelayMode()
        }
    }
    var lightModel: LightModel? {
        didSet {
            setupUI()
            setButtonCurrentStatus() 
            isPowerOff = (lightModel?.status.onOff == "off")
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        removeAllSubviews()
        addSubview(topLine)
        backgroundColor = STELLAR_COLOR_C3
        var triatsList = [Traits]()
        for triat in lightModel!.traits ?? [Traits]() {
            if triat == .brightness || triat == .internalScene {
                triatsList.append(triat)
            }else if triat == .color && !triatsList.contains(.colorTemperature) {
                triatsList.append(triat)
            }else if triat == .colorTemperature && !triatsList.contains(.color) {
                triatsList.append(triat)
            } 
        }
        triatsList.removeAll(where: { $0 == .internalScene }) 
        if lightModel?.internalMode.count ?? 0 > 0 {
            triatsList.append(.internalMode)
        }
        if lightModel?.remoteType == .locally {
            triatsList.append(.delayOff)
        }
        if lightModel?.type == .mainLight {
            triatsList.append(.monitor)
        }
        powerButton.tabGorupCount = CGFloat(triatsList.count+1)
        let width = frame.width/CGFloat(triatsList.count+1)
        buttonCount = triatsList.count+1
        powerButton.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        addSubview(powerButton)
        powerButton.addTarget(self, action: #selector(changePowerState), for: .touchUpInside)
        for idx in 0..<triatsList.count {
            let triat = triatsList[idx]
            switch triat {
            case .brightness: 
                brightnessButton.tag = TAG_START + idx
                brightnessButton.tabGorupCount = CGFloat(triatsList.count+1)
                brightnessButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(brightnessButton)
                brightnessButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            case .colorTemperature,.color: 
                colorButton.tag = TAG_START + idx
                colorButton.tabGorupCount = CGFloat(triatsList.count+1)
                colorButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(colorButton)
                colorButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            case .internalScene: 
                streamerButton.tag = TAG_START + idx
                streamerButton.tabGorupCount = CGFloat(triatsList.count+1)
                streamerButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(streamerButton)
                streamerButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            case .delayOff:
                cutdownButton.tag = TAG_START + idx
                cutdownButton.tabGorupCount = CGFloat(triatsList.count+1)
                cutdownButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(cutdownButton)
                cutdownButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            case .internalMode:
                preSetButton.tag = TAG_START + idx
                preSetButton.tabGorupCount = CGFloat(triatsList.count+1)
                preSetButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(preSetButton)
                preSetButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            case .monitor:
                monitorButton.tag = TAG_START + idx
                monitorButton.tabGorupCount = CGFloat(triatsList.count+1)
                monitorButton.frame = CGRect(x: width*CGFloat(idx+1), y: 0, width: width, height: frame.size.height)
                addSubview(monitorButton)
                monitorButton.addTarget(self, action: #selector(selectItemWithIndex), for: .touchUpInside)
            default:
                break
            }
        }
    }
    private func setButtonCurrentStatus() {
        if lightModel?.traits == nil {
            return
        }
        guard let pTriats = lightModel?.traits else { return }
        guard let pLight = lightModel else { return }
        if pTriats.contains(.colorTemperature) || pTriats.contains (.color) || pTriats.contains(.internalScene) { 
            switch pLight.status.currentMode {
            case .cct,.color:
                colorButton.isSelected = true
                selectedButton = colorButton
            case .internalScene:
                streamerButton.isSelected = true
                selectedButton = streamerButton
            case .mode:
                preSetButton.isSelected = true
                selectedButton = preSetButton
            }
        }else { 
            brightnessButton.isSelected = true
            selectedButton = brightnessButton 
        }
    }
    private func setPowerStatus() {
        if isPowerOff { 
            selectedButton?.isSelected = false
            powerButton .setTitle(StellarLocalizedString("SMART_TRUN_ON"), for: .normal)
            powerButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            powerButton.setImage(UIImage(named: "btn_light_power_s"), for: .normal)
            currentModeBlock?(.power)
            hiddenOtherItems()
        }else {
            selectedButton?.isSelected = true
            powerButton.setTitle(StellarLocalizedString("SMART_TRUN_OFF"), for: .normal)
            powerButton.setTitleColor(STELLAR_COLOR_C6, for: .normal)
            powerButton.setImage(UIImage(named: "btn_light_power_n"), for: .normal)
            if let tag = selectedButton?.tag {
                if tag == self.brightnessButton.tag {
                    currentModeBlock?(.breghtness)
                }else if tag == self.colorButton.tag {
                    currentModeBlock?(.color)
                }else if tag == self.streamerButton.tag {
                    currentModeBlock?(.streamer)
                }else if tag == self.cutdownButton.tag {
                    currentModeBlock?(.delayOff)
                }else if tag == self.preSetButton.tag {
                    currentModeBlock?(.preSet)
                }else if tag == self.monitorButton.tag {
                    currentModeBlock?(.monitoring)
                }
            }else {
                currentModeBlock?(.breghtness)
            }
            showOtherItems()
        }
    }
    @objc private func changePowerState(button: DetailItem) {
        if isPowerOff { 
            self.creatCommodAndSend(onOff: "on")
        }else { 
            self.creatCommodAndSend(onOff: "off")
        }
    }
    private func hiddenOtherItems() {
        var frame = self.powerButton.frame
        frame.origin.x = self.frame.width/2-frame.width/2
        let pop = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        pop?.fromValue = self.powerButton.frame
        pop?.toValue = frame
        pop?.springSpeed = 20
        pop?.springBounciness = 10
        powerButton.pop_add(pop, forKey: kPOPViewFrame)
        self.alpaAnimate(view: self.brightnessButton, from: 1, to: 0)
        self.alpaAnimate(view: self.colorButton, from: 1, to: 0)
        self.alpaAnimate(view: self.streamerButton, from: 1, to: 0)
        self.alpaAnimate(view: self.cutdownButton, from: 1, to: 0)
        self.alpaAnimate(view: self.preSetButton, from: 1, to: 0)
        self.alpaAnimate(view: self.monitorButton, from: 1, to: 0)
    }
    private func showOtherItems() {
        let pop = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        pop?.fromValue = self.powerButton.frame
        pop?.toValue = CGRect(x: 0, y: 0, width: frame.size.width/CGFloat(buttonCount), height: frame.size.height)
        pop?.springSpeed = 20
        pop?.springBounciness = 10
        powerButton.pop_add(pop, forKey: kPOPViewFrame)
        pop?.completionBlock = { ani,finished in
            self.alpaAnimate(view: self.streamerButton, from: 0, to: 1)
            self.alpaAnimate(view: self.brightnessButton, from: 0, to: 1)
            self.alpaAnimate(view: self.colorButton, from: 0, to: 1)
            self.alpaAnimate(view: self.cutdownButton, from: 0, to: 1)
            self.alpaAnimate(view: self.preSetButton, from: 0, to: 1)
            self.alpaAnimate(view: self.monitorButton, from: 0, to: 1)
        }
    }
    private func alpaAnimate(view: DetailItem, from: Any, to: Any) {
        let pop = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        pop?.fromValue = from
        pop?.toValue = to
        pop?.springSpeed = 20
        pop?.springBounciness = 10
        view.pop_add(pop, forKey: kPOPViewAlpha)
    }
    @objc private func selectItemWithIndex(button: DetailItem) {
        if selectedButton != nil {
            if selectedButton!.isEqual(button) {
                return
            }
            selectedButton!.isSelected = false
        }
        button.isSelected = true
        selectedButton = button
        let tag = button.tag
        if tag == self.brightnessButton.tag {
            currentModeBlock?(.breghtness)
        }else if tag == self.colorButton.tag {
            currentModeBlock?(.color)
        }else if tag == self.streamerButton.tag {
            currentModeBlock?(.streamer)
        }else if tag == self.cutdownButton.tag {
            currentModeBlock?(.delayOff)
        }else if tag == self.preSetButton.tag {
            currentModeBlock?(.preSet)
        }else if tag == self.monitorButton.tag {
            currentModeBlock?(.monitoring)
        }
    }
    private func doFailureAction(onOff: String) {
        if onOff == "off" {
            StellarProgressHUD.dissmissHUD()
        }
        self.powerButton.powerStopNVIndicator()
        TOAST(message: StellarLocalizedString("ALERT_CONTROL_FAIL"))
    }
    private func doSuccessAction(onOff: String) {
        self.powerButton.powerStopNVIndicator()
        if onOff == "on" {
            self.isPowerOff = false
        }else {
            StellarProgressHUD.dissmissHUD()
            self.isPowerOff = true
        }
    }
    private func creatCommodAndSend(onOff: String) {
        if !isPowerOff {
            StellarProgressHUD.showHUD()
        }
        powerButton.powerStartNVIndicator(color: STELLAR_COLOR_C10)
        if lightModel?.remoteType == .locally { 
            StellarHomeBleManger.sharedManager.openCloseLight(light: lightModel ?? LightModel(), isOpen: isPowerOff) { (suceess, light) in
                if suceess {
                    self.doSuccessAction(onOff: onOff)
                }else {
                    self.doFailureAction(onOff: onOff)
                }
            }
        }else { 
            CommandManager.shared.creatOnOffCommandAndSend(deviceGroup: [lightModel!], onOff: onOff, success: { (response) in
                if let resultList = response as? [[CommonResponseModel]] {
                    if resultList[1].count == 0 {
                        self.doSuccessAction(onOff: onOff)
                        NotificationCenter.default.post(name: .NOTIFY_DEVICES_UPDATE, object: nil)
                    }else {
                        self.doFailureAction(onOff: onOff)
                    }
                }else {
                    self.doFailureAction(onOff: onOff)
                }
            }) { (code, message) in
                self.doFailureAction(onOff: onOff)
            }
        }
    }
    private func setDelayMode() {
        if isCurrentHaveDelayTask {
            if selectedButton != nil {
                selectedButton?.isSelected = false
            }
            selectedButton = self.cutdownButton
            if isPowerOff {
                return
            }
            setPowerStatus()
        }
    }
    lazy var topLine: UIView = {
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 1))
        line.backgroundColor = STELLAR_COLOR_C8
        return line
    }()
    lazy var powerButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "icon_power_gray49"), for: .disabled)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var brightnessButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_light_brightness_n"), for: .normal)
        tempView.setImage(UIImage(named: "btn_light_brightness_n"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_light_brightness_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_DEVICE_BRIGHTNESS"), for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_DEVICE_BRIGHTNESS"), for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var colorButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_light_color_n"), for: .normal)
        tempView.setImage(UIImage(named: "btn_light_color_n"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_light_color_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_COLOR_CHANGE"), for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_COLOR_CHANGE"), for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var streamerButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_light_streamer_n"), for: .normal)
        tempView.setImage(UIImage(named: "btn_light_streamer_n"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_light_streamer_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_STREAMER"), for: .normal)
        tempView.setTitle(StellarLocalizedString("SMART_STREAMER"), for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var preSetButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_light_streamer_n"), for: .normal)
        tempView.setImage(UIImage(named: "btn_light_streamer_n"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_light_streamer_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle("预设", for: .normal)
        tempView.setTitle("预设", for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var cutdownButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_cd_n"), for: .normal)
        tempView.setImage(UIImage(named: "btn_cd_s"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_cd_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_DELAY_OFF"), for: .normal)
        tempView.setTitle(StellarLocalizedString("EQUIPMENT_DELAY_OFF"), for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    lazy var monitorButton: DetailItem = {
        let tempView = DetailItem.init(type: .custom)
        tempView.setImage(UIImage(named: "btn_jiance"), for: .normal)
        tempView.setImage(UIImage(named: "btn_jiance_s"), for: .highlighted)
        tempView.setImage(UIImage(named: "btn_jiance_s"), for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        tempView.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        tempView.setTitle("监测", for: .normal)
        tempView.setTitle("监测", for: .highlighted)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
}