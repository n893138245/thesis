import UIKit
class SelectHourCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8.fit
        bgView.clipsToBounds = true
        timeLabel.font = STELLAR_FONT_NUMBER_T14
    }
    func setupData(model: (hour: String, isHaveHistorty: Bool)) {
        timeLabel.text = model.hour
        if model.isHaveHistorty {
            bgView.backgroundColor = STELLAR_COLOR_C8
            timeLabel.textColor = STELLAR_COLOR_C5
        }else {
            bgView.backgroundColor = UIColor.clear
            timeLabel.textColor = STELLAR_COLOR_C7
        }
    }
}