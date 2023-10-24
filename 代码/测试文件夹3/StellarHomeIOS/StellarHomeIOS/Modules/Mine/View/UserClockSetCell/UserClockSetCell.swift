import UIKit
class UserClockSetCell: UITableViewCell {
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var mTipLabel: UILabel!
    var switchBlock: ((_ isOn: Bool) ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        mTipLabel.isHidden = true
    }
    func setupData(model: (type: UserAlertWays,isOpen: Bool,isWayExistance: Bool)) {
        switch model.type {
        case .cellphone:
            mTipLabel.text = "未绑定手机"
            mTitleLabel.text = "短信接收报警消息"
        case .email:
            mTipLabel.text = "未绑定邮箱"
            mTitleLabel.text = "邮件接收报警消息"
        }
        if model.isWayExistance {
            mSwitch.isHidden = false
            mTipLabel.isHidden = true
            mSwitch.isOn = model.isOpen
        }else {
            mSwitch.isHidden = true
            mTipLabel.isHidden = false
        }
    }
    func setupData(model: (tittle: String, isOpen: Bool)) {
        mSwitch.isOn = model.isOpen
        mTitleLabel.text = model.tittle
    }
    @IBAction func onHandleSwitch(_ sender: UISwitch) {
        switchBlock?(sender.isOn)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}