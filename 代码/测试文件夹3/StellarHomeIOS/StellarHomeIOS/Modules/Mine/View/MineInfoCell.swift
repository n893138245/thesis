import UIKit
enum MineInfoChangeType {
    case header
    case nickName
    case phoneNumber
    case destructionAccount
    case changePassword
    case bindEmail
    case thridBinding
    case clockSetting
}
class MineInfoCell: UITableViewCell {
    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var cellphoneLabel: UILabel!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mHeadTitleLabel: UILabel!
    @IBOutlet weak var mNickNameTitleLabel: UILabel!
    @IBOutlet weak var mPhoneNumTitleLabel: UILabel!
    @IBOutlet weak var mChangePwdTitleLabel: UILabel!
    @IBOutlet weak var mEmailTitleLabel: UILabel!
    @IBOutlet weak var mBindTitleLabel: UILabel!
    @IBOutlet weak var mSubsTitleLabel: UILabel!
    @IBOutlet weak var mDestroyTitleLabel: UILabel!
    var infoChangeBlock:((_ infoType: MineInfoChangeType,_ name:String) -> Void)?
    var infoChangeSubscribeBlock:((Bool) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        headImg.layer.cornerRadius = 23
        headImg.clipsToBounds = true
        headImg.layer.borderWidth = 1
        headImg.layer.borderColor = UIColor.init(hexString: "#EFEFEF").cgColor
        cellphoneLabel.font = STELLAR_FONT_NUMBER_T14
        emailLabel.font = STELLAR_FONT_NUMBER_T14
        emailLabel.text = StellarLocalizedString("MINE_BIND_UNBOUND")
        mHeadTitleLabel.text = StellarLocalizedString("MINE_INFO_PHOTO")
        mNickNameTitleLabel.text = StellarLocalizedString("MINE_INFO_NICKNAME")
        mChangePwdTitleLabel.text = StellarLocalizedString("MINE_CHANGEPWD_TITLE")
        mEmailTitleLabel.text = StellarLocalizedString("COMMON_EMAIL")
        mPhoneNumTitleLabel.text = StellarLocalizedString("COMMON_PHONE")
        mBindTitleLabel.text = StellarLocalizedString("ALERT_BIND_ACCOUNT")
        mSubsTitleLabel.text = StellarLocalizedString("MINE_INFO_ALLOW")
        mDestroyTitleLabel.text = StellarLocalizedString("MINE_DESTRUCTION_TITLE")
    }
    func setupviews(user:AppUser){
        if !StellarAppManager.sharedManager.user.userInfo.nickname.isEmpty {
            nickNameLabel.text = StellarAppManager.sharedManager.user.userInfo.nickname
        }else {
            if let thridInfo = StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.first {
                nickNameLabel.text = thridInfo.nickname
            }else{
                nickNameLabel.text = StellarLocalizedString("MINE_EMPTY_NICKNAME")
            }
        }
        subscribeSwitch.isOn = StellarAppManager.sharedManager.user.userInfo.subscribe
        if !user.userInfo.email.isEmpty {
            emailLabel.text = user.userInfo.email
        }
        if !user.userInfo.cellphone.isEmpty {
            var cellPhone = user.userInfo.cellphone
            if cellPhone.contains("-") {
                cellPhone = cellPhone.replacingOccurrences(of: "-", with: " ")
            }
            cellphoneLabel.text = cellPhone
        }
        if StellarAppManager.sharedManager.user.headImage != nil {
            headImg.image = StellarAppManager.sharedManager.user.headImage
        }else {
            if let thridInfo = StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.first {
                headImg.kf.setImage(with: URL(string: thridInfo.headerImage), placeholder: UIImage.init(named: "faces_normal"))
            }else{
                headImg.image = UIImage.init(named: "faces_normal")
            }
        }
    }
    @IBAction func headerChangeClick(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.header, "")
        }
    }
    @IBAction func destructionAccount(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.destructionAccount,"")
        }
    }
    @IBAction func nickNameChangeClick(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.nickName,nickNameLabel.text ?? "")
        }
    }
    @IBAction func switchAction(_ sender: UISwitch) {
        infoChangeSubscribeBlock?(sender.isOn)
    }
    @IBAction func changePhoneNum(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.phoneNumber,"")
        }
    }
    @IBAction func changePwd(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.changePassword,"")
        }
    }
    @IBAction func bindingEmail(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.bindEmail,"")
        }
    }
    @IBAction func thirdBinding(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.thridBinding,"")
        }
    }
    @IBAction func clockSetting(_ sender: Any) {
        if let block = infoChangeBlock {
            block(.clockSetting,"")
        }
    }
}