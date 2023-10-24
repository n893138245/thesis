import UIKit
class RoomNoDeviceCell: UITableViewCell {
    @IBOutlet weak var mTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.text = StellarLocalizedString("SCENE_ROOM_EMPTY_DEVICE")
    }
    static func initWithXIb() -> UITableViewCell{
        let arrayOfViews = Bundle.main.loadNibNamed("RoomNoDeviceCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}