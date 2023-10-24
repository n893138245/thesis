import UIKit
class DevicesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var iconBGView: UIView!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.textColor = STELLAR_COLOR_C4
        textLabel.font = STELLAR_FONT_T11
        iconBGView.backgroundColor = STELLAR_COLOR_C9
        iconBGView.layer.cornerRadius = 20
    }
    func setupViews(device: BasicDeviceModel, roomName: String) {
        if roomName.isEmpty {
            textLabel.text = device.name + "\n"
        }else {
            textLabel.text = roomName + "\n" + device.name
        }
        let url = URL(string: getDeviceNormalIconBy(fwType: device.fwType))
        icon.kf.setImage(with: url)
    }
}