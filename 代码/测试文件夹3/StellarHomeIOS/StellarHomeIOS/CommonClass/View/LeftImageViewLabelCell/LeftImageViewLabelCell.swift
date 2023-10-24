import UIKit
class LeftImageViewLabelCell: UITableViewCell {
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        selectionStyle = .none
    }
    func setupViews(){
        leftLabel.textColor = STELLAR_COLOR_C4
        leftLabel.font = STELLAR_FONT_T16
    }
    func setupViews(leftString:String,leftIconName:String,isHiddenRightIcon:Bool){
        leftLabel.text = leftString
        leftIcon.image = UIImage.init(named: leftIconName)
        if isHiddenRightIcon {
            rightIcon.isHidden = true
        }
    }
}