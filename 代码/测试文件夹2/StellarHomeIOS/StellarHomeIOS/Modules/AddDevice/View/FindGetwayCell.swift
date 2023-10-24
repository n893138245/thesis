import UIKit
class FindGetwayCell: UITableViewCell {
    @IBOutlet weak var nameCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var macNameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var mTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.font = STELLAR_FONT_T16
        mTitleLabel.textColor = STELLAR_COLOR_C4
        macNameLabel.font = STELLAR_FONT_T12
        macNameLabel.textColor = STELLAR_COLOR_C6
    }
    func setupData(gatewayModel: GatewayModel) {
        if gatewayModel.status.online {
            mTitleLabel.textColor = STELLAR_COLOR_C4
            contentView.alpha = 1.0
            mTitleLabel.text = gatewayModel.name
        }else {
            mTitleLabel.textColor = STELLAR_COLOR_C7
            contentView.alpha = 0.7
            mTitleLabel.text = "\(gatewayModel.name) \(StellarLocalizedString("ADD_DEVICE_DEVICE_OFFLINE"))"
        }
        var nameStr = ""
        if let roomId = gatewayModel.room, let roomName = StellarRoomManager.shared.getRoom(roomId: roomId).name{
            nameStr.append(roomName)
        }
        nameStr.append(" SN: \(gatewayModel.sn)")
        macNameLabel.text = nameStr
    }
    func setData(model:BleEquipmentModel){
        mTitleLabel.text = model.peripheral?.name
        let url = URL(string: getDeviceNormalIconBy(fwType: Int(model.fwType) ?? -1))
        icon.kf.setImage(with: url)
        macNameLabel.text = "\(StellarLocalizedString("EQUIPMENT_MAC")):" + model.mac
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}