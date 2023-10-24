import UIKit
class TokenModel: Convertible {
    @objc var accessToken:String = ""
    @objc var refreshToken:String = ""
    @objc var id:String = ""
    required init() {
    }
}