import UIKit
class AccessDeviceCell: UITableViewCell {
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceBgView: UIView!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        deviceBgView.layer.cornerRadius = 25
        deviceBgView.clipsToBounds = true
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        arrow.isHidden = true
    }
    func setData(model: BasicDeviceModel) {
        let url = URL(string: getDeviceNormalIconBy(fwType: model.fwType))
        deviceImage.kf.setImage(with: url)
        if let light = model as? LightModel {
            statusLabel.text = light.status.online ? StellarLocalizedString("ADD_DEVICE_DEVICE_ONLINE"):StellarLocalizedString("ADD_DEVICE_DEVICE_OFFLINE")
            contentView.alpha = light.status.online ? 1.0:0.5
        }
        if model is PanelModel {
            statusLabel.text = StellarLocalizedString("ADD_DEVICE_DEVICE_ONLINE")
            contentView.alpha = 1.0
        }
        var room = ""
        if model.room != nil {
           room = StellarRoomManager.shared.getRoom(roomId: model.room!).name ?? ""
        }
        deviceNameLabel.text = "\(room) \(model.name)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}