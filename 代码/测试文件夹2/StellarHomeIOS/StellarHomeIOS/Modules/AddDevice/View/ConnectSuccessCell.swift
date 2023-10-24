import UIKit
class ConnectSuccessCell: UITableViewCell {
    @IBOutlet weak var roomIcon: UIImageView!
    @IBOutlet weak var mCheckIcon: UIImageView!
    @IBOutlet weak var mTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.font = STELLAR_FONT_T15
        mTitleLabel.textColor = STELLAR_COLOR_C4
    }
    func setupViewsWithData(model: (roomModel: StellarRoomModel,isSelected: Bool)) {
        mTitleLabel.text = model.roomModel.name
        model.isSelected ? setSelected():setUnselected()
        guard let id = model.roomModel.id else { return }
        let url = URL(string: getRoomIcon(roomId: id))
        roomIcon.kf.setImage(with: url)
    }
    func setSelected() {
        mCheckIcon.image = UIImage(named: "radio_select")
    }
    func setUnselected() {
        mCheckIcon.image = UIImage(named: "radio_normal")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}