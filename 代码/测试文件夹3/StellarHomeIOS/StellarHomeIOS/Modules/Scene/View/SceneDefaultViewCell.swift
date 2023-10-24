import UIKit
enum SceneUseState {
    case nolamp_icons
    case normal
}
class SceneDefaultViewCell: UITableViewCell {
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var moreDeviceView: UIView!
    @IBOutlet weak var moreDeviceViewConstraint: NSLayoutConstraint!
    private let tagStart = 1000
    var clickBlock:(() -> Void)?
    var moreBlock:(() -> Void)?
    var isSelectStyle = false {
        didSet {
            if isSelectStyle {
                selectImage.isHidden = false
                playButton.isHidden = true
                moreButton.isHidden = true
            }
        }
    }
    var useState: SceneUseState = .nolamp_icons {
        didSet {
            switch useState {
            case .nolamp_icons:
                playButton.setTitle(StellarLocalizedString("SMART_EDIT"), for: .normal)
                playButton.setImage(nil, for: .normal)
            case .normal:
                playButton.setTitle("", for: .normal)
                playButton.setImage(UIImage.init(named: "icon_scence_play"), for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        creatRadomlamp_icons()
        playButton.titleLabel?.textColor = STELLAR_COLOR_C4
        playButton.titleLabel?.font = STELLAR_FONT_BOLD_T14
        selectImage.isHidden = true
        bgImage.contentMode = .scaleAspectFill
        playButton.setTitle(StellarLocalizedString("SMART_USE"), for: .normal)
    }
    private func creatRadomlamp_icons() {
        for idx in 0...4 {
            let lamp_iconBgView = UIView.init(frame: CGRect(x: 16+idx*42, y: 88, width: 32, height: 32))
            lamp_iconBgView.tag = 100 + idx
            bgView.addSubview(lamp_iconBgView)
            lamp_iconBgView.layer.cornerRadius = 16
            lamp_iconBgView.clipsToBounds = true
            lamp_iconBgView.backgroundColor = STELLAR_COLOR_C3
            let lamp_icon = UIImageView.init(image: UIImage(named: "lamp_icon"))
            lamp_icon.bounds = CGRect(x: 0, y: 0, width: 27, height: 27)
            lamp_icon.center = CGPoint(x: lamp_iconBgView.frame.width/2, y: lamp_iconBgView.frame.height/2)
            lamp_icon.tag = tagStart + idx
            lamp_icon.contentMode = .scaleAspectFit
            lamp_iconBgView.addSubview(lamp_icon)
        }
        moreDeviceViewConstraint.constant = 16 + 5*42 - 10
        moreDeviceView.isHidden = false
    }
    func setData(sceneModel: ScenesModel) {
        nameLabel.text = sceneModel.name
        if let path = sceneModel.backImageUrl {
            bgImage.kf.setImage(with: URL(string: getScenesBgImage(path: path)))
        }else {
            bgImage.image = UIImage.init(named: "scence_\(sceneModel.backImageId ?? 1)")
        }
        if !(sceneModel.available ?? true) {
            useState = .nolamp_icons
        }else {
            useState = .normal
        }
        var isControlRoom = false 
        if (sceneModel.actions?.first?.room) != nil {
            isControlRoom = true
        }
        var deviceOrRoomList = [String]()
        for action in sceneModel.actions ?? [ExecutionModel]() {
            if isControlRoom {
                if !deviceOrRoomList.contains("\(action.room ?? 0)") {
                    deviceOrRoomList.append("\(action.room ?? 0)")
                }
            }else {
                if !deviceOrRoomList.contains(action.device ?? "") {
                    deviceOrRoomList.append(action.device ?? "")
                }
            }
        }
        isControlRoom ? showRoomIcons(roomList: deviceOrRoomList):showLightIcons(lightList: deviceOrRoomList)
    }
    private func showLightIcons(lightList: [String]) {
        for index in 0...4 {
            guard let light_iconBgView = bgView.viewWithTag(100 + index) else {
                return
            }
            light_iconBgView.isHidden = (index >= lightList.count)
            if !light_iconBgView.isHidden {
                setLampIconWithSn(lampBg: light_iconBgView, index: index, isControlRoom: false, list: lightList)
            }
        }
        moreDeviceView.isHidden = (lightList.count <= 5)
    }
    private func showRoomIcons(roomList: [String]) {
        for index in 0...4 {
            guard let room_iconBgView = bgView.viewWithTag(100 + index) else {
                return
            }
            room_iconBgView.isHidden = (index >= roomList.count)
            if !room_iconBgView.isHidden {
                setLampIconWithSn(lampBg: room_iconBgView, index: index, isControlRoom: true, list: roomList)
            }
        }
        moreDeviceView.isHidden = (roomList.count <= 5)
    }
    private func setLampIconWithSn(lampBg: UIView,index: Int,isControlRoom: Bool,list: [String]) {
        if isControlRoom {
            let tempIamgeView = lampBg.viewWithTag(index + tagStart) as? UIImageView ?? UIImageView()
            tempIamgeView.frame.size.height = 20
            tempIamgeView.frame.size.height = 20
            tempIamgeView.image = UIImage(named: "room_none")
            tempIamgeView.center = CGPoint(x: lampBg.bounds.width/2, y: lampBg.bounds.height/2)
            guard let roomId = Int(list[index]) else { return }
            let url = URL(string: getRoomIcon(roomId: roomId))
            tempIamgeView.kf.setImage(with: url)
            return
        }
        let sn = list[index]
        if let device = DevicesStore.sharedStore().findDevice(sn: sn) {
            let url = URL(string: getDeviceNormalIconBy(fwType: device.fwType))
            if let tempIamgeView = lampBg.viewWithTag(index + tagStart) as? UIImageView {
                tempIamgeView.kf.setImage(with: url)
                tempIamgeView.frame.size.height = 27
                tempIamgeView.frame.size.height = 27
            }
        }
    }
    func setDataBySelectStyleModel(model: (scense: ScenesModel, selected: Bool)) {
        setData(sceneModel: model.scense)
        if model.scense.available == false {
            self.contentView.alpha = 0.2
        }else {
            self.contentView.alpha = 1.0
        }
        if model.selected {
            selectImage.image = UIImage(named: "icon_streamer_white28_s")
        }else {
            selectImage.image = UIImage(named: "icon_streamer_white28")
        }
    }
    func setSelect(){
        selectImage.image = UIImage(named: "icon_streamer_white28_s")
    }
    func setUnSelect(){
        selectImage.image = UIImage(named: "icon_streamer_white28")
    }
    @IBAction func clickAction(_ sender: StellarButton) {
        if let block = clickBlock {
            block()
        }
    }
    @IBAction func moreAction(_ sender: Any) {
        if let block = moreBlock {
            block()
        }
    }
}