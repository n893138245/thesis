import UIKit
enum TextfieldViewState {
    case kPhoneTextfieldType
    case kEMailTextfieldType
    case kPasswordTextfieldType
}
class AccountOrPasswordView: UIView {
    private let disposeBag: DisposeBag = DisposeBag()
    var output = Output()
    var myTextfieldViewState:TextfieldViewState?{
        didSet{
            setupTextfieldViewState()
        }
    }
    var phoneClickBlock:((String)->Void)?
    var commonClickBlock:((String)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        setupActions()
    }
    private func initViews(){
        addSubview(textFieldPhoneView)
        textFieldPhoneView.snp.makeConstraints { (make) in
            make.left.top.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(79)
        }
        addSubview(commonTextFieldView)
        commonTextFieldView.snp.makeConstraints { (make) in
            make.left.top.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(79)
        }
        addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldPhoneView.snp.bottom).offset(25)
            make.width.equalTo(291)
            make.height.equalTo(46)
            make.centerX.equalTo(snp.centerX)
        }
    }
    private func setValidateOutputResult(){
        output.textFieldValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
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
        bottomBtn.rx.tap.subscribe(onNext: { (_) in
            if self.myTextfieldViewState == .kPhoneTextfieldType {
                let internationalPhoneNum = "+86" + "-" + (self.textFieldPhoneView.textfield.text ?? "")
                self.phoneClickBlock?(internationalPhoneNum)
            }else{
                self.commonClickBlock?(self.commonTextFieldView.textfield.text ?? "")
            }
        }).disposed(by: disposeBag)
    }
    private func setupTextfieldViewState(){
        if myTextfieldViewState == .kPhoneTextfieldType {
            textFieldPhoneView.isHidden = false
            commonTextFieldView.isHidden = true
            bottomBtn.setTitle(StellarLocalizedString("REGIST_GET_CODE"), for: .normal)
            setPhoneInput()
            setValidateOutputResult()
        }else if myTextfieldViewState == .kEMailTextfieldType {
            textFieldPhoneView.isHidden = true
            commonTextFieldView.isHidden = false
            commonTextFieldView.myTextFieldType = .kEMail
            bottomBtn.setTitle(StellarLocalizedString("COMMON_NEXT"), for: .normal)
            setCommonTextfieldInput()
            setValidateOutputResult()
        }else if myTextfieldViewState == .kPasswordTextfieldType {
            textFieldPhoneView.isHidden = true
            commonTextFieldView.isHidden = false
            commonTextFieldView.myTextFieldType = .kPassword
            bottomBtn.setTitle(StellarLocalizedString("PASSWORD_RESET_PASSWORD"), for: .normal)
            setCommonTextfieldInput()
            setValidateOutputResult()
        }
    }
    private func setPhoneInput(){
        let input = Input.init(textfieldInput: textFieldPhoneView.textfield.rx.value.orEmpty.asObservable())
        output.textFieldValidateResult = input.textfieldInput.flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
            return ValidateService.validateChinesePhoneNum(inputString: textfieldInput)
        }.share(replay: 1)
    }
    private func setCommonTextfieldInput(){
        let input = Input.init(textfieldInput: commonTextFieldView.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
        output.textFieldValidateResult = input.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                if self.myTextfieldViewState == .kEMailTextfieldType{
                    return ValidateService.validateEmail(text: textfieldInput)
                }else{
                    return ValidateService.validatePasssword(text: textfieldInput)
                }
        }.share(replay: 1)
    }
    func getInternationalPhoneNum() -> String{
        let phone = "+86" + "-" + (self.textFieldPhoneView.textfield.text ?? "")
        return phone
    }
    func getTextFiedlEmail() -> String{
        return self.commonTextFieldView.textfield.text ?? ""
    }
    func getTextFiedlPassword() -> String{
        return self.commonTextFieldView.textfield.text ?? ""
    }
    func setupViews(bottomBtnTitle:String){
        bottomBtn.setTitle(bottomBtnTitle, for: .normal)
    }
    lazy var bottomBtn:StellarButton = {
        let btn = StellarButton.init()
        btn.style = .normal
        btn.layer.cornerRadius = 23
        btn.layer.masksToBounds = true
        return btn
    }()
    private lazy var textFieldPhoneView:StellarPhoneTextFieldView = {
        let textField = StellarPhoneTextFieldView.stellarPhoneTextFieldView()
        return textField
    }()
    private lazy var commonTextFieldView:StellarCommonTextFieldView = {
        let textField = StellarCommonTextFieldView.stellarCommonTextFieldView()
        return textField
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}