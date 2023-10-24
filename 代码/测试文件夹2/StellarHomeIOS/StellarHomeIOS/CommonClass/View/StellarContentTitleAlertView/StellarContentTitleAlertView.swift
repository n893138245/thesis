import UIKit
class StellarContentTitleAlertView: UIView {
    private let bag: DisposeBag = DisposeBag()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var lineview1: UIView!
    @IBOutlet weak var lineview2: UIView!
        @IBOutlet weak var contentView: UIView!
    var leftButtonBlock:(()->Void)? = nil
    var rightButtonBlock:(()->Void)? = nil
    func setTitleAndContentType(content:String,leftClickString:String,rightClickString:String,title:String){
        titleLabel.text = title
        contentLabel.text = content
        leftButton.setTitle(leftClickString, for: .normal)
        rightButton.setTitle(rightClickString, for: .normal)
    }
    class func stellarContentTitleAlertView() ->StellarContentTitleAlertView {
        let view = Bundle.main.loadNibNamed("StellarContentTitleAlertView", owner: nil, options: nil)?.last as! StellarContentTitleAlertView
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView(){
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T17
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = STELLAR_FONT_T16
        leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        rightButton.titleLabel?.font = STELLAR_FONT_T17
        lineview1.backgroundColor = STELLAR_COLOR_C8
        lineview2.backgroundColor = STELLAR_COLOR_C8
    }
    func showView(){
        if self.isHidden != false {
            self.isHidden = false
            let basic = POPBasicAnimation.init(propertyNamed: kPOPViewBackgroundColor)
            basic?.fromValue = UIColor.black.withAlphaComponent(0.0)
            basic?.toValue = UIColor.black.withAlphaComponent(0.4)
            basic?.duration = 0.25
            self.pop_add(basic, forKey: "view.backgroundColor")
            let pop = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
            pop?.fromValue = CGSize(width: 0.3, height: 0.3)
            pop?.toValue = CGSize(width: 1, height: 1)
            pop?.springSpeed = 20
            pop?.springBounciness = 12
            contentView.pop_add(pop, forKey: "scale")
        }
    }
    func closeView(){
        if self.isHidden != true {
            self.isHidden = true
        }
    }
    @IBAction private func leftClick(_ sender: Any) {
        closeView()
        if leftButtonBlock != nil {
            leftButtonBlock!()
        }
    }
    @IBAction private func rightClick(_ sender: Any) {
        closeView()
        if rightButtonBlock != nil {
            rightButtonBlock!()
        }
    }
}