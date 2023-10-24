import UIKit
class NoCustomSmartView: UIView {
    @IBOutlet weak var minddleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    class func NoCustomSmartView() ->NoCustomSmartView {
        let view = Bundle.main.loadNibNamed("NoCustomSmartView", owner: nil, options: nil)?.last as! NoCustomSmartView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    func setupViews(){
        minddleLabel.text = StellarLocalizedString("SMART_EMPTY_TITLE")
        minddleLabel.textColor = STELLAR_COLOR_C4
        minddleLabel.font = STELLAR_FONT_T18
        bottomLabel.text = StellarLocalizedString("SMART_EMPTY_CONTENT")
        bottomLabel.textColor = STELLAR_COLOR_C6
        bottomLabel.font = STELLAR_FONT_T14
    }
}