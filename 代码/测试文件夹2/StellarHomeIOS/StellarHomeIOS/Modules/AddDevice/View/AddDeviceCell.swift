import UIKit
class AddDeviceCell: UITableViewCell {
    @IBOutlet weak var modelTypeLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var typeBGView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        typeLabel.font = STELLAR_FONT_T11
        typeLabel.textColor = STELLAR_COLOR_C1
        modelTypeLabel.font = STELLAR_FONT_T11
        modelTypeLabel.textColor = STELLAR_COLOR_C6
        typeBGView.backgroundColor = UIColor.init(hexString: "#F0F6FF")
        typeBGView.layer.cornerRadius = 2
        typeBGView.layer.masksToBounds = true
        nameLabel.font = STELLAR_FONT_BOLD_T15
        nameLabel.textColor = STELLAR_COLOR_C4
    }
    func setData(detailModel:AddDeviceDetailModel,isHiddenArrow:Bool = true){
        let url = URL(string: getDeviceNormalIconBy(fwType: detailModel.fwType ?? -1))
        icon.kf.setImage(with: url,options:[.forceRefresh])
        typeLabel.text = getDeviceConnectionType(detailModel.connection)
        rightArrow.isHidden = isHiddenArrow
        guard let name = detailModel.name else {
            nameLabel.isHidden = true
            return
        }
        modelTypeLabel.text = detailModel.model
        nameLabel.isHidden = false
        nameLabel.text = name
    }
}