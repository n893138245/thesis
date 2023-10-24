import UIKit
class RoomManagerCell: UITableViewCell {
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var model: RoomModel? = nil {
        didSet {
            nameLabel.text = model?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}