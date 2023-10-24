import UIKit
class ScenesModel: Convertible {
    var id:String?
    var name:String?
    var backImageId:Int?
    var available:Bool?
    var isDefault:Bool?
    var actions: [ExecutionModel]?
    var backImageUrl: String?
    required init() {
    }
}