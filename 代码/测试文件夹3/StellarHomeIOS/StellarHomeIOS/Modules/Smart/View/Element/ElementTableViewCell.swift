import UIKit
class ElementTableViewCell: UITableViewCell {
    @IBOutlet weak var lockedIcon: UIImageView!
    private var isSelectedStyle:Bool = false{
        didSet{
            if oldValue != isSelectedStyle {
                if isSelectedStyle{
                    setSelected()
                }else{
                    setUnselected()
                }
            }
        }
    }
    func setUpDatas(model: (light: LightModel,selected: Bool)) {
        var room = StellarRoomModel()
        if model.light.room != nil {
            room = StellarRoomManager.shared.getRoom(roomId: model.light.room!)
        }
        topLabel.text = "\(room.name ?? "") \(model.light.name)"
        if model.light.remoteType == .locally {
            contentView.alpha = 0.4
            bottomLabel.text = StellarLocalizedString("SCENE_SELECT_DEVICE_UNSUPPORT")
        }else {
            if model.light.status.online {
                contentView.alpha = 1.0
                bottomLabel.text = StellarLocalizedString("ADD_DEVICE_DEVICE_ONLINE")
            }else {
                contentView.alpha = 1.0
                bottomLabel.text = StellarLocalizedString("ADD_DEVICE_DEVICE_OFFLINE")
            }
        }
        selectIcon.image = model.selected ? UIImage.init(named: "radio_select"):UIImage.init(named: "radio_normal")
        let url = URL(string: getDeviceNormalIconBy(fwType: model.light.fwType))
        icon.kf.setImage(with: url)
    }
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var selectIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUnselected()
        setupViews()
    }
    func setupViews(){
        lockedIcon.isHidden = true
        topLabel.textColor = STELLAR_COLOR_C4
        topLabel.font = STELLAR_FONT_BOLD_T17
        bottomLabel.textColor = STELLAR_COLOR_C6
        bottomLabel.font = STELLAR_FONT_T13
    }
    func setUnselected(){
        selectIcon.image = UIImage.init(named: "radio_normal")
    }
    func setSelected(){
        selectIcon.image = UIImage.init(named: "radio_select")
    }
}