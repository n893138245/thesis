import UIKit
class SwitchKeyCell: UICollectionViewCell {
    @IBOutlet weak var blueBgView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var centerSetBtn: UIButton!
    @IBOutlet weak var bottomSetBtn: UIButton!
    var settingBlock: (() -> Void)?
    var excuteBlock: (() -> Void)?
    @IBAction func centerBtnClick(_ sender: UIButton) {
        if buttonModel!.actions.count > 0 {
            if let block = excuteBlock { 
                block()
            }
        }else {
            if let block = settingBlock {
                block()
            }
        }
    }
    var buttonModel: ButttonModel? = nil {
        didSet {
            if buttonModel!.actions.count > 0 {
                centerSetBtn.setImage(UIImage(named: "btn_power_49_n"), for: .normal)
                centerSetBtn.setImage(UIImage(named: "icon_power_gray49"), for: .disabled)
            }else {
                centerSetBtn.setImage(UIImage(named: "icon_set_black49"), for: .normal)
                centerSetBtn.setImage(UIImage(named: "con_set_gray49"), for: .disabled)
            }
        }
    }
    @IBAction func bottomBtnClick(_ sender: UIButton) {
        if let block = settingBlock {
            block()
        }
    }
    func showLoading() {
        bottomSetBtn.isEnabled = false
        centerSetBtn.ss.startNVIndicator(color: STELLAR_COLOR_C10)
    }
    func showSuccess(finished:(() -> Void)?) {
        centerSetBtn.ss.stopNVIndicator()
        centerSetBtn.setImage(UIImage(named: "icon_power_empty49"), for: .normal)
        centerSetBtn.ss.showSuccessCheck(hideBlock: {
            self.centerSetBtn.setImage(UIImage(named: "btn_power_49_n"), for: .normal)
            self.bottomSetBtn.isEnabled = true
            if let block = finished {
                block()
            }
        })
    }
    func stopLoading() {
        bottomSetBtn.isEnabled = true
        centerSetBtn.ss.stopNVIndicator()
    }
    func disabledStatus() {
        centerSetBtn.isEnabled = false
        bottomSetBtn.isEnabled = false
    }
    func normalStatus() {
        centerSetBtn.isEnabled = true
        bottomSetBtn.isEnabled = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomSetBtn.layer.cornerRadius = 14
        bottomSetBtn.setTitleColor(STELLAR_COLOR_C7, for: .disabled)
        bottomSetBtn.clipsToBounds = true
        bottomSetBtn.setTitle(StellarLocalizedString("EQUIPMENT_PANEL_SETTINGS"), for: .normal)
    }
}