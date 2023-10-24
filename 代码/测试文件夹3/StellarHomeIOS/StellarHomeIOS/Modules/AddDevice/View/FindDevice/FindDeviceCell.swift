import UIKit
class FindDeviceCell: UITableViewCell {
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var isSelcted:Bool = false{
        didSet{
            if isSelcted{
                setSelectState()
            }else{
                setUnSelectState()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = STELLAR_FONT_T16
        nameLabel.textColor = STELLAR_COLOR_C4
    }
    func setData(model:(BasicDeviceModel,Bool),theType: DeviceType){
        nameLabel.text = model.0.name
        if model.1{
            isSelcted = true
        }else{
            isSelcted = false
        }
        let url = URL(string: getDeviceNormalIconBy(fwType: model.0.fwType))
        icon.kf.setImage(with: url)
    }
    private func setSelectState(){
        selectedIcon.image = UIImage.init(named: "radio_select")
    }
    private func setUnSelectState(){
        selectedIcon.image = UIImage.init(named: "radio_normal")
    }
}