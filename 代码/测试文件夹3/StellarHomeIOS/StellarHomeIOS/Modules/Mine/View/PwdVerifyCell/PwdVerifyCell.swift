import UIKit
class PwdVerifyCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    var verifyBlock: (() ->Void)?
    struct Input {
        let textfieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
        initRx()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func initSubViews() {
        IQKeyboardManager.shared.enableAutoToolbar = true
        contentView.addSubview(pwdTextField)
        contentView.addSubview(bottomButton)
        bottomButton.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(pwdTextField.snp.bottom).offset(40)
            $0.height.equalTo(46.fit)
            $0.width.equalTo(291.fit)
        }
        pwdTextField.textField.becomeFirstResponder()
    }
    private func initRx() {
        let passwordInput = Input.init(textfieldInput: pwdTextField.textField.rx.value.orEmpty.asObservable().distinctUntilChanged())
        var passwordOutput = Output()
        passwordOutput.textFieldValidateResult = passwordInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validatePasssword(text: textfieldInput)
        }
        .share(replay: 1)
        passwordOutput.textFieldValidateResult
            .subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_): break
            case .next(let result):
                switch result{
                case .ok:
                    self?.pwdTextField.bottomTitleLabel.text = ""
                    self?.bottomButton.isEnabled = true
                    break
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?.bottomButton.isEnabled = false
                        break
                    case .other(let msg):
                        self?.bottomButton.isEnabled = false
                        self?.pwdTextField.bottomTitleLabel.text = msg
                        break
                    }
                }
            }
        }.disposed(by: disposeBag)
        bottomButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.verifyBlock?()
            }).disposed(by: disposeBag)
    }
    static func initWithXIb() -> UITableViewCell{
        let arrayOfViews = Bundle.main.loadNibNamed("PwdVerifyCell", owner: nil, options: nil)
        guard let firstView = arrayOfViews?.first as? UITableViewCell else {
            return UITableViewCell()
        }
        return firstView
    }
    lazy var pwdTextField: StellarTextField = {
        let text = StellarTextField.init(frame: CGRect(x: 30, y: 40, width: kScreenWidth-60, height: 80))
        text.style = .password
        text.title = StellarLocalizedString("MINE_CHANGEPHONE_ENTER_PWD")
        return text
    }()
    lazy var bottomButton: StellarButton = {
        let view = StellarButton()
        view.style = .normal
        view.isEnabled = false
        view.setTitle(StellarLocalizedString("MINE_CHANGEPWD_CONFRIM"), for: .normal)
        return view
    }()
}