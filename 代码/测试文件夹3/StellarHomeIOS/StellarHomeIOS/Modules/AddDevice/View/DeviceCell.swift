import UIKit
class DeviceCell: UICollectionViewCell {
    @IBOutlet weak var mDeviceNameLabel: UILabel!
    @IBOutlet weak var mDeviceIamge: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
     mDeviceNameLabel.font = STELLAR_FONT_T14
     mDeviceNameLabel.textColor = STELLAR_COLOR_C4
    }
}