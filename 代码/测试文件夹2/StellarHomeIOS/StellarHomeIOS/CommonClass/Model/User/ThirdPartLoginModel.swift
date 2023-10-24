import UIKit
public class ThirdPartLoginModel: Convertible {
    var thirdPartId:String?
    var thirdPartType:ThirdPartType?
    var data:ThirdPartLoginModelData = ThirdPartLoginModelData()
    required public init() {
    }
}
public class ThirdPartInfoModel: Convertible {
    var thirdPartId:String?
    var nickname:String?
    var headerImage:String?
    var cellphone:String?
    var email:String?
    var accessToken:String?
    var refreshToken:String?
    var expireIn:Int?
    var thirdPartType:ThirdPartType = .unknown
    var data = ThirdPartLoginModelData()
    public func kj_JSONValue(from modelValue: Any?, _ property: Property) -> Any? {
        if (modelValue as? String) == "" {
            return nil
        }
        return modelValue
    }
    required public init() {
    }
}
public class ThirdPartLoginModelData: Convertible {
    var authorizationCode:String?
    var identityToken:String?
    required public init() {
    }
}