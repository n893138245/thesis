import UIKit
import CountryPickerView
class StellarPhoneTextFieldView: UIView {
    let _bag: DisposeBag = DisposeBag()
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var bottonLabel: UILabel!
    struct Input {
        let textfieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    class func stellarPhoneTextFieldView() ->StellarPhoneTextFieldView {
        let view = Bundle.main.loadNibNamed("StellarPhoneTextFieldView", owner: nil, options: nil)?.last as! StellarPhoneTextFieldView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setValidateResult()
    }
    func setupView(){
        lineView.backgroundColor = STELLAR_COLOR_C1
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C6,NSAttributedString.Key.font:STELLAR_FONT_T17]
        textfield.font = STELLAR_FONT_NUMBER_T17
        textfield.attributedPlaceholder = NSAttributedString(string: StellarLocalizedString("LOGIN_ENTER_PHONE"),attributes: placeholserAttributes)
        textfield.textColor = STELLAR_COLOR_C4
        textLabel.text = StellarLocalizedString("LOGIN_ENTER_PHONE")
        textLabel.font = STELLAR_FONT_T12
        textLabel.textColor = STELLAR_COLOR_C1
        textLabel.alpha = 0
        bottonLabel.font = STELLAR_FONT_T12
        bottonLabel.textColor = STELLAR_COLOR_C2
        bottonLabel.alpha = 0
    }
    func setValidateResult(){
        let input = Input.init(textfieldInput: textfield.rx.value.orEmpty.asObservable())
        var output = Output()
        output.textFieldValidateResult = input.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validateChinesePhoneNum(inputString: textfieldInput)
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
                        break
                    }
                }
            }
            }.disposed(by: _bag)
    }
    private func parentViewController() -> UIViewController? {
        var n = self.next
        while n != nil {
            if (n is UIViewController) {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }
}
extension StellarPhoneTextFieldView:CountryPickerViewDataSource,CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        textfield.sendActions(for: .valueChanged)
    }
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        let closeItem = UIBarButtonItem.init(title: StellarLocalizedString("COMMON_CANCEL"), style: .done, target: self, action: nil)
        return closeItem
    }
}