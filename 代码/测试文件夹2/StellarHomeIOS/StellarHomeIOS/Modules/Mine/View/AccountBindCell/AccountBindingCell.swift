import UIKit
enum BindStatus {
    case binding,unbound,unkowning
}
class AccountBindingCell: UITableViewCell {
    var myBindStatus: BindStatus = .unkowning
    @IBOutlet weak var animateBgView: UIView!
    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var bindButton: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var mTitleLabel: UILabel!
    var animateFrame = CGRect.zero
    var buttonFrame = CGRect.zero
    var clickBlock: ((_ myStatus: BindStatus) ->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        contentBgView.layer.cornerRadius = 8
        bindButton.backgroundColor = STELLAR_COLOR_C10
        bindButton.layer.cornerRadius = 16
        bindButton.clipsToBounds = true
        animateFrame = CGRect(x: 0, y: 0, width: kScreenWidth-40, height: 118)
        buttonFrame = CGRect(x: kScreenWidth-56-70, y: 43, width: 70, height: 32)
        contentBgView.layer.shadowOffset = CGSize(width:0 , height: 4)
        contentBgView.layer.shadowOpacity = 0.5
        contentBgView.layer.shadowColor = STELLAR_COLOR_C9.cgColor
        contentBgView.layer.shouldRasterize = true
        contentBgView.layer.rasterizationScale = UIScreen.main.scale
        contentBgView.layer.shadowRadius = 8
        contentBgView.layer.masksToBounds = false
    }
    private func setupMyThridType(isBind: Bool, model: ThirdPartInfoModel) {
        nickNameLabel.text = model.nickname
        mTitleLabel.textColor = isBind ? STELLAR_COLOR_C3:STELLAR_COLOR_C4
        animateBgView.layer.cornerRadius = isBind ? 8:16
        myBindStatus = isBind ? .binding:.unbound
        switch model.thirdPartType {
        case .wechat:
            animateBgView.backgroundColor = UIColor.init(hex: "#29C077")
            animateBgView.frame = isBind ? animateFrame:buttonFrame
            mTitleLabel.text = "微信"
            headerIcon.image = isBind ? UIImage(named: "login_wechat_w"):UIImage(named: "login_wechat_c")
            bindButton.backgroundColor = isBind ? STELLAR_COLOR_C3.withAlphaComponent(0.2):UIColor.init(hex: "#29C077")
            isBind ? bindButton.setTitle("解绑", for: .normal):bindButton.setTitle("绑定", for: .normal)
            contentBgView.layer.shadowColor =  isBind ? UIColor.init(hex: "#29C077").cgColor:STELLAR_COLOR_C9.cgColor
        case .facebook:
            nickNameLabel.text = model.nickname
            animateBgView.backgroundColor = UIColor.init(hex: "#5083C4")
            animateBgView.frame = isBind ? animateFrame:buttonFrame
            mTitleLabel.text = "FaceBook"
            headerIcon.image = isBind ? UIImage(named: "login_facebook_w"):UIImage(named: "login_facebook_c")
            bindButton.backgroundColor = isBind ? STELLAR_COLOR_C3.withAlphaComponent(0.2):UIColor.init(hex: "#5083C4")
            isBind ? bindButton.setTitle("Untie", for: .normal):bindButton.setTitle("Bind", for: .normal)
            contentBgView.layer.shadowColor = isBind ? UIColor.init(hex: "#5083C4").cgColor:STELLAR_COLOR_C9.cgColor
        case .apple:
            nickNameLabel.text = isBind ? "已绑定":""
            animateBgView.backgroundColor = UIColor.init(hex: "#202126")
            animateBgView.frame = isBind ? animateFrame:buttonFrame
            mTitleLabel.text = "Apple"
            headerIcon.image = isBind ? UIImage(named: "login_apple_w"):UIImage(named: "login_apple_c")
            bindButton.backgroundColor = isBind ? STELLAR_COLOR_C3.withAlphaComponent(0.2):UIColor.init(hex: "#202126")
            isBind ? bindButton.setTitle("解绑", for: .normal):bindButton.setTitle("绑定", for: .normal)
            contentBgView.layer.shadowColor = isBind ? UIColor.init(hex: "#000000")?.withAlphaComponent(0.3).cgColor:STELLAR_COLOR_C9.cgColor
        default:
            break
        }
    }
    func setupViews(model: ThirdPartInfoModel) {
        (model.thirdPartId?.isEmpty ?? true) ? setupMyThridType(isBind: false, model: model):setupMyThridType(isBind: true, model: model)
    }
    @IBAction func onBindingClick(_ sender: Any) {
        clickBlock?(myBindStatus)
    }
    func openBg(type: ThirdPartType,complete: (() ->Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.mTitleLabel.textColor = STELLAR_COLOR_C3
            if type == .apple {
                self.headerIcon.image = UIImage(named: "login_apple_w")
            }else if type == .wechat {
                self.headerIcon.image = UIImage(named: "login_wechat_w")
            }
            self.animateBgView.frame = self.animateFrame
        }) { (_) in
            self.animateBgView.layer.cornerRadius = 8
            self.bindButton.backgroundColor = STELLAR_COLOR_C3.withAlphaComponent(0.2)
            self.bindButton.setTitle("解绑", for: .normal)
            complete?()
        }
    }
    func closeBg(type: ThirdPartType, complete: (() ->Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.mTitleLabel.textColor = STELLAR_COLOR_C4
            if type == .apple {
                self.headerIcon.image = UIImage(named: "login_apple_c")
            }else if type == .wechat {
                self.headerIcon.image = UIImage(named: "login_wechat_c")
            }
            self.animateBgView.frame = self.buttonFrame
            self.nickNameLabel.text = ""
            self.contentBgView.layer.shadowColor = STELLAR_COLOR_C9.cgColor
        }) { (_) in
            self.animateBgView.layer.cornerRadius = 16
            self.bindButton.backgroundColor = isChinese() ? UIColor.init(hex: "#29C077"):UIColor.init(hex: "#5083C4")
            self.bindButton.setTitle("绑定", for: .normal)
            complete?()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}