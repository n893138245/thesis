import UIKit
class StellarTextFieldAlertView: UIView {
    private let bag: DisposeBag = DisposeBag()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var lineview2: UIView!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var lineview1: UIView!
    @IBOutlet weak var contentView: UIView!
    var isVoiceControl = true
    var leftButtonBlock:(()->Void)? = nil
    var rightButtonBlock:((String)->Void)? = nil
    struct Input {
        let textFieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    class func stellarTextFieldAlertView() ->StellarTextFieldAlertView {
        let view = Bundle.main.loadNibNamed("StellarTextFieldAlertView", owner: nil, options: nil)?.last as! StellarTextFieldAlertView
        getKeyboardWindow().addSubview(view)
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
        secondTitleLabel.textColor = STELLAR_COLOR_C6
        secondTitleLabel.font = STELLAR_FONT_BOLD_T13
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C7,NSAttributedString.Key.font:STELLAR_FONT_T16]
        textField.attributedPlaceholder = NSAttributedString(string: StellarLocalizedString("ALERT_INPUT"),attributes: placeholserAttributes)
        textfieldView.backgroundColor = STELLAR_COLOR_C8
        lineview1.backgroundColor = STELLAR_COLOR_C8
        lineview2.backgroundColor = STELLAR_COLOR_C8
        leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        rightButton.setTitleColor(STELLAR_COLOR_C6, for: .disabled)
        tipLabel.textColor = STELLAR_COLOR_C2
        tipLabel.font = STELLAR_FONT_BOLD_T13
    }
    private func setVerifyChinese(){
        let input = Input.init(textFieldInput: textField.rx.value.orEmpty.asObservable().distinctUntilChanged())
        var output = Output()
        output.textFieldValidateResult = input.textFieldInput
            .flatMapLatest { (textFieldString) -> Observable<ValidateResult> in
                if self.isVoiceControl {
                    return ValidateService.validateChinese(inputString: textFieldString)
                }
                return ValidateService.validateChinese(inputString: textFieldString,isVoiceControl: false)
        }
        .share(replay: 1)
        output.textFieldValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_): break
            case .next(let result):
                switch result{
                case .ok:
                    self?.rightButton.isEnabled = true
                    self?.tipLabel.text = StellarLocalizedString("ALERT_CONFIRM_TIP")
                    break
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?.rightButton.isEnabled = false
                        self?.tipLabel.text = StellarLocalizedString("ALERT_EMPTY_TIP")
                        break
                    case .other(let msg):
                        self?.rightButton.isEnabled = false
                        self?.tipLabel.text = msg
                        break
                    }
                }
            }
        }.disposed(by:bag )
    }
    func setTitleTextFieldType(title:String,secondTitle:String,leftClickString:String,rightClickString:String){
        setVerifyChinese()
        titleLabel.text = title
        secondTitleLabel.text = secondTitle
        leftButton.setTitle(leftClickString, for: .normal)
        rightButton.setTitle(rightClickString, for: .normal)
    }
    func showView(text:String = ""){
        if isHidden != false {
            let vc = CURRENT_TOP_VC()
            vc.fd_interactivePopDisabled = true
            isHidden = false
            textField.text = text
            let basic = POPBasicAnimation.init(propertyNamed: kPOPViewBackgroundColor)
            basic?.fromValue = UIColor.black.withAlphaComponent(0.0)
            basic?.toValue = UIColor.black.withAlphaComponent(0.4)
            basic?.duration = 0.25
            pop_add(basic, forKey: "view.backgroundColor")
            let pop = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
            pop?.fromValue = CGSize(width: 0.3, height: 0.3)
            pop?.toValue = CGSize(width: 1, height: 1)
            pop?.springSpeed = 20
            pop?.springBounciness = 12
            contentView.pop_add(pop, forKey: "scale")
            pop?.completionBlock = { (_,_) in
                self.textField.becomeFirstResponder()
            }
        }
    }
    func closeView(){
        if isHidden != true {
            let vc = CURRENT_TOP_VC()
            vc.fd_interactivePopDisabled = false
            isHidden = true
        }
    }
    @IBAction private func leftClick(_ sender: Any) {
        textField.resignFirstResponder()
        closeView()
        if leftButtonBlock != nil {
            leftButtonBlock!()
        }
    }
    @IBAction private func rightClick(_ sender: Any) {
        textField.resignFirstResponder()
        closeView()
        if rightButtonBlock != nil {
            rightButtonBlock!(textField.text ?? "")
        }
    }
}