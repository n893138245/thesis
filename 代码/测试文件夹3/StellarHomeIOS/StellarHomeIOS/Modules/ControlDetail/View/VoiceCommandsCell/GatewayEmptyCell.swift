import UIKit
class GatewayEmptyCell: UITableViewCell {
    @IBOutlet weak var leftPadding: NSLayoutConstraint!
    @IBOutlet weak var rightPadding: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUpUI(padding: CGFloat) {
        leftPadding.constant = padding
        rightPadding.constant = padding
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}