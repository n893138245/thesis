import UIKit
enum AboutStyle {
    case web
    case version
}
class AboutSansiWebCell: UITableViewCell {
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    var aboutStyle: AboutStyle = .web {
        didSet {
            if aboutStyle == .web {
                arrow.isHidden = false
                versionLabel.isHidden = true
                webLabel.isHidden = false
            }else {
                arrow.isHidden = true
                versionLabel.isHidden = false
                webLabel.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}