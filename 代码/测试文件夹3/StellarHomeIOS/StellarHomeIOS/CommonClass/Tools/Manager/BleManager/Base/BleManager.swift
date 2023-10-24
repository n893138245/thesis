import UIKit
import CoreBluetooth
let kBlueToothCentralDidUpdateStateNotification = Notification.Name("kBlueToothCentralDidUpdateStateNotification")
let kBlueToothCentralDiscoverPeripheralUpdateNotification = Notification.Name("kBlueToothCentralDiscoverPeripheralUpdateNotification")
let kBlueToothCentralConnectUpdateNotification = Notification.Name("kBlueToothCentralConnectUpdateNotification")
let kBlueToothCentralDidDiscoverCharacteristicsNotification = Notification.Name("kBlueToothCentralDidDiscoverCharacteristicsNotification")
let kBlueToothCentralWriteResponse = Notification.Name("kBlueToothCentralWriteResponse")
let kBlueToothCentralDidSendValue = Notification.Name("kBlueToothCentralDidSendValue")
let kBlueToothCentralWriteError = Notification.Name("kBlueToothCentralWriteError")
class BleManager: NSObject {
    var timeTask:SSTimeTask?
    static private let instance = BleManager()
    private var centralManager:CBCentralManager?
    private let isLog = true
    var domesticDevices:Array<BleEquipmentModel>           
    var state:CBManagerState?                               
    var selectedEquipment:BleEquipmentModel?                
    var connectStateBlockDic = [String:((uuid:String,succ:Bool)->Void)]()
    var writeResultBlockDic = [String:(resultBlock:((isSuccess:Bool,bleData:StellarBleData?)->Void),interval:Int)]()
    class func sharedManager() -> BleManager {
        return instance
    }
    override init() {
        domesticDevices = []
        super.init()
        if timeTask == nil {
            timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 3, isRepeat: true) { [weak self] task in
                for (key, value) in self?.writeResultBlockDic ?? [String:(((Bool,StellarBleData?)->Void),Int)](){
                    let dataInterval = value.1
                    let nowDate = Date.init()
                    let interval = Int(nowDate.timeIntervalSince1970)
                    if (interval - dataInterval) >= 3 {
                        value.0(false,nil)
                        self?.writeResultBlockDic.removeValue(forKey:key)
                    }
                }
            }
        }
    }
    func open(){
        if centralManager == nil {
            centralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil)
        }
    }
    func searchDevices(){
        open()
        cleanUp()
        let option = ["1":CBCentralManagerScanOptionAllowDuplicatesKey]
        centralManager?.scanForPeripherals(withServices: nil, options: option)
        StellarBlePrint("-------scanForPeripherals")
    }
    func stopSearch(){
        centralManager?.stopScan()
        StellarBlePrint("-------stopScan")
    }
    func cleanUp(){
        centralManager?.stopScan()
        domesticDevices = []
        if selectedEquipment != nil{
            disconnectToEquipment(model: selectedEquipment, completion: nil)
            selectedEquipment = nil
        }
    }
    func connectToEquipment(model:BleEquipmentModel,completion:((_ uuid:String?,_ succ:Bool)->Void)?)
    {
        guard let peripheral = model.peripheral else {
            completion?(model.UUIDString,false)
            return
        }
        if peripheral.state == .connecting{
            return
        }
        if peripheral.state == .connected{
            completion?(model.UUIDString,true)
            return
        }
        centralManager?.connect(peripheral, options: nil)
        StellarBlePrint("-------connecting peripheral=\(peripheral.name ?? "")")
        connectStateBlockDic[peripheral.identifier.uuidString] = completion
        selectedEquipment = model
    }
    func disconnectToEquipment(model:BleEquipmentModel?,completion:((_ uuid:String?,_ succ:Bool)->Void)?){
        if model == nil{
            if completion != nil{
                completion!(nil,false)
            }
            return
        }
        if model?.peripheral == nil{
            if completion != nil{
                completion!(nil,false)
            }
            return
        }
        centralManager?.cancelPeripheralConnection(model!.peripheral!)
    }
    func writeValue(characteristic:CBCharacteristic,data:Data,resultBlock:((Bool,StellarBleData?)->Void)? = nil,seq:UInt8 = 0xFF)
    {
        StellarBlePrint("writeValue = \(data.toHexString())")
        DispatchQueue.main.async { [weak self] in
            self?.selectedEquipment?.peripheral?.writeValue(data, for: characteristic, type: .withResponse)
            let nowDate = Date.init()
            let interval = Int(nowDate.timeIntervalSince1970)
            let key = "\(seq)"
            if let actionBlock = resultBlock{
                self?.writeResultBlockDic[key] = (actionBlock,interval)
            }
        }
    }
    private func StellarBlePrint(_ message: String) {
        if isLog == true {
            DispatchQueue.global(qos: .default).async {
                print("Stellar_CoreBluetooth \(message)")
            }
        }
    }
}
extension BleManager:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            state = .unknown
            break
        case .resetting:
            state = .resetting
            break
        case .unsupported:
            state = .unsupported
            break
        case .unauthorized:
            state = .unauthorized
            break
        case .poweredOff:
            state = .poweredOff
            break
        case .poweredOn:
            state = .poweredOn
            break
        default:
            break
        }
        NotificationCenter.default.post(name: kBlueToothCentralDidUpdateStateNotification, object: nil)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let model = BleEquipmentModel()
        if let kCBAdvDataManufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
            if kCBAdvDataManufacturerData.count == 29 {
                let identification = String.init(data: Data.init(kCBAdvDataManufacturerData[(kCBAdvDataManufacturerData.count-11)...(kCBAdvDataManufacturerData.count-7)]), encoding: .utf8)
                if identification != "sansi" {
                    return
                }
                let fwtype = kCBAdvDataManufacturerData[(kCBAdvDataManufacturerData.count-6)...(kCBAdvDataManufacturerData.count-5)].toHexString().ss.hexTodec()
                let mac = kCBAdvDataManufacturerData[0...5].toHexString()
                if mac.isEmpty || fwtype.isEmpty || mac == "0"{
                    return
                }
                model.mac = mac
                model.fwType = fwtype
                model.peripheral = peripheral
            }
        }
        if model.peripheral == nil {
            return
        }
        model.UUIDString = peripheral.identifier.uuidString
        if !domesticDevicesContainsObject(equipmentModel: model){
            domesticDevices.append(model)
        }
        StellarBlePrint("-------发现 peripheral.name = \(String(describing: peripheral.name)) mac=\(model.mac) fwtype = \(model.fwType)")
        NotificationCenter.default.post(name: kBlueToothCentralDiscoverPeripheralUpdateNotification, object: nil)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        StellarBlePrint("-------连接成功 peripheral.name = \(String(describing: peripheral.name))")
        guard let hittedModel = domesticDevicesWithObject(peripheral: peripheral) else {
            return
        }
        selectedEquipment = hittedModel
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        NotificationCenter.default.post(name: kBlueToothCentralConnectUpdateNotification, object: hittedModel)
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        StellarBlePrint("-------断开连接 peripheral.name = \(String(describing: peripheral.name))")
        for (connectUUIDString,connectResultBlock) in connectStateBlockDic{
            if peripheral.identifier.uuidString == connectUUIDString {
                connectResultBlock(connectUUIDString,false)
                connectStateBlockDic.removeValue(forKey: connectUUIDString)
            }
        }
        NotificationCenter.default.post(name: kBlueToothCentralConnectUpdateNotification, object: peripheral)
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        StellarBlePrint("-------连接失败 peripheral.name = \(String(describing: peripheral.name))")
        NotificationCenter.default.post(name: kBlueToothCentralConnectUpdateNotification, object: nil)
    }
    private func domesticDevicesWithObject(peripheral:CBPeripheral) -> BleEquipmentModel?{
        for model in domesticDevices {
            if (model.peripheral != nil){
                if model.peripheral == peripheral
                {
                    return model
                }
            }else{
                if model.UUIDString == peripheral.identifier.uuidString{
                    model.peripheral = peripheral
                    return model
                }
            }
        }
        return nil
    }
    private func domesticDevicesContainsObject(equipmentModel:BleEquipmentModel) -> Bool
    {
        for model in domesticDevices {
            guard model.peripheral != nil else{
                return false
            }
            if equipmentModel.mac == model.mac{
                return true
            }
        }
        return false
    }
}
extension BleManager:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        StellarBlePrint("didReadRSSI peripheral=\(peripheral)")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        StellarBlePrint("didDiscoverServices peripheral=\(peripheral)")
        guard let services = peripheral.services else {
            return
        }
        for s in services {
            peripheral.discoverCharacteristics(nil, for: s)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        StellarBlePrint("didDiscoverCharacteristicsFor peripheral=\(peripheral)")
        guard let services = peripheral.services else {
            return
        }
        for s in services{
            guard let characteristics = s.characteristics else {
                return
            }
            for c in characteristics {
                if c.uuid.uuidString == LH_CONTROL_BLE_DESK_UUID {
                    peripheral.setNotifyValue(true, for: c)
                }else if c.uuid.uuidString == LH_MATCHNET_CHAR_UUID {
                    peripheral.setNotifyValue(true, for: c)
                }
            }
        }
        NotificationCenter.default.post(name: kBlueToothCentralDidDiscoverCharacteristicsNotification, object: nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        StellarBlePrint("didDiscoverDescriptorsFor peripheral=\(peripheral) error=\(String(describing: error))")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        StellarBlePrint("didUpdateValueFor peripheral=\(peripheral) error=\(String(describing: error))")
        guard let characteristicData = characteristic.value else {
            return
        }
        StellarBlePrint("didUpdateValueFor characteristicData = \(characteristicData.toHexString())")
        for (key, value) in writeResultBlockDic{
            let bleData = StellarBleData(data: characteristicData)
            if key == "\(bleData.seq)" {
                let resultBlock = value.resultBlock
                if error == nil {
                    resultBlock(true,bleData)
                }else{
                    resultBlock(false,nil)
                }
                writeResultBlockDic.removeValue(forKey:key)
            }
        }
        NotificationCenter.default.post(name: kBlueToothCentralWriteResponse, object:characteristicData )
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        StellarBlePrint("didWriteValueFor peripheral=\(peripheral) error=\(String(describing: error))")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        StellarBlePrint("didUpdateNotificationStateFor peripheral=\(peripheral) error=\(String(describing: error))")
        for (connectUUIDString,connectResultBlock) in connectStateBlockDic{
            if peripheral.identifier.uuidString == connectUUIDString {
                connectResultBlock(connectUUIDString,true)
                connectStateBlockDic.removeValue(forKey: connectUUIDString)
            }
        }
    }
}