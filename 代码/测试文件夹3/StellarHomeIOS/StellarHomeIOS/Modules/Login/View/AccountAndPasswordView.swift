import UIKit
enum AccountPasswordViewState {
    case kPhoneTextfieldType
    case kEMailTextfieldType
}
class AccountAndPasswordView: UIView {
    private let disposeBag: DisposeBag = DisposeBag()
    private var phoneOutput = Output()
    private var eMailOutput = Output()
    private var passwordOutput = Output()
    var myAccountPasswordViewState:AccountPasswordViewState?{
        didSet{
            setupAccountAndPasswordViewState()
        }
    }
    var phoneBtnClickBlock:((_ phoneNum:String,_ password:String)->Void)?
    var eMailBtnClickBlock:((_ eMail:String,_ password:String)->Void)?
    var forgetClickBlock:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupviews()
        setupActions()
    }
    private func setupviews(){
        addSubview(phoneTextFieldView)
        phoneTextFieldView.snp.makeConstraints { (make) in
            make.left.top.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(79)
        }
        addSubview(emailTextFieldView)
        emailTextFieldView.snp.makeConstraints { (make) in
            make.left.top.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(79)
        }
        addSubview(passwordTextFieldView)
        passwordTextFieldView.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTextFieldView.snp.bottom).offset(32)
            make.right.equalTo(-23)
            make.height.equalTo(79)
            make.left.equalTo(23)
        }
        bottomBtn.setTitle(StellarLocalizedString("LOGIN_LOGIN"), for: .normal)
        addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTextFieldView.snp.bottom).offset(30)
            make.width.equalTo(291)
            make.height.equalTo(46)
            make.centerX.equalTo(snp.centerX)
        }
        addSubview(forgetBtn)
        forgetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomBtn.snp.bottom).offset(32)
            make.width.equalTo(291)
            make.height.equalTo(46)
            make.centerX.equalTo(snp.centerX)
        }
    }
    func getInternationalPhoneNum() -> String{
        return "+86" + "-" + (phoneTextFieldView.textfield.text ?? "")
    }
    func getEmail() -> String{
        return self.emailTextFieldView.textfield.text ?? ""
    }
    func getPassword() -> String{
        return passwordTextFieldView.textfield.text ?? ""
    }
    private func setupAccountAndPasswordViewState(){
        if myAccountPasswordViewState == AccountPasswordViewState.kPhoneTextfieldType {
            phoneTextFieldView.isHidden = false
            emailTextFieldView.isHidden = true
            setPhoneInput()
            setOutput(accountObservable: phoneOutput.textFieldValidateResult)
        }else if myAccountPasswordViewState == AccountPasswordViewState.kEMailTextfieldType {
            phoneTextFieldView.isHidden = true
            emailTextFieldView.isHidden = false
            setEmailInput()
            setOutput(accountObservable: eMailOutput.textFieldValidateResult)
        }
    }
    private func setPhoneInput(){
        let phoneInput = Input.init(textfieldInput: phoneTextFieldView.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        phoneOutput.textFieldValidateResult = phoneInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validateChinesePhoneNum(inputString: textfieldInput)
        }.share(replay: 1)
        let passwordInput = Input.init(textfieldInput: passwordTextFieldView.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        passwordOutput.textFieldValidateResult = passwordInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validatePasssword(text: textfieldInput)
        }.share(replay: 1)
    }
    private func setEmailInput(){
        let emailInput = Input.init(textfieldInput: emailTextFieldView.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        eMailOutput.textFieldValidateResult = emailInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validateEmail(text: textfieldInput)
        }.share(replay: 1)
        let passwordInput = Input.init(textfieldInput: passwordTextFieldView.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        passwordOutput.textFieldValidateResult = passwordInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validatePasssword(text: textfieldInput)
        }.share(replay: 1)
    }
    private func setOutput(accountObservable:Observable<ValidateResult>){
        let phonePasswordObserver = Observable<ValidateResult>.combineLatest(accountObservable, passwordOutput.textFieldValidateResult){(account,password) in
            if account.isOk && password.isOk{
               return .ok
            }else{
                return .failed(ValidateFailReason.other(""))
            }
        }
        phonePasswordObserver.subscribe { [weak self] (event) in
            switch event{
            case .completed:return
            case .error(_): break
            case .next(let result):
                switch result{
                case .ok:
                    self?.bottomBtn.isEnabled = true
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?.bottomBtn.isEnabled = false
                    case .other( _):
                        self?.bottomBtn.isEnabled = false
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    private func setupActions(){
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let viewSelf = self else{
                return
            }
            if viewSelf.myAccountPasswordViewState == AccountPasswordViewState.kPhoneTextfieldType {
                let phone = viewSelf.getInternationalPhoneNum()
                let password = viewSelf.getPassword()
                viewSelf.phoneBtnClickBlock?(phone,password)
            }else if viewSelf.myAccountPasswordViewState == AccountPasswordViewState.kEMailTextfieldType {
                let email = viewSelf.getEmail()
                let password = viewSelf.getPassword()
                viewSelf.eMailBtnClickBlock?(email,password)
            }
        }).disposed(by: disposeBag)
        forgetBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.forgetClickBlock?()
        }).disposed(by: disposeBag)
    }
    private lazy var bottomBtn:StellarButton = {
        let btn = StellarButton.init()
        btn.style = .normal
        btn.layer.cornerRadius = 23
        return btn
    }()
    lazy var phoneTextFieldView:StellarPhoneTextFieldView = {
        let textField = StellarPhoneTextFieldView.stellarPhoneTextFieldView()
        return textField
    }()
    lazy var emailTextFieldView:StellarCommonTextFieldView = {
        let textField = StellarCommonTextFieldView.stellarCommonTextFieldView()
        textField.myTextFieldType = .kEMail
        return textField
    }()
    private lazy var passwordTextFieldView:StellarCommonTextFieldView = {
        let textField = StellarCommonTextFieldView.stellarCommonTextFieldView()
        textField.myTextFieldType = .kPassword
        return textField
    }()
    private lazy var forgetBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T15
        btn.setTitle(StellarLocalizedString("LOGIN_FORGET_PASSWORD"), for: .normal)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}