import Foundation
import SwiftyJSON
class DUIInternalSkillDetailModel {
	let skillDesc: String
	let skillId: Int
	let utterances: String
	let image: String
	let defaultLogo: Int
	let versionDesc: String
	let changeLog: String
	let version: Int
	let skillName: String
    var ordersArr: [String] {
        let jsonArr = JSON.init(parseJSON: self.utterances).arrayValue
        var result: [String] = []
        jsonArr.forEach { (json) in
            if let orderStr = json.string {
                if orderStr.count > 0{
                    result.append(orderStr)
                }
            }
        }
        if result.isEmpty == true{
            result = String.ss.getQuotationMarksString(str: self.skillDesc)
        }
        return result
    }
	init(json: JSON) {
		skillDesc = json["skillDesc"].stringValue
		skillId = json["skillId"].intValue
		utterances = json["utterances"].stringValue
		image = json["image"].stringValue
        defaultLogo = json["defaultLogo"].intValue
		versionDesc = json["versionDesc"].stringValue
		changeLog = json["changeLog"].stringValue
		version = json["version"].intValue
		skillName = json["skillName"].stringValue
	}
}