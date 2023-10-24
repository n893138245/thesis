import UIKit
class LeftLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setUnselected()
    }
    func setupViews(){
        leftLabel.textColor = STELLAR_COLOR_C4
        leftLabel.font = STELLAR_FONT_T16
    }
    func setUnselected(){
        rightIcon.image = UIImage.init(named: "radio_normal")
    }
    func setSelected(){
        rightIcon.image = UIImage.init(named: "radio_select")
    }
}