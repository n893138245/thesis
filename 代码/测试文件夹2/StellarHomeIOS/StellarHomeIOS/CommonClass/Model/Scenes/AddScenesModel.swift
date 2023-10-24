import UIKit
public class AddScenesModel: Convertible {
    var name:String?
    var isDefault:Bool?
    var backImageId: Int?
    var actions: [ExecutionModel]?
    var backImageUrl: String?
    required public init() {
    }
}