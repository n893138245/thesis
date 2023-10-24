let LH_MATCHNET_CHAR_UUID = "2222"
class DUIBleGatewayManager: NSObject {
    static let sharedManager = DUIBleGatewayManager.init()
    private let disposeBag = DisposeBag()
    private var ssid = ""
    private var psk = ""
    private var currentCharacteristic:CBCharacteristic?
    var addingHubsn = ""
    func getScanDevices() -> [BleEquipmentModel]{
        var models = [BleEquipmentModel]()
        for bleEquipmentModel in BleManager.sharedManager().domesticDevices {
            if bleEquipmentModel.fwType == "0" {
                bleEquipmentModel.fwType = "24321"
                models.append(bleEquipmentModel)
            }
            if bleEquipmentModel.fwType == "24321" {
                models.append(bleEquipmentModel)
            }
        }
        return models
    }
    override init() {
        super.init()
        NotificationCenter.default.rx.notification (kBlueToothCentralWriteResponse).subscribe({ [weak self] (nitify) in
            guard let characteristicData = nitify.element?.object as? Data else{
                return
            }
            let bleData = StellarWiFiFrame.initWithData(characteristicData)
            guard let type = bleData?.type else{
                return
            }
            if type == StellarFrameTypeQueryDeviceName{
                guard let deviceName = bleData?.getFrameDeviceName() else{
                    return
                }
                DUIBleGatewayManager.sharedManager.addingHubsn = deviceName
                DevicesStore.sharedStore().subscribeNoGatewaySearchDevice(sn: deviceName, success: nil, failure: nil)
                self?.bindHubAndAccount(sn: deviceName, resultBlock: { (isSuccess) in
                    if isSuccess{
                        DUIManager.sharedManager().getAuthCode(success: { [weak self] in
                            let userid = DUIManager.sharedManager().duiUserId ?? ""
                            let authcode = DUIManager.sharedManager().duiAuthCode ?? ""
                            let codeVerify = DUIManager.sharedManager().duiCodeVerify ?? ""
                            self?.sendDUIInfo(userid: userid, authcode: authcode, codeVerify: codeVerify)
                        }) { [weak self] in
                            self?.sendPairFailed()
                        }
                    }else{
                        self?.sendPairFailed()
                    }
                })
            }else if type == StellarFrameTypeDUIInfo{
                self?.sendAccountInfo(ssid: self?.ssid ?? "", password: self?.psk ?? "")
            }else if type == StellarFrameTypeSetWifiAccess{
                self?.sendServerInfo()
            }else if type == StellarFrameTypeSetUpService{
                self?.sendDeviceToken()
            }else if type == StellarFrameTypeSendDeviceToken{
                self?.sendBegainRegistAction()
            }
        }).disposed(by:disposeBag)
    }
    func isOpenBlueTooth() -> Bool{
        if BleManager.sharedManager().state ==  .poweredOn{
            return true
        }else{
            return false
        }
    }
    func open(){
        BleManager.sharedManager().open()
    }
    func scan(){
        BleManager.sharedManager().searchDevices()
    }
    func stopScan(){
        BleManager.sharedManager().stopSearch()
    }
    func disconnect(){
        BleManager.sharedManager().disconnectToEquipment(model: BleManager.sharedManager().selectedEquipment, completion: nil)
    }
    func begainMatch(ssidString:String,pskString:String,bleEquipmentModel:BleEquipmentModel){
        if ssidString.isEmpty{
            return
        }
        ssid = ssidString
        psk = pskString
        BleManager.sharedManager().connectToEquipment(model: bleEquipmentModel) { (uuid, isSuccess) in
            if !isSuccess{
                self.sendPairFailed()
            }else{
                self.connectSuccess()
            }
        }
    }
    private func connectSuccess(){
        guard let services = BleManager.sharedManager().selectedEquipment?.peripheral?.services else {
            return
        }
        for s in services {
            guard let characteristics = s.characteristics else {
                return
            }
            for c in characteristics {
                if c.uuid.uuidString == LH_MATCHNET_CHAR_UUID {
                    self.currentCharacteristic = c
                    self.queryDeviceName()
                }
            }
        }
    }
    private func sendPairFailed(){
        addingHubsn = ""
        let model = BasicDeviceModel()
        model.type = .hub
        NotificationCenter.default.post(name: .NOTIFY_DEVICE_ADD_DEVICE_RESULT, object: nil, userInfo: ["addDeviceResult" : (model,false)])
    }
}
extension DUIBleGatewayManager {
    private func queryDeviceName(){
        guard let characteristic = currentCharacteristic else {
            return
        }
        guard let f = StellarWiFiFrame.createQueryDeviceNameFrame() else {
            return
        }
        BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
    }
    private func bindHubAndAccount(sn:String,resultBlock:((Bool)->Void)?){
        StellarUserStore.sharedStore.getDCAToken(success: { (jsonDic) in
            if let duiAccessToken = jsonDic["accessToken"] as? String,let duiRefreshToken = jsonDic["refreshToken"] as? String{
                DUIManager.sharedManager().bindSansiSmartHomeSkill(accessToken:duiAccessToken, refreshToken:duiRefreshToken, success: {
                    let duiHubDeviceModel =  DUIHubDeviceModel.init(json: dui_testDeviceInfo)
                    duiHubDeviceModel.deviceName = sn
                    DUIManager.sharedManager().bindDevice(device: duiHubDeviceModel, success: {
                        resultBlock?(true)
                    }, failure: {
                        resultBlock?(false)
                    })
                }) {
                    resultBlock?(false)
                }
            }else{
                resultBlock?(false)
            }
        }) { (error) in
            resultBlock?(false)
        }
    }
    private func sendDUIInfo(userid:String,authcode:String,codeVerify:String){
        guard let characteristic = currentCharacteristic else {
            return
        }
        guard let f = StellarWiFiFrame.createDUIInfoFrame(userid: userid, authcode: authcode, codeVerify: codeVerify) else {
            return
        }
        BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
    }
    private func sendAccountInfo(ssid:String,password:String){
        guard let characteristic = currentCharacteristic else {
            return
        }
        guard let f = StellarWiFiFrame.createFrame(wifiSSID: ssid, password: password) else {
            return
        }
        BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
    }
    private func sendServerInfo(){
        guard let characteristic = currentCharacteristic else {
            return
        }
        guard let f = StellarWiFiFrame.createFrame(url: StellarHomeResourceUrl.baseurl_device_url, port: StellarHomeResourceUrl.baseurl_device_port) else {
            return
        }
        BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
    }
    func sendDeviceToken(){
        DevicesStore.sharedStore().getDeviceRegisterToken(success: { (jsonDic) in
            if let token: String = jsonDic["registerToken"] as? String{
                guard let characteristic = self.currentCharacteristic else {
                    return
                }
                guard let f = StellarWiFiFrame.createFrame(token: token) else {
                    return
                }
                BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
            }else{
                self.sendPairFailed()
            }
        }) { (error) in
            self.sendPairFailed()
        }
    }
    func sendBegainRegistAction(){
        guard let characteristic = currentCharacteristic else {
            return
        }
        guard let f = StellarWiFiFrame.begainRegistAction() else {
            return
        }
        BleManager.sharedManager().writeValue(characteristic: characteristic, data: f.data)
    }
}