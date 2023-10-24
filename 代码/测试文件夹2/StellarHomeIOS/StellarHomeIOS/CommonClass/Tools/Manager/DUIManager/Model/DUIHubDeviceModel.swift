import UIKit
class DUIHubDeviceModel {
    var deviceAlias: String = ""
    var deviceName: String = ""
    var deviceType: String = ""
    var deviceInfo: DUIHubDeviceInfo = DUIHubDeviceInfo()
    init() {
    }
    init(json: JSON) {
        update(json: json)
    }
    init(dictionary: [String: Any]) {
        update(dictionary: dictionary)
    }
    func update(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        update(json: json)
    }
    func update(json: JSON) {
        if let temp = json["deviceAlias"].string{
            deviceAlias = temp
        }
        if let temp = json["deviceName"].string{
            deviceName = temp
        }
        if let temp = json["deviceType"].string{
            deviceType = temp
        }
        if let temp = json["deviceInfo"].dictionary{
            deviceInfo.update(dictionary: temp)
        }
    }
    func toJson() -> JSON {
        var json: JSON = [:]
        json["deviceAlias"] = JSON.init(rawValue: deviceAlias) ?? ""
        json["deviceName"] = JSON.init(rawValue: deviceName) ?? ""
        json["deviceType"] = JSON.init(rawValue: deviceType) ?? ""
        json["deviceInfo"] = deviceInfo.toJson()
        return json
    }
}
class DUIHubDeviceInfo {
    var platform: String = ""
    var productId: String = ""
    init() {
    }
    init(json: JSON) {
        update(json: json)
    }
    init(dictionary: [String: Any]) {
        update(dictionary: dictionary)
    }
    func update(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        update(json: json)
    }
    func update(json: JSON) {
        if let temp = json["platform"].string{
            platform = temp
        }
        if let temp = json["productId"].string{
            productId = temp
        }
    }
    func toJson() -> JSON {
        var json: JSON = [:]
        json["platform"] = JSON.init(rawValue: platform) ?? ""
        json["productId"] = JSON.init(rawValue: productId) ?? ""
        return json
    }
}