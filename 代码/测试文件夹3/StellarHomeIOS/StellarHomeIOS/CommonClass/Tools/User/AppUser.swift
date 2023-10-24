import UIKit
class AppUser: NSObject {
    var mySceneModelArr = [ScenesModel]()
    var myIntelligentsModelArr = [IntelligentDetailModel]()
    var headImage:UIImage?
    var userInfo:InfoModel = InfoModel(){
        didSet{
            if !userInfo.userid.isEmpty {
                mDic.updateValue(userInfo.userid, forKey: keyAppUser + #keyPath(InfoModel.userid))
            }
            if !userInfo.cellphone.isEmpty {
                mDic.updateValue(userInfo.cellphone, forKey: keyAppUser + #keyPath(InfoModel.cellphone))
            }
            if !userInfo.nickname.isEmpty {
                mDic.updateValue(userInfo.nickname, forKey: keyAppUser + #keyPath(InfoModel.nickname))
            }
            if !userInfo.avatar.isEmpty {
                mDic.updateValue(userInfo.avatar, forKey: keyAppUser + #keyPath(InfoModel.avatar))
            }
            if !userInfo.email.isEmpty {
               mDic.updateValue(userInfo.email, forKey: keyAppUser + #keyPath(InfoModel.email))
            }
            mDic.updateValue(String.init(describing: userInfo.subscribe), forKey: keyAppUser + #keyPath(InfoModel.subscribe))
            isDirty = true
        }
    }
    @objc var hasLogined:Bool = false{
        didSet{
            mDic.updateValue(hasLogined, forKey: keyAppUser + #keyPath(hasLogined))
            isDirty = true
        }
    }
    var token:TokenModel = TokenModel(){
        didSet{
            if !token.accessToken.isEmpty {
                mDic.updateValue(token.accessToken, forKey: keyAppUser + #keyPath(TokenModel.accessToken))
                isDirty = true
            }
            if !token.refreshToken.isEmpty {
                mDic.updateValue(token.refreshToken, forKey: keyAppUser + #keyPath(TokenModel.refreshToken))
                isDirty = true
            }
            if !token.id.isEmpty {
                mDic.updateValue(token.id, forKey: keyAppUser + #keyPath(TokenModel.id))
                isDirty = true
            }
        }
    }
     @objc var accessTokenExpire:String = ""{
        didSet{
            mDic.updateValue(accessTokenExpire, forKey: keyAppUser + #keyPath(accessTokenExpire))
            isDirty = true
        }
    }
     @objc var refreshTokenExpire:String = ""{
        didSet{
            mDic.updateValue(refreshTokenExpire, forKey: keyAppUser + #keyPath(refreshTokenExpire))
            isDirty = true
        }
    }
    @objc var accessTokenSaveTime:String = ""{
        didSet{
            mDic.updateValue(accessTokenSaveTime, forKey: keyAppUser + #keyPath(accessTokenSaveTime))
            isDirty = true
        }
    }
    @objc var refreshTokenSaveTime:String = ""{
        didSet{
            mDic.updateValue(refreshTokenSaveTime, forKey: keyAppUser + #keyPath(refreshTokenSaveTime))
            isDirty = true
        }
    }
    var isDirty:Bool = false
    var mDic:[String:Any] = [:]
    func loadUserWithIdentifer(identifier:String){
        if identifier.isEmpty {
            userInfo = InfoModel()
            mySceneModelArr.removeAll()
            myIntelligentsModelArr.removeAll()
            headImage = nil
            return
        }
        if userInfo.userid == identifier{
            return
        }
        guard let dic = userDefaults.value(forKey:keyAppUser + identifier) as? [String:Any] else {
            return
        }
        if dic.count > 0 {
            mDic = dic
            userInfo.userid = mDic[keyAppUser + #keyPath(InfoModel.userid)] as? String ?? ""
            userInfo.cellphone = mDic[keyAppUser + #keyPath(InfoModel.cellphone)] as? String ?? ""
            userInfo.nickname = mDic[keyAppUser + #keyPath(InfoModel.nickname)] as? String ?? ""
            userInfo.avatar = mDic[keyAppUser + #keyPath(InfoModel.avatar)] as? String ?? ""
            if let mDicHasLogined = mDic[keyAppUser + #keyPath(hasLogined)] as? Bool{
                hasLogined = mDicHasLogined
            }else{
                hasLogined = false
            }
            if let mDicSubscribe = mDic[keyAppUser + #keyPath(InfoModel.subscribe)] as? Bool {
                userInfo.subscribe = mDicSubscribe
            }else{
                userInfo.subscribe = false
            }
            token.id = mDic[keyAppUser + #keyPath(TokenModel.id)] as? String ?? ""
            token.accessToken = mDic[keyAppUser + #keyPath(TokenModel.accessToken)] as? String ?? ""
            token.refreshToken = mDic[keyAppUser + #keyPath(TokenModel.refreshToken)] as? String ?? ""
            accessTokenExpire = mDic[keyAppUser + #keyPath(accessTokenExpire)] as? String ?? ""
            refreshTokenExpire = mDic[keyAppUser + #keyPath(refreshTokenExpire)] as? String ?? ""
            accessTokenSaveTime = mDic[keyAppUser + #keyPath(accessTokenSaveTime)] as? String ?? ""
            refreshTokenSaveTime = mDic[keyAppUser + #keyPath(refreshTokenSaveTime)] as? String ?? ""
        }
    }
    func savePhoto(data: Data) {
        userDefaults.setValue(data, forKey: keyAppUser + StellarAppManager.sharedManager.user.userInfo.userid + "headImage")
    }
    func getPhoto() ->UIImage? {
        if let data = userDefaults.value(forKey: keyAppUser + StellarAppManager.sharedManager.user.userInfo.userid + "headImage") as? Data {
            if let image = UIImage.init(data: data) {
                headImage = image
                return image
            }
        }
        return nil
    }
    func save(){
        if isDirty{
            userDefaults.setValue(mDic, forKey: keyAppUser + StellarAppManager.sharedManager.user.userInfo.userid)
            userDefaults.synchronize()
            isDirty = false
        }
    }
}