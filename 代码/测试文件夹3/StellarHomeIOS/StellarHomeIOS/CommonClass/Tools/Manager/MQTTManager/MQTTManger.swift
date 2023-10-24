import UIKit
import CocoaMQTT
protocol MQTTMangerNotifyDelegate: NSObjectProtocol {
    func didReceiveStatusUpated(json: JSON)
    func didReceiveDeviceSearch(json: JSON)
    func didReceiveDeviceAddResult(json: JSON)
}
class MQTTManger: NSObject {
    private let StellarHomeMQTTHost: String = StellarHomeResourceUrl.mqtt_host;
    private let StellarHomeMQTTPort: UInt16 = 8883;
    private let logOn = true
    class func sharedManager() -> MQTTManger {
        return instance
    }
    static private let instance: MQTTManger = MQTTManger()
    private var messageCache: [(topic: String, json: JSON ,qos: CocoaMQTTQOS )] = []
    private var connectedCache: (success: (()->Void)?, failure: ((String)->Void)?)?
    private var resultsClonsureCache: [(requestID: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?, startTime: Date)] = []
    lazy var mqtt: CocoaMQTT = {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        let temp = CocoaMQTT(clientID: clientID, host: StellarHomeMQTTHost, port: StellarHomeMQTTPort)
        temp.autoReconnect = true
        temp.username = StellarHomeResourceUrl.mqttUserName
        temp.password = StellarHomeResourceUrl.mqttUserPassword
        temp.willMessage = CocoaMQTTWill(topic: "/die", message: "dieout")
        temp.keepAlive = 180
        temp.delegate = self
        temp.dispatchQueue = DispatchQueue.global()
        temp.enableSSL = true
        temp.allowUntrustCACertificate = true
        let clientCertArray = getClientCertFromP12File(certName: StellarHomeResourceUrl.mqttCerName, certPass: "123456")
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        temp.sslSettings = sslSettings
        return temp
    }()
    weak var delegate: MQTTMangerNotifyDelegate?
    func disConnectMQTTBroker() {
        if mqtt.connState == .connected {
            mqtt.disconnect()
        }
    }
    func connectMQTTBroker(success: (()->Void)?, failure: ((String)->Void)?) {
        switch mqtt.connState{
        case .initial:
            let _ = mqtt.connect()
            connectedCache = (success, failure)
            break
        case .connecting:
            connectedCache = (success, failure)
            break
        case .connected:
            success?()
        case .disconnected:
            let _ = mqtt.connect()
            connectedCache = (success, failure)
        @unknown default:
            break
        }
    }
    func getClientCertFromP12File(certName: String, certPass: String) -> CFArray? {
        let resourcePath = Bundle.main.path(forResource: certName, ofType: "p12")
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            print("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        let key = kSecImportExportPassphrase as String
        let options : NSDictionary = [key: certPass]
        var items : CFArray?
        let securityError = SecPKCS12Import(p12Data, options, &items)
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                print("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                print("Failed to open the certificate file: \(certName).p12")
            }
            return nil
        }
        guard let theArray = items, CFArrayGetCount(theArray) > 0 else {
            return nil
        }
        let dictionary = (theArray as NSArray).object(at: 0)
        guard let identity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) else {
            return nil
        }
        let certArray = [identity] as CFArray
        return certArray
    }
    func onOffAction(device: LightModel, onOff: Bool, success: (()->Void)?, failure: ((ErrorCode)->Void)?){
        let detail = ExecutionDetail()
        detail.command = .onOff
        let param = ExecutionDetailParams()
        param.onOff = onOff ? "on":"off"
        detail.params = param
        let excution = ExecutionModel()
        excution.device = device.sn
        excution.execution = [detail]
        sendAction(gatewaySn: device.gatewaySn, device: device, executions: excution, success: success, failure: failure)
    }
    func subscribeGateway(sn: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        connectMQTTBroker(success: {
            self.mqtt.subscribe([
                ("notify/change/\(sn)/#", .qos0),
                ("notify/status/\(sn)/#", .qos0),
                ("notify/deviceAdd/\(sn)/#", .qos1)])
            self.resultsClonsureCache.append((sn, success, failure, Date.init()))
        }) { (_) in
            return
        }
    }
    func subscribeNoGatewayDevice(sn: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        connectMQTTBroker(success: {
            self.mqtt.subscribe([
                ("notify/change/noGateway/+/+/\(sn)", .qos0),
                ("notify/status/noGateway/+/+/\(sn)", .qos0)])
            self.resultsClonsureCache.append((sn, success, failure, Date.init()))
        }) { (_) in
            return
        }
    }
    func subscribeNoGateWayDeviceAdd(sn: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        if self.mqtt.subscriptions.contains(where: { (arg0) -> Bool in
            let (topic, _) = arg0
            return topic == "notify/deviceAdd/noGateway/+/\(sn)"
        }) {
            return
        }
        connectMQTTBroker(success: {
            self.mqtt.subscribe([("notify/deviceAdd/noGateway/+/\(sn)", .qos0)])
            self.resultsClonsureCache.append((sn, success, failure, Date.init()))
        }) { (_) in
            return
        }
    }
    func subscribeGatewaySearchDevice(sn: String, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        connectMQTTBroker(success: {
            self.mqtt.subscribe([
                ("notify/search/\(sn)/#", .qos1)])
            self.resultsClonsureCache.append((sn, success, failure, Date.init()))
        }) { (_) in
            return
        }
    }
    func unsubscribeGatewaySearchDevice(sn: String) {
        mqtt.unsubscribe("notify/search/\(sn)/#")
    }
    func unsubscribeGateway(sn: String) {
        mqtt.unsubscribe("notify/change/\(sn)/#")
        mqtt.unsubscribe("notify/status/\(sn)/#")
        mqtt.unsubscribe("notify/search/\(sn)/#")
        mqtt.unsubscribe("notify/deviceAdd/\(sn)/#")
    }
    func unsubscribeNoGatewayDevice(sn: String) {
        mqtt.unsubscribe("notify/change/noGateway/+/+/\(sn)")
        mqtt.unsubscribe("notify/status/noGateway/+/+/\(sn)")
        mqtt.unsubscribe("notify/search/noGateway/+/\(sn)")
    }
    func unsubscribeNoGatewayDeviceAdd(sn: String) {
        mqtt.unsubscribe("notify/deviceAdd/noGateway/+/\(sn)")
    }
    private func publishMessage(topic: String, json: JSON ,qos: CocoaMQTTQOS = .qos0) {
        switch mqtt.connState {
        case .connected:
            mqtt.publish(topic, withString: json.rawString([.castNilToNSNull: true])!, qos: qos)
        case .connecting:
            messageCache.append((topic: topic, json: json, qos: qos))
        case .disconnected, .initial:
            connectMQTTBroker(success: {
                self.messageCache.append((topic: topic, json: json, qos: qos))
            }) { (message) in
                self.messageCache.append((topic: topic, json: json, qos: qos))
            }
        default:
            break;
        }
    }
    private func sendAction(gatewaySn: String, device: BasicDeviceModel, executions: ExecutionModel, success: (()->Void)?, failure: ((ErrorCode)->Void)?) {
        for execution in executions.execution {
            if device.traits?.contains(execution.command) ?? false{
                let topic = "action/\(gatewaySn)/\(device.type)/\(execution.command)/\(device.sn)"
                var message: JSON = [:];
                let requestID = UUID().uuidString
                message["requestID"] = JSON(requestID)
                if let temp = execution.params{
                    message["params"] = JSON(temp);
                }
                publishMessage(topic: topic, json: message)
                resultsClonsureCache.append((requestID: requestID, success: success, failure: failure, startTime: Date.init()))
            }
        }
    }
    private func doCachedMessage() {
        for (topic, json, qos) in messageCache {
            publishMessage(topic: topic, json: json, qos: qos)
        }
        messageCache.removeAll()
    }
    private func actionConfirm(responseID: String, payload: JSON) {
        let errorCode: ErrorCode = ErrorCode.init(rawValue: payload["code"].intValue) ?? .unknownError
        let targetResults = resultsClonsureCache.filter {$0.requestID == responseID}
        if targetResults.first != nil{
            if let targetResult = targetResults.first{
                if errorCode == .success{
                    if let temp = targetResult.success{
                        temp()
                    }
                }else{
                    if let temp = targetResult.failure{
                        temp(errorCode)
                    }
                }
                resultsClonsureCache = resultsClonsureCache.filter{$0.requestID != responseID}
            }
        }
    }
    private func notifyChange(gatewaySN: String, deviceType: DeviceType, paramType: String, deviceSN: String, payload: JSON) {
        var finalJson: JSON = [:]
        let paramJson: JSON = [paramType : payload["value"]]
        if paramType == "swVersion" {
            finalJson = paramJson
        }else if paramType == "upgradeProgress" {
            guard let progress = payload["value"].int else { return }
            NotificationCenter.default.post(name: .NOTIFY_UPGRADEPROGRESS, object: nil, userInfo: ["upgradeProgress" : progress,"sn":deviceSN])
        }else{
            finalJson["status"] = paramJson
        }
        finalJson["gatewaySn"] = JSON(gatewaySN)
        finalJson["sn"] = JSON(deviceSN)
        if deviceType != .unknown  {
            finalJson["type"] = JSON(deviceType.rawValue)
        }
        delegate?.didReceiveStatusUpated(json: finalJson)
    }
    private func notifyDeviceAdd(gatewaySN: String, deviceType: DeviceType, deviceMac: String, payload: JSON) {
        var finalJson: JSON = [:]
        finalJson["result"] = payload
        finalJson["gatewaySn"] = JSON(gatewaySN)
        finalJson["mac"] = JSON(deviceMac)
        if deviceType != .unknown  {
            finalJson["type"] = JSON(deviceType.rawValue)
        }
        delegate?.didReceiveDeviceAddResult(json: finalJson)
    }
    private func notifyStatus(gatewaySN: String, deviceType: DeviceType, paramType: String, deviceSN: String, payload: JSON) {
        var finalJson: JSON = [:]
        let paramJson: JSON = [paramType : payload["value"]]
        finalJson["status"] = paramJson
        finalJson["gatewaySn"] = JSON(gatewaySN)
        finalJson["sn"] = JSON(deviceSN)
        if deviceType != .unknown  {
            finalJson["type"] = JSON(deviceType.rawValue)
        }
        if paramType == "radarLocationInfo" {
            guard let radarLocationArr = payload["value"].arrayObject else { return }
            NotificationCenter.default.post(name: .NOTIFY_RADARLOCATIONINFO, object: nil, userInfo: ["radarLocationInfo" : radarLocationArr])
        }
        delegate?.didReceiveStatusUpated(json: finalJson)
    }
    private func notifySearch(gatewaySN: String, deviceType: DeviceType, deviceMac: String, payload: JSON) {
        var finalJson: JSON = payload
        finalJson["gatewaySn"] = JSON(gatewaySN)
        finalJson["mac"] = JSON(deviceMac)
        if deviceType != .unknown  {
            finalJson["type"] = JSON(deviceType.rawValue)
        }
        print("search mac=\(JSON(deviceMac)) === \(finalJson.rawValue)")
        delegate?.didReceiveDeviceSearch(json: finalJson)
    }
    private func MQTTPrint(_ message: String) {
        if logOn == true{
            print("nxs MQTT \(message)")
        }else{
            return
        }
    }
    deinit {
        MQTTPrint("\(#function)");
    }
}
extension MQTTManger: CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        let index: CFIndex = SecTrustGetCertificateCount(trust)
        let cerUrl = URL(fileURLWithPath:StellarHomeResourceUrl.mqttCerPath)
        guard let localCertificateData = try? Data(contentsOf: cerUrl) else{
            completionHandler(false)
            return
        }
        var result: Bool = false
        for i in 0..<Int(index){
            let certificate = SecTrustGetCertificateAtIndex(trust, i)!
            let remoteCertificateData
                = SecCertificateCopyData(certificate) as Data
            if remoteCertificateData == localCertificateData{
                result = true
                break
            }
        }
        if result == true {
            completionHandler(true)
        }else{
            completionHandler(false)
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        MQTTPrint("didConnectAck: \(ack.description)" );
        if ack == .accept {
            for device in DevicesStore.sharedStore().gateways{
                self.subscribeGateway(sn: device.sn ,success:nil, failure: nil)
            }
        }
        DispatchQueue.main.async {
            if let temp = self.connectedCache?.success{
                temp()
            }
            self.connectedCache = nil
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        MQTTPrint("didPublishMessage: \(message.string ?? "")");
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        MQTTPrint("didPublishAck: \(id)");
    }
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        MQTTPrint("didReceiveMessage which Topic:\(message.topic) Message:\(message.string ?? "")" );
        DispatchQueue.main.async {
            let topicItems = message.topic.components(separatedBy: "/")
            let payload: JSON = JSON.init(parseJSON: message.string!)
            if let firstSring = topicItems.first {
                if firstSring == "notify"{
                    if topicItems.count > 1 {
                        let type: String = topicItems[1];
                        switch type {
                        case "status":
                            if topicItems.count > 4{
                                let gatewaySN = topicItems[2]
                                let deviceType = DeviceType.init(rawValue: topicItems[3]) ?? .unknown
                                let paramType = topicItems[4]
                                let deviceSn = topicItems[5]
                                self.notifyStatus(gatewaySN: gatewaySN, deviceType: deviceType, paramType: paramType, deviceSN: deviceSn, payload: payload)
                            }
                        case "change":
                            if topicItems.count > 5 {
                                let gatewaySN = topicItems[2]
                                let deviceType = DeviceType.init(rawValue: topicItems[3]) ?? .unknown
                                let paramType = topicItems[4]
                                let deviceSn = topicItems[5]
                                self.notifyChange(gatewaySN: gatewaySN, deviceType: deviceType, paramType: paramType, deviceSN: deviceSn, payload: payload)
                            }
                        case "search":
                            if topicItems.count > 4{
                                let gatewaySN = topicItems[2]
                                let deviceType = DeviceType.init(rawValue: topicItems[3]) ?? .unknown
                                let deviceSn = topicItems[4]
                                self.notifySearch(gatewaySN: gatewaySN, deviceType: deviceType, deviceMac: deviceSn, payload: payload)
                            }
                        case "deviceAdd":
                            if topicItems.count > 4 {
                                let gatewaySN = topicItems[2]
                                let deviceType = DeviceType.init(rawValue: topicItems[3]) ?? .unknown
                                let deviceMac = topicItems[4]
                                self.notifyDeviceAdd(gatewaySN: gatewaySN, deviceType: deviceType, deviceMac: deviceMac, payload: payload)
                            }
                        default:
                            break
                        }
                    }
                }else if firstSring == "confirm"{
                    if topicItems.count > 1 {
                        let responseID = topicItems[1];
                        self.actionConfirm(responseID: responseID, payload: payload)
                    }
                }
            }
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        MQTTPrint("didSubscribeTopic: \(topics)" );
        if topics.contains(where: {$0.contains("action")}) == true{
            doCachedMessage()
        }else if topics.contains(where: {$0.contains("noGateway")}) == true {
            if let topicItems = topics.first(where: {$0.contains("notify")})?.components(separatedBy: "/"){
                if topicItems.count >= 3 {
                    let targetSn = topicItems.last
                    if let action = resultsClonsureCache.first(where: {$0.requestID == targetSn}){
                        DispatchQueue.main.async {
                            if let temp = action.success{
                                temp()
                            }
                        }
                    }
                }
            }
        }else if topics.contains(where: {$0.contains("notify")}) == true{
            if let topicItems = topics.first(where: {$0.contains("notify")})?.components(separatedBy: "/"){
                if topicItems.count >= 3 {
                    let targetSn = topicItems[2]
                    if let action = resultsClonsureCache.first(where: {$0.requestID == targetSn}){
                        DispatchQueue.main.async {
                            if let temp = action.success{
                                temp()
                            }
                        }
                    }
                }
            }
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        mqtt.subscriptions.removeValue(forKey: topic)
        MQTTPrint("didUnsubscribeTopic: \(topic)" );
    }
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        MQTTPrint("mqttDidPing");
    }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        MQTTPrint("mqttDidReceivePong");
    }
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        MQTTPrint("didDisconnect: \(String(describing: err))" );
        DispatchQueue.main.async {
            if let temp = self.connectedCache?.failure{
                temp(err.debugDescription)
                self.connectedCache = nil
            }
        }
    }
}
