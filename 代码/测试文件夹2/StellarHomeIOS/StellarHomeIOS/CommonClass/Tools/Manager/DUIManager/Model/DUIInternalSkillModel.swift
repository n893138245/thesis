import Foundation
import SwiftyJSON
class DUIInternalSkillModel {
	let engineType: Int
	let isFallback: Bool
	let img: String
	let skillId: String
	let isBuiltIn: Int
	let skillType: Int
	let skillName: String
	let version: String
    var detail: DUIInternalSkillDetailModel?
	init(json: JSON) {
		engineType = json["engineType"].intValue
		isFallback = json["isFallback"].boolValue
		img = json["img"].stringValue
		skillId = json["skillId"].stringValue
		isBuiltIn = json["isBuiltIn"].intValue
		skillType = json["skillType"].intValue
		skillName = json["skillName"].stringValue
		version = json["version"].stringValue
	}
}