import UIKit
class ThirdPartLoginManager: NSObject {
    public class func loginWithFaceBook(success: ((SSDKUser)->Void)?, failue: ((ErrorCode)->Void)?){
        ShareSDK.authorize(.typeFacebook, settings: nil) { (state, user, error) in
            guard let tempUser = user else{
                failue?(.thirdPartAuthorizeError);
                return
            }
            switch state {
            case .success:
                print(tempUser.credential.rawData ?? [:])
                print(tempUser.rawData ?? "")
                success?(tempUser)
            case .fail:
                print(error ?? "")
                failue?(.thirdPartAuthorizeError)
            default:
                break
            }
        }
    }
    public class func loginWithWeChat(success: ((SSDKUser)->Void)?, failue: ((ErrorCode)->Void)?) {
        if !WXApi.isWXAppInstalled() {
            TOAST(message: "您没有安装微信客户端")
            return
        }
        ShareSDK.authorize(.typeWechat, settings: nil) { (state, user, error) in
            guard let tempUser = user else{
                failue?(.thirdPartAuthorizeError);
                return
            }
            switch state {
            case .success:
                print(tempUser.credential.rawData ?? [:])
                print(tempUser.rawData ?? "")
                success?(tempUser)
            case .fail:
                print(error ?? "")
                failue?(.thirdPartAuthorizeError)
            default:
                break
            }
        }
    }
}