import UIKit
class FoundSkillsRowCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bgWidth: NSLayoutConstraint!
    @IBOutlet weak var bgHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = STELLAR_FONT_T16
        contentLabel.numberOfLines = 0
        bgView.backgroundColor = STELLAR_COLOR_C9
    }
    func setupViews(content:String){
        contentLabel.text = "“\(content)”"
        let size = contentLabel.sizeThatFits(CGSize.init(width: kScreenWidth - 57*2, height: kScreenHeight))
        print("zzzzzzzzzzzzz \(size)  \(contentLabel.text ?? "")")
        bgWidth.constant = size.width + 34.0
        bgHeight.constant = size.height + 18.0
        layoutIfNeeded()
        let maskPath = UIBezierPath(roundedRect: bgView.bounds, byRoundingCorners: [.topRight,.topLeft,.bottomRight], cornerRadii: CGSize.init(width: 19, height: 19))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bgView.bounds
        maskLayer.path = maskPath.cgPath
        bgView.layer.mask = maskLayer
    }
}