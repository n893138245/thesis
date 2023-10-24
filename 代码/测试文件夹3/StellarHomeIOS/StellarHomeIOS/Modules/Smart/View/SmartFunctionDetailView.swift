import UIKit
class SmartFunctionDetailView: UIView {
    private let tagStart = 1000
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadSubViews(){
        let width:CGFloat = 32
        addSubview(clockButton)
        clockButton.frame = CGRect.init(x: 0, y: 0, width: width, height: width)
        addSubview(arrow)
        arrow.frame = CGRect.init(x: clockButton.frame.maxX + 3, y: 12, width: 13, height: 6)
        addSubview(lampBgView)
        lampBgView.frame = CGRect.init(x: arrow.frame.maxX + 3, y: 0, width: 6*42, height: width)
        creatRadomlamp_icons()
        addSubview(scenesButton)
        scenesButton.frame = CGRect.init(x: arrow.frame.maxX + 3, y: 0, width: width, height: width)
        addSubview(moreDetailsView)
        moreDetailsView.snp.makeConstraints {
            $0.centerY.equalTo(clockButton.snp.centerY)
            $0.left.equalTo(clockButton.snp.right).offset(5*42 + 15)
        }
        moreDetailsView.isHidden = true
    }
    func setData(model: IntelligentDetailModel) {
        guard let condition = model.condition.first else { 
            return
        }
        if condition.type == .countdown {
            clockButton.setImage(UIImage(named: "icon_scence_countdown"), for: .normal)
        }else if condition.type == .timing {
            clockButton.setImage(UIImage(named: "icon_scence_time"), for: .normal)
        }
        if model.enable {
            moreDetailsView.image = UIImage(named: "dian_s")
            arrow.image = UIImage(named: "icon_correlation_s")
        }else {
            moreDetailsView.image = UIImage(named: "dian_n")
            arrow.image = UIImage(named: "icon_correlation")
        }
        guard let action = model.actions.first else { 
            showEmptyActionStatus()
            return 
        }
        clockButton.isHidden = false
        arrow.isHidden = false
        guard let detail = action.execution.first else { 
            return
        }
        if detail.command == .execute { 
            scenesButton.isHidden = false
            lampBgView.isHidden = true
            scenesButton.setImage(UIImage(named: "icon_scence_scence"), for: .normal)
            moreDetailsView.isHidden = true
        }else { 
            lampBgView.isHidden = false
            scenesButton.isHidden = true
            setupShowlamp_icons(model: model)
        }
    }
    private func showEmptyActionStatus() {
        scenesButton.isHidden = true
        lampBgView.isHidden = true
        clockButton.isHidden = true
        arrow.isHidden = true
    }
    private func setupShowlamp_icons(model: IntelligentDetailModel) {
        var isControlRoomAction = false
        if (model.actions.first?.room) != nil {
            isControlRoomAction = true
        }
        var deviceOrRoomList = [String]()
        for action in model.actions {
            if isControlRoomAction {
                if !deviceOrRoomList.contains("\(action.room ?? 0)") {
                    deviceOrRoomList.append("\(action.room ?? 0)")
                }
            }else {
                if !deviceOrRoomList.contains(action.device ?? "") {
                    deviceOrRoomList.append(action.device ?? "")
                }
            }
        }
        isControlRoomAction ? showRoomIcons(roomIdList: deviceOrRoomList):showDeviceIcons(deviceList: deviceOrRoomList)
    }
    private func showRoomIcons(roomIdList: [String]) {
        moreDetailsView.isHidden = roomIdList.count <= 5
        for index in 0...4 {
            guard let room_iconBgView = lampBgView.viewWithTag(100 + index) else {
                return
            }
            room_iconBgView.isHidden = (index >= roomIdList.count)
            if !room_iconBgView.isHidden {
                setBottomIcons(lampBg: room_iconBgView, index: index, isControlRoomAction: true, list: roomIdList)
            }
        }
    }
    private func showDeviceIcons(deviceList: [String]) {
        moreDetailsView.isHidden = deviceList.count <= 5
        for index in 0...4 {
            guard let lamp_iconBgView = lampBgView.viewWithTag(100 + index) else {
                return
            }
            lamp_iconBgView.isHidden = (index >= deviceList.count)
            if !lamp_iconBgView.isHidden {
                setBottomIcons(lampBg: lamp_iconBgView, index: index, isControlRoomAction: false, list: deviceList)
            }
        }
    }
    private func setBottomIcons(lampBg: UIView,index: Int,isControlRoomAction: Bool,list: [String]) {
        if isControlRoomAction {
            let imageView = lampBg.viewWithTag(index + tagStart) as? UIImageView ?? UIImageView()
            imageView.frame.size.width = 20
            imageView.frame.size.height = 20
            imageView.image = UIImage(named: "room_none")
            imageView.center = CGPoint(x: lampBg.bounds.width/2, y: lampBg.bounds.height/2)
            guard let room = Int(list[index]) else { return }
            let url = URL(string: getRoomIcon(roomId: room))
            imageView.kf.setImage(with: url)
            return
        }
        let sn = list[index]
        if let device = DevicesStore.sharedStore().findDevice(sn: sn) {
            let url = URL(string: getDeviceNormalIconBy(fwType: device.fwType))
            if let imageView = lampBg.viewWithTag(index + tagStart) as? UIImageView {
                imageView.kf.setImage(with: url)
                imageView.frame.size.width = 27
                imageView.frame.size.height = 27
                imageView.center = CGPoint(x: lampBg.bounds.width/2, y: lampBg.bounds.height/2)
            }
        }
    }
    private func creatRadomlamp_icons() {
        for idx in 0...4 {
            let lamp_iconBgView = UIView.init(frame: CGRect(x: idx*42, y: 0, width: 32, height: 32))
            lamp_iconBgView.tag = 100 + idx
            lamp_iconBgView.backgroundColor = STELLAR_COLOR_C3
            lampBgView.addSubview(lamp_iconBgView)
            lamp_iconBgView.layer.cornerRadius = 16
            lamp_iconBgView.clipsToBounds = true
            lamp_iconBgView.backgroundColor = STELLAR_COLOR_C3
            let lamp_icon = UIImageView.init(image: UIImage(named: "lamp_icon"))
            lamp_icon.tag = idx + tagStart
            lamp_icon.bounds = CGRect(x: 0, y: 0, width: 27, height: 27)
            lamp_icon.center = CGPoint(x: lamp_iconBgView.frame.width/2, y: lamp_iconBgView.frame.height/2)
            lamp_icon.contentMode = .scaleAspectFit
            lamp_iconBgView.addSubview(lamp_icon)
        }
    }
    lazy var clockButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = STELLAR_COLOR_C3
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setImage(UIImage.init(named: "icon_scence_time"), for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: 6, right: 0)
        return button
    }()
    lazy var arrow:UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "icon_correlation")
        return view
    }()
    lazy var scenesButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = STELLAR_COLOR_C3
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.setImage(UIImage.init(named: "icon_scence_scence"), for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: 6, right: 0)
        return button
    }()
    lazy var lampBgView: UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy var moreDetailsView: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "dian_n"))
        return tempView
    }()
}