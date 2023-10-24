import UIKit
class IntelligentDetailModel: Convertible {
    var id: String = ""
    var name:String = ""
    var backImageId:Int = -1
    var enable:Bool = false
    var available:Bool = false
    var conditionsRelation:String = ""
    var enableTime:String = ""
    var condition:[IntelligentDetailModelCondition] = []
    var actions:[ExecutionModel] = [ExecutionModel]()
    required init() {}
    class func getDayStringWithWeekDays(week: [Int]?) -> String {
        var theDays = StellarLocalizedString("SMART_ONLY_ONECE")
        if let weeks = week {
            if weeks.elementsEqual([0,1,2,3,4,5,6]) {
                theDays = StellarLocalizedString("SMART_EVERY_DAY")
            }else if weeks.elementsEqual([1,2,3,4,5]) {
                theDays = StellarLocalizedString("SMART_WORKING_DAY")
            }else if weeks.count > 0 {
                theDays = ""
                var copyWeeks = [Int]()
                weeks.forEach { (day) in
                    copyWeeks.append(day)
                }
                if copyWeeks.contains(0) {
                    copyWeeks.removeAll(where: {$0 == 0})
                    copyWeeks.insert(0, at: copyWeeks.count) 
                }
                for day in copyWeeks {
                    switch day {
                    case 0:
                        theDays += " \(StellarLocalizedString("SMART_SUNDAY"))"
                    case 1:
                        theDays += " \(StellarLocalizedString("SMART_MONDAY"))"
                    case 2:
                        theDays += " \(StellarLocalizedString("SMART_TUESDAY"))"
                    case 3:
                        theDays += " \(StellarLocalizedString("SMART_WEDNESDAY"))"
                    case 4:
                        theDays += " \(StellarLocalizedString("SMART_THURSDAY"))"
                    case 5:
                        theDays += " \(StellarLocalizedString("SMART_FRIDAY"))"
                    case 6:
                        theDays += " \(StellarLocalizedString("SMART_SATURDAY"))"
                    default:
                        break
                    }
                }
                if theDays.contains(" ") {
                    theDays.removeFirst()
                }
            }
        }
        return theDays
    }
}
class IntelligentDetailModelCondition: Convertible, Equatable {
    static func == (lhs: IntelligentDetailModelCondition, rhs: IntelligentDetailModelCondition) -> Bool {
        return lhs.type == rhs.type && lhs.params == rhs.params
    }
    var type: IntelligentDetailModelConditionType = .other
    var params:IntelligentDetailModelConditionParams = IntelligentDetailModelConditionParams()
    required init() {}
    enum IntelligentDetailModelConditionType: String, ConvertibleEnum {
        case countdown,timing,sensor,other
    }
}
class IntelligentDetailModelConditionParams: Convertible, Equatable {
    static func == (lhs: IntelligentDetailModelConditionParams, rhs: IntelligentDetailModelConditionParams) -> Bool {
        return lhs.countdownTime == rhs.countdownTime &&
            lhs.weekdays == rhs.weekdays &&
            lhs.time == rhs.time &&
            lhs.sn == rhs.sn &&
            lhs.senserType == rhs.senserType &&
            lhs.reloation == rhs.reloation &&
            lhs.value == rhs.value
    }
    var countdownTime: Int = 0
    var weekdays: [Int]?
    var time: String = ""
    var sn: String = ""
    var senserType: String = ""
    var reloation: String = ""
    var value: String = ""
    required init() {}
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name == "time",let utcTimeString = jsonValue as? String,utcTimeString.contains("Z") {
            return String.ss.localTimeWithUTCString(UTCtimeString: utcTimeString)
        }
        return jsonValue
    }
}