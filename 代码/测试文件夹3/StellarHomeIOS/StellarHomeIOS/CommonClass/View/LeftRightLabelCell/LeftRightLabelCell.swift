import UIKit
class LeftRightLabelCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    func setupViews(){
        leftLabel.textColor = STELLAR_COLOR_C4
        leftLabel.font = STELLAR_FONT_T16
        rightLabel.textColor = STELLAR_COLOR_C6
        rightLabel.font = STELLAR_FONT_T14
    }
    func setTitles(leftString:String,rightString:String){
        leftLabel.text = leftString
        rightLabel.text = rightString
    }
}