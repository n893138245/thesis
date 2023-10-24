import UIKit
class PreSetCell: UICollectionViewCell {
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        animateView.backgroundColor = STELLAR_COLOR_C9
        let layer = UIColor.ss.drawWithColors(colors:[UIColor.init(hexString: "#134EB4").cgColor,UIColor.init(hexString: "#207AD5").cgColor])
        let width = (kScreenWidth - 40 - 32) / 3
        layer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        animateView.layer.insertSublayer(layer, at: 0)
        animateView.isHidden = true
        contentView.backgroundColor = STELLAR_COLOR_C9
    }
    func setupViews(model: (modeModel: LightInternalMode, isCurrentMode: Bool)) {
        mTitleLabel.text = model.modeModel.name
        let cct = model.modeModel.params?.cct ?? 4000
        var value = (title:model.modeModel.name,
                     image_n:"icon_temperature_5_w",
                     image_s:"icon_temperature_5_s",
                     value:cct) 
        if let pValue = TemperatureResource.titleImageList.first(where: {$0.title == model.modeModel.name}) {
            value = pValue
        }
        if model.isCurrentMode {
            mTitleLabel.textColor = STELLAR_COLOR_C3
            mImage.image = UIImage(named: value.image_n)
            animateView.isHidden = false
        }else {
            mTitleLabel.textColor = UIColor.black
            mImage.image = UIImage(named: value.image_s)
            animateView.isHidden = true
        }
    }
}