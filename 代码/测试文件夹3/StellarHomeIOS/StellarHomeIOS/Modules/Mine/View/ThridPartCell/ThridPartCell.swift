import UIKit
class ThridPartCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var mContentLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        bgView.layer.cornerRadius = 8
//        bgView.clipsToBounds = true
        content.textColor = .gray
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupViews(icon: String,title: String,content: String) {
        iconImage.image = UIImage(named: icon)
        mTitleLabel.text = title
        mContentLabel.text = content
    }
}
