import UIKit
enum VerifyType {
    case kResetPhonePassword
    case kResetEmailPassword
    case kLogin
    case kRegistEmail
    case kRegistPhone
}
class VerificationCodeViewController: BaseViewController {
    @IBOutlet weak var inputCodeLabel: UILabel!
    @IBOutlet weak var sendCodeContainer: UIView!
    @IBOutlet weak var sendPhoneLabel: UILabel!
    var myThirdPartType:ThirdPartType?
    var sendTargetString:String = ""
    var thirdpartyUserInfo:SSDKUser?
    var myVerifyType:VerifyType = .kResetPhonePassword
    var isAgreePushProduct:Bool = true
    var appleModel:ThirdPartLoginModelData?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        sendCodeView.textfield.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        SSTimeManager.shared.removeTask(task: sendCodeView.timeTask!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    private func setupView(){
        view.backgroundColor = STELLAR_COLOR_C1
        if myVerifyType == .kResetEmailPassword || myVerifyType == .kRegistEmail {
            sendPhoneLabel.text = StellarLocalizedString("SENDCODE_PHONE") + sendTargetString
        }else{
            let index = sendTargetString.firstIndex(of:"-")!
            let region = sendTargetString.prefix(upTo: index)
            let phoneNum = sendTargetString[index..<sendTargetString.endIndex].replacingOccurrences(of: "-", with: " ")
            sendPhoneLabel.text = StellarLocalizedString("SENDCODE_PHONE") + region + phoneNum.substring(from: 0, length: 4)! + " " + phoneNum.substring(from: 4, length: 4)! + " " + phoneNum.substring(from: 8, length: 4)!
        }
        inputCodeLabel.text = StellarLocalizedString("SENDCODE_INPUTCODE")
        inputCodeLabel.textColor = STELLAR_COLOR_C3
        inputCodeLabel.font = STELLAR_FONT_BOLD_T30
        sendCodeView.frame = CGRect.init(x: 0, y: 100, width: kScreenWidth-18, height: 400)
        sendCodeContainer.addSubview(sendCodeView)
        sendCodeView.verificateCodeBlock = { [weak self] in
            self?.verificateCode()
        }
        sendCodeView.clickBlock = {
            StellarProgressHUD.showHUD()
            let sendCodeModel = SendCodeModel()
            switch self.myVerifyType {
            case .kLogin:
                sendCodeModel.cellphone = self.sendTargetString
                sendCodeModel.codeUsage = .login
                break
            case .kRegistPhone:
                sendCodeModel.cellphone = self.sendTargetString
                sendCodeModel.codeUsage = .register
                break
            case .kRegistEmail:
                sendCodeModel.email = self.sendTargetString
                sendCodeModel.codeUsage = .register
                break
            case .kResetPhonePassword:
                sendCodeModel.cellphone = self.sendTargetString
                sendCodeModel.codeUsage = .reset_password
                break
            case .kResetEmailPassword:
                sendCodeModel.email = self.sendTargetString
                sendCodeModel.codeUsage = .reset_password
                break
            }
            StellarUserStore.sharedStore.sendCode(sendCodeModel: sendCodeModel, success: { jsonDic in
                StellarProgressHUD.dissmissHUD()
                self.sendCodeView.initCountDownClock()
            }) { (error) in
                self.failedAction(message: error)
            }
        }
    }
    private func verificateCode(){
        StellarProgressHUD.showHUD()
        switch myVerifyType {
        case .kResetEmailPassword:
            let checkCodeModel = CheckCodeModel()
            checkCodeModel.smscode = sendCodeView.getTextString()
            checkCodeModel.codeUsage = .reset_password
            checkCodeModel.email = sendTargetString
            StellarUserStore.sharedStore.checkCode(checkCodeModel: checkCodeModel, success: {[weak self] (jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let vc = SetupPasswordVC()
                vc.eMail = self?.sendTargetString ?? ""
                vc.code = self?.sendCodeView.getTextString() ?? ""
                vc.mySetupPasswordStep = .kPassword
                self?.navigationController?.pushViewController(vc, animated: true)
            }) {[weak self](error) in
                self?.failedAction(message: error)
            }
            break
        case .kResetPhonePassword:
            let checkCodeModel = CheckCodeModel()
            checkCodeModel.smscode = sendCodeView.getTextString()
            checkCodeModel.codeUsage = .reset_password
            checkCodeModel.cellphone = sendTargetString
            StellarUserStore.sharedStore.checkCode(checkCodeModel: checkCodeModel, success: { [weak self](jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let vc = SetupPasswordVC()
                vc.cellPhone = self?.sendTargetString ?? ""
                vc.code = self?.sendCodeView.getTextString() ?? ""
                vc.mySetupPasswordStep = .kPassword
                self?.navigationController?.pushViewController(vc, animated: true)
            }) { [weak self](error) in
                self?.failedAction(message: error)
            }
            break
        case .kLogin:
            let loginRequestModel = LoginRequestModel()
            loginRequestModel.smscode = sendCodeView.getTextString()
            loginRequestModel.cellphone = sendTargetString
            StellarUserStore.sharedStore.login(loginRequestModel: loginRequestModel, success: { (jsonDictionary) in
                let model = jsonDictionary.kj.model(TokenModel.self)
                let infoModel = InfoModel()
                infoModel.cellphone = self.sendTargetString
                infoModel.userid = model.id
                StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: infoModel, userToken: model, duiOperationSuccess: {
                    StellarProgressHUD.dissmissHUD {
                        TOAST_SUCCESS(message: StellarLocalizedString("ALERT_LOGIN_SUCCESS")) {
                            StellarAppManager.sharedManager.user.hasLogined = true
                            StellarAppManager.sharedManager.nextStep()
                        }
                    }
                }) {
                    self.failedAction(message:StellarLocalizedString("SENDCODE_SEND_CODE_FAIL"))
                }
            }) { (error) in
                self.failedAction(message: error)
            }
            break
        case .kRegistPhone:
            let checkCodeModel = CheckCodeModel()
            checkCodeModel.smscode = sendCodeView.getTextString()
            checkCodeModel.codeUsage = .register
            checkCodeModel.cellphone = sendTargetString
            StellarUserStore.sharedStore.checkCode(checkCodeModel: checkCodeModel, success: { [weak self](jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let vc = RegistVC()
                vc.myThirdPartType = self?.myThirdPartType
                vc.thirdpartyUserInfo = self?.thirdpartyUserInfo
                vc.appleModel = self?.appleModel ?? ThirdPartLoginModelData()
                vc.cellPhone = self?.sendTargetString ?? ""
                vc.isAgreePushProduct = self?.isAgreePushProduct ?? true
                vc.code = self?.sendCodeView.getTextString() ?? ""
                vc.mySetupPasswordStep = .kPassword
                self?.navigationController?.pushViewController(vc, animated: true)
            }) { [weak self](error) in
                self?.failedAction(message: error)
            }
            break
        case .kRegistEmail:
            let checkCodeModel = CheckCodeModel()
            checkCodeModel.smscode = sendCodeView.getTextString()
            checkCodeModel.codeUsage = .register
            checkCodeModel.email = sendTargetString
            StellarUserStore.sharedStore.checkCode(checkCodeModel: checkCodeModel, success: {[weak self] (jsonDic) in
                StellarProgressHUD.dissmissHUD()
                let vc = RegistVC()
                vc.thirdpartyUserInfo = self?.thirdpartyUserInfo
                vc.isAgreePushProduct = self?.isAgreePushProduct ?? true
                vc.eMail = self?.sendTargetString ?? ""
                vc.code = self?.sendCodeView.getTextString() ?? ""
                vc.mySetupPasswordStep = .kPassword
                self?.navigationController?.pushViewController(vc, animated: true)
            }) { [weak self](error) in
                self?.failedAction(message: error)
            }
            break
        }
    }
    private func failedAction(message:String){
        StellarProgressHUD.dissmissHUD()
        sendCodeView.clear()
        sendCodeView.textfield.becomeFirstResponder()
        if message.isEmpty {
            hintView.showAnimationAndHideenAfterDuration(2)
        }else{
            hintView.showAnimationWithTitle(message, duration: 2)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView(StellarLocalizedString("SENDCODE_SEND_CODE_FAIL"))
        self.view.addSubview(hView)
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        return hView
    }()
    private lazy var sendCodeView:SendCodeView = {
        let view = SendCodeView.SendCodeView()
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}