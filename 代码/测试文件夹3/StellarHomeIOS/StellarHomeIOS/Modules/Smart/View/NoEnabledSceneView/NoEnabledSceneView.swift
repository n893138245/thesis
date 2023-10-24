import UIKit
class NoEnabledSceneView: UIView {
    @IBOutlet weak var mTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.text = StellarLocalizedString("SMART_NO_SCENE")
    }
    class func NoEnabledSceneView() ->NoEnabledSceneView {
        let view = Bundle.main.loadNibNamed("NoEnabledSceneView", owner: nil, options: nil)?.last as! NoEnabledSceneView
        return view
    }
    func setupViews(title: String) {
        mTitleLabel.text = title
    }
}