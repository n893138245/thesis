import UIKit
class WelcomeVC: BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollFallsAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAction()
    }
    private func setupViews(){
        view.backgroundColor = STELLAR_COLOR_C1
//        view.addSubview(bgGifImageView1)
//        view.addSubview(bgGifImageView2)
        let topIcon = UIImageView()
        topIcon.image = UIImage.init(named: "welcom_logo")
        topIcon.sizeToFit()
        topIcon.origin = CGPoint.init(x: 40, y: getAllVersionSafeAreaTopHeight()+57)
//        view.addSubview(topIcon)
        let topLabel = UILabel.init(frame: CGRect.init(x: 40, y: topIcon.frame.maxY + 20, width: kScreenWidth - 40, height: 47))
        topLabel.text = StellarLocalizedString("LOGIN_WELCOME")
        topLabel.font = STELLAR_FONT_BOLD_T32
        topLabel.textColor = STELLAR_COLOR_C3
        view.addSubview(topLabel)
        let topLifeLabel = UILabel.init(frame: CGRect.init(x: 40, y: topLabel.frame.maxY + 5, width: kScreenWidth - 40, height: 47))
        topLifeLabel.text = "智能家居app"
        topLifeLabel.font = STELLAR_FONT_BOLD_T52
        topLifeLabel.textColor = STELLAR_COLOR_C3
        view.addSubview(topLifeLabel)
        view.addSubview(registButton)
        registButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-174 - getAllVersionSafeAreaBottomHeight())
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(291)
            make.height.equalTo(46)
        }
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(registButton.snp.top).offset(-24)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(291)
            make.height.equalTo(46)
        }
        view.addSubview(thirdLoginBtnView)
        thirdLoginBtnView.isHidden = true
        thirdLoginBtnView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-20 - getAllVersionSafeAreaBottomHeight())
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(71 + 41)
        }
    }
    private func setupAction(){
        loginButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = LoginVC()
//            vc.myLoginState = .kCodeType
            vc.myLoginState = .kPasswordType
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        registButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = RegistVC()
            vc.mySetupPasswordStep = .kPhoneAccount
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).subscribe({ [weak self] (_) in
            self?.thirdLoginBtnView.layoutLoginViews()
            self?.scrollFallsAnimation()
        }).disposed(by:disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).subscribe({ [weak self] (_) in
            self?.bgGifImageView1.layer.removeAllAnimations()
            self?.bgGifImageView2.layer.removeAllAnimations()
        }).disposed(by:disposeBag)
        thirdLoginBtnView.clickTypeBlock = { [weak self] type in
            if type == .apple{
                if #available(iOS 13.0, *) {
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    let auth = ASAuthorizationController(authorizationRequests: [request])
                    auth.delegate = self
                    auth.performRequests()
                }
            }else if type == .wechat{
                self?.loginWithWeChat()
            }
        }
    }
    private func loginWithWeChat(){
        ThirdPartLoginManager.loginWithWeChat(success: { (user) in
            if user.credential == nil{
                TOAST(message: StellarLocalizedString("ALERT_AUTH_FAIL"))
            }else{
                self.loginThirdPartRequest(user:user)
            }
        }) { (errorCode) in
            TOAST(message: StellarLocalizedString("ALERT_AUTH_FAIL"))
        }
    }
    private func loginThirdPartRequest(user:SSDKUser){
        StellarProgressHUD.showHUD()
        let thirdPartLoginModel = ThirdPartLoginModel()
        thirdPartLoginModel.thirdPartId = user.rawData["unionid"] as? String
        thirdPartLoginModel.thirdPartType = .wechat
        StellarUserStore.sharedStore.thirdLogin(loginRequestModel: thirdPartLoginModel, success: { (jsonDictionary) in
            let tokenModel = jsonDictionary.kj.model(TokenModel.self)
            let infoModel = InfoModel()
            infoModel.userid = tokenModel.id
            StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: tokenModel, duiOperationSuccess: {
                StellarProgressHUD.dissmissHUD()
                TOAST_SUCCESS(message: StellarLocalizedString("ALERT_AUTH_SUCCESS")) {
                    StellarAppManager.sharedManager.user.hasLogined = true
                    StellarAppManager.sharedManager.nextStep()
                }
            }) {
                StellarProgressHUD.dissmissHUD()
                print("DUI关联错误")
                TOAST(message: "第三方登录失败")
            }
        }) { (code,error) in
            StellarProgressHUD.dissmissHUD()
            self.needToBindAction(user: user)
        }
    }
    private func needToBindAction(user:SSDKUser){
        TOAST(message: StellarLocalizedString("ALERT_FIRST_BINDING"))
        let vc = RegistVC()
        vc.myThirdPartType = .wechat
        vc.mySetupPasswordStep = .kPhoneAccount
        vc.thirdpartyUserInfo = user
        navigationController?.pushViewController(vc, animated: true)
    }
    private func scrollFallsAnimation() {
        if bgGifImageView1.frame.origin.y == -kScreenHeight{
            bgGifImageView1.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        }
        if bgGifImageView2.frame.origin.y == 0{
            bgGifImageView2.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        }
        UIView.animate(withDuration: 12, delay: 0, options: [.curveLinear], animations: {  [weak self] in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self?.bgGifImageView1.frame = CGRect.init(x: 0, y: -kScreenHeight, width: kScreenWidth, height: kScreenHeight)
            self?.bgGifImageView2.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        })
    }
    private lazy var bgGifImageView1:UIImageView = {
        let bgView =  UIImageView()
        bgView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        bgView.contentMode = .scaleToFill
        bgView.image = UIImage.init(named: "welcome_move_bg")
        return bgView
    }()
    private lazy var bgGifImageView2:UIImageView = {
        let bgView =  UIImageView()
        bgView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        bgView.contentMode = .scaleToFill
        bgView.image = UIImage.init(named: "welcome_move_bg")
        return bgView
    }()
    private lazy var loginButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle(StellarLocalizedString("LOGIN_LOGIN"), for: .normal)
        button.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        button.backgroundColor = STELLAR_COLOR_C3
        button.titleLabel?.font = STELLAR_FONT_T20
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var registButton:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle(StellarLocalizedString("REGIST_REGIST"), for: .normal)
        button.setTitleColor(STELLAR_COLOR_C3, for: .normal)
        button.titleLabel?.font = STELLAR_FONT_T20
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = STELLAR_COLOR_C3.cgColor
        return button
    }()
    private lazy var thirdLoginBtnView:ThirdLoginBtnView = {
        let view = ThirdLoginBtnView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 71))
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
extension WelcomeVC:ASAuthorizationControllerDelegate{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        var user: String? = nil
        var identityToken:String?
        var authorizationCode:String?
        var name:String?
        if let apple = authorization.credential as? ASAuthorizationAppleIDCredential {
            user = apple.user
            identityToken = String.init(data: apple.identityToken ?? Data(), encoding: .utf8)
            authorizationCode = String.init(data: apple.authorizationCode ?? Data(), encoding: .utf8)
            let familyName = apple.fullName?.familyName ?? ""
            let givenName = apple.fullName?.givenName ?? ""
            name = familyName + givenName
        } else if let password = authorization.credential as? ASPasswordCredential {
            user = password.user
        }
        guard let userID = user else { return }
        self.appleLogin(userID: userID,authorizationCode: authorizationCode,identityToken: identityToken,name: name)
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        TOAST(message: "授权失败")
        print(error)
    }
    @available(iOS 13.0, *)
    func appleLogin(userID:String,authorizationCode:String?,identityToken:String?,name:String?){
        StellarProgressHUD.showHUD()
        let thirdPartLoginModel = ThirdPartLoginModel()
        thirdPartLoginModel.thirdPartId = userID
        thirdPartLoginModel.thirdPartType = .apple
        thirdPartLoginModel.data.authorizationCode = authorizationCode
        thirdPartLoginModel.data.identityToken = identityToken
        StellarUserStore.sharedStore.thirdLogin(loginRequestModel: thirdPartLoginModel, success: { (jsonDictionary) in
            let tokenModel = jsonDictionary.kj.model(TokenModel.self)
            let infoModel = InfoModel()
            infoModel.userid = tokenModel.id
            StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: tokenModel, duiOperationSuccess: {
                StellarProgressHUD.dissmissHUD()
                TOAST_SUCCESS(message: StellarLocalizedString("ALERT_AUTH_SUCCESS")) {
                    StellarAppManager.sharedManager.user.hasLogined = true
                    StellarAppManager.sharedManager.nextStep()
                }
            }) {
                StellarProgressHUD.dissmissHUD()
                TOAST(message: "第三方登录失败")
            }
        }) { (code,msg) in
            if code == .thirdUserNotExist{
                self.sendRegistRequest(userID: userID, authorizationCode: authorizationCode, identityToken: identityToken, name: name, successBlock: { (_) in
                    self.appleLogin(userID: userID, authorizationCode: authorizationCode, identityToken: identityToken, name: name)
                }) {
                    TOAST(message: "注册失败")
                }
            }else{
                StellarProgressHUD.dissmissHUD()
                TOAST(message: "第三方登录失败")
            }
        }
    }
    private func sendRegistRequest(userID:String,authorizationCode:String?,identityToken:String?,name:String?, successBlock:((_ response:Any)->Void)?, failureBlock:(()->Void)?){
        let registRequest = RegistModel()
        var thridInfo = [ThirdPartInfoModel]()
        let info = ThirdPartInfoModel()
        info.thirdPartId = userID
        info.nickname = name
        let appleModel = ThirdPartLoginModelData()
        appleModel.authorizationCode = authorizationCode
        appleModel.identityToken = identityToken
        info.data = appleModel
        info.thirdPartType = .apple
        info.expireIn = 3600
        thridInfo.append(info)
        registRequest.thirdPartInfo = thridInfo
        StellarUserStore.sharedStore.register(registModel: registRequest, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            successBlock?(jsonDic)
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            failureBlock?()
        }
    }
}
