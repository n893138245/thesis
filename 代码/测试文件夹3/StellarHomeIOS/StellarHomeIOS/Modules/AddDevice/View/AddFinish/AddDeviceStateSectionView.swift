import UIKit
class AddDeviceStateSectionView: UIView {
    let disposeBag = DisposeBag()
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    class func addDeviceStateSectionView() ->AddDeviceStateSectionView {
        let view = Bundle.main.loadNibNamed("AddDeviceStateSectionView", owner: nil, options: nil)?.last as! AddDeviceStateSectionView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initviews()
    }
    private func initviews(){
        leftLabel.textColor = STELLAR_COLOR_C11
        leftLabel.font = STELLAR_FONT_BOLD_T16
        rightButton.setTitle(StellarLocalizedString("ALERT_WHT_FAILED"), for: .normal)
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        rightButton.titleLabel?.font = STELLAR_FONT_T14
    }
    func setview(leftTitle:String,isHiddenRightButton:Bool,clickBlock:(() -> Void)?){
        leftLabel.text = leftTitle
        rightButton.isHidden = isHiddenRightButton
        rightButton.rx.tap.subscribe(onNext:{
            clickBlock?()
        }).disposed(by: disposeBag)
    }
}