import UIKit
class FullColorDetailCell: UICollectionViewCell {
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var checkIcon: UIImageView!
    var clickBlock: (() ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.font = STELLAR_FONT_NUMBER_T12
        colorButton.layer.cornerRadius = 35.0/2.0
        colorButton.clipsToBounds = true
        colorButton.layer.borderWidth = 1.0
        colorButton.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        checkIcon.isHidden = true
    }
    @IBAction func onClicked(_ sender: Any) {
        clickBlock?()
    }
    func setupViews(cctModel: FullColorModel) {
        colorButton.backgroundColor = UIColor(hex: cctModel.bgColor)
        mTitleLabel.text = "\(cctModel.cct)K"
        checkIcon.isHidden = !cctModel.isSelected
    }
    func showLoading() {
        colorButton.ss.startActivityIndicator(color: UIColor.ss.rgbA(r: 177, g: 77, b: 47, a: 0.3))
    }
    func stopLoading() {
        colorButton.ss.stopActivityIndicator()
    }
    func showSelected() {
        checkIcon.isHidden = false
    }
    func hiddenSelected() {
        checkIcon.isHidden = true
    }
}