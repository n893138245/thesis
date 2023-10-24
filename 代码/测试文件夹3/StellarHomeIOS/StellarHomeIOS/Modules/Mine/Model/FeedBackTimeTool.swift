import UIKit
class FeedBackTimeTool: NSObject {
    static let sharedTool = FeedBackTimeTool.init()
    private let feedBackTimeKey = "feedBackTimeKey\(StellarAppManager.sharedManager.user.userInfo.userid)"
    private let submitCountKey = "submitCountKey\(StellarAppManager.sharedManager.user.userInfo.userid)"
    private let verificationTimeKey = "verificationTimeKey\(StellarAppManager.sharedManager.user.userInfo.userid)"
    private let accessCodeKey = "accessCodeKey\(StellarAppManager.sharedManager.user.userInfo.userid)"
    func saveCurrentTime() {
        let date = Date()
        userDefaults.set(date, forKey: feedBackTimeKey)
        if let count = userDefaults.object(forKey: submitCountKey) as? Int {
            userDefaults.set(count + 1, forKey: submitCountKey)
        }else {
            userDefaults.set(1, forKey: submitCountKey)
        }
    }
    func clearYestadayDatas() {
        if let lastDate = userDefaults.object(forKey: feedBackTimeKey) as? Date {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            let lastDateString = dateformatter.string(from: lastDate)
            let currentDateString = dateformatter.string(from: Date())
            if currentDateString != lastDateString { 
                userDefaults.removeObject(forKey: feedBackTimeKey)
                if (userDefaults.object(forKey: submitCountKey) as? Int) != nil {
                    userDefaults.removeObject(forKey: submitCountKey)
                }
            }
        }
    }
    func timeDefferenceResult() -> Int {
        clearYestadayDatas()
        if let lastDate = userDefaults.object(forKey: feedBackTimeKey) as? Date {
            let gregorian = NSCalendar(calendarIdentifier: .chinese)
            let result = gregorian!.components(.second, from: lastDate, to: Date(), options: [.matchFirst])
            return (result.second!/60)
        }
        return 10
    }
    var submitCount: Int {
        get {
            clearYestadayDatas()
            if let count = userDefaults.object(forKey: submitCountKey) as? Int {
                return count
            }
            return 0
        }
    }
    func saveCurrentVerificationTime(accessCode: String) {
        let date = Date()
        userDefaults.set(date, forKey: verificationTimeKey)
        if getVerificationAccessCode() != nil {
            userDefaults.removeObject(forKey: accessCodeKey)
        }
        userDefaults.set(accessCode, forKey: accessCodeKey)
    }
    func getVerificationAccessCode() -> String? {
        removeLastAccessCode()
        if let code = userDefaults.object(forKey: accessCodeKey) as? String {
            return code
        }
        return nil
    }
    func removeAccessCode() {
        if (userDefaults.object(forKey: accessCodeKey) as? String) != nil {
            userDefaults.removeObject(forKey: accessCodeKey)
        }
        if userDefaults.object(forKey: verificationTimeKey) as? Date != nil {
            userDefaults.removeObject(forKey: verificationTimeKey)
        }
    }
    private func verificationTimeDefferenceResult() -> Int {
        if let lastDate = userDefaults.object(forKey: verificationTimeKey) as? Date {
            let gregorian = NSCalendar(calendarIdentifier: .chinese)
            let result = gregorian?.components(.second, from: lastDate, to: Date(), options: [.matchFirst])
            return ((result?.second ?? 0)/60)
        }
        return 11
    }
    private func removeLastAccessCode() {
        if verificationTimeDefferenceResult() > 10 && (userDefaults.object(forKey: accessCodeKey) as? String) != nil {
            userDefaults.removeObject(forKey: accessCodeKey)
        }
    }
}