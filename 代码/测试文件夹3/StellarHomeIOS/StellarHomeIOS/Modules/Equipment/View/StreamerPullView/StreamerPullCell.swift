import UIKit
class StreamerPullCell: UITableViewCell {
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var mTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                mTitleLabel.textColor = STELLAR_COLOR_C1
                selectedIcon.isHidden = false
            }else {
                mTitleLabel.textColor = STELLAR_COLOR_C4
                selectedIcon.isHidden = true
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}