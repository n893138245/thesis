import UIKit
class OperationTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    class func OperationTableViewCell() ->OperationTableViewCell {
        let view = Bundle.main.loadNibNamed("OperationTableViewCell", owner: nil, options: nil)?.last as! OperationTableViewCell
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lockImage.isHidden = true
        topLabel.textColor = STELLAR_COLOR_C4
        topLabel.font = STELLAR_FONT_BOLD_T16
        bottomLabel.textColor = STELLAR_COLOR_C6
        bottomLabel.font = STELLAR_FONT_T12
        colorView.layer.cornerRadius = 2
        colorView.clipsToBounds = true
        colorView.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        colorView.layer.borderWidth = 1.0
        colorView.isHidden = true
    }
    func setupViews(light: LightModel) {
        let url = URL(string: getDeviceNormalIconBy(fwType: light.fwType))
        icon.kf.setImage(with: url)
        var room = StellarRoomModel()
        if light.room != nil {
            room = StellarRoomManager.shared.getRoom(roomId: light.room ?? 0)
        }
        topLabel.text = "\(room.name ?? "") \(light.name)"
        if light.status.online {
            topLabel.textColor = STELLAR_COLOR_C4
            bottomLabel.textColor = STELLAR_COLOR_C6
            bottomLabel.text = StellarLocalizedString("SMART_DEVICE_ONLINE")
        }else {
            topLabel.textColor = STELLAR_COLOR_C7
            bottomLabel.textColor = STELLAR_COLOR_C7
            bottomLabel.text = StellarLocalizedString("SMART_DEVICE_OFFLINE")
        }
    }
    func setupViews(model: GroupModel) {
        colorView.isHidden = true
        guard let action = model.executions.first else {
            return
        }
        if action.room != nil {
            setRoomActionSatus(model: model)
        }else {
            guard let detail = action.execution.first else { return }
            if detail.command == .execute {
                setScenseActionStatus(model: model)
            }else {
                setControlDevicesStaus(model: model)
            }
        }
    }
    private func setRoomActionSatus(model: GroupModel) {
        setBottomTitleWithGroup(model: model)
        let room = StellarRoomManager.shared.getRoom(roomId: model.executions.first?.room ?? 0).name ?? "全部"
        var deviceCount = DevicesStore.sharedStore().lights.filter({$0.remoteType != .locally}).count
        if model.executions.first?.room != 0 {
            let lights = DevicesStore.sharedStore().sortedLightsDic[model.executions.first?.room ?? 0]
            deviceCount = lights?.filter({$0.remoteType != .locally}).count ?? 0
        }
        topLabel.text = "\(StellarLocalizedString("SMART_CONTROL_ROOM"))-\(room)（\(deviceCount)\(StellarLocalizedString("SMART_DEVICE_COUNT"))）"
        icon.image = UIImage(named: "room_none")
        guard let roomId = model.executions.first?.room else { return }
        let url = URL(string: getRoomIcon(roomId: roomId))
        icon.kf.setImage(with: url)
    }
    private func setScenseActionStatus(model: GroupModel) {
        icon.image = UIImage(named: "icon_scence_scence")
        topLabel.text = StellarLocalizedString("SCENE_EXECUTE")
        if let scenesName = StellarAppManager.sharedManager.user.mySceneModelArr.first(where: {$0.id == model.executions.first?.scene})?.name {
            bottomLabel.text = "\(scenesName)"
        }else {
            bottomLabel.text = "\(model.executions.first?.scene ?? "")"
        }
    }
    private func setControlDevicesStaus(model: GroupModel) {
        let device = DevicesStore.instance.findDevice(sn: model.executions.first?.device ?? "") ?? BasicDeviceModel()
        let url = URL(string: getDeviceNormalIconBy(fwType: device.fwType))
        icon.kf.setImage(with: url)
        setBottomTitleWithGroup(model: model)
        if model.executions.count > 1 {
            topLabel.text = "\(model.executions.count)\(StellarLocalizedString("SMART_DEVICE_COUNT"))"
        }else {
            if let excution = model.executions.first {
                var name = ""
                let allDevce = DevicesStore.instance.allDevices
                if let model = allDevce.first(where: { (device) -> Bool in
                    device.sn == excution.device
                }) {
                    var room = StellarRoomModel()
                    if model.room != nil {
                        room = StellarRoomManager.shared.getRoom(roomId: model.room!)
                    }
                    name = "\(room.name ?? "") \(model.name)"
                }
                topLabel.text = "\(name)"
            }
        }
    }
    private func setBottomTitleWithGroup(model: GroupModel) {
        guard let excute = model.executions.first?.execution.first else {
            return
        }
        switch excute.command {
        case .brightness:
            let brightness = excute.params?.brightness ?? 0
            let styleTxt = Style{
                $0.font = STELLAR_FONT_T12
                $0.color = STELLAR_COLOR_C6
            }
            let styleNum = Style{
                $0.font = STELLAR_FONT_NUMBER_T12
                $0.color = STELLAR_COLOR_C6
            }
            let txt = StellarLocalizedString("SMART_DEVICE_BRIGHTNESS")
            let num = " \(brightness)%"
            let attriTxt = txt.set(style: styleTxt) + num.set(style: styleNum)
            bottomLabel.attributedText = attriTxt
        case .onOff:
            let onOff = excute.params?.onOff ?? ""
            if  onOff == "on" {
                bottomLabel.text = StellarLocalizedString("SMART_TRUN_ON")
            }else if onOff == "off" {
                bottomLabel.text = StellarLocalizedString("SMART_TRUN_OFF")
            }else {
                bottomLabel.text = StellarLocalizedString("SMART_AUTOONOFF")
            }
        case .colorTemperature:
            let cct = excute.params?.cct ?? 0
            bottomLabel.text = StellarLocalizedString("SMART_TEMPERATURE")
            colorView.backgroundColor = TemperatureResource.getColorWithCCT(cct: cct)
            colorView.isHidden = false
        case .color:
            bottomLabel.text = StellarLocalizedString("SMART_COLOR")
            let color = excute.params?.color ?? (255,255,255)
            colorView.backgroundColor = UIColor.ss.rgbA(r: CGFloat(color.r), g: CGFloat(color.g), b: CGFloat(color.b), a: 1.0)
            colorView.isHidden = false
        default:
            break
        }
    }
    func setupViews(topString:String,bottomString:String,imageName:String){
        colorView.isHidden = true
        topLabel.text = topString
        bottomLabel.text = bottomString
        icon.image = UIImage.init(named: imageName)
    }
    func setupOreation(operation: DataType, currentOperation: DataType) {
        if operation == .executeScenesType {
            topLabel.text = StellarLocalizedString("SMART_EXECUTE_SCENSE")
            bottomLabel.text = StellarLocalizedString("SMART_SCENSE_EXAMPLE")
            icon.image = UIImage.init(named: "icon_scence_scence")
        }else if operation == .controlRoomType {
            topLabel.text = StellarLocalizedString("SMART_CONTROL_ROOM")
            bottomLabel.text = StellarLocalizedString("SMART_CONTROL_ROOM_EXAMPLE")
            icon.image = UIImage.init(named: "icon_room")
        }else if operation == .controlDeviceType {
            topLabel.text = StellarLocalizedString("SMART_CONTROL_DEVICE")
            bottomLabel.text = StellarLocalizedString("SMART_CONTROL_DEVICE_EXAMPLE")
            icon.image = UIImage.init(named: "icon_scence_light")
        }
        if currentOperation != .emptyType {
            if operation != currentOperation {
                contentView.alpha = 0.4
                lockImage.isHidden = false
                rightArrow.isHidden = true
            }else {
                contentView.alpha = 1.0
                lockImage.isHidden = true
                rightArrow.isHidden = false
            }
        }else {
            contentView.alpha = 1.0
            lockImage.isHidden = true
            rightArrow.isHidden = false
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for actionContent in subviews {
            if String(describing: actionContent).range(of: "SwipeActionsView") != nil {
                for wapView in actionContent.subviews {
                    wapView.frame.size = actionContent.frame.size
                    for button in wapView.subviews {
                        if let theButton = button as? UIButton {
                            theButton.backgroundColor = STELLAR_COLOR_C2
                            theButton.frame.size.height = 90
                            theButton.frame.size.width = 90
                            theButton.layer.cornerRadius = 10
                            theButton.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
}