import UIKit
class EquipmentNoResultView: UIView {
    @IBOutlet weak var topViewTopLabel: UILabel!
    @IBOutlet weak var topViewMiddleLabel: UILabel!
    @IBOutlet weak var bottomViewTopLabel: UILabel!
    @IBOutlet weak var bottomViewBottomLabel: UILabel!
    @IBOutlet weak var bottomView: UIControl!
    @IBOutlet weak var topView: UIView!
    var addEquipmentBlock:(() -> Void)?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    class func equipmentNoResultView() ->EquipmentNoResultView {
        let view = Bundle.main.loadNibNamed("EquipmentNoResultView", owner: nil, options: nil)?.last as! EquipmentNoResultView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.setTitle(StellarLocalizedString("EQUIPMENT_NODEVICE_ADD"), for: .normal)
        topViewTopLabel.text = StellarLocalizedString("ADD_DEVICE_ADD")
        topViewTopLabel.textColor = STELLAR_COLOR_C4
        topViewTopLabel.font = STELLAR_FONT_BOLD_T20
        topViewMiddleLabel.text = StellarLocalizedString("EQUIPMENT_NODEVICE_CONTENT")
        topViewMiddleLabel.textColor = STELLAR_COLOR_C6
        topViewMiddleLabel.font = STELLAR_FONT_T15
        bottomViewTopLabel.text = StellarLocalizedString("EQUIPMENT_NODEVICE_HELP")
        bottomViewTopLabel.textColor = STELLAR_COLOR_C4
        bottomViewTopLabel.font = STELLAR_FONT_BOLD_T20
        bottomViewBottomLabel.text = StellarLocalizedString("EQUIPMENT_NODEVICE_HELP_DETAIL")
        bottomViewBottomLabel.textColor = STELLAR_COLOR_C6
        bottomViewBottomLabel.font = STELLAR_FONT_T15
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowRadius = 10
        topView.layer.shadowOffset = CGSize.zero
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10
        bottomView.layer.shadowOffset = CGSize.zero
    }
    @IBAction func addAction(_ sender: Any) {
        addEquipmentBlock?()
    }
    @IBAction func ioJumpAction(_ sender: Any) {
        jumpTo(url: StellarHomeResourceUrl.sansi_io)
    }
}