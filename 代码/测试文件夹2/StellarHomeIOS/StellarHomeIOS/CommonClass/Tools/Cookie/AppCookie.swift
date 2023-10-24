import UIKit
class AppCookie: NSObject {
    var isDirty = false
    var launchedCount:NSInteger{
        didSet{
            userDefaults.setValue(launchedCount, forKey: AppAssistance.appVersion()+userIdentifier)
            isDirty = true
        }
    }
    var userIdentifier:String{
        didSet{
            userDefaults.setValue(userIdentifier, forKey: keyAppCookie + "currentUser")
            isDirty = true
        }
    }
    override init() {
        userIdentifier = (userDefaults.object(forKey: keyAppCookie + "currentUser") as? String) ?? ""
        launchedCount =  (userDefaults.object(forKey:AppAssistance.appVersion()+userIdentifier) as? NSInteger) ?? 0
    }
    func save(){
        if isDirty {
            userDefaults.synchronize()
        }
    }
    func clear(){
        launchedCount = 0
        userIdentifier = ""
        userDefaults.synchronize()
    }
}