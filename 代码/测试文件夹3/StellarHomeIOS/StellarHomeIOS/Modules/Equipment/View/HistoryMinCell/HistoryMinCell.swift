import UIKit
class HistoryMinCell: UITableViewCell {
    @IBOutlet weak var bottomGrayLineView: UIView!
    @IBOutlet weak var topGrayLineView: UIView!
    @IBOutlet weak var bluePointView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    var clickBlock:(() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        timeButton.layer.cornerRadius = 8
        timeButton.clipsToBounds = true
        timeButton.titleLabel?.font = STELLAR_FONT_NUMBER_T18
        timeButton.setTitleColor(STELLAR_COLOR_C5, for: .normal)
        bluePointView.layer.cornerRadius = 5
    }
    func setupData(time: String, isHiddenTopLine: Bool,isHiddenBottmLine: Bool) {
        timeButton.setTitle(time, for: .normal)
        topGrayLineView.isHidden = isHiddenTopLine
        bottomGrayLineView.isHidden = isHiddenBottmLine
    }
    @IBAction func clickButton(_ sender: Any) {
        clickBlock?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}