import UIKit
class SafetyVerficationTipCell: UITableViewCell {
    @IBOutlet weak var mTipLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTipLabel.text = StellarLocalizedString("MINE_CHANGEPHONE_VERIFY_TIP")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    static func initWithXIb() -> UITableViewCell{
        let arrayOfViews = Bundle.main.loadNibNamed("SafetyVerficationTipCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
}