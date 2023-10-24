import UIKit
class AboutSansiSocialCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func tapLED(_ sender: UIButton) {
        showWeChatAlert(weChatString: "三思LED")
    }
    @IBAction func tapWeibo(_ sender: UIButton) {
        jumpTo(url: "sinaweibo:
    }
    @IBAction func tapLight(_ sender: UIButton) {
        showWeChatAlert(weChatString: "三思照明")
    }
    private func showWeChatAlert(weChatString: String) {
        let pastboard = UIPasteboard.general
        pastboard.string = weChatString
         let alert = StellarMineAlertView.init(title: "微信号复制成功", message: "请在“添加朋友”中直接粘贴，\n搜索后关注公众号", icon: UIImage(named: "wechat_big")!, confimTitle: StellarLocalizedString("COMMON_FINE"))
         alert.show()
     }
}