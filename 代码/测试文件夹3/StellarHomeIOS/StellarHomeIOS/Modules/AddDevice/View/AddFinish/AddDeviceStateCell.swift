import UIKit
class AddDeviceStateCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    private func setupViews(){
        stateLabel.textColor = STELLAR_COLOR_C6
        stateLabel.font = STELLAR_FONT_T12
        nameLabel.textColor = STELLAR_COLOR_C4
        nameLabel.font = STELLAR_FONT_T16
        stateLabel.text = StellarLocalizedString("ALERT_SET_INFO_VOICE")
    }
    func setData(device: (BasicDeviceModel,AddDeviceState), defaultRoomId: Int){
        nameLabel.text = device.0.name
        if device.1 == .success {
            if device.0.room == nil{
                stateLabel.text = StellarLocalizedString("ALERT_DEFAULT_ROOM") + ": \(StellarRoomManager.shared.getRoom(roomId: defaultRoomId).name ?? "") "
            }else {
                stateLabel.text = "\(StellarRoomManager.shared.getRoom(roomId: device.0.room ?? 0).name ?? "")"
            }
        }else if device.1 == .fail {
            stateLabel.text = StellarLocalizedString("ALERT_ADD_FAIL")
        }
        let url = URL(string: getDeviceNormalIconBy(fwType: device.0.fwType))
        icon.kf.setImage(with: url)
    }
}