import UIKit
enum SetupPasswordStep {
    case kInit
    case kPhoneAccount
    case kEmailAccount
    case kPassword
}
class SetupPasswordVC: LoginBaseVC {
    var mySetupPasswordStep:SetupPasswordStep = .kInit{
        didSet{
            self.changeStep()
        }
    }
    var cellPhone = ""
    var eMail = ""
    var code:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    override func setupViews(){
        super.setupViews()
        codeLoginPhoneView.setupViews(bottomBtnTitle: StellarLocalizedString("COMMON_NEXT"))
        contentBGView.addSubview(codeLoginPhoneView)
        codeLoginPhoneView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.bottom.equalTo(self.codeLoginPhoneView.bottomBtn.snp.bottom)
            make.left.right.equalTo(0)
        }
        contentBGView.addSubview(codeLoginEmailView)
        codeLoginEmailView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.bottom.equalTo(self.codeLoginPhoneView.bottomBtn.snp.bottom)
            make.left.right.equalTo(0)
        }
        contentBGView.addSubview(setupPasswordView)
        setupPasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.bottom.equalTo(self.codeLoginPhoneView.bottomBtn.snp.bottom)
            make.left.right.equalTo(0)
        }
        contentBGView.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeLoginPhoneView.snp.bottom).offset(32)
            make.centerX.right.equalTo(contentBGView)
        }
        if mySetupPasswordStep == .kInit {
            mySetupPasswordStep = .kPhoneAccount
        }
        if mySetupPasswordStep == .kPassword {
            navView.backclickBlock = { [weak self] in
                if self?.mySetupPasswordStep == .kPassword {
                    self?.navigationController?.viewControllers.reversed().forEach({ (vc) in
                        if let popVc = vc as? SetupPasswordVC {
                            self?.navigationController?.popToViewController(popVc, animated: true)
                        }
                    })
                }else{
                    self?.navigationController?.viewControllers.reversed().forEach({ (vc) in
                        if let popVc = vc as? LoginVC {
                            self?.navigationController?.popToViewController(popVc, animated: true)
                        }
                    })
                }
            }
        }
    }
    private func setupAction(){
        inputPhoneNum()
        inputEmial()
        inputPassword()
        resetBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.mySetupPasswordStep == .kPhoneAccount {
                self?.mySetupPasswordStep = .kEmailAccount
            }else if self?.mySetupPasswordStep == .kEmailAccount {
                self?.mySetupPasswordStep = .kPhoneAccount
            }
        }).disposed(by: disposeBag)
    }
    private func inputEmial(){
        codeLoginEmailView.commonClickBlock = { [weak self] (email) in
            self?.codeLoginEmailView.bottomBtn.startIndicator()
            self?.checkNewUser(email: email, successBlock: { (isNew) in
                if isNew{
                    self?.codeLoginEmailView.bottomBtn.stopIndicator()
                    TOAST(message: StellarLocalizedString("ALERT_USER_NOT_EXIT"))
                }else{
                    self?.sendCode(email: email, complete: { isSuccess,error in
                        self?.codeLoginEmailView.bottomBtn.stopIndicator()
                        if isSuccess {
                            let vc = VerificationCodeViewController()
                            vc.sendTargetString = email
                            vc.myVerifyType = .kResetEmailPassword
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                            self?.hintView.showAnimationWithTitle(error, duration: 3)
                        }
                    })
                }
            },failureBlock: {
                self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                self?.hintView.showAnimationWithTitle(StellarLocalizedString("ALERT_RESET_FAIL"), duration: 3)
            })
        }
    }
    private func inputPhoneNum(){
        codeLoginPhoneView.phoneClickBlock = { [weak self] phone in
            self?.codeLoginPhoneView.bottomBtn.startIndicator()
            self?.checkNewUser(phone: phone, successBlock: { (isNew) in
                if isNew{
                    self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                    TOAST(message: StellarLocalizedString("ALERT_USER_NOT_EXIT"))
                }else{
                    self?.sendCode(phone: phone, complete: { isSuccess,error in
                        self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                        if isSuccess {
                            let vc = VerificationCodeViewController()
                            vc.sendTargetString = phone
                            vc.myVerifyType = .kResetPhonePassword
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                            self?.hintView.showAnimationWithTitle(error, duration: 3)
                        }
                    })
                }
            },failureBlock: {
                self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                self?.hintView.showAnimationWithTitle(StellarLocalizedString("ALERT_RESET_FAIL"), duration: 3)
            })
        }
    }
    private func inputPassword(){
        setupPasswordView.commonClickBlock = { [weak self] (password) in
            StellarProgressHUD.showHUD()
            let resetPasswordRequest = ResetPasswordModel()
            if self?.cellPhone.isEmpty ?? true {
                resetPasswordRequest.email = self?.eMail ?? ""
            }else{
                resetPasswordRequest.cellphone = self?.cellPhone ?? ""
            }
            resetPasswordRequest.smscode = self?.code ?? ""
            let password = self?.setupPasswordView.getTextFiedlPassword() ?? ""
            resetPasswordRequest.newPassword = password.sha256()
            StellarUserStore.sharedStore.resetPassword(resetPasswordModel: resetPasswordRequest, success: {
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS"))
                let loginRequestModel = LoginRequestModel()
                loginRequestModel.password = password.sha256()
                if self?.cellPhone.isEmpty ?? true {
                    loginRequestModel.email = self?.eMail ?? ""
                }else{
                    loginRequestModel.cellphone = self?.cellPhone ?? ""
                }
                StellarUserStore.sharedStore.login(loginRequestModel: loginRequestModel, success: { (jsonDictionary) in
                    let model = jsonDictionary.kj.model(TokenModel.self)
                    let infoModel = InfoModel()
                    if self?.cellPhone.isEmpty ?? true {
                        infoModel.email = self?.eMail ?? ""
                    }else{
                        infoModel.cellphone = self?.cellPhone ?? ""
                    }
                    infoModel.userid = model.id
                    StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: model, duiOperationSuccess: {
                        StellarProgressHUD.dissmissHUD()
                        TOAST_SUCCESS(message: StellarLocalizedString("ALERT_LOGIN_SUCCESS") ) {
                            StellarAppManager.sharedManager.user.hasLogined = true
                            StellarAppManager.sharedManager.nextStep()
                        }
                    }) {
                        self?.setupPasswordFailed()
                    }
                }) { (error) in
                    self?.setupPasswordFailed()
                }
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
                self?.setupPasswordFailed()
            }
        }
    }
    func setupPasswordFailed(){
        for vc in self.navigationController?.viewControllers.reversed() ?? [UIViewController](){
            if let popVc = vc as? SetupPasswordVC {
                self.navigationController?.popToViewController(popVc, animated: true)
            }
        }
    }
    private func changeStep(){
        codeLoginEmailView.setNeedsLayout()
        codeLoginPhoneView.setNeedsLayout()
        setupPasswordView.setNeedsLayout()
        switch mySetupPasswordStep {
        case .kInit:
            break
        case .kPhoneAccount:
            typeLabel.text = StellarLocalizedString("PASSWORD_RESET_PASSWORD")
            resetBtn.setTitle(StellarLocalizedString("COMMON_EMAIL") + StellarLocalizedString("PASSWORD_RESET_PASSWORD"), for: .normal)
            resetBtn.isHidden = false
                self.codeLoginEmailView.alpha = 0
                self.setupPasswordView.alpha = 0
                self.codeLoginPhoneView.alpha = 1
        case .kEmailAccount:
            typeLabel.text = StellarLocalizedString("PASSWORD_RESET_PASSWORD")
            resetBtn.setTitle(StellarLocalizedString("COMMON_PHONE") + StellarLocalizedString("PASSWORD_RESET_PASSWORD"), for: .normal)
            resetBtn.isHidden = false
                self.codeLoginPhoneView.alpha = 0
                self.setupPasswordView.alpha = 0
                self.codeLoginEmailView.alpha = 1
        case .kPassword:
            fd_interactivePopDisabled = true
            typeLabel.text = StellarLocalizedString("PASSWORD_SET_PASSWORD")
            resetBtn.isHidden = true
                self.codeLoginEmailView.alpha = 0
                self.codeLoginPhoneView.alpha = 0
                self.setupPasswordView.alpha = 1
        }
    }
    private func sendCode(phone:String = "",email:String = "",complete: ((Bool,String) ->Void)?){
        StellarProgressHUD.showHUD()
        if phone.isEmpty && email.isEmpty  {
            complete?(false,"")
        }
        let sendCodeModel = SendCodeModel()
        if phone.isEmpty {
            sendCodeModel.email = email
        }else{
            sendCodeModel.cellphone = phone
        }
        sendCodeModel.codeUsage = .reset_password
        StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: { jsonDic in
            StellarProgressHUD.dissmissHUD()
            complete?(true,"")
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            complete?(false,error)
        }
    }
    private lazy var codeLoginPhoneView:AccountOrPasswordView = {
        let cView = AccountOrPasswordView()
        cView.myTextfieldViewState = .kPhoneTextfieldType
        return cView
    }()
    private lazy var codeLoginEmailView:AccountOrPasswordView = {
        let cView = AccountOrPasswordView()
        cView.myTextfieldViewState = .kEMailTextfieldType
        return cView
    }()
    private lazy var setupPasswordView:AccountOrPasswordView = {
        let cView = AccountOrPasswordView()
        cView.myTextfieldViewState = .kPasswordTextfieldType
        return cView
    }()
    private lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        view.addSubview(hView)
        return hView
    }()
    private lazy var resetBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T15
        return btn
    }()
}