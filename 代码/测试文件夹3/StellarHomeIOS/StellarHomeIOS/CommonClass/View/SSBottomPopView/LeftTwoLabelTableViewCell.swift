import UIKit
class LeftTwoLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func initWithXIb() -> UITableViewCell{
        let arrayOfViews = Bundle.main.loadNibNamed("LeftTwoLabelTableViewCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    func setview(firstTitle:String = "",secondTitle:String = "",rightImageName:String = ""){
        firstLabel.text = firstTitle
        secondLabel.text = secondTitle
        rightIcon.image = UIImage.init(named: rightImageName)
    }
}