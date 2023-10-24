import UIKit
import CountryPickerView
enum TextFieldType {
    case kInit
    case kEMail
    case kName
    case kPassword
}
class StellarCommonTextFieldView: UIView {
    let _bag: DisposeBag = DisposeBag()
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    struct Input {
        let textfieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    var myTextFieldType:TextFieldType = .kInit{
        didSet{
            self.setType(type: myTextFieldType)
        }
    }
    class func stellarCommonTextFieldView() ->StellarCommonTextFieldView {
        let view = Bundle.main.loadNibNamed("StellarCommonTextFieldView", owner: nil, options: nil)?.last as! StellarCommonTextFieldView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView(){
        lineView.backgroundColor = STELLAR_COLOR_C1
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C6,NSAttributedString.Key.font:STELLAR_FONT_T17]
        textfield.font = STELLAR_FONT_NUMBER_T17
        textfield.attributedPlaceholder = NSAttributedString(string: StellarLocalizedString("LOGIN_ENTER_PHONE"),attributes: placeholserAttributes)
        textfield.textColor = STELLAR_COLOR_C4
        textLabel.font = STELLAR_FONT_T12
        textLabel.textColor = STELLAR_COLOR_C1
        textLabel.alpha = 0
        bottonLabel.font = STELLAR_FONT_T12
        bottonLabel.textColor = STELLAR_COLOR_C2
        bottonLabel.alpha = 0
        eyeButton.setImage(UIImage.init(named: "input_icon_eye_n"), for: .normal)
    }
    func setType(type:TextFieldType){
        let input = Input.init(textfieldInput: textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        var output = Output()
        switch type {
        case .kInit:
            break
        case .kEMail:
            self.eyeButton.isHidden = true
            self.textLabel.text = StellarLocalizedString("LOGIN_ENTER_EMAIL")
            self.textfield.placeholder = StellarLocalizedString("LOGIN_ENTER_EMAIL")
            textfield.keyboardType = .asciiCapable
            output.textFieldValidateResult = input.textfieldInput
                .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                    return ValidateService.validateEmail(text: textfieldInput)
                }
                .share(replay: 1)
            output.textFieldValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
                switch event{
                case .completed:return
                case .error(_): break
                case .next(let result):
                    switch result{
                    case .ok:
                        UIView.animate(withDuration: 0.5, animations: {
                            self?.bottonLabel.alpha = 0
                        })
                        break
                    case .failed(let reason):
                        switch reason{
                        case .emptyInput:
                            self?.lineView.backgroundColor = STELLAR_COLOR_C8
                            UIView.animate(withDuration: 0.5, animations: {
                                self?.textLabel.alpha = 0
                                self?.bottonLabel.alpha = 0
                            })
                            break
                        case .other(let msg):
                            self?.lineView.backgroundColor = STELLAR_COLOR_C1
                            UIView.animate(withDuration: 0.5, animations: {
                                self?.textLabel.alpha = 1
                                self?.bottonLabel.alpha = 1
                            })
                            self?.bottonLabel.text = msg
                        }
                    }
                }
                }.disposed(by: _bag)
            break
        case .kPassword:
            self.textLabel.text = StellarLocalizedString("LOGIN_ENTER_PASSWORD")
            self.textfield.placeholder = StellarLocalizedString("LOGIN_ENTER_PASSWORD")
            self.eyeButton.isHidden = false
            textfield.keyboardType = .asciiCapable
            textfield.isSecureTextEntry = true
            output.textFieldValidateResult = input.textfieldInput
                .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                    return ValidateService.validatePasssword(text: textfieldInput)
                }
                .share(replay: 1)
            output.textFieldValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
                switch event{
                case .completed:return
                case .error(_): break
                case .next(let result):
                    switch result{
                    case .ok:
                        self?.eyeButton.isHidden = false
                        UIView.animate(withDuration: 0.5, animations: {
                            self?.bottonLabel.alpha = 0
                        })
                        break
                    case .failed(let reason):
                        switch reason{
                        case .emptyInput:
                            self?.eyeButton.isHidden = true
                            self?.lineView.backgroundColor = STELLAR_COLOR_C8
                            UIView.animate(withDuration: 0.5, animations: {
                                self?.textLabel.alpha = 0
                                self?.bottonLabel.alpha = 0
                            })
                            break
                        case .other(let msg):
                            self?.eyeButton.isHidden = false
                            self?.lineView.backgroundColor = STELLAR_COLOR_C1
                            UIView.animate(withDuration: 0.5, animations: {
                                self?.textLabel.alpha = 1
                                self?.bottonLabel.alpha = 1
                            })
                            self?.bottonLabel.text = msg
                        }
                    }
                }
                }.disposed(by: _bag)
            break
        case .kName:
            self.eyeButton.isHidden = true
            break
        }
    }
    @IBAction func eyeAction(_ sender: Any) {
        textfield.isSecureTextEntry = !textfield.isSecureTextEntry
        if textfield.isSecureTextEntry {
            eyeButton.setImage(UIImage.init(named: "input_icon_eye_n"), for: .normal)
        }else{
            eyeButton.setImage(UIImage.init(named: "input_icon_eye_s"), for: .normal)
        }
    }
}