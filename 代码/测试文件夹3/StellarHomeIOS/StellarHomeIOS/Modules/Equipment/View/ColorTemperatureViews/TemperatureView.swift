import UIKit
enum UserControlType {
    case singleLightControl
    case lightGroupControl
    case roomControl
    case unkowning
}
class TemperatureView: UIView {
    var light: LightModel?
    var lightGroup: [LightModel]?
    private var roomId: Int?
    var actionModel: ExecutionModel?
    private var maxCCT: Float = 6500
    private var minCCT: Float = 2700
    var currentCCT: Int = 0{
        didSet{
            if (Int(oldValue/100) != Int(currentCCT/100) && circleSlider?.isTouchBegin == true) {
                feedback.impactOccurred()
            }
        }
    }
    private var feedback: UIImpactFeedbackGenerator
    private var cctDataList: [(cct: Int, bgColor: String)] = []
    private var myControlType: UserControlType = .unkowning
    private var selectButton: UIButton?
    private let disposeBag = DisposeBag()
    var circleSlider: CircleSlider?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = STELLAR_FONT_T20
        label.textColor = STELLAR_COLOR_C6
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "2700k"
        return label
    }()
    private lazy var seletedIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icon_c_s")
        img.contentMode = .scaleAspectFit
        img.isHidden = true
        return img
    }()
    override init(frame: CGRect) {
        feedback = UIImpactFeedbackGenerator.init(style: .medium)
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    private func setupUI() {
        if circleSlider != nil {
            return
        }
        setupNotify()
        let leftSapce: CGFloat = kScreenWidth < 375.0 ? 45 : 30
        let w = bounds.width - 2*leftSapce
        let h = bounds.height - 35 - 17
        var rect = CGRect.zero
        if w <= h {
            rect = CGRect(x: leftSapce, y: (h-w)/2+20, width: w, height: w)
        }else{
            rect = CGRect(x: leftSapce, y: (w-h)/2+20, width: h - 2*leftSapce, height: h - 2*leftSapce)
        }
        circleSlider = CircleSlider(frame: rect)
        circleSlider?.delegate = self
        addSubview(circleSlider!)
        addSubview(titleLabel) 
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo((circleSlider?.snp.left)!).offset(90)
            make.right.equalTo((circleSlider?.snp.right)!).offset(-90)
            make.centerY.equalTo((circleSlider?.snp.centerY)!)
        }
        setupData()
    }
    private func setupNotify() {
        NotificationCenter.default.rx.notification(.NOTIFY_CURRENTMODE_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let dic = notify.userInfo as? [String: CurrentMode] else {
                    return
                }
                guard let currentMode = dic["currentMode"] else {
                    return
                }
                if currentMode != .temperature {
                    return
                }
                guard let cct = self?.currentCCT else {
                    return
                }
                self?.creatNetCommands(cct: cct)
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_CCT_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let dic = notify.userInfo as? [String: Int] else {
                    return
                }
                guard let cct = dic["cct"] else {
                    return
                }
                self?.setBasicDatas(cct: cct, maxValue: Int(self?.maxCCT ?? 6500), minValue: Int(self?.minCCT ?? 2700))
                if let pIndex = self?.cctDataList.firstIndex(where: {$0.cct == cct}),let pButton = self?.viewWithTag(pIndex + 1000) as? UIButton {
                    self?.seletedIcon.isHidden = false
                    self?.seletedIcon.snp.remakeConstraints { (make) in
                        make.size.equalTo(CGSize(width: 13, height: 9))
                        make.center.equalTo(pButton.snp.center)
                    }
                }else {
                    self?.seletedIcon.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    private func setupData() {
        var isCCTMode = false
        if let lightModel = light {
            setupData(pLight: lightModel)
            isCCTMode = lightModel.status.currentMode == .cct
        }
        if let lights = lightGroup {
            setupData(pLightGroup: lights)
            isCCTMode = lights.first?.status.currentMode == .cct
        }
        if let action = actionModel {
            setupData(action: action)
            isCCTMode = action.execution.first?.command == .colorTemperature
        }
        if !isCCTMode {
            return
        }
        creatNetCommands(cct: currentCCT)
    }
    private func setupData(pLight: LightModel) {
        myControlType = .singleLightControl
        setBasicDatas(cct: pLight.status.cct, maxValue: pLight.colorTemperatureRange.temperatureMaxK, minValue: pLight.colorTemperatureRange.temperatureMinK)
        cctDataList = TemperatureResource.gropCCTList.filter({ $0.cct > pLight.colorTemperatureRange.temperatureMinK && $0.cct < pLight.colorTemperatureRange.temperatureMaxK })
        creatGroupCCTListView(triats: pLight.traits ?? [Traits]())
    }
    private func setupData(pLightGroup: [LightModel]) {
        myControlType = .lightGroupControl
        let range = DevicesStore.instance.getLightGroupTemperatureRange(pLights: pLightGroup)
        guard let light = pLightGroup.first else {
            return
        }
        setBasicDatas(cct: light.status.cct, maxValue: range.max, minValue: range.min)
        cctDataList = TemperatureResource.gropCCTList.filter({ $0.cct > range.min && $0.cct < range.max })
        creatGroupCCTListView(triats: DevicesStore.instance.getSumOfTriats(lights: pLightGroup))
    }
    private func setupData(action: ExecutionModel) {
        guard let room = action.room else {
            return
        }
        roomId = room
        myControlType = .roomControl
        var lights: [LightModel] = []
        if room == 0 {
            lights = DevicesStore.instance.lights
        }else {
            lights = DevicesStore.instance.lights.filter({$0.room == room})
        }
        let range = DevicesStore.instance.getLightGroupTemperatureRange(pLights: lights)
        cctDataList = TemperatureResource.gropCCTList.filter({ $0.cct > range.min && $0.cct < range.max })
        guard let light = lights.first else {
            return
        }
        setBasicDatas(cct: light.status.cct, maxValue: range.max, minValue: range.min)
        let lightModels = room == 0 ? DevicesStore.instance.lights:DevicesStore.instance.lights.filter({$0.room == room})
        creatGroupCCTListView(triats: DevicesStore.instance.getSumOfTriats(lights: lightModels))
    }
    private func setBasicDatas(cct: Int,maxValue: Int, minValue: Int) {
        maxCCT = Float(maxValue)
        minCCT = Float(minValue)
        currentCCT = cct
        if cct > maxValue {
            currentCCT = maxValue
        }
        if cct < minValue {
            currentCCT = minValue
        }
        titleLabel.text = "\(currentCCT)K"
        circleSlider?.setProgress(value: (Float(currentCCT) - minCCT)/(maxCCT-minCCT))
    }
    private func creatGroupCCTListView(triats: [Traits]) {
        let btnW: CGFloat = 28.fit
        let btnSpace: CGFloat = 16.fit
        let leftSpace: CGFloat = triats.contains(.color) ? 20.fit:(kScreenWidth-(btnW * CGFloat(cctDataList.count+1) + btnSpace * CGFloat(cctDataList.count)))/2.0
        for index in 0...cctDataList.count {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: leftSpace + CGFloat(index)*(btnW + btnSpace), y: bounds.height - 32.fit - btnW, width: btnW, height: btnW)
            if index == cctDataList.count {
                btn.setBackgroundImage(UIImage(named: "tc_more"), for: .normal)
            }else {
                btn.backgroundColor = UIColor(hexString: cctDataList[index].bgColor)
                btn.layer.cornerRadius = btnW/2
                btn.clipsToBounds = true
                btn.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
                btn.layer.borderWidth = 1.0
            }
            addSubview(btn)
            btn.tag = 1000 + index
            btn.rx.tap
                .subscribe(onNext: { [weak self] (_) in
                    self?.onClickGroupButton(button: btn)
                }).disposed(by: disposeBag)
        }
        addSubview(seletedIcon)
    }
    private func onClickGroupButton(button: UIButton) {
        let index = button.tag - 1000
        if index == cctDataList.count { 
            showBottomView()
        }else {
            seletedIcon.isHidden = false
            seletedIcon.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: 13, height: 9))
                make.center.equalTo(button.snp.center)
            }
            let cct = TemperatureResource.gropCCTList[index].cct
            setBasicDatas(cct: cct, maxValue: Int(maxCCT), minValue: Int(minCCT))
            creatNetCommands(cct: cct)
        }
    }
    private func showBottomView() {
        let bottomView = SSBottomPopView.SSBottomPopView()
        bottomView.setupViews(title: "色温")
        let fac = HBottomFullColorFactory()
        fac.cctRange = (Int(maxCCT),Int(minCCT))
        if myControlType == .singleLightControl {
            fac.devices = [light ?? LightModel()]
        }else if myControlType == .lightGroupControl {
            fac.devices = self.lightGroup
        }else {
            fac.roomId = self.roomId
        }
        bottomView.setDisplayFactory(factory: fac)
        bottomView.setContentHeight(height: 390 + getAllVersionSafeAreaBottomHeight())
        bottomView.show()
    }
    private func creatNetCommands(cct: Int) {
        NotificationCenter.default.post(name: .NOTIFY_USER_CCT_CHANGE, object: nil, userInfo: ["cct": cct])
        switch myControlType {
        case .singleLightControl:
            guard let lightModel = light else {
                return
            }
            if lightModel.remoteType == .locally {
                creatBleCommodAndSend(cct: cct)
            }else {
                creatNormalCommodAndSend(cct: cct)
            }
        case .lightGroupControl:
            creatNormalCommodAndSend(cct: cct)
        case .roomControl:
            creatRoomCommodAndSend(cct: cct)
        default:
            break
        }
    }
    private func creatNormalCommodAndSend(cct: Int) {
        currentCCT = cct
        var devicesList = [LightModel]()
        devicesList = lightGroup?.count ?? 0 > 0 ? lightGroup!:[self.light ?? LightModel()]
        circleSlider?.startLayerShdowAnimation()
        CommandManager.shared.creatCCTCommandAndSend(deviceGroup: devicesList, cct: cct, success: { (_) in
            self.circleSlider?.stopLayerShdowAnimation()
        }) { (_, _) in
            self.circleSlider?.stopLayerShdowAnimation()
        }
    }
    private func creatRoomCommodAndSend(cct: Int) {
        currentCCT = cct
        circleSlider?.startLayerShdowAnimation()
        CommandManager.shared.creatRoomTemperatureCammand(roomId: roomId!, cct: cct, success: { (_) in
            self.circleSlider?.stopLayerShdowAnimation()
        }) { (_, _) in
            self.circleSlider?.stopLayerShdowAnimation()
        }
    }
    private func creatBleCommodAndSend(cct: Int) {
        currentCCT = cct
        circleSlider?.startLayerShdowAnimation()
        StellarHomeBleManger.sharedManager.setupCCTLight(light: light ?? LightModel(), cct: cct) { [weak self] (success, light) in
            self?.circleSlider?.stopLayerShdowAnimation()
        }
    }
    deinit {
    }
}
extension TemperatureView: CircleSliderDelegate {
    func progressDidChange(progress: Float) {
        let cct = Int(progress * (maxCCT - minCCT) + minCCT)
        currentCCT = cct
        selectButton?.isSelected = false
        titleLabel.text = "\(cct)K"
    }
    func progressChangeEnd(progress: Float) {
        let cct = Int(progress * (maxCCT-minCCT) + minCCT)
        selectButton?.isSelected = false
        titleLabel.text = "\(cct)K"
        creatNetCommands(cct: cct)
        seletedIcon.isHidden = true
    }
}