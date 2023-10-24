import UIKit
enum DeviceState{
    case kStateOn
    case kStateNomal
    case kStateOffline
}
class DeviceCollectionViewCell: UICollectionViewCell {
    private var myDevice = BasicDeviceModel()
    private let space:CGFloat = 9
    private var cellWidth:CGFloat = 0
    private var cellHeight:CGFloat = 0
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var roomBgView: UIView!
    @IBOutlet weak var batteryButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var showAnimationView: UIView!
    @IBOutlet weak var roomNameBgViewWidthConstraint: NSLayoutConstraint! 
    var batteryClickBlock:(()->Void)? = nil
    var deviceState:DeviceState = .kStateNomal{
        didSet{
            setState()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    private func initViews(){
        cellWidth = (kScreenWidth - space * 3) / 2.0
        cellHeight = cellWidth/174.0 * 114.0
        deviceLabel.font = STELLAR_FONT_BOLD_T15
        deviceLabel.textColor = STELLAR_COLOR_C4
        onlineLabel.font = STELLAR_FONT_T12
        onlineLabel.textColor = STELLAR_COLOR_C6
        roomLabel.font = STELLAR_FONT_T12
        roomLabel.textColor = STELLAR_COLOR_C5
        showAnimationView.isHidden = true
        showAnimationView.frame = CGRect.init(x: 0, y: 0, width: cellWidth, height: cellHeight)
        let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#0945B0").cgColor,UIColor.init(hexString: "#1878D7").cgColor])
        gradientLayer.frame = showAnimationView.frame
        showAnimationView.layer.insertSublayer(gradientLayer, at: 0)
    }
    func setData(model:BasicDeviceModel){
        myDevice = model
        deviceLabel.text = model.name
        roomBgView.isHidden = false
        var roomName = ""
        if model.room != nil && model.room != -1 {
            roomName = StellarRoomManager.shared.getRoom(roomId: model.room!).name ?? "\(model.room!)"
        }
        if roomName.isEmpty {
            roomBgView.isHidden = true
        }else{
            roomLabel.text = roomName
        }
        let url = URL(string: getDeviceNormalIconBy(fwType: model.fwType))
        deviceImageView.kf.setImage(with: url)
        if let equipmentModel = model as? PanelModel  {
            if equipmentModel.status.online{
                deviceState = .kStateNomal
            }else{
                deviceState = .kStateOffline
            }
        }
        if let equipmentModel = model as? LightModel  {
            if equipmentModel.status.online{
                if equipmentModel.status.onOff == "on"{
                    deviceState = .kStateOn
                }else{
                    deviceState = .kStateNomal
                }
            }else{
                deviceState = .kStateOffline
            }
        }
        if let equipmentModel = model as? GatewayModel  {
            if equipmentModel.status.online{
                deviceState = .kStateNomal
            }else{
                deviceState = .kStateOffline
            }
        }
        if !model.willReportState {
            deviceState = .kStateNomal
        }
        let roomNameRect = String.ss.getTextRectSize(text: roomLabel.text ?? "", font: STELLAR_FONT_T12, size: CGSize.init(width: kScreenWidth , height: CGFloat.greatestFiniteMagnitude))
        let space:CGFloat = 9
        let roomNameWidth = roomNameRect.size.width
        let batteryWidth:CGFloat = 49
        let cellWidth = (kScreenWidth - space*3)/2.0
        let battartLabelMinX = cellWidth - batteryWidth
        let roomBgViewMinX:CGFloat = 12
        if roomBgViewMinX + roomNameWidth + 10 >= battartLabelMinX {
            if batteryButton.isHidden == true{
                roomNameBgViewWidthConstraint.constant = cellWidth - roomBgViewMinX - 12.fit
            }else{
                roomNameBgViewWidthConstraint.constant = battartLabelMinX - roomBgViewMinX
            }
        }else{
            roomNameBgViewWidthConstraint.constant = roomNameWidth + 10.5
        }
    }
    private func setState(){
        switch deviceState {
        case .kStateOn:
            if myDevice is LightModel  {
                onlineLabel.text = "已开灯"
                batteryButton.isHidden = false
            }
            bgView.isHidden = false
            let gradientLayer = UIColor.ss.drawWithColors(colors: [UIColor.init(hexString: "#0945B0").cgColor,UIColor.init(hexString: "#1878D7").cgColor])
            gradientLayer.frame = CGRect.init(x: 0, y: 0, width: cellWidth, height: cellHeight)
            bgView.layer.insertSublayer(gradientLayer, at: 0)
            deviceLabel.textColor = STELLAR_COLOR_C3
            deviceLabel.alpha = 1
            onlineLabel.textColor = STELLAR_COLOR_C3
            roomBgView.alpha = 1
            roomLabel.textColor = STELLAR_COLOR_C3
            roomBgView.backgroundColor = STELLAR_COLOR_C8.withAlphaComponent(0.2)
            batteryButton.setImage(UIImage.init(named: "icon_power_white"), for: .normal)
            backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(1)
            batteryButton.setImage(UIImage(named: "icon_power_bluegray"), for: .disabled)
            break
        case .kStateNomal:
            onlineLabel.text = StellarLocalizedString("ADD_DEVICE_DEVICE_ONLINE")
            if myDevice is LightModel  {
                if myDevice.connection == .ble {
                    batteryButton.isHidden = true
                }else{
                    batteryButton.isHidden = false
                }
            }else{
                batteryButton.isHidden = true
            }
            bgView.layer.sublayers = []
            bgView.backgroundColor = STELLAR_COLOR_C3
            bgView.isHidden = false
            deviceLabel.textColor = STELLAR_COLOR_C4
            deviceLabel.alpha = 1
            onlineLabel.textColor = STELLAR_COLOR_C6
            roomLabel.textColor = STELLAR_COLOR_C5
            roomBgView.backgroundColor = STELLAR_COLOR_C8.withAlphaComponent(1)
            batteryButton.setImage(UIImage.init(named: "icon_power_black"), for: .normal)
            backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(1)
            batteryButton.setImage(UIImage(named: "icon_power_gray"), for: .disabled)
            break
        case .kStateOffline:
            onlineLabel.text = StellarLocalizedString("ADD_DEVICE_DEVICE_OFFLINE")
            batteryButton.isHidden = true
            bgView.isHidden = true
            deviceLabel.textColor = STELLAR_COLOR_C4.withAlphaComponent(0.2)
            onlineLabel.textColor = STELLAR_COLOR_C4.withAlphaComponent(0.2)
            roomLabel.textColor = STELLAR_COLOR_C4.withAlphaComponent(0.2)
            roomBgView.backgroundColor = STELLAR_COLOR_C8.withAlphaComponent(0.4)
            backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(0.98)
            break
        }
    }
    func openEquipmentWithAnimation(){
        if self.deviceState == .kStateNomal {
            showAnimationView.frame = self.batteryButton.frame
            showAnimationView.layer.cornerRadius = 16
            showAnimationView.layer.masksToBounds = true
            showAnimationView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.showAnimationView.frame = CGRect.init(x: 0, y: 0, width: self.cellWidth, height: self.cellHeight)
                self.showAnimationView.layer.cornerRadius = 10
                self.showAnimationView.layer.masksToBounds = true
            }) { (_) in
                self.deviceState = .kStateOn
                self.showAnimationView.isHidden = true
            }
        }
    }
    func closeEquipmentWithAnimation(){
        if self.deviceState == .kStateOn{
            deviceState = .kStateNomal
            showAnimationView.frame = CGRect.init(x: 0, y: 0, width: self.cellWidth, height: self.cellHeight)
            showAnimationView.layer.cornerRadius = 10
            showAnimationView.layer.masksToBounds = true
            showAnimationView.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.showAnimationView.frame = CGRect.init(x: self.cellWidth - 33 - 8.5, y: self.cellHeight - 33 - 8.5, width: 33, height: 33)
                self.showAnimationView.layer.cornerRadius = 16.5
                self.showAnimationView.layer.masksToBounds = true
            }) { (_) in
                self.showAnimationView.isHidden = true
            }
        }
    }
    @IBAction func powerClick(_ sender: Any) {
        batteryClickBlock?()
    }
}