import UIKit
class DevicesStore: NSObject {
    var allDevices: [BasicDeviceModel] = [] {
        didSet {
            DUIManager.sharedManager().applianceAliasSync()
            querySmartHomeDevices()
            sortLightsRoomIdsAndNames()
            sortDevicesRoomIdsAndNames()
        }
    }
    var subscribeDevices : [BasicDeviceModel] = []{
        didSet{
            for device in subscribeDevices{
                if device.type == .hub{
                    MQTTManger.sharedManager().subscribeGateway(sn: device.sn ,success:{
                    }, failure: nil)
                }else if device.connection == .softAP {
                    MQTTManger.sharedManager().subscribeNoGatewayDevice(sn: device.sn, success: {
                    }) { (errorCode) in
                    }
                }
            }
        }
    }
    var searchDevices: [BasicDeviceModel] = [BasicDeviceModel]()
    var hasDevicesAllRoomsID: [Int] = []
    var hasDevicesAllRoomsName: [String] = []
    var sortedDevicesDic = [Int:Array<BasicDeviceModel>]()
    var sortedLightsDic = [Int:Array<LightModel>]()
    var hasLightsAllRoomsID: [Int] = []
    var hasLightsAllRoomsName: [String] = []
    var lights: [LightModel] {
        get {
            return allDevices.filter{$0.type == .light || $0.type == .mainLight } as! [LightModel]
        }
    }
    var gateways: [GatewayModel] {
        get {
            return allDevices.filter{$0.type == .hub} as! [GatewayModel]
        }
    }
    var panels: [PanelModel] {
        get {
            return allDevices.filter{$0.type == .panel} as! [PanelModel]
        }
    }
    static let instance: DevicesStore = DevicesStore.init()
    class func sharedStore() -> DevicesStore {
        return instance
    }
    override init() {
        super.init()
    }
    func getSumOfTriats(lights: [LightModel]) -> [Traits] {
        var triats = [Traits]()
        for light in lights {
            for triat in light.traits ?? [Traits]() {
                if !triats.contains(triat) {
                    triats.append(triat)
                }
            }
        }
        return triats
    }
    func getLightGroupTemperatureRange(pLights: [LightModel]) -> (min: Int, max: Int) {
        let lightArr = pLights.filter({$0.colorTemperatureRange.temperatureMinK != 0 && $0.colorTemperatureRange.temperatureMaxK != 0})
        var minTems = lightArr.map({$0.colorTemperatureRange.temperatureMinK})
        minTems.sort(by: {$0 < $1})
        var maxTemps = lightArr.map({$0.colorTemperatureRange.temperatureMaxK})
        maxTemps.sort(by: {$0 > $1})
        return (minTems.first ?? 2700,maxTemps.first ?? 6500)
    }
    func getLightGroupModeList(lightGroup: [LightModel]) ->[LightInternalMode]? {
        guard  let light = lightGroup.first else {
            return nil
        }
        for lightModel in lightGroup {
            if light.internalMode != lightModel.internalMode {
                return nil
            }
        }
        return light.internalMode
    }
    func findDevice(sn: String) -> BasicDeviceModel? {
        let result = allDevices.filter{$0.sn == sn}
        if result.count > 0{
            return result.first
        }else{
            return nil
        }
    }
    func checkUserLightList(compelete: ((_ isHaveLight: Bool) ->Void)?) {
        if lights.count > 0 {
            compelete?(true)
            return
        }
        getAllDeviceBasicInfo(success: { (list) in
            var isHaveLight = false
            for model in list {
                if model.type == .light || model.type == .mainLight {
                    isHaveLight = true
                    break
                }
            }
            compelete?(isHaveLight)
        }) { (error) in
            compelete?(false)
        }
    }
    func changeDeviceName(device: BasicDeviceModel, newName: String,success:((_ model:BasicDeviceModel)->Void)?, failure: (()->Void)?) {
        if (device.type == .light || device.type == .mainLight) && device.connection != .ble{
            duiChangeApplianceName(devicesn: device.sn, newName: newName, success: {
                self.modifyDeviceName(sn: device.sn,name: newName, success: { (jsonDic) in
                    let model = jsonDic.kj.model(BasicDeviceModel.self)
                    success?(model)
                }) { (err) in
                    failure?()
                }
            }) {
                failure?()
            }
        }else {
            modifyDeviceName(sn: device.sn,name: newName, success: { (jsonDic) in
                let model = jsonDic.kj.model(BasicDeviceModel.self)
                success?(model)
            }) { (err) in
                failure?()
            }
        }
    }
    func changeDeviceRoom(device: BasicDeviceModel,newRoomId: Int,success:(()->Void)?, failure: (()->Void)?) {
        modifyDeviceRoom(sn: device.sn,room: newRoomId, success: { (jsonDic) in
            success?()
        }) { (err) in
            failure?()
        }
    }
    func deletDevice(device: BasicDeviceModel, success: (()->Void)?, failure: (()->Void)?) {
        if device.type == .hub{
            self.duiDeletDevice(device: device, success: {
                self.deleteDevice(sn: device.sn, success: { (jsonDic) in
                    let response = jsonDic.kj.model(CommonResponseModel.self)
                    if response.code == 0 {
                        let allDevices = DevicesStore.instance.allDevices
                        DevicesStore.instance.allDevices = allDevices.filter{$0.sn != device.sn}
                        success?()
                    }else {
                        failure?()
                    }
                }) { (error) in
                    failure?()
                }
            }) {
                failure?()
            }
        }else {
            deleteDevice(sn: device.sn, success: { (jsonDic) in
                let response = jsonDic.kj.model(CommonResponseModel.self)
                if response.code == 0 {
                    var allDevices = DevicesStore.instance.allDevices
                    allDevices.removeAll(where: { (model) -> Bool in
                        return model.sn == device.sn
                    })
                    DevicesStore.instance.allDevices = allDevices
                    success?()
                }else {
                    failure?()
                }
            }) { (error) in
                failure?()
            }
        }
    }
    func subscribeGatewaySearchDevice(sn: String, searchDetailModel:AddDeviceDetailModel, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        self.searchDetailModel = searchDetailModel
        MQTTManger.sharedManager().subscribeGatewaySearchDevice(sn: sn, success: success, failure: failure)
    }
    func subscribeNoGatewaySearchDevice(sn: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        MQTTManger.sharedManager().subscribeNoGateWayDeviceAdd(sn: sn, success: success, failure: failure)
    }
    func unsubscribeNoGatewaySearchDevice(sn: String) {
        MQTTManger.sharedManager().unsubscribeNoGatewayDeviceAdd(sn: sn)
    }
    func unsubscribeGatewaySearchDevice(sn: String) {
        MQTTManger.sharedManager().unsubscribeGatewaySearchDevice(sn: sn)
        searchDevices.removeAll()
        complementQueryDevices.removeAll()
        complementQueryingDevices.removeAll()
        searchDetailModel = AddDeviceDetailModel()
    }
    private var complementQueryDevices: [BasicDeviceModel] = [BasicDeviceModel]()
    private var complementQueryingDevices: [BasicDeviceModel] = [BasicDeviceModel]()
    private var searchDetailModel:AddDeviceDetailModel = AddDeviceDetailModel()
    private func sortDevicesRoomIdsAndNames() {
        hasDevicesAllRoomsName.removeAll()
        hasDevicesAllRoomsID.removeAll()
        sortedDevicesDic.removeAll()
        for model in allDevices{
            if model.room != nil && model.room != -1 {
                if hasDevicesAllRoomsID.contains(model.room!){
                    var arr = sortedDevicesDic[model.room!]
                    arr?.append(model)
                    sortedDevicesDic.updateValue(arr!, forKey: model.room!)
                }else{
                    hasDevicesAllRoomsName.append(StellarRoomManager.shared.getRoom(roomId: model.room!).name ?? "\(model.room!)")
                    hasDevicesAllRoomsID.append(model.room!)
                    var arr = Array<BasicDeviceModel>()
                    arr.append(model)
                    sortedDevicesDic.updateValue(arr, forKey: model.room!)
                }
            }
        }
    }
    private func sortLightsRoomIdsAndNames() {
        sortedLightsDic.removeAll()
        hasLightsAllRoomsID.removeAll()
        hasLightsAllRoomsName.removeAll()
        let lightList = allDevices.filter{$0.type == .light || $0.type == .mainLight} as? [LightModel]
        for light in lightList ?? [LightModel]() {
            if light.room != nil && light.room != -1 {
                if !hasLightsAllRoomsID.contains(light.room!) {
                    hasLightsAllRoomsID.append(light.room!)
                    hasLightsAllRoomsName.append(StellarRoomManager.shared.getRoom(roomId: light.room!).name ?? "\(light.room!)")
                    var arr = [LightModel]()
                    arr.append(light)
                    sortedLightsDic.updateValue(arr, forKey: light.room!)
                }else {
                    var arr = sortedLightsDic[light.room!]
                    arr?.append(light)
                    sortedLightsDic.updateValue(arr!, forKey: light.room!)
                }
            }
        }
    }
}
extension DevicesStore: MQTTMangerNotifyDelegate{
    func didReceiveStatusUpated(json: JSON) {
        guard let targetDevice = findDevice(sn: json["sn"].stringValue) else{
            return
        }
        switch targetDevice.type {
        case .unknown:
            break
        case .light,.mainLight:
            guard var model = targetDevice as? LightModel else{
                return
            }
            model.kj_m.convert(from: json.dictionaryObject ?? [:])
            NotificationCenter.default.post(name: .NOTIFY_STATUS_UPDATED, object: nil, userInfo: ["deviceState" : model])
        case .panel:
            guard var model = targetDevice as? PanelModel else{
                return
            }
            model.kj_m.convert(from: json.dictionaryObject ?? [:])
            NotificationCenter.default.post(name: .NOTIFY_STATUS_UPDATED, object: nil, userInfo: ["deviceState" : model])
        case .hub:
            guard var model = targetDevice as? GatewayModel else{
                return
            }
            model.kj_m.convert(from: json.dictionaryObject ?? [:])
            NotificationCenter.default.post(name: .NOTIFY_STATUS_UPDATED, object: nil, userInfo: ["deviceState" : model])
            if model.status.online {
                return
            }
            for basicDevice in self.allDevices {
                if let light = basicDevice as? LightModel,light.gatewaySn == model.sn {
                    light.status.online = false
                    NotificationCenter.default.post(name: .NOTIFY_STATUS_UPDATED, object: nil, userInfo: ["deviceState" : light])
                }
            }
        }
    }
    func didReceiveDeviceSearch(json: JSON) {
        let didReceivFwtype = json["fwType"].intValue
        let didReceivSwversion = json["swVersion"].intValue
        let didReceivHwversion = json["hwVersion"].intValue
        if didReceivFwtype == -1 || didReceivFwtype != searchDetailModel.fwType{
            return
        }
        guard let basicDeviceType = DeviceType.kj_convert(from: json["type"].stringValue) else {
            return
        }
        var basicModel = BasicDeviceModel()
        switch basicDeviceType {
        case .light,.mainLight:
            basicModel = LightModel()
            break
        case .panel:
            basicModel = PanelModel()
            break
        case .hub:
            basicModel = GatewayModel()
            break
        default:
            break
        }
        basicModel.kj_m.convert(from: json.dictionaryValue)
        if basicModel.name.isEmpty {
            basicModel.name = json["description"].stringValue
        }
        searchContainDevices(model:basicModel,didReceivFwtype:didReceivFwtype,didReceivSwversion:didReceivSwversion,didReceivHwversion:didReceivHwversion)
    }
    private func searchContainDevices(model:BasicDeviceModel,didReceivFwtype:Int,didReceivSwversion:Int,didReceivHwversion:Int){
        var basicModel = model
        let mac = basicModel.mac
        let containSearchedMacs = self.searchDevices.map{$0.mac}
        if containSearchedMacs.firstIndex(of: mac) != nil {
            return
        }
        var isAWSComplement = false
        var awsComplementJson = [String:Any]()
        for queryDevice in self.complementQueryDevices{
            if (queryDevice.fwType == didReceivFwtype) && (queryDevice.swVersion == didReceivSwversion) && (queryDevice.hwVersion == didReceivHwversion) {
                isAWSComplement = true
                awsComplementJson = queryDevice.kj.JSONObject()
            }
        }
        if isAWSComplement{
            basicModel.kj_m.convert(from: self.searchDetailModel.kj.JSONObject())
            basicModel.kj_m.convert(from: awsComplementJson)
            self.searchDevices.append(basicModel)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .NOTIFY_DEVICE_SEARCHED, object: nil, userInfo: nil)
            }
        }else{
            var isAWSComplementing = false
            for queryingDevice in self.complementQueryingDevices{
                if (queryingDevice.fwType == didReceivFwtype) && (queryingDevice.swVersion == didReceivSwversion) && (queryingDevice.hwVersion == didReceivHwversion) {
                    isAWSComplementing = true
                }
            }
            if isAWSComplementing {
                return
            }
            self.getDeviceVersionConfingRequest(basicModel: basicModel) { json in
                basicModel.kj_m.convert(from: self.searchDetailModel.kj.JSONObject())
                basicModel.kj_m.convert(from: json)
                self.searchDevices.append(basicModel)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .NOTIFY_DEVICE_SEARCHED, object: nil, userInfo: nil)
                }
            }
        }
    }
    private func getDeviceVersionConfingRequest(basicModel: BasicDeviceModel,completeBlock:((String)->Void)?){
        complementQueryingDevices.append(basicModel)
        DevicesStore.sharedStore().queryDevicesVersionDescription(fwType: "\(basicModel.fwType)", hwVersion: "\(basicModel.hwVersion)", swVersion: "\(basicModel.swVersion)", success: { (completionJson) in
            if completionJson.isEmpty{
                return
            }
            var descriptionJson = completionJson
            let description = completionJson["description"].stringValue
            descriptionJson["name"] = JSON(description)
            let deviceType = basicModel.type
            switch deviceType {
            case .unknown:
                print("查询到未知设备，添加设备，查询补全信息json失败")
            case .light,.mainLight:
                self.supplementLightConfing(basicModel:basicModel,deviceType:deviceType,descriptionJson:descriptionJson,completeBlock:completeBlock)
            case .hub:
                self.supplementHubConfing(basicModel:basicModel,deviceType:deviceType,descriptionJson:descriptionJson,completeBlock:completeBlock)
            case .panel:
                self.supplementPanelConfing(basicModel:basicModel,deviceType:deviceType,descriptionJson:descriptionJson,completeBlock:completeBlock)
            }
        }) { (error) in
            print("补全请求失败")
        }
    }
    func supplementLightConfing(basicModel: BasicDeviceModel,deviceType:DeviceType,descriptionJson:JSON,completeBlock:((String)->Void)?){
        var light = LightModel()
        light.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
        light.fwType = basicModel.fwType
        light.swVersion = basicModel.swVersion
        light.hwVersion = basicModel.hwVersion
        self.complementQueryDevices.append(light)
        for queryingDevice in self.complementQueryingDevices {
            if (basicModel.mac != queryingDevice.mac) && (basicModel.fwType == queryingDevice.fwType) && (basicModel.swVersion == queryingDevice.swVersion) && (basicModel.hwVersion == queryingDevice.hwVersion) {
                if var queryLight = queryingDevice as? LightModel {
                    queryLight.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
                    queryLight.kj_m.convert(from: self.searchDetailModel.kj.JSONObject())
                    self.searchDevices.append(queryLight)
                    guard let index = self.complementQueryingDevices.firstIndex(where: {$0.mac == queryLight.mac}) else {
                        return
                    }
                    self.complementQueryingDevices.remove(at: index)
                }
            }
        }
        completeBlock?(descriptionJson.description)
        guard let index = self.complementQueryingDevices.firstIndex(where: {($0.fwType == basicModel.fwType)&&($0.swVersion == basicModel.swVersion)&&($0.hwVersion == basicModel.hwVersion)}) else {
            return
        }
        self.complementQueryingDevices.remove(at: index)
    }
    func supplementHubConfing(basicModel: BasicDeviceModel,deviceType:DeviceType,descriptionJson:JSON,completeBlock:((String)->Void)?){
        var hub = GatewayModel()
        hub.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
        hub.fwType = basicModel.fwType
        hub.swVersion = basicModel.swVersion
        hub.hwVersion = basicModel.hwVersion
        self.complementQueryDevices.append(hub)
        for queryingDevice in self.complementQueryingDevices {
            if (basicModel.mac != queryingDevice.mac) && (basicModel.fwType == queryingDevice.fwType) && (basicModel.swVersion == queryingDevice.swVersion) && (basicModel.hwVersion == queryingDevice.hwVersion) {
                if var queryHub = queryingDevice as? LightModel {
                    queryHub.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
                    queryHub.kj_m.convert(from: self.searchDetailModel.kj.JSONObject())
                    self.searchDevices.append(queryHub)
                    guard let index = self.complementQueryingDevices.firstIndex(where: {$0.mac == queryHub.mac}) else {
                        return
                    }
                    self.complementQueryingDevices.remove(at: index)
                }
            }
        }
        completeBlock?(descriptionJson.description)
        guard let index = self.complementQueryingDevices.firstIndex(where: {($0.fwType == basicModel.fwType)&&($0.swVersion == basicModel.swVersion)&&($0.hwVersion == basicModel.hwVersion)}) else {
            return
        }
        self.complementQueryingDevices.remove(at: index)
    }
    func supplementPanelConfing(basicModel: BasicDeviceModel,deviceType:DeviceType,descriptionJson:JSON,completeBlock:((String)->Void)?){
        var panelModel = PanelModel()
        panelModel.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
        panelModel.fwType = basicModel.fwType
        panelModel.swVersion = basicModel.swVersion
        panelModel.hwVersion = basicModel.hwVersion
        self.complementQueryDevices.append(panelModel)
        for queryingDevice in self.complementQueryingDevices {
            if (basicModel.mac != queryingDevice.mac) && (basicModel.fwType == queryingDevice.fwType) && (basicModel.swVersion == queryingDevice.swVersion) && (basicModel.hwVersion == queryingDevice.hwVersion) {
                if var queryPanel = queryingDevice as? LightModel {
                    queryPanel.kj_m.convert(from: descriptionJson.dictionaryObject ?? [String:Any]())
                    queryPanel.kj_m.convert(from: self.searchDetailModel.kj.JSONObject())
                    self.searchDevices.append(queryPanel)
                    guard let index = self.complementQueryingDevices.firstIndex(where: {$0.mac == queryPanel.mac}) else {
                        return
                    }
                    self.complementQueryingDevices.remove(at: index)
                }
            }
        }
        completeBlock?(descriptionJson.description)
        guard let index = self.complementQueryingDevices.firstIndex(where: {($0.fwType == basicModel.fwType)&&($0.swVersion == basicModel.swVersion)&&($0.hwVersion == basicModel.hwVersion)}) else {
            return
        }
        self.complementQueryingDevices.remove(at: index)
    }
    func didReceiveDeviceAddResult(json: JSON) {
        let result = json["result"].dictionaryValue
        let sn = result["sn"]?.stringValue ?? ""
        let model = BasicDeviceModel()
        model.mac = json["mac"].stringValue
        model.sn = result["sn"]?.stringValue ?? ""
        if sn.isEmpty{
            NotificationCenter.default.post(name: .NOTIFY_DEVICE_ADD_DEVICE_RESULT, object: nil, userInfo: ["addDeviceResult" : (model,false)])
        }else{
            NotificationCenter.default.post(name: .NOTIFY_DEVICE_ADD_DEVICE_RESULT, object: nil, userInfo: ["addDeviceResult" : (model,true)])
        }
    }
}
extension DevicesStore{
    func adddevicesToGateway(devices: [BasicDeviceModel],success:(([ResponseDeviceModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.adddevicesToGateway(devices),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let responseDeviceModels = json.arrayObject?.kj.modelArray(ResponseDeviceModel.self) ?? [ResponseDeviceModel]()
                success?(responseDeviceModels)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func addSingleDevice(device: BasicDeviceModel,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.addSingleDevice(device),success: { (json) in
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
    func getAllDeviceBasicInfo(success:(([BasicDeviceModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.getAllDeviceBasicInfo,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                var list: [BasicDeviceModel] = []
                for basic in json.arrayValue {
                    if let device = self.classifyDevice(basic: basic) {
                        list.append(device)
                    }
                }
                success?(list)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    private func classifyDevice(basic:JSON) -> BasicDeviceModel?{
        let type = DeviceType.kj_convert(from: basic["type"].stringValue)
        switch type {
        case .hub:
            return basic.description.kj.model(GatewayModel.self)
        case .panel:
            return basic.description.kj.model(PanelModel.self)
        case .light,.mainLight:
            return basic.description.kj.model(LightModel.self)
        case .unknown:
            return nil
        default:
            return nil
        }
    }
    func getAllDeviceStateInfo(success:(([[String: Any]])->Void)?, failure:((String)->Void)?) {
        Network.request(.getAllDeviceStateInfo,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jSONArr = (json.arrayObject as? [[String : Any]]) ?? [[String: Any]]()
                success?(jSONArr)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getSingleDeviceInfo(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getSingleDeviceInfo(sn: sn),success: { (json) in
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
    func excuteDevices(actions:[ExecutionModel],success:((Any)->Void)?, failure:((String)->Void)?) {
        Network.request(.excuteDevices(actions),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                var successList = [CommonResponseModel]()
                var failureList = [CommonResponseModel]()
                for dic in json.arrayValue {
                    if let model = dic.description.kj.model(CommonResponseModel.self) {
                        if model.code != 0 {
                            failureList.append(model)
                        }else {
                            successList.append(model)
                        }
                    }
                }
                success?([successList,failureList]) 
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getSingleStatusDevice(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getSingleStatusDevice(sn: sn),success: { (json) in
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
    func getRelationDevice(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getRelationDevice(sn: sn),success: { (json) in
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
    func excutePanelActions(sn:String,buttonId:String,success:(([CommonResponseModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.excutePanelActions(sn: sn, buttonId: buttonId),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                var list: [CommonResponseModel] = []
                for dic in json.arrayValue {
                    if let model = dic.description.kj.model(CommonResponseModel.self),model.code == 0 {
                        list.append(model) 
                    }
                }
                success?(list)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getPanelButtonsActions(sn:String,success:((Array<ButttonModel>)->Void)?, failure:((String)->Void)?) {
        Network.request(.getPanelButtonsActions(sn: sn),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let jsonArr = json.arrayValue
                var list: [ButttonModel] = []
                for dic in jsonArr {
                    if let model = dic.description.kj.model(ButttonModel.self) {
                        list.append(model)
                    }
                }
                success?(list)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func setPanelButtonsActions(sn:String,buttonId:Int,actions:[ExecutionModel],success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.setPanelButtonsActions(sn: sn, buttonId: buttonId, actions: actions),success: { (json) in
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
    func startSearch(sn:String,time:Int,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.startSearch(sn: sn,time:time),success: { (json) in
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
    func stopSearch(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.stopSearch(sn: sn),success: { (json) in
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
    func start_upgrade(sn:String,latestSwVersion: Int,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.start_upgrade(sn: sn, latestSwVersion: latestSwVersion),success: { (json) in
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
    func start_MonitoringLocation(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.startMonitorLocation(sn: sn),success: { (json) in
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
    func stop_MonitoringLocation(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.stopMonitorLocation(sn: sn),success: { (json) in
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
    func start_MonitoringVitalSigns(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.startMonitorVital(sn: sn),success: { (json) in
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
    func stop_MonitoringVitalSigns(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.stopMonitorVital(sn: sn),success: { (json) in
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
    func getVitalSigns(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getVitalSigns(sn: sn),success: { (json) in
            if let dic = json.dictionaryObject {
                success?(dic)
            }else {
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getLocations(sn:String,success:(([RadarLocationInfo])->Void)?, failure:((String)->Void)?) {
        Network.request(.getLocationInfo(sn: sn),success: { (json) in
            let arr = json["radarLocationInfo"].arrayValue
            if arr.count == 0 {
                failure?("")
            }else {
                var list = [RadarLocationInfo]()
                for dic in arr {
                    if let model = dic.description.kj.model(RadarLocationInfo.self) {
                        list.append(model)
                    }
                }
                success?(list)
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getLocationsExistanceByTime(sn:String,startTime:String,endTime:String, success:(([String])->Void)?, failure:((String)->Void)?) {
        Network.request(.radarLocationExistance(sn: sn, startTime: startTime, endTime: endTime),success: { (json) in
            let arr = json["radarLocationExistance"].arrayValue
            if arr.isEmpty {
                failure?("")
            }else {
                var list = [String]()
                for date in arr {
                    list.append(date.description)
                }
                success?(list)
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func getLocationsHistoryByTime(sn:String,time:String, success:(([RadarLocationInfo])->Void)?, failure:((String)->Void)?) {
        Network.request(.radarLocationHistory(sn: sn, time: time),success: { (json) in
            let arr = json.arrayValue
            if arr.isEmpty {
                failure?("")
            }else {
                var list = [RadarLocationInfo]()
                for dic in arr {
                    if let model = dic.description.kj.model(RadarLocationInfo.self) {
                        list.append(model)
                    }
                }
                success?(list)
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    private func deleteDevice(sn:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.deleteDevice(sn: sn),success: { (json) in
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
    private func modifyDeviceName(sn:String,name:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modifyDeviceName(sn: sn,name: name),success: { (json) in
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
    private func modifyDeviceRoom(sn:String,room:Int,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.modifyDeviceRoom(sn: sn,room: room),success: { (json) in
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
extension DevicesStore{
    func queryAllRooms(success:(([StellarRoomModel])->Void)?, failure:((String)->Void)?) {
        Network.request(.queryAllRooms,success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let models = json["rooms"].arrayObject?.kj.modelArray(StellarRoomModel.self) ?? [StellarRoomModel]()
                success?(models)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func queryDevicesVersionDescription(fwType:String,hwVersion:String,swVersion:String,success:((JSON)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryDevicesVersionDescription(fwType: fwType, hwVersion: hwVersion, swVersion: swVersion),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                success?(json)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func devicesUpgradeInfo(fwType:String,hwVersion:String,success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.devicesUpgradeInfo(fwType: fwType, hwVersion: hwVersion),success: { (json) in
            let code = json["code"].intValue
            if code == 0 {
                let versionJson = json["version"].arrayValue.first
                let jSONDictionary = versionJson?.dictionaryObject ?? [String : Any]()
                success?(jSONDictionary)
            }else{
                failure?("")
            }
        }) { moyaError,error  in
            failure?(error)
        }
    }
    func queryDevicesAddList(success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.queryDevicesAddList,success: { (json) in
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
    func getDeviceRegisterToken(success:((JSONDictionary)->Void)?, failure:((String)->Void)?) {
        Network.request(.getDeviceRegisterToken,success: { (json) in
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
extension DevicesStore{
    func setMQTTMangerDelegate(){
        MQTTManger.sharedManager().delegate = self
    }
    func qureySmartHomes(success: (() ->Void)?, failure: (() ->Void)?) {
        DUIManager.sharedManager().qureySmartHomeAppliances(success: {
            success?()
        }) {
            failure?()
        }
    }
    func duiChangeApplianceName(devicesn: String, newName: String,success:(()->Void)?, failure: (()->Void)?) {
        if let model = getDUIIotApplianceModel(appliceId: devicesn) {
            DUIManager.sharedManager().changeApplianceName(device: model, newName: newName, success: {
                success?()
            }) {
                failure?()
            }
        }else {
            qureySmartHomes(success: {
                if self.getDUIIotApplianceModel(appliceId: devicesn) != nil {
                    self.duiChangeApplianceName(devicesn: devicesn, newName: newName, success: success, failure: failure)
                }else {
                    failure?()
                }
            }) {
                failure?()
            }
        }
    }
    private func duiChangeDeviceRoom(device: BasicDeviceModel,newRoomId: Int,success:(()->Void)?, failure: (()->Void)?) {
        if let model = getDUIIotApplianceModel(appliceId: device.sn) {
            DUIManager.sharedManager().changeAppliancePosition(device: model, newPosition: StellarRoomManager.shared.getRoom(roomId: newRoomId).name ?? "", success: {
                success?()
            }) {
                failure?()
            }
        }else {
            qureySmartHomes(success: {
                if self.getDUIIotApplianceModel(appliceId: device.sn) != nil {
                    self.duiChangeDeviceRoom(device: device, newRoomId: newRoomId, success: success, failure: failure)
                }else {
                    failure?()
                }
            }) {
                failure?()
            }
        }
    }
    private func  duiDeletDevice(device: BasicDeviceModel, success: (()->Void)?, failure: (()->Void)?) {
        let iotArr = DUIManager.sharedManager().hubDevices.filter({ model -> Bool in
            model.deviceName == device.sn
        })
        if iotArr.count > 0{
            DUIManager.sharedManager().unbindDevice(device: iotArr.first!, success: {
                success?()
            }) {
                failure?()
            }
        }else{
            DUIManager.sharedManager().queryHubDvices(success: {
                let iotArr = DUIManager.sharedManager().hubDevices.filter({ model -> Bool in
                    model.deviceName == device.sn
                })
                if let device = iotArr.first{
                    DUIManager.sharedManager().unbindDevice(device: device, success: {
                        success?()
                    }) {
                        failure?()
                    }
                }else{
                    success?()
                }
            }) {
                failure?()
            }
        }
    }
    private func getDUIIotApplianceModel(appliceId: String) ->DUIIotAppliance? {
        let iotArr = DUIManager.sharedManager().appliances.filter({ model -> Bool in
            model.applianceId == appliceId
        })
        return iotArr.first
    }
    private func querySmartHomeDevices() {
        DUIManager.sharedManager().qureySmartHomeAppliances(success: nil, failure: nil)
        DUIManager.sharedManager().queryHubDvices(success: nil, failure: nil)
    }
}