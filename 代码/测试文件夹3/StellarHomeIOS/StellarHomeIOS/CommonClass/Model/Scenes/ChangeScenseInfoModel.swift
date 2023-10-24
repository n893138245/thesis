import UIKit
public class ChangeScenseInfoModel: Convertible {
    var id:String?
    var name:String?
    var backImageId: Int?
    var actions: [ExecutionModel]?
    var backImageUrl: String?
    required public init() {
    }
}