import UIKit
class ReSetHubCell: UITableViewCell {
    @IBOutlet weak var mTopTitleLbel: UILabel!
    @IBOutlet weak var mTopDetailLabel: UILabel!
    @IBOutlet weak var mBottomDetailLabel: UILabel!
    @IBOutlet weak var mBottomTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTopTitleLbel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_RESET_TITLE1")
        mTopDetailLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_RESET_CONTENT1")
        mBottomTitleLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_RESET_TITLE2")
        mBottomDetailLabel.text = StellarLocalizedString("ADD_DEVICE_GATEWAY_RESET_CONTENT2")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}