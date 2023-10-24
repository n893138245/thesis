import UIKit
class TitleAndNameTableViewCell: UITableViewCell {
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reddot: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    private func setupViews(){
        titleLabel.font = STELLAR_FONT_T16
        titleLabel.textColor = STELLAR_COLOR_C4
        rightLabel.font = STELLAR_FONT_T14
        rightLabel.textColor = STELLAR_COLOR_C6
    }
    func setlabelTitles(left:String,right:String,isHiddenArrow:Bool,isShowReddot:Bool)
    {
        titleLabel.text = left
        rightLabel.text = right
        if isHiddenArrow {
            rightLabelRightConstraint.constant = -20
            arrowImageView.isHidden = true
        }
        if isShowReddot{
            reddot.isHidden = false
            rightLabel.textColor = STELLAR_COLOR_C2
        }
        else
        {
            reddot.isHidden = true
            rightLabel.textColor = STELLAR_COLOR_C6
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}