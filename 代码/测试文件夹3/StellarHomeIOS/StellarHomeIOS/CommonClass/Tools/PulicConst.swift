import Foundation
import UIKit
import SwiftRichString
let userDefaults = UserDefaults.standard
let kStatusBarH = UIApplication.shared.statusBarFrame.size.height 
let kNavigationBarH = UINavigationController.init().navigationBar.frame.height  
let kNavigationH = (kStatusBarH + kNavigationBarH)
let kScreenWidth = UIScreen.main.bounds.size.width                              
let kScreenHeight = UIScreen.main.bounds.size.height                             
let BOTTOM_HEIGHT:CGFloat = 49.0                                                       
let NAVVIEW_HEIGHT:CGFloat = 64.0                                                     
let NAVVIEW_HEIGHT_DISLODGE_SAFEAREA:CGFloat = 44.0                                  
let kBottomArcH = CGFloat(kStatusBarH > 20.1 ? 34 : 0)   
let ratio = (kScreenWidth < kScreenHeight ? kScreenWidth : kScreenHeight) / 375.0
var isIphoneX_serious: Bool {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return false
    }
    let size = UIScreen.main.bounds.size
    let notchValue: Int = Int(size.width/size.height * 100)
    if 216 == notchValue || 46 == notchValue {
        return true
    }
    return false
}
let STELLAR_COLOR_C1: UIColor = UIColor.init(hexString: "#3CB371")
let STELLAR_COLOR_C2: UIColor = UIColor.init(hexString: "#CD3232")
let STELLAR_COLOR_C3: UIColor = UIColor.init(hexString: "#ffffff")
let STELLAR_COLOR_C4: UIColor = UIColor.init(hexString: "#272A35")
let STELLAR_COLOR_C5: UIColor = UIColor.init(hexString: "#272A35")
let STELLAR_COLOR_C6: UIColor = UIColor.init(hexString: "#95949B")
let STELLAR_COLOR_C7: UIColor = UIColor.init(hexString: "#C5C9D1")
let STELLAR_COLOR_C8: UIColor = UIColor.init(hexString: "#F0F2F5")
let STELLAR_COLOR_C9: UIColor = UIColor.init(hexString: "#F3F4F9")
let STELLAR_COLOR_C10: UIColor = UIColor.init(hexString: "#50C48C")
let STELLAR_COLOR_C11: UIColor = UIColor.init(hexString: "#343434")
let STELLAR_FONT_T32: UIFont = UIFont.systemFont(ofSize: 32, weight: .regular)
let STELLAR_FONT_T30: UIFont = UIFont.systemFont(ofSize: 30, weight: .regular)
let STELLAR_FONT_T20: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular)
let STELLAR_FONT_T18: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
let STELLAR_FONT_T17: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
let STELLAR_FONT_T16: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
let STELLAR_FONT_T15: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
let STELLAR_FONT_T14: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
let STELLAR_FONT_T13: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)
let STELLAR_FONT_T12: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
let STELLAR_FONT_T11: UIFont = UIFont.systemFont(ofSize: 11, weight: .regular)
let STELLAR_FONT_BOLD_T52: UIFont = UIFont.systemFont(ofSize: 52, weight: .semibold)
let STELLAR_FONT_BOLD_T32: UIFont = UIFont.systemFont(ofSize: 32, weight: .semibold)
let STELLAR_FONT_BOLD_T30: UIFont = UIFont.systemFont(ofSize: 30, weight: .semibold)
let STELLAR_FONT_BOLD_T24: UIFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
let STELLAR_FONT_BOLD_T20: UIFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
let STELLAR_FONT_BOLD_T18: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
let STELLAR_FONT_BOLD_T17: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
let STELLAR_FONT_BOLD_T16: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
let STELLAR_FONT_BOLD_T15: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
let STELLAR_FONT_BOLD_T14: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
let STELLAR_FONT_BOLD_T13: UIFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
let STELLAR_FONT_BOLD_T12: UIFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
let STELLAR_FONT_BOLD_T11: UIFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
let STELLAR_FONT_MEDIUM_T32: UIFont = UIFont.systemFont(ofSize: 32, weight: .medium)
let STELLAR_FONT_MEDIUM_T30: UIFont = UIFont.systemFont(ofSize: 30, weight: .medium)
let STELLAR_FONT_MEDIUM_T20: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium)
let STELLAR_FONT_MEDIUM_T18: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)
let STELLAR_FONT_MEDIUM_T17: UIFont = UIFont.systemFont(ofSize: 17, weight: .medium)
let STELLAR_FONT_MEDIUM_T16: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
let STELLAR_FONT_MEDIUM_T15: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium)
let STELLAR_FONT_MEDIUM_T14: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
let STELLAR_FONT_MEDIUM_T13: UIFont = UIFont.systemFont(ofSize: 13, weight: .medium)
let STELLAR_FONT_MEDIUM_T12: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
let STELLAR_FONT_MEDIUM_T11: UIFont = UIFont.systemFont(ofSize: 11, weight: .medium)
let STELLAR_FONT_NUMBER_T32: UIFont = UIFont(name: "DINPro-Medium", size: 32)!
let STELLAR_FONT_NUMBER_T30: UIFont = UIFont(name: "DINPro-Medium", size: 30)!
let STELLAR_FONT_NUMBER_T26: UIFont = UIFont(name: "DINPro-Medium", size: 26)!
let STELLAR_FONT_NUMBER_T22: UIFont = UIFont(name: "DINPro-Medium", size: 22)!
let STELLAR_FONT_NUMBER_T20: UIFont = UIFont(name: "DINPro-Medium", size: 20)!
let STELLAR_FONT_NUMBER_T19: UIFont = UIFont(name: "DINPro-Medium", size: 19)!
let STELLAR_FONT_NUMBER_T18: UIFont = UIFont(name: "DINPro-Medium", size: 18)!
let STELLAR_FONT_NUMBER_T17: UIFont = UIFont(name: "DINPro-Medium", size: 17)!
let STELLAR_FONT_NUMBER_T16: UIFont = UIFont(name: "DINPro-Medium", size: 16)!
let STELLAR_FONT_NUMBER_T15: UIFont = UIFont(name: "DINPro-Medium", size: 15)!
let STELLAR_FONT_NUMBER_T14: UIFont = UIFont(name: "DINPro-Medium", size: 14)!
let STELLAR_FONT_NUMBER_T13: UIFont = UIFont(name: "DINPro-Medium", size: 13)!
let STELLAR_FONT_NUMBER_T12: UIFont = UIFont(name: "DINPro-Medium", size: 12)!
@available(iOS 11.0, *)
let safeAreaBottomHeight = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
@available(iOS 11.0, *)
let safeAreaTopHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top
let keyAppUser = "__AppUser_"
let keyDUIUser = "__DUIUser"
let keyAppCookie = "__AppCookie_"
struct Input {
    let textfieldInput: Observable<String>
}
struct Output {
    var textFieldValidateResult: Observable<ValidateResult>!
}
extension Notification.Name {
    static let Scenes_SetDeviceStatusComplete = Notification.Name(rawValue:"Scenes_SetDeviceStatusComplete")
    static let Smart_SetConditionsComplete = Notification.Name(rawValue:"Smart_SetConditionsComplete")
    static let NOTIFY_STATUS_UPDATED = NSNotification.Name.init(rawValue: "NOTIFY_STATUS_UPDATED")
    static let NOTIFY_UPGRADEPROGRESS = NSNotification.Name.init(rawValue: "NOTIFY_UPGRADEPROGRESS")
    static let NOTIFY_RADARLOCATIONINFO = NSNotification.Name.init(rawValue: "NOTIFY_RADARLOCATIONINFO")
    static let NOTIFY_DEVICE_SEARCHED = NSNotification.Name.init(rawValue: "NOTIFY_DEVICE_SEARCHED")
    static let NOTIFY_DEVICE_ADD_DEVICE_RESULT = NSNotification.Name.init(rawValue: "NOTIFY_DEVICE_ADD_DEVICES_RESULT")
    static let NOTIFY_DEVICE_HEARTBEAT_RESULT = NSNotification.Name.init(rawValue: "NOTIFY_DEVICE_HEARTBEAT_RESULT")
    static let NOTIFY_DEVICES_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_DEVICES_CHANGE")
    static let NOTIFY_DEVICES_UPDATE = NSNotification.Name.init(rawValue: "NOTIFY_DEVICES_UPDATE")
    static let NOTIFY_BRIGHTNESS_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_BRIGHTNESS_CHANGE")
    static let NOTIFY_CCT_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_CCT_CHANGE")
    static let NOTIFY_CURRENTMODE_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_CURRENTMODE_CHANGE")
    static let NOTIFY_USER_BRIGHTNESS_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_USER_BRIGHTNESS_CHANGE") 
    static let NOTIFY_USER_CCT_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_USER_CCT_CHANGE") 
    static let NOTIFY_SELECTDEVICES_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_SELECTDEVICES_CHANGE")
    static let NOTIFY_SELECTSCENES_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_SELECTSCENES_CHANGE")
    static let NOTIFY_SCENE_CHANGE = NSNotification.Name.init(rawValue: "NOTIFY_SCENE_CHANGE")
    static let NOTIFY_BLE_CUTDOWN_CLOSE = NSNotification.Name.init(rawValue: "NOTIFY_BLE_CUTDOWN_CLOSE") 
    static let NOTIFY_BLE_CUTDOWN_START = NSNotification.Name.init(rawValue: "NOTIFY_BLE_CUTDOWN_START") 
    static let NOTIFY_BLE_RECONNECTED = NSNotification.Name.init(rawValue: "NOTIFY_BLE_RECONNECTED") 
}
struct SS<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}
protocol SSCompatible {}
extension SSCompatible {
    static var ss: SS<Self>.Type {
        set {}
        get { SS<Self>.self }
    }
    var ss: SS<Self> {
        set {}
        get { SS(self) }
    }
}
protocol SizeFitProtocol {
}
extension Int: SizeFitProtocol {
}
extension CGFloat: SizeFitProtocol {
}
extension Double: SizeFitProtocol {
}
extension UInt: SizeFitProtocol {
}
extension Float: SizeFitProtocol {
}
extension SizeFitProtocol {
    var fit: CGFloat {
        let length: CGFloat
        if let element = self as? Int {
            length = CGFloat(element)
        }else if let element = self as? Double {
            length = CGFloat(element)
        }else if let element = self as? UInt {
            length = CGFloat(element)
        }else if let element = self as? Float {
            length = CGFloat(element)
        }else if let element = self as? CGFloat {
            length = CGFloat(element)
        }else{
            length = 0.0
        }
        return length*ratio
    }
}
#if DEVELOPMENT
let isDebug = true
#else
let isDebug = false
#endif
var isOpenDui = true
struct StellarHomeResourceUrl {
    static var sansi_io:String {
        return "https://blog.csdn.net/n893138245/article/details/132247451"
    }
    static var universal_link:String {
        return "https://stellarhelp.sansi.io/app/stellar_home/"
    }
    static var privacy_link: String{
        return StellarLocalizedString("MINE_USER_ABOUT_USER_PRIVACY_URL")
    }
    static var agreement_link: String{
        return StellarLocalizedString("MINE_USER_ABOUT_USER_AGREEMENT_URL")
    }
    static var mqtt_host:String {
        return isDebug ? "54.223.145.115" : "homemq.sansistellar.com"
    }
    static var wifi_device_reomte_url:String {
        return isDebug ? "54.223.145.115" : "homeiot.sansistellar.com"
    }
    static var wifi_device_reomte_port:UInt16{
        return 13385
    }
    static var ap_mode_ip:String {
        return "192.168.6.1"
    }
    static var baseurl_device:String {
        return isDebug ? "https://54.223.145.115:8001" : "https://homeiot.sansistellar.com:8001"
    }
    static var baseurl_device_port:UInt16 {
        return 8001
    }
    static var baseurl_device_url:String {
        return isDebug ? "https://54.223.145.115" : "https://homeiot.sansistellar.com"
    }
    static var baseurl_user:String {
        return isDebug ? "https://54.223.145.115:7002" : "https://homeiot.sansistellar.com:9001"
    }
    static var baseulr_source:String {
        return isDebug
            ? "https://stellar-home-source-development.s3.cn-north-1.amazonaws.com.cn"
            : "https://stellar-home-source.s3.cn-north-1.amazonaws.com.cn"
    }
    static var caPath:String {
        return isDebug ? Bundle.main.path(forResource: "server", ofType: "cer")! : Bundle.main.path(forResource: "server_release", ofType: "cer")!
    }
    static var clientPath:String {
        return isDebug ? Bundle.main.path(forResource: "client", ofType: "p12")! : Bundle.main.path(forResource: "client_release", ofType: "p12")!
    }
    static var mqttCerPath:String {
        return isDebug ? Bundle.main.path(forResource: "mqtt_server", ofType: "cer")! : Bundle.main.path(forResource: "mqtt_server_release", ofType: "cer")!
    }
    static var mqttCerName:String {
        return isDebug ? "mqtt_client" : "mqtt_client_release"
    }
    static var mqttUserName:String {
        return isDebug ? "test" : "phone"
    }
    static var mqttUserPassword:String {
        return isDebug ? "sansi1280" : "25af40e3-8565-425d-a086-dc9d3b7002b8"
    }
}
struct DCAConfig {
    static let apikey: String = isDebug
        ? "90e5feeb55f24d45a4822a9f71693e39"
        : "010f9276253d46e690042c321e559fe0"
    static let apiSecret: String = isDebug
        ? "acee5f46e0cd402f8649637a07622ae7"
        : "e7c653a243be4d5f82799b2b9a3e6eae"
    static let clinetId: String = isDebug
        ? "260f5571307a48b8977f5942aca97bc3"
        : "7d7967e38cf3443c8d0dd87db3f2a4a0"
    static let manufacture: String = isDebug
        ? "SansiTest"
        : "Sansi"
    static let redirectUrl: String = "http://dui.callback"
    static let manufactureSecret: String = isDebug
        ? "bBscXx9r5Ih8BwP+s3tnCeJ3spVa/oTnMR1yQRJ7gFq88Ky4vF/OmFQDF056yNXmwYN7Gk1PeTYCRmuwz3fAjliCm8slM/a++6taHHjB62KUVc3J8qdM70eKWJ+9E+KGM1jFeK51zmLlM0TdxA3xbFKuAxTbUv/4oEq4bYJi1+Y="
        : "pjo4iCpCNW2AZP0FZd5a57ZWgfNyhIj8qpjn+fJzMG4KwWKOxbMPpkhlgyolVmolucasLX09qrZv5MdOmTsEZhuXRdHc9klioLhvkiU087INV/VPu6TTsZpoJQoVV+AaaP8MviaedtoObJNYNtdeID9AinT6TayvoaLehOFtwso="
    static let productId: String = isDebug
        ? "278589595"
        : "279593889"
    static let sansiSmartHomeSkillId: String = isDebug
        ? "2019052200000284"
        : "2020041300000091"
    static let sansiRoomControlSkillId: String = isDebug
        ? "2019101700000224"
        : "2020041600000148"
    static let sansiSmartHomeSkillVersion: String = isDebug
        ? "6"
        : "1"
}
struct TemperatureResource {
    static let titleImageList = [(title:"休闲模式",image_n:"icon_temperature_6_w",image_s:"icon_temperature_6_s",value:2700),
                                 (title:"阅读模式",image_n:"icon_temperature_7_w",image_s:"icon_temperature_7_s",value:3500),
                                 (title:"书写模式",image_n:"icon_temperature_5_w",image_s:"icon_temperature_5_s",value:4000),
                                 (title:"读写模式",image_n:"icon_temperature_5_w",image_s:"icon_temperature_5_s",value:4000),
                                 (title:"休闲",image_n:"icon_temperature_6_w",image_s:"icon_temperature_6_s",value:2700),
                                 (title:"阅读",image_n:"icon_temperature_7_w",image_s:"icon_temperature_7_s",value:3500),
                                 (title:"书写",image_n:"icon_temperature_5_w",image_s:"icon_temperature_5_s",value:4000),
                                 (title:"工作",image_n:"icon_temperature_1_w",image_s:"icon_temperature_1_s",value:5000),
                                 (title:"睡眠",image_n:"icon_temperature_2_w",image_s:"icon_temperature_2_s",value:3000),
                                 (title:"吃饭",image_n:"icon_temperature_3_w",image_s:"icon_temperature_3_s",value:3500),
                                 (title:"娱乐",image_n:"icon_temperature_4_w",image_s:"icon_temperature_4_s",value:6000)]
    static let gropCCTList = [(cct: 3000, bgColor: "#FFB969"),
                              (cct: 3500, bgColor: "#FFC987"),
                              (cct: 5000, bgColor: "#FFE7CC"),
                              (cct: 6000, bgColor: "#FFF4ED")]
    static func getColorWithCCT(cct: Int) -> UIColor {
        let num = (Double(cct)/100).rounded() 
        let roundedCCT = Int(num) * 100
        guard let model = allCCTValuesList.first(where: {$0.cct == roundedCCT}) else {
            return UIColor(hexString: "#FFAE53")
        }
        return UIColor(hex: model.bgColor)
    }
    static let allCCTValuesList = [(cct: 2700, bgColor: "#FFAE53"),
                                   (cct: 2800, bgColor: "#FFB25B"),
                                   (cct: 2900, bgColor: "#FFB662"),
                                   (cct: 3000, bgColor: "#FFB969"),
                                   (cct: 3100, bgColor: "#FFBD6F"),
                                   (cct: 3200, bgColor: "#FFC076"),
                                   (cct: 3300, bgColor: "#FFC37B"),
                                   (cct: 3400, bgColor: "#FFC682"),
                                   (cct: 3500, bgColor: "#FFC987"),
                                   (cct: 3600, bgColor: "#FFCB8E"),
                                   (cct: 3700, bgColor: "#FFCE92"),
                                   (cct: 3800, bgColor: "#FFD097"),
                                   (cct: 3900, bgColor: "#FED39C"),
                                   (cct: 4000, bgColor: "#FFD5A1"),
                                   (cct: 4100, bgColor: "#FFD7A6"),
                                   (cct: 4200, bgColor: "#FFD9AB"),
                                   (cct: 4300, bgColor: "#FFDBAE"),
                                   (cct: 4400, bgColor: "#FFDEB4"),
                                   (cct: 4500, bgColor: "#FFDFB8"),
                                   (cct: 4600, bgColor: "#FFE1BC"),
                                   (cct: 4700, bgColor: "#FFE2C0"),
                                   (cct: 4800, bgColor: "#FFE4C4"),
                                   (cct: 4900, bgColor: "#FFE5C8"),
                                   (cct: 5000, bgColor: "#FFE7CC"),
                                   (cct: 5100, bgColor: "#FFE8D0"),
                                   (cct: 5200, bgColor: "#FFEAD3"),
                                   (cct: 5300, bgColor: "#FFEBD7"),
                                   (cct: 5400, bgColor: "#FFEDDA"),
                                   (cct: 5500, bgColor: "#FFEEDE"),
                                   (cct: 5600, bgColor: "#FFEFE1"),
                                   (cct: 5700, bgColor: "#FFF0E4"),
                                   (cct: 5800, bgColor: "#FFF1E7"),
                                   (cct: 5900, bgColor: "#FFF3EA"),
                                   (cct: 6000, bgColor: "#FFF4ED"),
                                   (cct: 6100, bgColor: "#FFF5F2"),
                                   (cct: 6200, bgColor: "#FFF6F3"),
                                   (cct: 6300, bgColor: "#FFF7F5"),
                                   (cct: 6400, bgColor: "#FFF7F8"),
                                   (cct: 6500, bgColor: "#FFF9FB")]
}
