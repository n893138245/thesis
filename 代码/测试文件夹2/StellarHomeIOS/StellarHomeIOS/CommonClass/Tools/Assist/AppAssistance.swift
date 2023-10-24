import UIKit
class AppAssistance: NSObject {
    static func appVersion() -> String{
           (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
       }
    static func appBuildVersion() -> String{
        (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    static func lastAppVersion() -> String{
        guard let version = userDefaults.value(forKey:"CFBundleShortVersionString") as? String else {
            return ""
        }
        return version
    }
    static func appName() -> String{
        (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
    }
    static func saveVersion(){
        userDefaults.setValue(AppAssistance.appVersion(), forKey: "CFBundleShortVersionString")
        userDefaults.synchronize()
    }
}