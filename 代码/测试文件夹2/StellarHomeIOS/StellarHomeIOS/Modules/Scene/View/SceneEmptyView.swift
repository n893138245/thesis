import UIKit
class SceneEmptyView: UIView {
    @IBOutlet weak var mContentLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    class func SceneEmptyView() ->SceneEmptyView {
        let view = Bundle.main.loadNibNamed("SceneEmptyView", owner: nil, options: nil)?.last as! SceneEmptyView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        mTitleLabel.text = StellarLocalizedString("SCENE_EMPTY_TITLE")
        mContentLabel.text = StellarLocalizedString("SCENE_EMPTY_CONTENT")
    }
}