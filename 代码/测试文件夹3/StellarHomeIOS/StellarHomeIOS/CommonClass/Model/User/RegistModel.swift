import UIKit
public class RegistModel: Convertible {
    var email:String?
    var cellphone:String?
    var smscode:String?
    var password:String?
    var thirdPartInfo: [ThirdPartInfoModel]?
    required public init() {
    }
}