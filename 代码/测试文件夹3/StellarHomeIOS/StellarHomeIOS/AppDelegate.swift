import UIKit
import AWSCore
import AWSMobileClient
import AppTrackingTransparency
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppAssistance.saveVersion()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50.0
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.CNNorth1,
                                                                identityPoolId:"cn-north-1:de72f2bc-a9a4-486e-8091-6af0326d5891")
        let configuration = AWSServiceConfiguration(region:.CNNorth1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        setupShareSDK()
        checkTrackStatus()
        QPUtilities.initializeAliSDK()
        StellarAppManager.sharedManager.startWithAppDelegate(appDelegate: self)
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        SSTimeManager.shared.taskArray.forEach { (task) in
            task.isStop = true
        }
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        SSTimeManager.shared.taskArray.forEach { (task) in
            task.isStop = false
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    func setupShareSDK() {
        ShareSDK.registPlatforms { (platformsRegister) in
            platformsRegister?.setupWeChat(withAppId: "wxb19ac02802745fba",
                                           appSecret: "c8379767ca54d3410c8efe996dd37973", universalLink: StellarHomeResourceUrl.universal_link)
            platformsRegister?.setupFacebook(withAppkey: "2422035471383986",
                                             appSecret: "f03c9ea566a4569acdeca2cba70cda12",
                                             displayName: "Stellar Home")
        }
    }
    func checkTrackStatus() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined, .denied, .restricted:
                    print("用户拒绝追踪")
                default:
                    print("用户允许追踪")
                }
            }
        }
    }
}