import UIKit
class DUISmartHomeSkillModel {
    var authAddr: String = ""
    var callbackAddr: String = ""
    var clientId: String = ""
    var clientSecret: String = ""
    var createTime: String = ""
    var deviceGatewayAddr: String = ""
    var deviceMonitorAddr: String = ""
    var engineType: Int = 0
    var homeKitProtocol: Int = 0
    var httpMethod: String = ""
    var img: String = ""
    var isBuiltIn: Int = 0
    var isFallback: Int = 0
    var proxyUrl: String = ""
    var ready: Int = 0
    var scope: String = ""
    var skillId: String = ""
    var skillName: String = ""
    var skillType: Int = 0
    var skillVersion: Int = 0
    var tokenAddr: String = ""
    init(json: JSON) {
        authAddr = json["authAddr"].stringValue;
        callbackAddr = json["callbackAddr"].stringValue;
        clientId = json["clientId"].stringValue;
        clientSecret = json["clientSecret"].stringValue;
        createTime = json["createTime"].stringValue;
        deviceGatewayAddr = json["deviceGatewayAddr"].stringValue;
        deviceMonitorAddr = json["deviceMonitorAddr"].stringValue;
        engineType = json["engineType"].intValue;
        homeKitProtocol = json["homeKitProtocol"].intValue;
        img = json["img"].stringValue;
        isBuiltIn = json["isBuiltIn"].intValue;
        isFallback = json["isFallback"].intValue;
        proxyUrl = json["proxyUrl"].stringValue;
        ready = json["ready"].intValue;
        scope = json["scope"].stringValue;
        skillId = json["skillId"].stringValue;
        skillName = json["skillName"].stringValue;
        skillType = json["skillType"].intValue;
        skillVersion = json["skillVersion"].intValue;
        tokenAddr = json["tokenAddr"].stringValue;
    }
}