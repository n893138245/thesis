struct StellarUserStore {
    static let sharedStore = StellarUserStore.init()
    func login(loginRequestModel: LoginRequestModel, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.login(loginRequestModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else if code == 10010{
                failure?("密码错误")
            }else{
                failure?("登录失败")
            }
        }) { moyaError,error  in
            failure?("登录失败")
        }
    }
    func getDCAToken(success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getDcaToken,success: { (json) in
            success?(json.dictionaryObject ?? [String : Any]())
        }) { moyaError,error  in
            failure?("获取失败")
        }
    }
    func thirdLogin(loginRequestModel: ThirdPartLoginModel, success:((JSONDictionary)->Void)?, failure:((ErrorCode,String)->Void)?) {
        Network.request(.thirdLogin(loginRequestModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else if code == ErrorCode.thirdUserNotExist.rawValue{
                failure?(.thirdUserNotExist,json["message"].string ?? "")
            }else{
                failure?(ErrorCode.unknownError,"")
            }
        }) { moyaError,error  in
            failure?(ErrorCode.unknownError,error)
        }
    }
    func sendCode(sendCodeModel: SendCodeModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.sendCode(sendCodeModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else if code == 10003{
                failure?("短信验证码错误")
            }else if code == 10005{
                failure?(ErrorMessage.smsSendError.rawValue)
            }else if code == 10008{
                failure?("请求过于频繁")
            }else{
                failure?("验证码发送失败，请重试")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func checkCode(checkCodeModel: CheckCodeModel, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.checkCode(checkCodeModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else if code == 10008{
                failure?("请求过于频繁")
            }else{
                failure?("验证码校验失败，请重试")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func changePhone(phone: String,accessCode:String, success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
       Network.request(.changePhone(phone, accessCode),success: { (json) in
           let code = json["code"].intValue
           if code == 0 {
               let jSONDictionary = json.dictionaryObject ?? [String : Any]()
               success?(jSONDictionary)
           }else{
               failure?("")
           }
       }) { moyaError,error  in
           failure?(error)
       }
    }
    func destroyAccount(accessCode: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.destroyAccount(accessCode),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func checkIdentify(loginRequestModel: LoginRequestModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.checkIdentify(loginRequestModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func chageEmail(email: String,accessCode: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.chageEmail(email, accessCode),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func changePassword(newPassword: String,accessCode: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.changePassword(newPassword, accessCode),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getUserInfo(success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getUserInfo,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func modificationUserInfo(subscribe: Bool,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modificationUserInfoSubscribe(subscribe: subscribe),success: { (json) in
           let code = json["code"].intValue
           if code == 0 {
               let jSONDictionary = json.dictionaryObject ?? [String : Any]()
               success?(jSONDictionary)
           }else{
               failure?("")
           }
       }) { moyaError,error  in
           failure?(error)
       }
    }
    func modificationUserInfo(nickname: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modificationUserInfoNickname(nickname: nickname),success: { (json) in
           let code = json["code"].intValue
           if code == 0 {
               let jSONDictionary = json.dictionaryObject ?? [String : Any]()
               success?(jSONDictionary)
           }else{
               failure?("")
           }
       }) { moyaError,error  in
           failure?(error)
       }
    }
    func modificationUserInfo(alertWays: [String],success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modificationUserInfoAlertWays(alertWays: alertWays),success: { (json) in
           let code = json["code"].intValue
           if code == 0 {
               let jSONDictionary = json.dictionaryObject ?? [String : Any]()
               success?(jSONDictionary)
           }else{
               failure?("")
           }
       }) { moyaError,error  in
           failure?(error)
       }
    }
    func refreshToken(refreshToken: String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.refreshToken(refreshToken: refreshToken),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func checkIsNewUser(cellphone:String,success:((Bool)->Void)?, failure:((String)->Void)?) {
        Network.request(.checkIsNewUserCellphone(cellphone: cellphone),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                success?(true)
            }else{
                success?(false)
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func checkIsNewUser(email:String,success:((Bool)->Void)?, failure:((String)->Void)?) {
        Network.request(.checkIsNewUserEmail(email: email),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                success?(true)
            }else{
                success?(false)
            }
       }) { moyaError,error  in
           failure?(error)
       }
    }
    func resetPassword(resetPasswordModel: ResetPasswordModel,success:(()->Void)?, failure:((String)->Void)?) {
        Network.request(.resetPassword(resetPasswordModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                success?()
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func register(registModel: RegistModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.register(registModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func bindThirdpart(thirdPartInfoModel: ThirdPartInfoModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.bindThirdpart(thirdPartInfoModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                code == 10014 ? failure?("该账户已存在"):failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func unbindThirdpart(thirdPartInfoModel: ThirdPartInfoModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.unbindThirdpart(thirdPartInfoModel),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONDictionary = json.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
}