import UIKit
public class AddIntelligentsModel: Convertible {
    var name:String?
    var backImageId:Int?
    var conditionsRelation = "and"
    var condition:[IntelligentDetailModelCondition]?
    var actions:[ExecutionModel]?
    required public init() {
    }
}