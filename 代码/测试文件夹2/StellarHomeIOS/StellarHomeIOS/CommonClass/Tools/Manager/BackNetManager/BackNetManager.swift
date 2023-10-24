import UIKit
class BackNetManager: NSObject {
    static let sharedManager = BackNetManager.init()
    private var disposeBag :DisposeBag = DisposeBag()
    private var isLog = false
    private var copyDevices: [LightModel] = []
    var needRestSns: [String] = []
    private var refreshTaskList: [(()->Void)?] = [] 
    private var isRefreshingToken = false
    func copyDeviceList() {
        removeBackup()
        for light in DevicesStore.sharedStore().lights {
            let model = LightModel()
            model.status = light.status
            model.sn = light.sn
            copyDevices.append(model)
        }
    }
    private func removeBackup() {
        copyDevices = []
        needRestSns = []
    }
    func restDeviceStatus() {
        if needRestSns.isEmpty || copyDevices.isEmpty {
            return
        }
        var needRestLights = [LightModel]()
        for sn in needRestSns {
            for light in copyDevices {
                if light.sn == sn {
                    needRestLights.append(light)
                }
            }
        }
        if needRestLights.count == 0 {
            return
        }
        let excuteModels = getExeGroup(needRestLights: needRestLights)
        DevicesStore.sharedStore().excuteDevices(actions: excuteModels, success: { (_) in
            self.log(message: "重置成功")
            self.removeBackup()
        }) { (_) in
            self.log(message: "重置失败")
            self.removeBackup()
        }
    }
    private func getExeGroup(needRestLights: [LightModel]) ->[ExecutionModel] {
        var groupList: [ExecutionModel] = []
        for light in needRestLights {
            let executeModel = ExecutionModel()
            executeModel.id = UUID().uuidString
            executeModel.device = light.sn
            let detailOnOff = ExecutionDetail() 
            if light.status.onOff == "off" {
                detailOnOff.command = .onOff
                let params = ExecutionDetailParams()
                params.onOff = "off"
                detailOnOff.params = params
                executeModel.execution.append(detailOnOff)
            }else {
                detailOnOff.command = .onOff
                let params = ExecutionDetailParams()
                params.onOff = "on"
                detailOnOff.params = params
                executeModel.execution.append(detailOnOff)
                let detailBrightness = ExecutionDetail() 
                detailBrightness.command = .brightness
                let paramsBritness = ExecutionDetailParams()
                paramsBritness.brightness = light.status.brightness
                detailBrightness.params = paramsBritness
                executeModel.execution.append(detailBrightness)
                if light.status.currentMode == .color {
                    let detailColor = ExecutionDetail() 
                    detailColor.command = .color
                    let params = ExecutionDetailParams()
                    params.color = light.status.color
                    detailColor.params = params
                    executeModel.execution.append(detailColor)
                }else if light.status.currentMode == .cct { 
                    let detailCCT = ExecutionDetail()
                    detailCCT.command = .colorTemperature
                    let params = ExecutionDetailParams()
                    params.cct = light.status.cct
                    detailCCT.params = params
                    executeModel.execution.append(detailCCT)
                }
            }
            groupList.append(executeModel)
        }
        return groupList
    }
}
extension BackNetManager {
    func prepareLoadingDatas() {
        DevicesStore.sharedStore().queryDevicesAddList(success: nil, failure: nil)
        getUserInfo()
        updateUserPhoto()
        linkDui()
        NotificationCenter.default.rx.notification(.NOTIFY_DEVICES_CHANGE).subscribe({ [weak self] (_) in 
            self?.queryScene()
        }).disposed(by:disposeBag)
    }
    private func linkDui() {
        StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: StellarAppManager.sharedManager.user.userInfo, userToken: StellarAppManager.sharedManager.user.token, duiOperationSuccess: {
            self.log(message: "linkDui成功")
        }) {
            self.log(message: "linkDui失败")
        }
    }
    private func queryScene() {
        ScenesStore.sharedStore.queryAllScenes(success: { (arr) in
            StellarAppManager.sharedManager.user.mySceneModelArr = arr
            self.log(message: "查询场景成功")
        }) { (error) in
            self.log(message: "查询场景失败")
        }
    }
    private func getUserInfo() {
        StellarUserStore.sharedStore.getUserInfo(success: { (jsonDic) in
            let model = jsonDic.kj.model(InfoModel.self)
            StellarAppManager.sharedManager.user.userInfo = model
            StellarAppManager.sharedManager.user.save()
            self.log(message: "获取用户信息成功")
        }) { (error) in
            self.log(message: "获取用户信息失败")
        }
    }
    private func updateUserPhoto() {
        AWSRequest.getHeaderImage(fileName: StellarAppManager.sharedManager.user.userInfo.userid, success: { (data) in
            if let headData = data {
                if let headImage = UIImage.init(data: headData) {
                    StellarAppManager.sharedManager.user.headImage = headImage
                    StellarAppManager.sharedManager.user.savePhoto(data: headData)
                    self.log(message: "更新头像成功")
                }
            }
        }) { (errorCode) in
            self.log(message: "更新头像失败")
        }
    }
    private func log(message: String) {
        if isLog {
            print("\(classForCoder) >>>>> \(message)")
        }
    }
}
extension BackNetManager {
    func refreshToken(success: (() ->Void)?) {
        if isRefreshingToken { 
            refreshTaskList.append(success) 
            return
        }
        isRefreshingToken = true
        Network.request(.refreshToken(refreshToken: StellarAppManager.sharedManager.user.token.refreshToken), success: { (json) in
            guard let token = json.debugDescription.kj.model(type: TokenModel.self) as? TokenModel else {
                self.refreshFail()
                return
            }
            StellarAppManager.sharedManager.user.token = token
            self.reLinkDUI(success: { 
                success?()
                for block in self.refreshTaskList {
                    block?() 
                }
                self.isRefreshingToken = false
                self.refreshTaskList.removeAll()
            }) {
                self.refreshFail()
            }
        }) { (_, _) in
            self.refreshFail()
        }
    }
    private func reLinkDUI(success: (()->Void)?, failure: (()->Void)?) {
        StellarAppManager.sharedManager.saveUserInfoAndInitDUI(userInfo: StellarAppManager.sharedManager.user.userInfo, userToken: StellarAppManager.sharedManager.user.token, duiOperationSuccess: {
            success?()
        }) {
            failure?()
        }
    }
    private func refreshFail() {
        refreshTaskList.removeAll()
        isRefreshingToken = false
        StellarAppManager.sharedManager.user.hasLogined = false
        StellarAppManager.sharedManager.user.save()
        let alert = StellarMineAlertView.init(title: StellarLocalizedString("ALERT_LOGIN_AGAIN"), message: StellarLocalizedString("ALERT_EXPIRED_LOGIN"), confimTitle: StellarLocalizedString("COMMON_FINE"))
        alert.leftClickBlock = {
            StellarAppManager.sharedManager.loginOutAction()
        }
        alert.show()
    }
}