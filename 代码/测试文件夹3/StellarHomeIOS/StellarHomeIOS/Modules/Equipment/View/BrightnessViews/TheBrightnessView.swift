import UIKit
class TheBrightnessView: UIView {
    var modifyClosure: (() -> Void)?
    private var brightnessView: BrightnessView?
    var currentBrightness = 1
    private var roomId: Int?
    private var myControlType: UserControlType = .unkowning
    var light: LightModel? {
        didSet {
            setupData()
        }
    }
    var lightGroup: [LightModel]? {
        didSet {
            setupData()
        }
    }
    var action: ExecutionModel? {
        didSet {
            setupData()
        }
    }
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupNotify()
    }
    private func setupUI() {
        let w = bounds.width
        let h = bounds.height
        var rect = CGRect.zero
        let theW: CGFloat = kScreenWidth < 375.0 ? 131.fit : 131
        let theH: CGFloat = kScreenWidth < 375.0 ? 307.fit : 307
        rect = CGRect(x: (w-theW)/2, y: (h-theH)/2, width: theW, height: theH)
        brightnessView = BrightnessView(frame: rect)
        addSubview(brightnessView!)
        brightnessView?.touchEndClosure = { [weak self] (brightness) in
            self?.sendCommand(brightness: brightness)
        }
    }
    private func setupData() {
        if let pLight = light {
            setupInitDatas(pLight: pLight)
        }
        if let pLightGroup = lightGroup {
            setupInitDatas(pLightGroup: pLightGroup)
        }
        if let pAction = action {
            setupInitDatas(pAction: pAction)
        }
    }
    private func setupInitDatas(pLight: LightModel) {
        myControlType = .singleLightControl
        let brightness = pLight.status.brightness < 1 ? 1:pLight.status.brightness
        setupBasicData(b: brightness)
    }
    private func setupInitDatas(pLightGroup: [LightModel]) {
        myControlType = .lightGroupControl
        guard let lightModel = pLightGroup.first else {
            return
        }
        let brightness = lightModel.status.brightness < 1 ? 1:lightModel.status.brightness
        setupBasicData(b: brightness)
        sendCommand(brightness: brightness)
    }
    private func setupInitDatas(pAction: ExecutionModel) {
        guard let room = pAction.room else { return }
        myControlType = .roomControl
        roomId = room
        guard let b = pAction.execution.first?.params?.brightness else {
            setupBasicData(b: 50)
            sendCommand(brightness: 50)
            return
        }
        setupBasicData(b: b)
        sendCommand(brightness: b)
    }
    private func setupBasicData(b: Int) {
        currentBrightness = b
        brightnessView?.setBgViewFrame(b)
    }
    private func sendCommand(brightness: Int) {
        currentBrightness = brightness
        NotificationCenter.default.post(name: .NOTIFY_USER_BRIGHTNESS_CHANGE, object: nil, userInfo: ["brightness":brightness])
        switch myControlType {
        case .singleLightControl:
            if light?.remoteType == .locally {
                creatBleCommand(bringtness: brightness)
            }else {
                creatNormalCommodAndSend(bringtness: brightness)
            }
        case .lightGroupControl:
            creatNormalCommodAndSend(bringtness: brightness)
        case.roomControl:
            creatRoomCommand(b: brightness)
        default:
            break
        }
    }
    private func setupNotify() {
        NotificationCenter.default.rx.notification(.NOTIFY_BRIGHTNESS_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let dic = notify.userInfo as? [String: Int] else {
                    return
                }
                guard let brightness = dic["brightness"] else {
                    return
                }
                self?.currentBrightness = brightness
                self?.brightnessView?.setBgViewFrame(brightness)
            }).disposed(by: disposeBag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func creatNormalCommodAndSend(bringtness: Int) {
        var devices = [LightModel]()
        if let group = lightGroup {
            devices = group
        }else {
            devices = [self.light ?? LightModel()]
        }
        brightnessView?.startLayerShdowAnimation()
        CommandManager.shared.creatBringhtnessCommandAndSend(deviceGroup: devices, brightness: bringtness, success: { (_) in
            self.brightnessView?.stopLayerShdowAnimation()
        }) { (_, _) in
            self.brightnessView?.stopLayerShdowAnimation()
        }
    }
    private func creatRoomCommand(b:Int) {
        brightnessView?.startLayerShdowAnimation()
        CommandManager.shared.creatRoomBritnessCammand(roomId: roomId!, britness: b, success: { [weak self] (_) in
            self?.brightnessView?.stopLayerShdowAnimation()
        }) { [weak self] (_, _) in
            self?.brightnessView?.stopLayerShdowAnimation()
        }
    }
    private func creatBleCommand(bringtness: Int) {
        brightnessView?.startLayerShdowAnimation()
        StellarHomeBleManger.sharedManager.setupBrightnessLight(light: light ?? LightModel(), brightness: bringtness) { [weak self] (success, light) in
            self?.brightnessView?.stopLayerShdowAnimation()
        }
    }
    deinit {
    }
}