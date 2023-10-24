import UIKit
class MineHeadView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconContentView: UIControl!
    var clickTitleBlock:(()->Void)?
    var clickIconBlock:(()->Void)?
    class func MineHeadView() ->MineHeadView {
        let view = Bundle.main.loadNibNamed("MineHeadView", owner: nil, options: nil)?.last as! MineHeadView
        return view
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize.init(width: 16, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        bringSubviewToFront(icon)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    private func setupViews(){
        nameLabel.textColor = STELLAR_COLOR_C4
        nameLabel.font = STELLAR_FONT_BOLD_T18
        nameLabel.text = StellarLocalizedString("MINE_EMPTY_NICKNAME")
        icon.layer.borderWidth = 2
        icon.layer.borderColor = STELLAR_COLOR_C3.cgColor
        icon.layer.cornerRadius = 45
        iconContentView.layer.cornerRadius = 46
        iconContentView.layer.shadowColor = UIColor.black.cgColor
        iconContentView.layer.shadowOffset = CGSize.zero
        iconContentView.layer.shadowOpacity = 0.37
        iconContentView.layer.shadowRadius = 3
    }
    @IBAction func clickIconAction(_ sender: Any) {
        clickIconBlock?()
    }
    @IBAction func clickTitleAction(_ sender: Any) {
        clickTitleBlock?()
    }
}