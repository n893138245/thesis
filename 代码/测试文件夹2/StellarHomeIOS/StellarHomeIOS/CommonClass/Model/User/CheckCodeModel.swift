import UIKit
public class CheckCodeModel: Convertible {
    var cellphone:String?
    var email:String?
    var smscode:String?
    var password:String?
    var codeUsage:CodeUsage = .login
    required public init() {
    }
}