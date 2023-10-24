import UIKit
class ControlRoomCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var deviceCountLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomIcon: UIImageView!
    @IBOutlet weak var iconBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.backgroundColor = STELLAR_COLOR_C9
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        iconBgView.layer.cornerRadius = 19
        iconBgView.clipsToBounds = true
    }
    func setData(room: String, conflict: Bool) {
        roomNameLabel.text = room
        if room == "全部" {
            deviceCountLabel.text = "\(DevicesStore.instance.lights.filter({$0.remoteType != .locally}).count)个设备"
            setRoomIcon(Id: 0)
        }else {
            if let id = StellarRoomManager.shared.getRoom(roomName: room).id {
                setRoomIcon(Id: id)
                let arr = DevicesStore.instance.lights.filter({$0.room == id})
                deviceCountLabel.text = "\(arr.filter({$0.remoteType != .locally}).count)个设备"
            }
        }
        if conflict {
            contentView.alpha = 0.4
        }else {
            contentView.alpha = 1.0
        }
    }
    private func setRoomIcon(Id: Int) {
        let url = URL(string: getRoomIcon(roomId: Id))
        roomIcon.kf.setImage(with: url)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}