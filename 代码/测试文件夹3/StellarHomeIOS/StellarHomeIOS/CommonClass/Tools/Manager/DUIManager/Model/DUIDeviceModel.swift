import UIKit
class DUIIotAppliance {
    var actions: [String] = []
    var additionalApplianceDetails: [String: Any] = [:]
    var alias: String = ""
    var applianceId: String = ""
    var applianceType: String = ""
    var discription: String = ""
    var friendlyName: String = ""
    var manufacturerName: String = ""
    var modelName: String = ""
    var skillId: String = ""
    var position: String = ""
    init(json: JSON) {
        update(json: json)
    }
    func update(json: JSON)  {
        if let temp = json["actions"].array{
            actions = temp.map{$0.stringValue};
        }
        if let temp = json["alias"].string{
            alias = temp
        }
        if let temp = json["applianceId"].string{
            applianceId = temp
        }
        if let temp = json["applianceType"].string{
            applianceType = temp
        }
        if let temp = json["discription"].string{
            discription = temp
        }
        if let temp = json["friendlyName"].string{
            friendlyName = temp
        }
        if let temp = json["manufacturerName"].string{
            manufacturerName = temp
        }
        if let temp = json["modelName"].string{
            modelName = temp
        }
        if let temp = json["skillId"].string{
            skillId = temp
        }
        if let temp = json["position"].string{
            position = temp
        }
        if let temp = json["additionalApplianceDetails"].dictionary{
            additionalApplianceDetails = temp
        }
    }
}