import UIKit
import iOS_DCA_SDK
let dui_testUid = "5d2848eb81bbc5043f7587c5"
let dui_testSansiToken = "TYdTs1I38a~oX-t~1liWsWeqcb0PVUXY"
let dui_testSansiRefreshToken = "2_tPaluE5Hw0azC4ZIbYBP8cAKsIiUFT"
let dui_testDeviceName = "sansi-audio-gateway-ble"
let dui_testDeviceInfo: JSON = [
    "deviceType":"音箱",
    "deviceName":dui_testDeviceName,
    "deviceAlias":"我的音箱",
    "deviceInfo": [
        "platform": "ios",
        "productId": DCAConfig.productId
    ]
]
private let isLog = false
private func duiPrint(_ message: String) {
    if isLog == true {
        DispatchQueue.global(qos: .default).async {
            print("zqt dui \(message)")
        }
    }
}
class DUIManager: NSObject {
    var duiUserId: String?{
        set{
        }
        get{
            guard let str = userDefaults.value(forKey:keyDUIUser + StellarAppManager.sharedManager.cookie.userIdentifier) as? String else {
                return ""
            }
            return str
        }
    }
    var duiUserToken: String?
    var duiAuthCode: String?
    var duiCodeVerify: String?
    var smartHomeSkills: [DUISmartHomeSkillModel] = []
    var internalSkills: [DUIInternalSkillModel] = []
    var appliances: [DUIIotAppliance] = []
    var hubDevices: [DUIHubDeviceModel] = []
    static let instanace: DUIManager = DUIManager()
    class func sharedManager() -> DUIManager {
        return instanace
    }
    override init() {
        super.init()
        if !isOpenDui {
            print("not open DUI")
            return
        }
        DCAManager.shared.initialize(apiKey: DCAConfig.apikey, apiSecret: DCAConfig.apiSecret)
        DCAManager.shared.delegate = self
    }
    func testLinkWithDUI(success :(()->Void)?, failure: ((Int32, String)->Void)?){
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        linkWithDUI(sansiUid: dui_testUid, sansiToken: dui_testSansiToken, success: success, failure: failure)
    }
    func testBindDevice(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        let testDeive = DUIHubDeviceModel.init(json: dui_testDeviceInfo)
        bindDevice(device: testDeive, success: success, failure: failure)
    }
    func linkWithDUI(sansiUid: String, sansiToken: String, success :(()->Void)?, failure: ((Int32, String)->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.accountManager.linkAcount(thirdPlatformUid: sansiUid, thirdPlatformToken: sansiToken, manufactureSecret: DCAConfig.manufactureSecret) { (code, message, model) in
            if code == "0"{
                duiPrint("\(#function)Success: \(model?.description ?? "no info")")
                self.duiUserId =  DCAManager.shared.accountManager.getUserId()
                userDefaults.setValue(DCAManager.shared.accountManager.getUserId(), forKey: keyDUIUser + StellarAppManager.sharedManager.cookie.userIdentifier)
                userDefaults.synchronize()
                self.duiUserToken = DCAManager.shared.accountManager.getAccessToken()
                self.doClonsure(success)
            }else{
                duiPrint("\(#function)Failure Code: \(code)  Message:\(message)")
                if let temp = failure{
                    temp(Int32(code) ?? -10000, message)
                }
            }
        }
    }
    func getAuthCode(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.deviceManager.requestAuthCode(redirectUrl: DCAConfig.redirectUrl, clientId: DCAConfig.clinetId, isScan: false) { (code, authCode) in
            if code == "0"{
                let codeVerifier = DCAManager.shared.deviceManager.codeVerifier
                duiPrint("""
                    getAuthCopdeSuccess
                    code:\(authCode)
                    codeVerifier:\(codeVerifier)
                    """
                )
                self.duiAuthCode = authCode
                self.duiCodeVerify = codeVerifier
                self.doClonsure(success)
            }else{
                duiPrint("\(#function)Failure error:\(code)")
                self.doClonsure(failure)
            }
        }
    }
    func bindDevice(device: DUIHubDeviceModel, success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.deviceManager.bindDevice(deviceData: device.toJson().dictionaryObject! as NSDictionary) { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            if let code = resultDic?.intValue(forKey: "errId", default: -10000){
                if code == 0{
                    self.doClonsure(success)
                }else{
                    self.doClonsure(failure)
                }
            }else{
                self.doClonsure(failure)
            }
        }
    }
    func unbindDevice(device: DUIHubDeviceModel, success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.deviceId = device.deviceName
        DCAManager.shared.deviceManager.unbindDevice { (resultDic) in
            duiPrint("\(#function)Success: \(resultDic ?? [:])")
            if let code = resultDic?.intValue(forKey: "errId", default: -10000){
                if code == 0{
                    self.doClonsure(success)
                }else{
                    self.doClonsure(failure)
                }
            }else{
                self.doClonsure(failure)
            }
        }
    }
    func querySmartHomeSkills(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.smartHomeManager.querySmartHomeSkill { (resultDic) in
            let arr = JSON(resultDic?["data"] as Any).array
            for json in arr ?? []{
                if json.description.contains("sansi"){
                    duiPrint("\(#function): \(json.description)")
                }
            }
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["code"].string{
                if code == "0"{
                    duiPrint("\(#function)Success")
                    self.smartHomeSkills.removeAll()
                    let skillsJsonArray = json["data"].arrayValue
                    skillsJsonArray.forEach({ (skillJson) in
                        let skillModel = DUISmartHomeSkillModel.init(json: skillJson)
                        self.smartHomeSkills.append(skillModel)
                    })
                    success?()
                }else{
                    duiPrint("\(#function)Failure: \(code)")
                    failure?()
                }
            }else{
                duiPrint("\(#function)Failure: code not exist")
                failure?()
            }
        }
    }
    func queryInternalSkills(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.skillManager.querySkillListByAliasKey(productId: DCAConfig.productId, aliasKey: "prod") { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["code"].string{
                if code == "0"{
                    duiPrint("\(#function)Success")
                    self.internalSkills.removeAll()
                    let skillsJsonArray = json["data"]["skills"].arrayValue
                    let group = DispatchGroup.init()
                    let queue = DispatchQueue.global()
                    skillsJsonArray.forEach({ (skillJson) in
                        if skillJson["skillId"].stringValue != DCAConfig.sansiRoomControlSkillId {
                            let skillModel = DUIInternalSkillModel.init(json: skillJson)
                            self.internalSkills.append(skillModel)
                            group.enter()
                            queue.async(group: group, qos: .default, flags: []) {
                                DCAManager.shared.skillManager.querySkillDetail(skillId: skillModel.skillId, skillVersion: skillModel.version) { (resultDic) in
                                    guard let tempDic = resultDic else{
                                        group.leave()
                                        return
                                    }
                                    guard let json = tempDic.toJson() else{
                                        group.leave()
                                        return
                                    }
                                    if let code = json["errcode"].int,code == 0{
                                        if let detailJson = json["data"].arrayValue.first{
                                            duiPrint("\(#function) getDetailSuccess")
                                            skillModel.detail = DUIInternalSkillDetailModel.init(json: detailJson)
                                        }
                                    }
                                    duiPrint("\(#function): \(json)")
                                    group.leave()
                                }
                            }
                        }
                    })
                    group.notify(queue: .main) {
                        success?()
                    }
                }else{
                    duiPrint("\(#function)Failure: \(code)")
                    failure?()
                }
            }else{
                duiPrint("\(#function)Failure: code not exist")
                failure?()
            }
            success?()
        }
    }
    func bindSansiSmartHomeSkill(accessToken: String, refreshToken: String, success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        querySmartHomeSkills(success: {
            if let sansiSkill = self.smartHomeSkills.first(where: {$0.skillId == DCAConfig.sansiSmartHomeSkillId}){
                let request: SmartHomeTokenRequest = SmartHomeTokenRequest.init()
                request.productId = DCAConfig.productId
                request.skillId = DCAConfig.sansiSmartHomeSkillId
                request.skillVersion = "\(sansiSkill.skillVersion)"
                request.smartHomeAccessToken = accessToken
                request.smartHomeRefreshToken = refreshToken
                request.accessTokenExpiresIn = 24*60*60
                duiPrint(request.debugDescription)
                DCAManager.shared.smartHomeManager.updateSmartHomeTokenInfo(smartHomeTokenRequest: request) { (resultDic) in
                    duiPrint("\(#function): \(resultDic ?? [:])")
                    guard let tempDic = resultDic else{
                        failure?()
                        return
                    }
                    guard let json = tempDic.toJson() else{
                        failure?()
                        return
                    }
                    if let code = json["code"].string{
                        if code == "0"{
                            duiPrint("\(#function)Success: \(code)")
                            success?()
                        }else{
                            duiPrint("\(#function)Failure: \(code)")
                            failure?()
                        }
                    }else{
                        duiPrint("\(#function)Success")
                        success?()
                    }
                }
            }else{
                duiPrint("\(#function)Failure: no skill available")
                self.doClonsure(failure)
            }
        }, failure: failure)
    }
    func querySansiSmartHomeSkillStatus(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        querySmartHomeSkills(success: {
            if let sansiSkill = self.smartHomeSkills.first(where: {$0.skillId == DCAConfig.sansiSmartHomeSkillId}){
                DCAManager.shared.smartHomeManager.querySmartHomeAccountStatus(skillId: DCAConfig.sansiSmartHomeSkillId, skillVersion: "\(sansiSkill.skillVersion)", productId: DCAConfig.productId) { (resultDic) in
                    duiPrint("\(#function): \(resultDic ?? [:])")
                    guard let tempDic = resultDic else{
                        failure?()
                        return
                    }
                    guard let json = tempDic.toJson() else{
                        failure?()
                        return
                    }
                    if let code = json["code"].string{
                        if code == "0"{
                            duiPrint("\(#function)Success: \(code)")
                            success?()
                        }else{
                            duiPrint("\(#function)Failure: \(code)")
                            failure?()
                        }
                    }else{
                        duiPrint("\(#function): code not exist")
                        failure?()
                    }
                }
            }else{
                duiPrint("\(#function)Failure: no skill available")
                self.doClonsure(failure)
            }
        }, failure: failure)
    }
    func queryHubDvices(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.deviceManager.getBindDeviceList { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["errId"].int{
                if code == 0{
                    self.hubDevices.removeAll()
                    let jsonArray = json["result"]["devices"].arrayValue
                    jsonArray.forEach({ (deviceJson) in
                        let devices = DUIHubDeviceModel.init(json: deviceJson)
                        self.hubDevices.append(devices)
                    })
                    duiPrint("\(#function)Success: \(code)")
                    self.doClonsure(success)
                }else{
                    duiPrint("\(#function)Failure: \(code)")
                    self.doClonsure(failure);
                }
            }else{
                duiPrint("\(#function): code not exist")
                failure?()
            }
        }
    }
    func qureySmartHomeAppliances(success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        querySmartHomeSkills(success: {
            guard let sansiSkill = self.smartHomeSkills.first(where: {$0.skillId == DCAConfig.sansiSmartHomeSkillId}) else {
                duiPrint("\(#function): no skill available")
                self.doClonsure(failure)
                return
            }
            DCAManager.shared.smartHomeManager.querySmartHomeAppliance(skillId: DCAConfig.sansiSmartHomeSkillId, skillVersion: "\(sansiSkill.skillVersion)", productId: DCAConfig.productId, group: "") { (resultDic) in
                duiPrint("\(#function): \(resultDic ?? [:])")
                guard let tempDic = resultDic else{
                    failure?()
                    return
                }
                guard let json = tempDic.toJson() else{
                    failure?()
                    return
                }
                if let code = json["errId"].int{
                    if code == 0{
                        self.appliances.removeAll()
                        let jsonArray = json["result"]["appliances"].arrayValue
                        jsonArray.forEach({ (deviceJson) in
                            let iotDevice = DUIIotAppliance.init(json: deviceJson)
                            self.appliances.append(iotDevice)
                        })
                        self.doClonsure(success)
                    }else{
                        self.doClonsure(failure)
                    }
                }else{
                    if json["errId"].string != "0"{
                        self.bindSansiSmartHomeSkill(accessToken: StellarAppManager.sharedManager.user.token.accessToken, refreshToken: StellarAppManager.sharedManager.user.token.refreshToken, success: {
                            self.qureySmartHomeAppliances(success: success, failure: failure)
                        }, failure: {
                            self.doClonsure(failure)
                        })
                    }
                }
            }
        }, failure: failure)
    }
    func querySmartHomeApplianceLocation(device: DUIIotAppliance, success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.smartHomeManager.queryAppliancePosition(applianceId: device.applianceId, skillId: device.skillId) { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["errId"].int{
                if code == 0{
                    let jsonResult = json["result"]
                    device.update(json: jsonResult)
                    self.doClonsure(success)
                }else{
                    self.doClonsure(failure);
                }
            }else{
                self.doClonsure(failure)
            }
        }
    }
    func changeAppliancePosition(device: DUIIotAppliance, newPosition: String, success :(()->Void)?, failure :(()->Void)?) {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        DCAManager.shared.smartHomeManager.updateApplianceCustomPosition(applianceId: device.applianceId, skillId: device.skillId, productId: DCAConfig.productId, position: newPosition, group: "") { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["errId"].int{
                if code == 0{
                    device.position = newPosition
                    self.doClonsure(success)
                }else{
                    self.doClonsure(failure);
                }
            }else{
                self.doClonsure(failure)
            }
        }
    }
    func changeApplianceName(device: DUIIotAppliance, newName: String, success :(()->Void)?, failure :(()->Void)?)  {
        if !isOpenDui {
            print("not open DUI")
            success?()
            return
        }
        duiPrint("\(#function) params: \(newName)")
        DCAManager.shared.smartHomeManager.updateApplianceAlias(applianceId: device.applianceId, skillId: device.skillId, productId: DCAConfig.productId, alias: newName, group: "") { (resultDic) in
            duiPrint("\(#function): \(resultDic ?? [:])")
            guard let tempDic = resultDic else{
                failure?()
                return
            }
            guard let json = tempDic.toJson() else{
                failure?()
                return
            }
            if let code = json["errId"].int{
                if code == 0{
                    device.alias = newName
                    self.doClonsure(success)
                }else{
                    self.doClonsure(failure);
                }
            }else{
                self.doClonsure(failure)
            }
        }
    }
    func applianceAliasSync()  {
        if !isOpenDui {
            print("not open DUI")
            return
        }
        duiPrint("\(#function)")
        DCAManager.shared.smartHomeManager.applianceAliasSync(productId: DCAConfig.productId, group: "", iotSkillId: DCAConfig.sansiSmartHomeSkillId, skillList: nil) { (dic) in
            duiPrint("dic")
        }
    }
    private func doClonsure(_ clonsure: (()->Void)?) {
        DispatchQueue.main.async {
            clonsure?()
        }
    }
}
extension DUIManager: DCAManagerDelegate{
    func onNeedLogin() {
        duiPrint("\(#function)")
        DUIManager.sharedManager().linkWithDUI(sansiUid: StellarAppManager.sharedManager.user.userInfo.userid, sansiToken: StellarAppManager.sharedManager.user.token.accessToken, success: {
        }) { (code, message) in
        }
    }
}