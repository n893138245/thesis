import UIKit
class NoDeviceView: UIView {
    let disposeBag = DisposeBag()
    var clickBlock:(() -> Void)? = nil
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    class func noDeviceView() ->NoDeviceView {
        let view = Bundle.main.loadNibNamed("NoDeviceView", owner: nil, options: nil)?.last as! NoDeviceView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        hintLabel.text = StellarLocalizedString("SCENE_EMPTY_DEVICE")
        hintLabel.textColor = STELLAR_COLOR_C4
        hintLabel.font = STELLAR_FONT_T18
        addDeviceButton.setTitle("    "+StellarLocalizedString("ADD_DEVICE_ADD")+"    ", for: .normal)
        addDeviceButton.titleLabel?.font = STELLAR_FONT_T14
        addDeviceButton.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        addDeviceButton.backgroundColor = STELLAR_COLOR_C1
        addDeviceButton.rx.tap.subscribe(onNext: { _ in
            self.clickBlock?()
        }).disposed(by: disposeBag)
    }
}