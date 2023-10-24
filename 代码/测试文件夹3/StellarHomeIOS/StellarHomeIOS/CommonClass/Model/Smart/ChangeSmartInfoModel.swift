import UIKit
public class ChangeSmartInfoModel: Convertible {
    var id:String?
    var name:String?
    var backImageId:Int?
    var conditionsRelation = "and"
    var condition:[IntelligentDetailModelCondition]?
    var actions:[ExecutionModel]?
    required public init() {
    }
}