import UIKit
class CurrentConditionView: UIControl {
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewBg: UIView!
    var clickBlock:(()->Void)? = nil
    class func CurrentConditionView() ->CurrentConditionView {
        let view = Bundle.main.loadNibNamed("CurrentConditionView", owner: nil, options: nil)?.last as! CurrentConditionView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.textColor = STELLAR_COLOR_C4
        topLabel.font = STELLAR_FONT_BOLD_T16
        bottomLabel.textColor = STELLAR_COLOR_C6
        bottomLabel.font = STELLAR_FONT_T12
        imageViewBg.backgroundColor = STELLAR_COLOR_C9
        addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    @objc func clickAction(){
        if clickBlock != nil{
            clickBlock!()
        }
    }
    func setupViews(topString:String,bottomString:String,imageName:String) {
        topLabel.text = topString
        bottomLabel.text = bottomString
        imageView.image = UIImage.init(named: imageName)
    }
    func setupData(condition: IntelligentDetailModelCondition) {
        var iconName = "icon_scence_if"
        var topString = ""
        var bottomString = ""
        if condition.type == .countdown {
            iconName = "icon_scence_countdown"
            bottomString = StellarLocalizedString("SMART_CUTDOWN")
            let time = condition.params.countdownTime/60
            topString = "\(time)\(StellarLocalizedString("SMART_MIN_LATER"))"
        }else if condition.type == .timing {
            iconName = "icon_scence_time"
            topString = condition.params.time
            bottomString = IntelligentDetailModel.getDayStringWithWeekDays(week: condition.params.weekdays)
        }
        topLabel.text = topString
        bottomLabel.text = bottomString
        imageView.image = UIImage.init(named: iconName)
    }
}