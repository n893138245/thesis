import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import MBProgressHUD
func fitLength() -> CGFloat{
    return (kScreenWidth < kScreenHeight ? kScreenWidth : kScreenHeight) / 375.0
}
func getAllVersionSafeAreaTopHeight() -> CGFloat {
    return kNavigationH - kNavigationBarH
}
func getAllVersionSafeAreaBottomHeight() -> CGFloat {
    if #available(iOS 11.0, *){
        if let safeHeight = safeAreaBottomHeight {
            return safeHeight
        }
        return 0
    }
    return 0
}
func StellarLocalizedString(_ str: String) -> String {
    return NSLocalizedString(str, comment: str)
}
func getWifiInfo() -> (ssid: String?, mac: String?) {
    if let cfas: NSArray = CNCopySupportedInterfaces() {
        for cfa in cfas {
            if let dict = CFBridgingRetain(
                CNCopyCurrentNetworkInfo(cfa as! CFString)
                ) {
                if let ssid = dict["SSID"] as? String,
                    let bssid = dict["BSSID"] as? String {
                    return (ssid, bssid)
                }
            }
        }
    }
    return (nil, nil)
}
public func getKeyboardWindow() -> UIWindow {
    return UIApplication.shared.keyWindow!
}
func CURRENT_ROOT_VC() -> UIViewController {
    return getKeyboardWindow().rootViewController!
}
func CURRENT_TOP_VC() -> UIViewController {
    return getTopVc(rootVc: CURRENT_ROOT_VC())
}
private func getTopVc(rootVc: UIViewController) -> UIViewController {
    if rootVc.presentedViewController != nil {
        return getTopVc(rootVc: rootVc.presentedViewController!)
    }else if rootVc.isKind(of: UITabBarController.self) {
        return getTopVc(rootVc: (rootVc as! UITabBarController).selectedViewController!)
    }else if rootVc.isKind(of: UINavigationController.self) {
        return getTopVc(rootVc: (rootVc as! UINavigationController).visibleViewController!)
    }
    return rootVc
}
func randomCustom(min: CGFloat, max: CGFloat) -> CGFloat {
    let y = arc4random() % UInt32(max) + UInt32(min)
    return CGFloat(y)
}
func TOAST(message: String,completeBlock:(() ->Void)? = nil) {
    StellarHintHud.toast(message: message, contentType: .center, completeBlock: completeBlock)
}
func TOAST_BOTTOM(message: String) {
    StellarHintHud.toast(message: message, contentType: .bottom, completeBlock: nil)
}
func TOAST_SUCCESS(message: String, completeBlock:(() ->Void)? = nil) {
    MBProgressHUD.showStellarHudSuccessfulWith(message, successBlock: completeBlock)
}
func WiFi_KEY() -> String {
    return StellarAppManager.sharedManager.user.userInfo.userid+"WiFi_KEY"
}
func getFormatRestTime(secounds :TimeInterval) -> String{
    if secounds.isNaN {
        return "00:00"
    }
    var Min = Int(secounds / 60)
    let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
    var Hour = 0
    if Min>=60 {
        Hour = Int(Min / 60)
        Min = Min - Hour*60
        return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
    }
    return String(format: "%02d:%02d", Min, Sec)
}
func jumpTo(url: String){
    guard url != "" else {
        return
    }
    if let url:URL = URL.init(string: url) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            if url.absoluteString.hasPrefix("sinaweibo") {
                TOAST(message: "未安装新浪微博App")
            }
        }
    }
}
func checkName(deviceName:String, existDevices:[String]) -> String{
    var index = 0
    while true {
        var checkName = deviceName
        if index > 0 {
            let chineseNum = index.ss.chineseString
            checkName = deviceName + "\(chineseNum)"
        }
        var hasSameName = false
        for hasDeviceName in existDevices {
            if hasDeviceName ==  checkName{
                hasSameName = true
                break
            }
        }
        if !hasSameName{
            return checkName
        }
        index += 1
    }
}
func isChinese() -> Bool {
    let defs = userDefaults
    let languages: [String] = defs.object(forKey: "AppleLanguages") as! [String]
    let preferredLanguage = languages.first!
    let result = preferredLanguage.contains("zh")
    return result
}
func getDeviceNormalIconBy(fwType:Int) -> String{
    return "\(StellarHomeResourceUrl.baseulr_source)/devices_json/\(fwType)/imgs/normal.png"
}
func getDeviceLargeIconBy(fwType:Int) -> String{
    return "\(StellarHomeResourceUrl.baseulr_source)/devices_json/\(fwType)/imgs/large.png"
}
func getRoomIcon(roomId: Int) -> String {
    return "\(StellarHomeResourceUrl.baseulr_source)/group_list/\(roomId)/imgs/normal.png"
}
func getScenesBgImage(path: String) -> String {
    return "\(StellarHomeResourceUrl.baseulr_source)/scenes\(path)"
}
func getDeviceConnectionType(_ connectionType:ConnectionType) -> String{
    switch connectionType {
    case .mesh:
        return "配合网关"
    case .zigbee:
        return "zigbee"
    case .softAP:
        return "WiFi直连"
    case .smartConfig:
        return "WiFi直连"
    case .dui:
        return ""
    case .ble:
        return "蓝牙"
    case .unknown:
        return "未知"
    }
}
func getFrontWindow() -> UIWindow? {
    let frontToBackWindows = UIApplication.shared.windows.reversed()
    for window in frontToBackWindows {
        let windowOnMainScreen = window.screen == UIScreen.main
        let windowIsVisible = !window.isHidden && window.alpha > 0
        let windowLevelSupported = (window.windowLevel >= .normal && window.windowLevel <= .normal)
        let windowKeyWindow = window.isKeyWindow
        if windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow {
            return window
        }
    }
    return nil
}
func isContainWeChat() -> Bool{
    if UIApplication.shared.canOpenURL(URL.init(fileURLWithPath: "weixin:
        return true
    }else{
        return false
    }
}
func getCurrentTime() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyy-MM-dd' 'HH:mm:ss"
    let timeString = formatter.string(from: date)
    return timeString
}