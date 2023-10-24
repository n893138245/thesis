import UIKit
enum UserBindType {
    case bindEmail 
    case changeEmail 
    case changePhone 
    case bindPhone 
}
private enum UserBindStep {
    case stepOne
    case stepTwo
}
class BindEmailAndPhoneViewController: BaseViewController {
    struct Input {
        let textfieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    var myBindType: UserBindType = .bindEmail
    private var myStep: UserBindStep = .stepOne
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewsByMyTypeAndStep()
        setupValidation()
        setupActions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let task = sendCodeView.timeTask {
            SSTimeManager.shared.removeTask(task: task)
        }
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        view.addSubview(topLabel)
        topLabel.frame = CGRect.init(x: 20, y: navView.frame.maxY + 8, width: kScreenWidth - 20, height: 42)
        detailLabel.frame = CGRect.init(x: 20, y: topLabel.frame.maxY + 6, width: kScreenWidth - 40, height: 40)
        detailLabel.numberOfLines = 0
        view.addSubview(detailLabel)
        view.addSubview(bottomBtn)
        bottomBtn.setTitle(StellarLocalizedString("REGIST_GET_CODE"), for: .normal)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: detailLabel.frame.maxY + 193, width: 290.fit, height: 46.fit)
        bottomBtn.isEnabled = false
        if myBindType == .bindEmail || myBindType == .changeEmail {
            view.addSubview(emailTextField)
            emailTextField.frame = CGRect.init(x: 22.fit, y: detailLabel.frame.maxY + 39.fit, width: kScreenWidth - 44.fit, height: 79.fit)
        }else {
            view.addSubview(phoneNumTextField)
            phoneNumTextField.frame = CGRect.init(x: 22.fit, y: detailLabel.frame.maxY + 39.fit, width: kScreenWidth - 44.fit, height: 79.fit)
        }
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    private func loadSendCodeView() {
        sendCodeView.frame = CGRect.init(x: 9, y: detailLabel.frame.maxY + 68, width: kScreenWidth-18, height: 400)
        view.addSubview(sendCodeView)
        sendCodeView.verificateCodeBlock = { [weak self] in 
            self?.netCheckCode()
        }
        sendCodeView.clickBlock = { [weak self] in 
            self?.netStepOne_sendCode(isResend: true)
        }
        sendCodeView.clear()
        sendCodeView.textfield.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    private func setupViewsByMyTypeAndStep() {
        switch myStep {
        case .stepOne:
            setupStepOne()
            break
        case .stepTwo:
            setupStepTwo()
            break
        }
    }
    private func setupStepOne() {
        switch myBindType {
        case .bindEmail:
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUT_EMAIL") , detail: "")
            break
        case .changeEmail:
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUT_NEWEMAIL"), detail: StellarLocalizedString("MINE_CHANGEPHONE_NEWEMAIL_TIP"))
            break
        case .bindPhone:
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUTNUM"), detail: "")
            break
        case .changePhone:
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUTNEWNUM"), detail: StellarLocalizedString("MINE_CHANGEPHONE_NEWPHONE_TIP"))
            break
        }
    }
    private func setupStepTwo() {
        phoneNumTextField.isHidden = true
        emailTextField.isHidden = true
        bottomBtn.isHidden = true
        switch myBindType {
        case .bindEmail,.changeEmail:
            let email = self.emailTextField.textfield.text!
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUTCODE"), detail: "\(StellarLocalizedString("MINE_CHANGEPHONE_SEND_TO"))"+email)
            break
        case .bindPhone,.changePhone:
            let phoneNum = self.phoneNumTextField.textfield.text!
            setupTopTitles(title: StellarLocalizedString("MINE_CHANGEPHONE_INPUTCODE"), detail: "\(StellarLocalizedString("MINE_CHANGEPHONE_SEND_TO")) +86 "+phoneNum.substring(from: 0, length: 3)! + " " + phoneNum.substring(from: 3, length: 4)! + " " + phoneNum.substring(from: 7, length: 4)!)
            break
        }
        loadSendCodeView()
    }
    private func setupTopTitles(title: String, detail: String) {
        topLabel.text = title
        detailLabel.text = detail
    }
    private func setupActions() {
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            StellarProgressHUD.showHUD()
            self?.bottomBtn.startIndicator()
            self?.checkNewUser(phone: self?.getCellPhone() ?? "", email: self?.emailTextField.textfield.text ?? "", complete: { (isNew) in
                if !isNew {
                    self?.bottomBtn.stopIndicator()
                    StellarProgressHUD.dissmissHUD()
                    TOAST(message: StellarLocalizedString("MINE_BIND_USER_EXISTS"))
                }else {
                    self?.netStepOne_sendCode(isResend: false)
                }
            })
        }).disposed(by: disposeBag)
    }
    private func setupValidation() {
        var input: Input?
        var output = Output()
        if myBindType == .bindEmail || myBindType == .changeEmail {
            input = Input.init(textfieldInput: emailTextField.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
            output.textFieldValidateResult = input!.textfieldInput
                .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                    return ValidateService.validateEmail(text: textfieldInput)
            }
            .share(replay: 1)
        }else {
            input = Input.init(textfieldInput: phoneNumTextField.textfield.rx.value.orEmpty.asObservable().distinctUntilChanged())
            output.textFieldValidateResult = input!.textfieldInput
                .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                    return ValidateService.validateChinesePhoneNum(inputString: textfieldInput)
            }
            .share(replay: 1)
        }
        output.textFieldValidateResult
            .subscribe { [weak self] (event: Event<ValidateResult>) in
                switch event {
                case .completed:return
                case .error(_): break
                case .next(let result):
                    switch result{
                    case .ok:
                        self?.bottomBtn.isEnabled = true
                        break
                    case .failed(_):
                        self?.bottomBtn.isEnabled = false
                    }
                }
        }.disposed(by: disposeBag)
    }
    private func checkNewUser(phone:String = "",email: String = "",complete: ((Bool) ->Void)?) {
        if email.isEmpty {
            StellarUserStore.sharedStore.checkIsNewUser(cellphone: phone, success: { (isNew) in
                complete?(isNew)
            }) { (error) in
                TOAST(message: StellarLocalizedString("SMART_NET_ERROR"))
            }
        }else {
            StellarUserStore.sharedStore.checkIsNewUser(email: email, success: { (isNew) in
                complete?(isNew)
            }) { (error) in
                TOAST(message: StellarLocalizedString("SMART_NET_ERROR"))
            }
        }
    }
    private func netStepOne_sendCode(isResend: Bool) {
        if isResend {
            StellarProgressHUD.showHUD()
        }
        let sendCodeModel = SendCodeModel()
        sendCodeModel.codeUsage = CodeUsage.register
        if myBindType == .changeEmail || myBindType == .bindEmail {
            sendCodeModel.email = emailTextField.textfield.text ?? ""
        }else {
            sendCodeModel.cellphone = getCellPhone()
        }
        StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: { jsonDic in
            StellarProgressHUD.dissmissHUD()
            self.bottomBtn.stopIndicator()
            if !isResend {
                self.myStep = .stepTwo
                self.setupViewsByMyTypeAndStep()
            }else { 
                self.sendCodeView.clear()
                self.sendCodeView.textfield.becomeFirstResponder()
                self.sendCodeView.initCountDownClock()
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            self.bottomBtn.stopIndicator()
            TOAST(message: error)
        }
    }
    private func netCheckCode() {
        StellarProgressHUD.showHUD()
        let checkCodeModel = CheckCodeModel()
        checkCodeModel.smscode = sendCodeView.getTextString()
        if myBindType == .changeEmail || myBindType == .bindEmail {
            checkCodeModel.email = emailTextField.textfield.text ?? ""
        }else {
            checkCodeModel.cellphone = getCellPhone()
        }
        checkCodeModel.codeUsage = CodeUsage.register
        StellarUserStore.sharedStore.checkCode(checkCodeModel: checkCodeModel, success: {[weak self] (jsonDic) in
            let response = jsonDic.kj.model(CommonResponseModel.self)
            if response.code != 0 {
                self?.checkCodeFailedAction(error:"校验失败")
                return
            }
            if self?.myBindType == .changeEmail || self?.myBindType == .bindEmail {
                self?.netStepTwo_SetNewEmail()
            }else {
                self?.netStepTwo_SetNewPhone()
            }
        }) {[weak self] (error) in
            self?.checkCodeFailedAction(error: error)
        }
    }
    private func netStepTwo_SetNewEmail() {
        StellarUserStore.sharedStore.chageEmail(email: emailTextField.textfield.text ?? "", accessCode: FeedBackTimeTool.sharedTool.getVerificationAccessCode() ?? "", success: { [weak self] (jsonDic) in
            guard let response = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                self?.setPhoneFailedAction()
                return
            }
            if response.code != 0 {
                self?.setPhoneFailedAction()
                return
            }
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS")) { 
                self?.popToUserInfoVc()
            }
        }) { [weak self] (error) in
            self?.setPhoneFailedAction()
        }
    }
    private func netStepTwo_SetNewPhone() {
        StellarUserStore.sharedStore.changePhone(phone: getCellPhone(), accessCode: FeedBackTimeTool.sharedTool.getVerificationAccessCode() ?? "", success: { [weak self] jsonDic in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS")) {
                self?.popToUserInfoVc()
            }
        }) { [weak self] (error) in
            self?.setPhoneFailedAction()
        }
    }
    private func checkCodeFailedAction(error:String){
        StellarProgressHUD.dissmissHUD()
        sendCodeView.clear()
        sendCodeView.textfield.becomeFirstResponder()
        if error.isEmpty {
            hintView.showAnimationWithTitle(StellarLocalizedString("MINE_CHANGEPHONE_CODE_ERROR"), duration: 1.0)
        }else{
            hintView.showAnimationWithTitle(error, duration: 1.0)
        }
    }
    private func setPhoneFailedAction(){
        StellarProgressHUD.dissmissHUD()
        self.sendCodeView.clear()
        self.sendCodeView.textfield.becomeFirstResponder()
        self.hintView.showAnimationWithTitle(StellarLocalizedString("MINE_CHANGEPHONE_NEWEMAIL_ERROR"), duration: 1.0)
    }
    private func popToUserInfoVc() {
        StellarProgressHUD.dissmissHUD()
        if myBindType == .bindEmail || myBindType == .changeEmail {
            StellarAppManager.sharedManager.user.userInfo.email = emailTextField.textfield.text ?? ""
        }else {
            StellarAppManager.sharedManager.user.userInfo.cellphone = getCellPhone()
        }
        StellarAppManager.sharedManager.user.save()
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: MineInfoViewController.classForCoder()) {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    private func getCellPhone() -> String {
        if myBindType == .changeEmail || myBindType == .bindEmail {
            return ""
        }
        let code = "+86"
        return code + "-" + (phoneNumTextField.textfield.text ?? "")
    }
    lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    lazy var topLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C4
        label.font = STELLAR_FONT_BOLD_T30
        return label
    }()
    lazy var detailLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C6
        label.font = STELLAR_FONT_BOLD_T14
        return label
    }()
    lazy var sendCodeView:SendCodeView = {
        let view = SendCodeView.SendCodeView()
        return view
    }()
    lazy var emailTextField:StellarCommonTextFieldView = {
        let view = StellarCommonTextFieldView.stellarCommonTextFieldView()
        view.myTextFieldType = .kEMail
        return view
    }()
    lazy var phoneNumTextField:StellarPhoneTextFieldView = {
        let view = StellarPhoneTextFieldView.stellarPhoneTextFieldView()
        return view
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.style = .normal
        return view
    }()
    lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        view.addSubview(hView)
        return hView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}