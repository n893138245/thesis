import UIKit
class ColorView: UIView {
    var light: LightModel?
    var actionModel: ExecutionModel?
    var roomId: Int?
    var lightGroup: [LightModel]?
    var colorPicker: TheColorPickerView?
    private var myControltype: UserControlType = .unkowning
    private let disposeBag = DisposeBag()
    private lazy var seletedImgView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "icon_color_check")
        imgV.contentMode = .scaleAspectFit
        imgV.isHidden = true
        return imgV
    }()
    private let quickDataList = [RGB(0.0/255, 255.0/255, 0.0/255, 1),
                                 RGB(0.0/255,0.0/255, 255.0/255, 1),
                                 RGB(255.0/255,255.0/255, 0.0/255, 1),
                                 RGB(255.0/255,0.0/255, 0.0/255, 1),
                                 RGB(180.0/255,0.0/255, 255.0/255, 1)]
    override init(frame: CGRect) {
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
        if colorPicker != nil {
            return
        }
        setupNotify()
        setupViews()
        setupPickColorActions()
        setupColorButtons()
    }
    private func setupViews() {
        var isColorMode = false
        if let pLight = light {
            setupData(pLight: pLight)
            isColorMode = pLight.status.currentMode == .color
        }
        if let pLightGroup = lightGroup {
            setupData(pLightGroup: pLightGroup)
            isColorMode = pLightGroup.first?.status.currentMode == .color
        }
        if let action = actionModel {
            setupData(pActionModel: action)
            isColorMode = action.execution.first?.command == .color
        }
        guard let color = colorPicker?.indicatorView.backgroundColor else { return }
        if !isColorMode {
            return
        }
        creatNetCommands(color: color)
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
                if currentMode != .color {
                    return
                }
                guard let color = self?.colorPicker?.indicatorView.backgroundColor else {
                    return
                }
                self?.creatNetCommands(color: color)
            }).disposed(by: disposeBag)
    }
    private func getFrame() -> CGRect {
        let leftSapce: CGFloat = kScreenWidth < 375.0 ? 45 : 30
        let w = bounds.width - 2 * leftSapce
        let h = bounds.height - 35 - 17
        var rect = CGRect.zero
        if w <= h {
            rect = CGRect(x: leftSapce, y: (h - w)/2, width: w, height: w)
        }else{
            rect = CGRect(x: leftSapce, y: (w - h)/2, width: h - 2 * leftSapce, height: h - 2 * leftSapce)
        }
        return rect
    }
    private func getFixRGB(rgb: (r: Int,g: Int,b: Int)) -> RGB {
        let R = rgb.r >= 0 ? rgb.r : 255
        let G = rgb.g >= 0 ? rgb.g : 255
        let B = rgb.b >= 0 ? rgb.b : 255
        return RGB(CGFloat(R)/255.0, CGFloat(G)/255.0, CGFloat(B)/255.0, 1)
    }
    private func setupData(pLight: LightModel) {
        myControltype = .singleLightControl
        addColorPicker(rgb: getFixRGB(rgb: pLight.status.color))
    }
    private func setupData(pLightGroup: [LightModel]) {
        myControltype = .lightGroupControl
        guard let pLight = pLightGroup.first else { return }
        pLight.status.color == (0, 0, 0) ? addColorPicker(rgb: getFixRGB(rgb: (255, 255, 255))):addColorPicker(rgb: getFixRGB(rgb: pLight.status.color))
    }
    private func setupData(pActionModel: ExecutionModel) {
        myControltype = .roomControl
        if let room = pActionModel.room {
            roomId = room
        }
        guard let color = pActionModel.execution.first?.params?.color else {
            let rgb = RGB(CGFloat(255)/255.0, CGFloat(255)/255.0, CGFloat(255)/255.0, 1)
            addColorPicker(rgb: rgb)
            return
        }
        let rgb = RGB(CGFloat(color.r)/255.0, CGFloat(color.g)/255.0, CGFloat(color.b)/255.0, 1)
        addColorPicker(rgb: rgb)
    }
    private func addColorPicker(rgb: RGB) {
        colorPicker = TheColorPickerView.init(frame: getFrame(), theRGB: rgb)
        addSubview(colorPicker!)
    }
    private func setupPickColorActions() {
        colorPicker?.pickerEndCallBack = { [weak self] (color) in
            self?.seletedImgView.isHidden = true
            self?.colorPicker?.startLayerShdowAnimation()
            self?.creatNetCommands(color: color)
        }
    }
    private func setupColorButtons() {
        let btnW: CGFloat = 28.fit
        let btnSpace: CGFloat = 16.fit
        let leftOffset = 20.fit
        for (i, color) in quickDataList.enumerated() {
            let btn = UIButton(frame: CGRect(x: leftOffset + CGFloat(i)*(btnW + btnSpace), y: bounds.height - 32.fit - btnW, width: btnW, height: btnW))
            btn.layer.cornerRadius = btnW/2
            btn.layer.masksToBounds = true
            btn.tag = 100 + i
            addSubview(btn)
            btn.backgroundColor = UIColor.init(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
            btn.rx.tap
                .subscribe(onNext: { [weak self] (_) in
                    self?.selectAction(btn: btn)
                }).disposed(by: disposeBag)
        }
        addSubview(seletedImgView)
        colorPicker?.setupIndicatPosition()
    }
    private func creatNetCommands(color: UIColor) {
        switch myControltype {
        case .singleLightControl,.lightGroupControl:
            creatCommandAndSend(color: color)
        case .roomControl:
            creatRoomColorCommand(color: color)
        default:
            break
        }
    }
    private func creatCommandAndSend(color: UIColor) {
        let red: CGFloat = color.red < 0 ? 0 : color.red
        let green: CGFloat = color.green < 0 ? 0 : color.green
        let blue: CGFloat = color.blue < 0 ? 0 : color.blue
        let rgb = (Int(red * 255),Int(green * 255),Int(blue * 255))
        var devices = [LightModel]()
        devices = (self.lightGroup?.count ?? 0 > 0 ? self.lightGroup:[self.light ?? LightModel()]) ?? [LightModel()]
        colorPicker?.startLayerShdowAnimation()
        CommandManager.shared.creatColorCommandAndSend(deviceGroup: devices, color: rgb, success: { (_) in
            self.colorPicker?.stopLayerShdowAnimation()
        }) { (_, _) in
            self.colorPicker?.stopLayerShdowAnimation()
        }
    }
    private func creatRoomColorCommand(color: UIColor) {
        colorPicker?.startLayerShdowAnimation()
        let red: CGFloat = color.red < 0 ? 0 : color.red
        let green: CGFloat = color.green < 0 ? 0 : color.green
        let blue: CGFloat = color.blue < 0 ? 0 : color.blue
        let rgb = (Int(red * 255),Int(green * 255),Int(blue * 255))
        CommandManager.shared.creatRoomRGBCammand(roomId: roomId!, RGB: rgb, success: { (_) in
            self.colorPicker?.stopLayerShdowAnimation()
        }) { (_, _) in
            self.colorPicker?.stopLayerShdowAnimation()
        }
    }
    private func selectAction(btn: UIButton) {
        seletedImgView.isHidden = false
        let tag = btn.tag
        let rgb = quickDataList[tag - 100]
        colorPicker?.rgb = rgb
        colorPicker?.setupIndicatPosition()
        let color = UIColor.ss.rgbA(r: rgb.red * 255.0, g: rgb.green * 255.0, b: rgb.blue * 255.0, a: 1)
        creatNetCommands(color: color)
        seletedImgView.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize(width: 13, height: 9))
            make.center.equalTo(btn.snp.center)
        }
    }
    deinit {
    }
}