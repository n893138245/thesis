import UIKit
class FoundSkillsHeadView: UIView {
    let contentLabel: LTMorphingLabel = LTMorphingLabel()
    class func FoundSkillsHeadView() ->FoundSkillsHeadView {
        let view = Bundle.main.loadNibNamed("FoundSkillsHeadView", owner: nil, options: nil)?.last as! FoundSkillsHeadView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = UIFont(name: "Helvetica-Bold", size:  20)
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-10)
            make.centerX.equalTo(self)
        }
    }
}