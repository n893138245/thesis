import UIKit
class FoundSkillsSectionView: UIView {
    @IBOutlet weak var topLabel: UILabel!
    class func FoundSkillsSectionView() ->FoundSkillsSectionView {
        let view = Bundle.main.loadNibNamed("FoundSkillsSectionView", owner: nil, options: nil)?.last as! FoundSkillsSectionView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    func setUpViews(){
        topLabel.textColor = STELLAR_COLOR_C6
        topLabel.font = STELLAR_FONT_T14
        topLabel.text = "你可以这样说"
    }
}