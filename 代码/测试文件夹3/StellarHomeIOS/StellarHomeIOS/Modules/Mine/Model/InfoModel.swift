import UIKit
enum UserAlertWays: String, ConvertibleEnum {
    case cellphone, email
}
class InfoModel: Convertible {
    @objc var userid:String = ""
    @objc var cellphone:String = ""
    @objc var subscribe:Bool = false
    @objc var nickname:String = ""
    @objc var avatar:String = ""
    @objc var email:String = ""
    var alertWays: [UserAlertWays] = []
    var thirdPartInfo = [ThirdPartInfoModel]()
    required init() {
    }
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        switch property.name {
        case "nickname":
            if (jsonValue as? String) == nil {
                return ""
            }
            return jsonValue
        default:
            return jsonValue
        }
    }
}