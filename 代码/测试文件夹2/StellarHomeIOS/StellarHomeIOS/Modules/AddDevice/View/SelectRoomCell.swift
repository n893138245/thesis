import UIKit
class SelectRoomCell: UITableViewCell {
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setupData(model: (room: StellarRoomModel, isSelected: Bool)) {
        model.isSelected ? setSelected():setUnselected()
        nameLabel.text = model.room.name
        guard let roomId = model.room.id else { return }
        let url = URL(string: getRoomIcon(roomId: roomId))
        roomIcon.kf.setImage(with: url)
    }
    func setSelected() {
        selectImage.image = UIImage(named: "radio_select")
    }
    func setUnselected() {
        selectImage.image = UIImage(named: "radio_normal")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}