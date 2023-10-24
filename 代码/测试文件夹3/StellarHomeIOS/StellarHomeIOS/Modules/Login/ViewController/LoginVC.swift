import UIKit
enum LoginState {
    case kInit
    case kCodeType
    case kEMailType
    case kPasswordType
}
class LoginVC: LoginBaseVC {
    var myLoginState:LoginState = .kInit{
        didSet{
            self.changeLoginState(state: myLoginState)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    override func setupViews(){
        super.setupViews()
        contentBGView.addSubview(leftLoginButton)
        leftLoginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40-getAllVersionSafeAreaBottomHeight())
            make.width.equalTo(46)
            make.right.equalTo(contentBGView.snp.centerX).offset(-30)
            make.height.equalTo(46)
        }
        contentBGView.addSubview(leftLoginLabel)
        leftLoginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(leftLoginButton.snp.bottom).offset(12)
            make.centerX.equalTo(leftLoginButton.snp.centerX)
        }
        rightLoginButton.setTitle(StellarLocalizedString("LOGIN_LOGIN_PASSWORD"), for: .normal)
        rightLoginButton.setImage(UIImage.init(named: "icon_login_password"), for: .normal)
        contentBGView.addSubview(rightLoginButton)
        rightLoginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40-getAllVersionSafeAreaBottomHeight())
            make.width.equalTo(46)
            make.left.equalTo(self.view.snp.centerX).offset(30)
            make.height.equalTo(46)
        }
        rightLoginLabel.text = StellarLocalizedString("LOGIN_LOGIN_PASSWORD")
        contentBGView.addSubview(rightLoginLabel)
        rightLoginLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rightLoginButton.snp.bottom).offset(12)
            make.centerX.equalTo(rightLoginButton.snp.centerX)
        }
        contentBGView.addSubview(codeLoginView)
        codeLoginView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.height.equalTo(400)
            make.left.right.equalTo(0)
        }
        contentBGView.addSubview(phonePasswordView)
        phonePasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.height.equalTo(400)
            make.left.right.equalTo(0)
        }
        contentBGView.addSubview(emailPasswordView)
        emailPasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.height.equalTo(400)
            make.left.right.equalTo(0)
        }
        if myLoginState == .kInit {
            myLoginState = .kCodeType
        }
    }
    private func setupAction(){
        codeLoginView.phoneClickBlock = { [weak self] num in
            self?.codeLoginView.bottomBtn.startIndicator()
            self?.checkNewUser(phone: num, successBlock: {isNew in
                self?.view.endEditing(true)
                self?.codeLoginView.bottomBtn.stopIndicator()
                if isNew{
                    TOAST(message: StellarLocalizedString("ALERT_USER_NOT_EXIT"))
                }else{
                    self?.sendLoginCode()
                }
            }) {
                self?.codeLoginView.bottomBtn.stopIndicator()
                TOAST(message: StellarLocalizedString("MINE_SECURITY_NETWORK_BUSY"))
            }
        }
        phonePasswordView.phoneBtnClickBlock = { [weak self] (phone,password) in
            self?.codeLoginView.bottomBtn.startIndicator()
            self?.checkNewUser(phone: phone, successBlock: {(isNew) in
                self?.view.endEditing(true)
                self?.codeLoginView.bottomBtn.stopIndicator()
                if isNew{
                    TOAST(message: StellarLocalizedString("ALERT_USER_NOT_EXIT"))
                }else{
                    self?.loginWith(phone: phone, password: password)
                }
            }) {
                self?.codeLoginView.bottomBtn.stopIndicator()
                TOAST(message: StellarLocalizedString("MINE_SECURITY_NETWORK_BUSY"))
            }
        }
        emailPasswordView.eMailBtnClickBlock = { [weak self] (email,password) in
            self?.codeLoginView.bottomBtn.startIndicator()
            self?.checkNewUser(email: email, successBlock: { (isNew) in
                self?.view.endEditing(true)
                self?.codeLoginView.bottomBtn.stopIndicator()
                if isNew{
                    TOAST(message: StellarLocalizedString("ALERT_USER_NOT_EXIT"))
                }else{
                    self?.loginWith(email: email, password: password)
                }
            }) {
                self?.codeLoginView.bottomBtn.stopIndicator()
                TOAST(message: StellarLocalizedString("MINE_SECURITY_NETWORK_BUSY"))
            }
        }
        phonePasswordView.forgetClickBlock = { [weak self] in
            let vc = SetupPasswordVC()
            vc.mySetupPasswordStep = .kPhoneAccount
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        emailPasswordView.forgetClickBlock = { [weak self] in
            let vc = SetupPasswordVC()
            vc.mySetupPasswordStep = .kEmailAccount
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        leftLoginButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = LoginVC()
            vc.hiddenBottomButton()
            if self?.myLoginState == LoginState.kCodeType{
                vc.myLoginState = LoginState.kEMailType
            }
            if self?.myLoginState == LoginState.kEMailType{
                vc.myLoginState = LoginState.kCodeType
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        rightLoginButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = LoginVC()
            vc.hiddenBottomButton()
            vc.myLoginState = LoginState.kPasswordType
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    private func hiddenBottomButton(){
        self.leftLoginButton.isHidden = true
        self.leftLoginLabel.isHidden = true
        self.rightLoginLabel.isHidden = true
        self.rightLoginButton.isHidden = true
    }
    private func changeLoginState(state:LoginState){
        switch state {
        case .kCodeType:
            typeLabel.text = StellarLocalizedString("LOGIN_LOGIN_CODE")
            self.leftLoginButton.setImage(UIImage.init(named: "icon_login_email"), for: .normal)
            self.leftLoginLabel.text = StellarLocalizedString("LOGIN_LOGIN_EMAIL")
            self.codeLoginView.isHidden = false
            self.phonePasswordView.isHidden = true
            self.emailPasswordView.isHidden = true
            break
        case .kEMailType:
            typeLabel.text = StellarLocalizedString("LOGIN_LOGIN_EMAIL")
            self.leftLoginButton.setImage(UIImage.init(named: "icon_login_phone"), for: .normal)
            self.leftLoginLabel.text = StellarLocalizedString("LOGIN_LOGIN_CODE")
            self.codeLoginView.isHidden = true
            self.phonePasswordView.isHidden = true
            self.emailPasswordView.isHidden = false
            break
        case .kPasswordType:
            typeLabel.text = StellarLocalizedString("LOGIN_LOGIN_PASSWORD")
            self.codeLoginView.isHidden = true
            self.phonePasswordView.isHidden = false
            self.emailPasswordView.isHidden = true
            self.rightLoginButton.isHidden = true
            self.rightLoginLabel.isHidden = true
            break
        case .kInit:
            break
        }
    }
    private func sendLoginCode(){
        StellarProgressHUD.showHUD()
        let sendCodeModel = SendCodeModel()
        sendCodeModel.cellphone = codeLoginView.getInternationalPhoneNum()
        sendCodeModel.codeUsage = .login
        codeLoginView.bottomBtn.startIndicator()
        StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: {jsonDic in
            StellarProgressHUD.dissmissHUD()
            self.codeLoginView.bottomBtn.stopIndicator()
            let vc = VerificationCodeViewController()
            vc.myVerifyType = .kLogin
            vc.sendTargetString = self.codeLoginView.getInternationalPhoneNum()
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            self.codeLoginView.bottomBtn.stopIndicator()
            self.hintView.showAnimationWithTitle(error, duration: 3)
        }
    }
    private func loginWith(phone:String = "",email:String = "",password:String){
        StellarProgressHUD.showHUD()
        if phone.isEmpty && email.isEmpty {
            TOAST(message: StellarLocalizedString("ALERT_LOGIN_FAIL"))
        }
        let loginRequestModel = LoginRequestModel()
        loginRequestModel.password = password.sha256()
        if !phone.isEmpty {
            loginRequestModel.cellphone = phone
        }else{
            loginRequestModel.email = email
        }
        StellarUserStore.sharedStore.login(loginRequestModel: loginRequestModel,success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(TokenModel.self)
            let infoModel = InfoModel()
            infoModel.cellphone = phone
            infoModel.userid = model.id
            print("登录成功")
            StellarProgressHUD.showHUD()
            StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: model, duiOperationSuccess: {
                StellarProgressHUD.dissmissHUD {
                    TOAST_SUCCESS(message: StellarLocalizedString("ALERT_LOGIN_SUCCESS")) {
                        StellarAppManager.sharedManager.user.hasLogined = true
                        StellarAppManager.sharedManager.nextStep()
                    }
                }
            }) {
                StellarProgressHUD.dissmissHUD()
                self.hintView.showAnimationWithTitle(StellarLocalizedString("ALERT_LOGIN_FAIL"), duration: 3)
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            self.hintView.showAnimationWithTitle(error, duration: 3)
        }
    }
    private lazy var leftLoginButton:UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    private lazy var leftLoginLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C6
        label.font = STELLAR_FONT_T12
        return label
    }()
    private lazy var rightLoginLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C6
        label.font = STELLAR_FONT_T12
        return label
    }()
    private lazy var rightLoginButton:UIButton = {
        let button = UIButton.init(type: .custom)
        return button
    }()
    private lazy var codeLoginView:AccountOrPasswordView = {
        let cView = AccountOrPasswordView()
        cView.myTextfieldViewState = .kPhoneTextfieldType
        return cView
    }()
    lazy var emailPasswordView:AccountAndPasswordView = {
        let cView = AccountAndPasswordView()
        cView.myAccountPasswordViewState = .kEMailTextfieldType
        return cView
    }()
    lazy var phonePasswordView:AccountAndPasswordView = {
        let cView = AccountAndPasswordView()
        cView.myAccountPasswordViewState = .kPhoneTextfieldType
        return cView
    }()
    private lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        view.addSubview(hView)
        return hView
    }()
}
