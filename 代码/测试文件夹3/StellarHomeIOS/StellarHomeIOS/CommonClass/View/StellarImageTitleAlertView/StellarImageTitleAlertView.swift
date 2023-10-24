import UIKit
class StellarImageTitleAlertView: UIView {
    private let bag: DisposeBag = DisposeBag()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var lineview2: UIView!
    @IBOutlet weak var lineview1: UIView!
    @IBOutlet weak var contentView: UIView!
    var leftButtonBlock:(()->Void)? = nil
    var rightButtonBlock:(()->Void)? = nil
    class func stellarImageTitleAlertView() ->StellarImageTitleAlertView {
        let view = Bundle.main.loadNibNamed("StellarImageTitleAlertView", owner: nil, options: nil)?.last as! StellarImageTitleAlertView
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView(){
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = STELLAR_FONT_T16
        leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        rightButton.titleLabel?.font = STELLAR_FONT_T17
        lineview1.backgroundColor = STELLAR_COLOR_C8
        lineview2.backgroundColor = STELLAR_COLOR_C8
    }
    func setImageContentType(content:String,leftClickString:String,rightClickString:String,image:UIImage?){
        if image != nil{
            imageView.image = image
        }
        contentLabel.text = content
        leftButton.setTitle(leftClickString, for: .normal)
        rightButton.setTitle(rightClickString, for: .normal)
    }
    func showView(){
        if isHidden{
            self.isHidden = false
            contentView.pop_add(self.ss.popScaleAnimation(), forKey: "scale")
        }
    }
    func closeView(){
        if !isHidden{
            isHidden = true
        }
    }
    @IBAction private func leftClick(_ sender: Any) {
        closeView()
        leftButtonBlock?()
    }
    @IBAction private func rightClick(_ sender: Any) {
        closeView()
        rightButtonBlock?()
    }
}