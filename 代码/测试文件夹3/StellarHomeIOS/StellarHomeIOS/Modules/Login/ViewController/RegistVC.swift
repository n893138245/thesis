import UIKit
enum RegistStep {
    case kInit
    case kPhoneAccount
    case kEmailAccount
    case kPassword
}
class RegistVC: LoginBaseVC {
    var mySetupPasswordStep:SetupPasswordStep = .kInit{
        didSet{
            self.changeStep()
        }
    }
    var myThirdPartType:ThirdPartType?
    var cellPhone = ""
    var eMail = ""
    var code:String = ""
    var isAgreePushProduct:Bool = true
    var isAgreeProtocol = false
    var thirdpartyUserInfo:SSDKUser?
    var appleModel = ThirdPartLoginModelData()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        changeStep()
    }
    override func setupViews(){
        super.setupViews()
        contentBGView.snp.remakeConstraints { (make) in
            make.top.equalTo(typeLabel.snp_bottomMargin).offset(29)
            make.bottom.equalTo(-24-getAllVersionSafeAreaBottomHeight()-44)
            make.left.equalTo(9)
            make.right.equalTo(-9)
        }
        codeLoginPhoneView.setupViews(bottomBtnTitle: StellarLocalizedString("REGIST_GET_CODE"))
        contentBGView.addSubview(codeLoginPhoneView)
        codeLoginPhoneView.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.bottom.equalTo(self.codeLoginPhoneView.bottomBtn.snp.bottom)
            make.left.right.equalTo(0)
        }
        codeLoginEmailView.setupViews(bottomBtnTitle: StellarLocalizedString("REGIST_GET_CODE"))
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
            make.bottom.equalTo(contentBGView.snp.bottom).offset(-32)
            make.centerX.right.equalTo(contentBGView)
        }
        view.addSubview(agreePushProductButton)
        agreePushProductButton.isHidden = true
        agreePushProductButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-getAllVersionSafeAreaBottomHeight()-24)
            make.centerX.equalTo(self.view)
            make.width.equalTo(160)
        }
        agreePushProductButton.isSelected = true
        if mySetupPasswordStep == .kInit{
            mySetupPasswordStep = .kPhoneAccount
        }
        if mySetupPasswordStep == .kPassword {
            navView.backclickBlock = { [weak self] in
                for vc in self?.navigationController?.viewControllers.reversed() ?? [UIViewController](){
                    if let popVc = vc as? RegistVC {
                        self?.navigationController?.popToViewController(popVc, animated: true)
                    }
                }
            }
        }
    }
    private func setupAction(){
        codeLoginPhoneView.phoneClickBlock = { [weak self] (phone) in
            self?.codeLoginPhoneView.bottomBtn.startIndicator()
            self?.checkNewUser(phone: phone, successBlock: { isNew in
                self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                if isNew{
                    self?.view.endEditing(true)
                    GHProgressHUD.showCustom(self?.privacyAlertView ?? PrivacyAlertView())
                }else{
                    TOAST(message: StellarLocalizedString("ALERT_PHONE_REGISTED"))
                }
            },failureBlock: {
                self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                self?.hintView.showAnimationWithTitle(StellarLocalizedString("SMART_NET_ERROR"), duration: 3)
            })
        }
        codeLoginEmailView.commonClickBlock = { [weak self] (email) in
            self?.codeLoginEmailView.bottomBtn.startIndicator()
            self?.checkNewUser(email: email, successBlock: { isNew in
                self?.codeLoginEmailView.bottomBtn.stopIndicator()
                if isNew{
                    self?.view.endEditing(true)
                    GHProgressHUD.showCustom(self?.privacyAlertView ?? PrivacyAlertView())
                }else{
                    TOAST(message: StellarLocalizedString("ALERT_EMAIL_REGISTED"))
                }
            },failureBlock: {
                self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                self?.hintView.showAnimationWithTitle(StellarLocalizedString("SMART_NET_ERROR"), duration: 3)
            })
        }
        setupPasswordView.commonClickBlock = { [weak self] (password) in
            StellarProgressHUD.showHUD()
            self?.sendRegistRequest(password: password, successBlock: { (response) in
                let loginRequestModel = LoginRequestModel()
                loginRequestModel.password = password.sha256()
                if self?.cellPhone.isEmpty ?? true {
                    loginRequestModel.email = self?.eMail ?? ""
                }else{
                    loginRequestModel.cellphone = self?.cellPhone ?? ""
                }
                StellarUserStore.sharedStore.login(loginRequestModel: loginRequestModel, success: { (jsonDictionary) in
                    let model = jsonDictionary.kj.model(TokenModel.self)
                    self?.confirmUserInfo()
                    let infoModel = InfoModel()
                    if self?.cellPhone.isEmpty ?? true {
                        infoModel.email = self?.eMail ?? ""
                    }else{
                        infoModel.cellphone = self?.cellPhone ?? ""
                    }
                    infoModel.subscribe = self?.isAgreePushProduct ?? false
                    infoModel.userid = model.id
                    StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: model, duiOperationSuccess: {
                        StellarProgressHUD.dissmissHUD()
                        TOAST_SUCCESS(message: StellarLocalizedString("ALERT_LOGIN_SUCCESS") ) {
                            StellarAppManager.sharedManager.user.hasLogined = true
                            StellarAppManager.sharedManager.nextStep()
                        }
                    }) {
                        self?.registfailAction()
                    }
                }) { (error) in
                    self?.registfailAction()
                }
            }, failureBlock: {
                self?.registfailAction()
            })
        }
        resetBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.mySetupPasswordStep == .kPhoneAccount {
                self?.mySetupPasswordStep = .kEmailAccount
            }else if self?.mySetupPasswordStep == .kEmailAccount {
                self?.mySetupPasswordStep = .kPhoneAccount
            }
        }).disposed(by: disposeBag)
        agreePushProductButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.agreePushProductButton.isSelected = !(self?.agreePushProductButton.isSelected ?? false)
            self?.isAgreePushProduct = self?.agreePushProductButton.isSelected ?? false
        }).disposed(by: disposeBag)
    }
    private func registfailAction(){
        StellarProgressHUD.dissmissHUD()
        TOAST(message: StellarLocalizedString("ALERT_REGIST_FAIL"))
        for vc in navigationController?.viewControllers.reversed() ?? [UIViewController](){
            if let popVc = vc as? RegistVC {
                navigationController?.popToViewController(popVc, animated: true)
            }
        }
    }
    private func sendRegistRequest(password:String, successBlock:((_ response:Any)->Void)?, failureBlock:(()->Void)?){
        StellarProgressHUD.showHUD()
        let registRequest = RegistModel()
        registRequest.smscode = self.code
        if thirdpartyUserInfo != nil {
            var thridInfo = [ThirdPartInfoModel]()
            let info = ThirdPartInfoModel()
            info.thirdPartId = thirdpartyUserInfo?.uid ?? ""
            info.nickname = thirdpartyUserInfo?.nickname ?? ""
            info.headerImage = thirdpartyUserInfo?.icon ?? ""
            if cellPhone.isEmpty{
                info.email = eMail
            }else{
                info.cellphone = cellPhone
            }
            info.data = self.appleModel
            info.thirdPartType = self.myThirdPartType ?? .unknown
            info.expireIn = 3600
            thridInfo.append(info)
            registRequest.thirdPartInfo = thridInfo
        }
        if !eMail.isEmpty {
            registRequest.email = eMail
        }else if !cellPhone.isEmpty {
            registRequest.cellphone = cellPhone
        }
        registRequest.smscode = code
        registRequest.password = password.sha256()
        StellarUserStore.sharedStore.register(registModel: registRequest, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            successBlock?(jsonDic)
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            failureBlock?()
        }
    }
    private func confirmUserInfo(){
        StellarUserStore.sharedStore.modificationUserInfo(subscribe: isAgreePushProduct, success: { (_) in
        }) { (_) in
        }
    }
    private func sendCode(internationalPhone:String = "",email:String = "",completion:((_ isNewUser:Bool,_ error:String)->Void)?){
        StellarProgressHUD.showHUD()
        if internationalPhone.isEmpty && email.isEmpty{
            completion?(false,"")
        }
        let sendCodeModel = SendCodeModel()
        if email.isEmpty {
            sendCodeModel.cellphone = internationalPhone
        }else{
            sendCodeModel.email = email
        }
        sendCodeModel.codeUsage = .register
        StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: { jsonDic in
            StellarProgressHUD.dissmissHUD()
            completion?(true,"发送验证码成功")
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            completion?(false,error)
        }
    }
    private func changeStep(){
        codeLoginEmailView.setNeedsLayout()
        setupPasswordView.setNeedsLayout()
        codeLoginPhoneView.setNeedsLayout()
        switch mySetupPasswordStep {
        case .kPhoneAccount:
            if self.thirdpartyUserInfo == nil{
                typeLabel.text = StellarLocalizedString("REGIST_ACCOUNT")
                resetBtn.setTitle(StellarLocalizedString("REGIST_USE_EMAIL_REGIST"), for: .normal)
                resetBtn.isHidden = true
            }else{
                typeLabel.text = StellarLocalizedString("ALERT_BIND_ACCOUNT")
                resetBtn.isHidden = true
            }
            codeLoginEmailView.alpha = 0
            setupPasswordView.alpha = 0
            codeLoginPhoneView.alpha = 1
        case .kEmailAccount:
            if self.thirdpartyUserInfo == nil{
                typeLabel.text = StellarLocalizedString("REGIST_ACCOUNT")
                resetBtn.setTitle(StellarLocalizedString("ALERT_REGIST_PHONE"), for: .normal)
                resetBtn.isHidden = false
            }else{
                typeLabel.text = StellarLocalizedString("ALERT_BIND_ACCOUNT")
                resetBtn.isHidden = true
            }
            codeLoginPhoneView.alpha = 0
            setupPasswordView.alpha = 0
            codeLoginEmailView.alpha = 1
        case .kPassword:
            fd_interactivePopDisabled = true
            typeLabel.text = StellarLocalizedString("PASSWORD_SET_PASSWORD")
            resetBtn.isHidden = true
            codeLoginEmailView.alpha = 0
            codeLoginPhoneView.alpha = 0
            setupPasswordView.alpha = 1
        case .kInit:
            break
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
        cView.setupViews(bottomBtnTitle: StellarLocalizedString("COMMON_CPMPLETE"))
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
        btn.setImage(UIImage.init(named: "loging_switch"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 18, bottom: 0, right: 0)
        btn.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        btn.titleLabel?.font = STELLAR_FONT_BOLD_T15
        return btn
    }()
    private lazy var agreePushProductButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = STELLAR_FONT_T13
        button.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        button.setTitle(StellarLocalizedString("REGIST_PROMOTION_PUSH"), for: .normal)
        button.setImage(UIImage.init(named: "icon_check"), for: .selected)
        button.setImage(UIImage.init(named: "icon_nocheck"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 22, bottom: 0, right: 0)
        return button
    }()
    private lazy var privacyAlertView:PrivacyAlertView = {
        let alertView = PrivacyAlertView(frame: CGRect(origin: .zero, size: CGSize(width: (kScreenWidth - 42), height: (kScreenHeight - 200))))
        GHProgressHUD.showCustom(alertView)
        alertView.agreeActionClosure = { [weak self] isReadToBottom in
            self?.isAgreeProtocol = isReadToBottom
            if isReadToBottom {
                self?.codeLoginPhoneView.bottomBtn.startIndicator()
                var sendCellPhone = ""
                var sendEmail = ""
                if self?.mySetupPasswordStep == .kPhoneAccount {
                    sendCellPhone = self?.codeLoginPhoneView.getInternationalPhoneNum() ?? ""
                }else{
                    sendEmail = self?.codeLoginEmailView.getTextFiedlEmail() ?? ""
                }
                self?.sendCode(internationalPhone: sendCellPhone,email: sendEmail, completion: { isSuccess,error in
                    self?.codeLoginPhoneView.bottomBtn.stopIndicator()
                    if isSuccess{
                        let vc = VerificationCodeViewController()
                        vc.appleModel = self?.appleModel
                        vc.thirdpartyUserInfo = self?.thirdpartyUserInfo
                        vc.myThirdPartType = self?.myThirdPartType
                        if self?.mySetupPasswordStep == .kEmailAccount {
                            vc.sendTargetString = sendEmail
                            vc.myVerifyType = .kRegistEmail
                        }else{
                            vc.sendTargetString = sendCellPhone
                            vc.myVerifyType = .kRegistPhone
                        }
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        if error.isEmpty {
                            self?.hintView.showAnimationWithTitle("验证码发送失败", duration: 3)
                        }else{
                            self?.hintView.showAnimationWithTitle(error, duration: 3)
                        }
                    }
                })
            }
        }
        return alertView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
