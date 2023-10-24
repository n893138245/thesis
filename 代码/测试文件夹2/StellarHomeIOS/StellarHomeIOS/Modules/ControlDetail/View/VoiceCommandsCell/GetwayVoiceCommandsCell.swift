import UIKit
import Kingfisher
class GetwayVoiceCommandsCell: UITableViewCell {
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var bottomCommandLabel: UILabel!
    @IBOutlet weak var topCommandLabel: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceBgView: UIView!
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        deviceBgView.layer.cornerRadius = 27
        deviceBgView.clipsToBounds = true
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
    }
    func setupUI(findSkillModel: OrdersSetModel) {
        deviceNameLabel.text = findSkillModel.name
        let randomOrders: [String] = findSkillModel.randomOrders(count: 2)
        topCommandLabel.text = "“\(randomOrders.first ?? "")”"
        bottomCommandLabel.text = "“\(randomOrders.last ?? "")”"
        if findSkillModel.type == .hub {
            deviceImage.image = UIImage(named: "gateway_icon")
        }else {
            let url = URL(string: getDeviceNormalIconBy(fwType: findSkillModel.fwType))
            deviceImage.kf.setImage(with: url)
        }
    }
    func updateIconImage(url: String, isBgHidden: Bool = false) {
        let url = URL(string: url)
        deviceImage.kf.setImage(with: url, placeholder: UIImage.init(named: "gateway_skills_noimg"))
        if isBgHidden {
            deviceBgView.layer.cornerRadius = 11
            deviceBgView.backgroundColor = .clear
        }else{
            deviceBgView.layer.cornerRadius = 27
            deviceBgView.backgroundColor = .white
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}