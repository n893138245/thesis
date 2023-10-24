import UIKit
class LeftImageAndLabelCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftImageview: UIImageView!
    @IBOutlet weak var arrowImageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView(){
        leftLabel.font = STELLAR_FONT_BOLD_T16
        leftLabel.textColor = STELLAR_COLOR_C4
    }
    func setProperty(image:String,leftTitle:String,isHiddenArrow:Bool)
    {
        leftLabel.text = leftTitle
        leftImageview.image = UIImage.init(named: image)
        arrowImageview.isHidden = isHiddenArrow
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}