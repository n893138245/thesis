import UIKit
enum AppMangerStep:Int{
    case kAppStepInit = 0
    case kAppStepLaunch = 1
    case kAppStepLogin = 2
    case kAppStepConnectedGateway = 3
    case kAppStepEquipmentLoading = 4
    case kAppStepMain = 5
    case kAppStepLogout = 6
}
class StellarAppManager: NSObject {
    static let sharedManager = StellarAppManager.init()
    var launchCountSinceNow:NSInteger = 0
    var currentStep:AppMangerStep?{
        didSet{
            if oldValue != currentStep{
                configure()
            }
        }
    }
    var currVc:UIViewController?
    func startWithAppDelegate(appDelegate:AppDelegate){
        appDelegate.window = window
        appDelegate.window?.makeKeyAndVisible()
        currentStep = .kAppStepInit
        cookie.launchedCount += 1
    }
    @objc func nextStep(){
        doSomethingBeforeSwitch()
        currentStep = AppMangerStep(rawValue: currentStep!.rawValue + 1)!
    }
    func loginOutAction(){
        cookie.clear()
        user.hasLogined = false
        user.save()
        MQTTManger.sharedManager().disConnectMQTTBroker()
        currentStep = .kAppStepLogout
    }
    func enterBackgroundState(){
    }
    func enterForegroundState(){
    }
    func saveUserInfoAndInitDUI(userInfo:InfoModel,userToken:TokenModel,duiOperationSuccess:(()->Void)? = nil,duiOperationFail:(()->Void)? = nil){
        StellarAppManager.sharedManager.cookie.userIdentifier = userInfo.userid
        StellarAppManager.sharedManager.user.userInfo = userInfo
        StellarAppManager.sharedManager.user.token = userToken
        StellarUserStore.sharedStore.getDCAToken(success: { (jsonDic) in
            if let duiAccessToken = jsonDic["accessToken"] as? String,let duiRefreshToken = jsonDic["refreshToken"] as? String{
                DUIManager.sharedManager().linkWithDUI(sansiUid: userInfo.userid, sansiToken: duiAccessToken, success: {
                    DUIManager.sharedManager().bindSansiSmartHomeSkill(accessToken: duiAccessToken, refreshToken: duiRefreshToken, success: duiOperationSuccess, failure: duiOperationFail)
                }) { (_, _) in
                    duiOperationFail?()
                }
            }else{
                duiOperationFail?()
            }
        }) { (error) in
            duiOperationFail?()
        }
    }
    private func configure(){
        switch currentStep {
        case .kAppStepInit?:
            configureInit()
            break
        case .kAppStepLaunch?:
            configureLaunch()
            break
        case .kAppStepLogin?:
            configureLogin()
            break
        case .kAppStepConnectedGateway?:
            configureConnectedGateway()
            break
        case .kAppStepEquipmentLoading?:
            configureEquipmentLoading()
            break
        case .kAppStepMain?:
            configureMain()
            break
        case .kAppStepLogout?:
            currentStep = .kAppStepInit
            break
        default:
            break
        }
    }
    private func configureInit(){
        user.loadUserWithIdentifer(identifier: cookie.userIdentifier)
        nextStep()
    }
    private func configureLaunch(){
        nextStep()
    }
    private func configureLogin(){
        if user.hasLogined{
            self.nextStep()
        }else{
            let vc = WelcomeVC()
            let nav = MyRootNavViewController(rootViewController: vc)
            switchToVC(vc: nav)
        }
    }
    private func configureConnectedGateway(){
        nextStep()
    }
    private func configureEquipmentLoading(){
        let vc = EquipmentLoadingVC()
        let nav = MyRootNavViewController(rootViewController: vc)
        switchToVC(vc: nav)
    }
    private func configureMain(){
        let vc = MainViewController()
        let nav = MyRootNavViewController(rootViewController: vc)
        switchToVC(vc: nav)
    }
    private func switchToVC(vc:UIViewController){
        if window.rootViewController == nil {
            self.window.rootViewController = vc
            self.window.makeKeyAndVisible()
            self.currVc = vc
            return
        }
        var animationOptions = UIView.AnimationOptions.transitionCrossDissolve
        if currentStep == .kAppStepEquipmentLoading || currentStep == .kAppStepConnectedGateway {
            animationOptions = UIView.AnimationOptions.transitionFlipFromLeft
        }
        UIView.transition(with: window, duration: 1, options: animationOptions, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.window.rootViewController = vc
            self.window.makeKeyAndVisible()
            self.currVc = vc
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }
    private func doSomethingBeforeSwitch(){
        if currentStep == .kAppStepLogin {
            user.save()
            cookie.save()
            MQTTManger.sharedManager().connectMQTTBroker(success: nil, failure: nil)
        }else if currentStep == .kAppStepEquipmentLoading{
            DevicesStore.sharedStore().setMQTTMangerDelegate()
        }else if currentStep == .kAppStepMain {
            cookie.clear()
            user.hasLogined = false
            user.save()
            MQTTManger.sharedManager().disConnectMQTTBroker()
        }
    }
    private lazy var window:UIWindow = {
        let view = UIWindow.init(frame: UIScreen.main.bounds)
        return view
    }()
    lazy var cookie:AppCookie = {
        let cookie = AppCookie()
        return cookie
    }()
    lazy var user:AppUser = {
        let user = AppUser()
        return user
    }()
}