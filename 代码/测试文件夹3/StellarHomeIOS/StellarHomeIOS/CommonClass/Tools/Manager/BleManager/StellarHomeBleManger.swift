import UIKit
let kBlueToothCentralLightStateNotification = Notification.Name("kBlueToothCentralLightStateNotification")
let kBlueToothCentralLightOffLineNotification = Notification.Name("kBlueToothCentralLightOffLineNotification")
let LH_CONTROL_BLE_DESK_UUID = "00010203-0405-0607-0873-616E73690002"
enum BLEFirmwareUpgradeState
{
    case kStateInit
    case kStateBegain
    case kStateSendPackage
    case kStateUpgradeFinish
    case kStateSwitchFirmware
    case kStateUpgradeSuccess
    case kStateUpgradeFail
}
class StellarHomeBleManger: NSObject {
    static let sharedManager = StellarHomeBleManger.init()
    private var seq:UInt8 = 0x00
    private var currentBleEquipmentModel:BleEquipmentModel?
    private var timeTask:SSTimeTask?
    private var isOnline = true
    private var firmwareUpgradeResultBlock:((_ upgradeState:BLEFirmwareUpgradeState,_ sendPer:CGFloat)->Void?)?
    var myUpgradeState = BLEFirmwareUpgradeState.kStateInit{
        didSet{
            switchFirmwareUpgradeState()
        }
    }
    private var firmBinData: Data =  Data()
    private var sendPackageIndex = 1 
    private let aveOffset =  128 
    override init() {
        super.init()
        setupData()
    }
    func setupData(){
        setupBleResponse()
        setupTimeTask()
        setupBleConnectUpdate()
    }
    func setupBleResponse(){
        let _ = NotificationCenter.default.rx.notification(kBlueToothCentralWriteResponse).takeUntil(self.rx.deallocated).subscribe(onNext: { notification in
            guard let data = notification.object as? Data else {
                return
            }
            let characteristicData = data.suffix(from: 4)
            let bleData = StellarBleData(data: characteristicData)
            if !bleData.isStellarRecv || !bleData.isCrcCorrect{
                return
            }
            if bleData.code == .HEARTBEAT_POST {
                let state = self.getBleEquipmentState()
                if state == CBPeripheralState.connecting || state == CBPeripheralState.connected {
                    self.isOnline = true
                }
            }
            if bleData.code == .SWITCHER_POST || bleData.code == .COLOR_POST || bleData.code == .BRIGHTNESS_POST || bleData.code == .CCT_POST || bleData.code == .SCENE_POST || bleData.code == .MODE_POST{
                self.sendLightStateChange(bleData)
            }
        })
    }
    private func sendLightStateChange(_ bleData:StellarBleData){
        let light = LightModel()
        var isChangeState = false
        if let color = bleData.color{
            light.status.color.r = Int(color.red * 255)
            light.status.color.g = Int(color.green * 255)
            light.status.color.b = Int(color.blue * 255)
            isChangeState = true
        }
        if let isOn = bleData.isOn{
            light.status.onOff = isOn ? "on":"off"
            isChangeState = true
        }
        if let brightness = bleData.brightness{
            light.status.brightness = brightness
            isChangeState = true
        }
        if let cct = bleData.cct{
            light.status.cct = cct
            isChangeState = true
        }
        if isChangeState == true {
            NotificationCenter.default.post(name: kBlueToothCentralLightStateNotification, object: light)
        }
    }
    func setupTimeTask(){
        if timeTask == nil {
            timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 30, isRepeat: true) { [weak self] task in
                if self?.isOnline ?? true{
                    self?.isOnline = false
                }else{
                    if self?.getBleEquipmentState() == .disconnected || self?.getBleEquipmentState() == .disconnecting {
                        NotificationCenter.default.post(name: kBlueToothCentralLightOffLineNotification, object: nil)
                    }
                }
            }
        }
    }
    func setupBleConnectUpdate(){
        let _ = NotificationCenter.default.rx.notification(kBlueToothCentralConnectUpdateNotification).takeUntil(self.rx.deallocated).subscribe(onNext: {[weak self] notification in
            guard let disconnectedPeripheral = notification.object as? CBPeripheral else {
                return
            }
            if disconnectedPeripheral == self?.currentBleEquipmentModel?.peripheral{
                NotificationCenter.default.post(name: kBlueToothCentralLightOffLineNotification, object: nil)
            }
        })
    }
    func getMySeq() -> UInt8 {
        var mySeq = seq
        if mySeq == 0xff {
            mySeq = 0x00
        }else{
            mySeq += 1
        }
        seq = mySeq
        return mySeq
    }
    func getScanDevices() -> [BleEquipmentModel]{
        return BleManager.sharedManager().domesticDevices
    }
    func isOpenBlueTooth() -> Bool{
        if BleManager.sharedManager().state == .poweredOn{
            return true
        }else{
            return false
        }
    }
    func getBleManagerState() -> CBManagerState?{
        return BleManager.sharedManager().state
    }
    func getBleEquipmentState() -> CBPeripheralState{
        guard let peripheral = currentBleEquipmentModel?.peripheral else {
            return .disconnected
        }
        return peripheral.state
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
    func cleanUp(){
        BleManager.sharedManager().cleanUp()
    }
    func connectToEquipment(model:BleEquipmentModel,completion:((_ uuid:String?,_ succ:Bool)->Void)?){
        BleManager.sharedManager().connectToEquipment(model: model) { (uuid, succ) in
            self.currentBleEquipmentModel = model
            completion?(uuid,succ)
        }
    }
    func connectToLight(lightModel:LightModel,completion:((_ uuid:String?,_ succ:Bool)->Void)?){
        let scanDevices = getScanDevices().filter{$0.mac == lightModel.mac}
        guard let connectedBleModel = scanDevices.first  else {
            return
        }
        BleManager.sharedManager().connectToEquipment(model: connectedBleModel) { (uuid, succ) in
            self.currentBleEquipmentModel = connectedBleModel
            completion?(uuid,succ)
        }
    }
    func disconnectToLight(lightModel:LightModel,completion:((_ uuid:String?,_ succ:Bool)->Void)?){
        guard let connectedBleModel = self.getScanDevices().first  else {
            return
        }
        BleManager.sharedManager().disconnectToEquipment(model: connectedBleModel) { (uuid, succ) in
            self.currentBleEquipmentModel = connectedBleModel
            completion?(uuid,succ)
        }
    }
    private func writeValue(bleEquipmentModel:BleEquipmentModel,uuidString:String,bleData:StellarBleData,resultBlock:((Bool,StellarBleData?)->Void)? = nil){
        guard let services = bleEquipmentModel.peripheral?.services else {
            resultBlock?(false,bleData)
            return
        }
        for s in services{
            guard let characteristics = s.characteristics else {
                return
            }
            for c in characteristics {
                if c.uuid.uuidString == uuidString {
                    BleManager.sharedManager().writeValue(characteristic: c, data: bleData.data, resultBlock: { (isSuccess,bleData) in
                        resultBlock?(isSuccess,bleData)
                    }, seq: bleData.seq)
                    break
                }
            }
        }
    }
}
extension StellarHomeBleManger {
    func openCloseLight(light:LightModel,isOpen:Bool,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.setSwitcherData(seq: StellarHomeBleManger.sharedManager.getMySeq(), switcher: isOpen ? "on":"off")
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let isOn = bleData?.isOn else {
                resultBlock?(false,light)
                return
            }
            light.status.onOff = isOn ? "on":"off"
            resultBlock?(isSuccess,light)
        }
    }
    func queryOpenCloseLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getSwitcherData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let isOn = bleData?.isOn else {
                resultBlock?(false,light)
                return
            }
            light.status.onOff = isOn ? "on" : "off"
            resultBlock?(isSuccess,light)
        }
    }
    func setupDelayCloseLight(light:LightModel,delay:Int,resultBlock:((_ isSuccess:Bool,_ light:LightModel,_ delay:Int?)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.setDelayOffData(seq: StellarHomeBleManger.sharedManager.getMySeq(), delay: delay)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let delay = bleData?.delayTime else {
                resultBlock?(false,light, nil)
                return
            }
            resultBlock?(isSuccess,light,delay)
        }
    }
    func queryDelayCloseLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel,_ delay:Int?,_ restTime:Int?)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getDelayOffData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let delay = bleData?.delayTime  else {
                resultBlock?(false,light, nil, nil)
                return
            }
            guard let restTime = bleData?.restTime  else {
                resultBlock?(false,light, nil, nil)
                return
            }
            resultBlock?(isSuccess,light,delay,restTime)
        }
    }
    func setupColorLight(light:LightModel,color:(r: Int,g: Int,b: Int),resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.setColorData(seq: StellarHomeBleManger.sharedManager.getMySeq(), r: color.r, g: color.g, b: color.b)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let color = bleData?.color else {
                resultBlock?(false,light)
                return
            }
            light.status.color.r = Int(color.red * 255)
            light.status.color.g = Int(color.green * 255)
            light.status.color.b = Int(color.blue * 255)
            resultBlock?(isSuccess,light)
        }
    }
    func queryColorLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getColorData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let color = bleData?.color else {
                resultBlock?(false,light)
                return
            }
            light.status.color.r = Int(color.red * 255)
            light.status.color.g = Int(color.green * 255)
            light.status.color.b = Int(color.blue * 255)
            resultBlock?(isSuccess,light)
        }
    }
    func setupBrightnessLight(light:LightModel,brightness:Int,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.setBrightnessData(seq: StellarHomeBleManger.sharedManager.getMySeq(), brightness: brightness)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let brightness = bleData?.brightness else {
                resultBlock?(false,light)
                return
            }
            light.status.brightness = brightness
            resultBlock?(isSuccess,light)
        }
    }
    func queryBrightnessLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getBrightnessData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let brightness = bleData?.brightness else {
                resultBlock?(false,light)
                return
            }
            light.status.brightness = brightness
            resultBlock?(isSuccess,light)
        }
    }
    func setupCCTLight(light:LightModel,cct:Int,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.setCCTData(seq: StellarHomeBleManger.sharedManager.getMySeq(), cct: cct)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let cct = bleData?.cct else {
                resultBlock?(false,light)
                return
            }
            light.status.cct = cct
            resultBlock?(isSuccess,light)
        }
    }
    func queryCCTLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getCCTData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let cct = bleData?.cct else {
                resultBlock?(false,light)
                return
            }
            light.status.cct = cct
            resultBlock?(isSuccess,light)
        }
    }
    func queryInfoLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getDeviceInfo(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let mac = bleData?.mac else {
                resultBlock?(false,light)
                return
            }
            guard let fwType = bleData?.fwType else {
                resultBlock?(false,light)
                return
            }
            guard let swVersion = bleData?.swVersion else {
                resultBlock?(false,light)
                return
            }
            guard let hwVersion = bleData?.hwVersion else {
                resultBlock?(false,light)
                return
            }
            guard let newSwVersion = bleData?.newSwVersion else {
                resultBlock?(false,light)
                return
            }
            light.mac = mac
            light.fwType = fwType
            light.swVersion = swVersion
            light.hwVersion = hwVersion
            resultBlock?(isSuccess,light)
        }
    }
    func querySNLight(light:LightModel,resultBlock:((_ isSuccess:Bool,_ light:LightModel)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.getSNData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            guard let sn = bleData?.sn else {
                resultBlock?(false,light)
                return
            }
            light.sn = sn
            resultBlock?(isSuccess,light)
        }
    }
    private func startUpgradeData(upgradeSwVersion:Int, resultBlock:((_ isSuccess:Bool)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.startUpgradeData(seq: StellarHomeBleManger.sharedManager.getMySeq(), upgradeSwVersion: upgradeSwVersion)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            let isSuccess = (bleData?.ack == .SUCCESS)
            resultBlock?(isSuccess)
        }
    }
    private func upgradeData(offset: UInt32, data: Data, resultBlock:((_ isSuccess:Bool)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.sendUpgradeContentData(seq: StellarHomeBleManger.sharedManager.getMySeq(), offset: offset, data: data)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            let isSuccess = (bleData?.ack == .SUCCESS)
            resultBlock?(isSuccess)
        }
    }
    private func finishUpgradeData(size: UInt32, resultBlock:((_ isSuccess:Bool)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.finishUpgradeData(seq: StellarHomeBleManger.sharedManager.getMySeq(), size: size, fileCRC: 0xFFFFFFFF)
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            let isSuccess = (bleData?.ack == .SUCCESS)
            resultBlock?(isSuccess)
        }
    }
    private func switchFrimwareData(resultBlock:((_ isSuccess:Bool)->Void)? = nil){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        let bleData = StellarBleData.switchFrimwareData(seq: StellarHomeBleManger.sharedManager.getMySeq())
        writeValue(bleEquipmentModel: connectedBleModel, uuidString: LH_CONTROL_BLE_DESK_UUID, bleData: bleData) { (isSuccess,bleData) in
            let isSuccess = (bleData?.ack == .SUCCESS)
            resultBlock?(isSuccess)
        }
    }
}
extension StellarHomeBleManger {
    func begainBLEFirmwareUpgrade(light:LightModel,upgradeSwVersion:Int,data: Data,resultBlock: ((_ upgradeState:BLEFirmwareUpgradeState,_ sendPer:CGFloat)->Void)?){
        guard let connectedBleModel = self.currentBleEquipmentModel  else {
            return
        }
        if connectedBleModel.mac != light.mac {
            return
        }
        sendPackageIndex = 0
        firmBinData = data
        firmwareUpgradeResultBlock = resultBlock
        myUpgradeState = .kStateBegain
        startUpgradeData(upgradeSwVersion: upgradeSwVersion) { (isSucc) in
            self.myUpgradeState = isSucc ? .kStateSendPackage : .kStateUpgradeFail
        }
    }
    private func switchFirmwareUpgradeState(){
        switch myUpgradeState {
        case .kStateInit:
            break
        case .kStateBegain:
            firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateBegain,0)
            break
        case .kStateSendPackage:
            self.sendPackage()
            break
        case .kStateUpgradeFinish:
            firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateUpgradeFinish,0)
            upgradeFinish()
            break
        case .kStateSwitchFirmware:
            firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateSwitchFirmware,0)
            switchFirmware()
            break
        case .kStateUpgradeSuccess:
            firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateUpgradeSuccess,0)
            break
        case .kStateUpgradeFail:
            firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateUpgradeFail,0)
            break
        }
    }
    private func sendPackage(){
        let fitstSendDataRange: Range = 0 ..< aveOffset
        let sendData = firmBinData.subdata(in: fitstSendDataRange)
        sendEveryUpgradeData(offset: 0, data: sendData) { (isSucc) in
            self.myUpgradeState = isSucc ? .kStateUpgradeFinish : .kStateUpgradeFail
        }
    }
    private func upgradeFinish(){
        StellarHomeBleManger.sharedManager.finishUpgradeData(size: UInt32(firmBinData.count)) { (isSucc) in
            self.myUpgradeState = isSucc ? .kStateSwitchFirmware : .kStateUpgradeFail
        }
    }
    private func switchFirmware(){
        StellarHomeBleManger.sharedManager.switchFrimwareData() { (isSucc) in
            self.myUpgradeState = isSucc ? .kStateUpgradeSuccess : .kStateUpgradeFail
        }
    }
    private func sendEveryUpgradeData(offset: UInt32, data: Data, resultBlock:((_ isSuccess:Bool)->Void)? = nil){
        StellarHomeBleManger.sharedManager.upgradeData(offset: offset, data: data) { (isSucc) in
            let upgradeTotalNum = (self.firmBinData.count % self.aveOffset == 0) ? self.firmBinData.count/self.aveOffset :(self.firmBinData.count/self.aveOffset + 1)
            let per = CGFloat(self.sendPackageIndex) / CGFloat(upgradeTotalNum)
            self.firmwareUpgradeResultBlock?(BLEFirmwareUpgradeState.kStateSendPackage,per.ss.truncate(places: 3))
            if isSucc{
                if (self.sendPackageIndex + 1) != upgradeTotalNum{
                    let reoffset = (self.sendPackageIndex) * self.aveOffset
                    let reRange = self.sendPackageIndex * self.aveOffset ..< (self.sendPackageIndex + 1) * self.aveOffset
                    let reData = self.firmBinData.subdata(in: reRange)
                    self.sendPackageIndex += 1
                    self.sendEveryUpgradeData(offset: UInt32(reoffset), data: reData,resultBlock: resultBlock)
                }else{
                    let lastRange = self.sendPackageIndex * self.aveOffset ..< self.firmBinData.count
                    let lastData = self.firmBinData.subdata(in: lastRange)
                    StellarHomeBleManger.sharedManager.upgradeData(offset: UInt32(self.firmBinData.count - lastData.count), data: lastData) { (isSucc) in
                        resultBlock?(isSucc)
                    }
                }
            }else{
                resultBlock?(false)
            }
        }
    }
}