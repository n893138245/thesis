import UIKit
import CoreBluetooth
let STELLAR_BLE_PREFIX_POST: UInt8 = 0xA5
let STELLAR_BLE_SUFFIX_POST: UInt8 = 0x5A
let STELLAR_BLE_PREFIX_RECV: UInt8 = 0x35
let STELLAR_BLE_SUFFIX_RECV: UInt8 = 0x53
enum STELLAR_FUN_CODE: UInt8 {
    case SWITCHER_SET = 0x00
    case SWITCHER_GET = 0x80
    case DELAY_SET = 0x40
    case DELAY_GET = 0xC0
    case COLOR_SET = 0x01
    case COLOR_GET = 0x81
    case BRIGHTNESS_SET = 0x02
    case BRIGHTNESS_GET = 0x82
    case CCT_SET = 0x03
    case CCT_GET = 0x83
    case HEARTBEAT_POST = 0x11
    case SWITCHER_POST = 0x30
    case COLOR_POST = 0x31
    case BRIGHTNESS_POST = 0x32
    case CCT_POST = 0x33
    case SCENE_POST = 0x34
    case MODE_POST = 0x35
    case DEVICE_INFO_GET = 0x50
    case SN_GET = 0x51
    case UPGRADE_START = 0xF0
    case UPGRADE_DATA_SEND = 0xF1
    case UPGRADE_DATA_END = 0xF2
    case SWITCH_SOFTWARE = 0xF3
    case UNKNOWN = 0xFF
}
enum STELLAR_ACK_CODE: UInt8 {
    case SUCCESS = 0x00
    case FAILURE = 0x01
    case PARAMS_INVALID = 0x02
    case NOT_SUPPORT = 0x03
    case UNKNOWN = 0xFF
}
enum STELLAR_SEND_CODE: UInt8{
    case NEED_RESPONSE = 0x80
    case NO_RESPOSNSE = 0x00
    case UNKNOWN = 0xFF
}
extension Numeric {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
}
extension Data {
    var array: [UInt8] { return Array(self) }
}
extension Array where Element == UInt8{
    var uint16: UInt16 {
        let u16 = UnsafePointer([UInt8](self)).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee
        }
        return u16
    }
}
class StellarBleData: NSObject {
    var dataArr: [UInt8]
    var data: Data
    var prefix: UInt8 {
        return dataArr.first ?? 0xFF
    }
    var len: UInt16 {
        guard dataArr.count > 2 else {
            return 0xFFFF
        }
        return [UInt8](dataArr[1...2]).uint16
    }
    var sendCode: STELLAR_SEND_CODE {
        guard isStellarPost else {
            return .UNKNOWN
        }
        guard dataArr.count > 3 else {
            return .UNKNOWN
        }
        return STELLAR_SEND_CODE.init(rawValue: dataArr[3]) ?? .UNKNOWN
    }
    var ack: STELLAR_ACK_CODE {
        guard dataArr.count > 3 else {
            return .UNKNOWN
        }
        return STELLAR_ACK_CODE.init(rawValue: dataArr[3]) ?? .UNKNOWN
    }
    var seq: UInt8 {
        guard dataArr.count > 4 else {
            return 0xFF
        }
        return dataArr[4]
    }
    var code: STELLAR_FUN_CODE {
        guard dataArr.count > 5 else {
            return .UNKNOWN
        }
        return STELLAR_FUN_CODE.init(rawValue: dataArr[5]) ?? .UNKNOWN
    }
    var content: [UInt8] {
        guard dataArr.count > 7 else {
            return []
        }
        return [UInt8](dataArr[6...dataArr.count - 1 - 3])
    }
    var crc: UInt16 {
        guard dataArr.count > 2 else {
            return 0xFFFF
        }
        let crcArr : [UInt8] = [UInt8](dataArr[dataArr.count - 3...dataArr.count - 2])
        return crcArr.uint16
    }
    var suffix: UInt8 {
        return dataArr.last ?? 0xFF
    }
    var isStellarPost: Bool {
        return self.prefix == STELLAR_BLE_PREFIX_POST && self.suffix == STELLAR_BLE_SUFFIX_POST
    }
    var isStellarRecv: Bool {
        return self.prefix == STELLAR_BLE_PREFIX_RECV && self.suffix == STELLAR_BLE_SUFFIX_RECV
    }
    var isCrcCorrect: Bool {
        let crcCheckData: [UInt8] = [UInt8](self.dataArr[1...dataArr.count - 4])
        let crcCheck = CRC(buffer: crcCheckData, buffer_length: UInt64(crcCheckData.count)).bigEndian
        print("crcCheck: \(crcCheck.data.toHexString())   crc:\(crc.data.toHexString())  data: \(data.toHexString())  len: \(len.data.toHexString())")
        return crcCheck == crc
    }
    init(data: Data) {
        self.data = data
        self.dataArr = data.bytes
    }
    init(dataArr: [UInt8]) {
        self.dataArr = dataArr
        self.data = Data(bytes: dataArr, count: dataArr.count)
    }
    init(prefix: UInt8, ack: STELLAR_SEND_CODE = .NEED_RESPONSE, seq: UInt8, code: STELLAR_FUN_CODE, content: [UInt8], suffix: UInt8) {
        let len: UInt16 = UInt16(7 + content.count).bigEndian
        var tempDataArr: [UInt8] = []
        tempDataArr.append(contentsOf: len.data.array)
        tempDataArr.append(ack.rawValue)
        tempDataArr.append(seq)
        tempDataArr.append(code.rawValue)
        tempDataArr.append(contentsOf: content)
        let crcData = CRC(buffer: tempDataArr, buffer_length: UInt64(tempDataArr.count)).bigEndian
        self.dataArr = [UInt8]()
        self.dataArr.append(prefix)
        self.dataArr.append(contentsOf: tempDataArr)
        self.dataArr.append(contentsOf: crcData.data.bytes)
        self.dataArr.append(suffix)
        self.data = Data(bytes: dataArr, count: dataArr.count)
        print("crcCheck: \(crcData.data.toHexString())   crc:\(crcData.data.toHexString())  data: \(data.toHexString())")
        print("nxs ble \(self.data.toHexString() )")
    }
    static func setSwitcherData(seq: UInt8, switcher: String) -> StellarBleData {
        var switcherByte: UInt8 = 0x00
        if switcher == "on"{
            switcherByte = 0x01
        }else if switcher == "onOff"{
            switcherByte = 0x02
        }
        let content = [switcherByte]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .SWITCHER_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getSwitcherData(seq: UInt8) -> StellarBleData {
        let content = [UInt8(0xFF)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .SWITCHER_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func setDelayOffData(seq: UInt8, delay: Int) -> StellarBleData {
        let content: [UInt8] = UInt16(delay).bigEndian.data.array
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .DELAY_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getDelayOffData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = UInt16(0xFFFF).bigEndian.data.array
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .DELAY_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func setColorData(seq: UInt8, r: Int, g: Int, b: Int) -> StellarBleData {
        let content: [UInt8] = [UInt8(r), UInt8(g), UInt8(b)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .COLOR_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getColorData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = [UInt8(0xFF), UInt8(0xFF), UInt8(0xFF)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .COLOR_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func setBrightnessData(seq: UInt8, brightness: Int) -> StellarBleData {
        let setMode: UInt8 = 0x00
        let content: [UInt8] = [setMode, UInt8(brightness)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .BRIGHTNESS_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getBrightnessData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = [UInt8(0xFF), UInt8(0xFF)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .BRIGHTNESS_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func increaseBrightnessData(seq: UInt8, delta: Int) -> StellarBleData {
        let setMode: UInt8 = 0x01
        let content: [UInt8] = [setMode, UInt8(delta)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .BRIGHTNESS_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func decreaseBrightnessData(seq: UInt8, delta: Int) -> StellarBleData {
        let setMode: UInt8 = 0x02
        let content: [UInt8] = [setMode, UInt8(delta)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .BRIGHTNESS_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func setCCTData(seq: UInt8, cct: Int) -> StellarBleData {
        let setMode: UInt8 = 0x00
        let cctValue: [UInt8] = UInt16(cct).bigEndian.data.array
        var content: [UInt8] = []
        content.append(setMode)
        content.append(contentsOf: cctValue)
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .CCT_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getCCTData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = [UInt8(0xFF), UInt8(0xFF), UInt8(0xFF)]
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .CCT_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func increaseCCTData(seq: UInt8, delta: Int) -> StellarBleData {
        let setMode: UInt8 = 0x01
        let cctValue: [UInt8] = UInt16(delta).bigEndian.data.array
        var content: [UInt8] = []
        content.append(setMode)
        content.append(contentsOf: cctValue)
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .CCT_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func decreaseCCTData(seq: UInt8, delta: Int) -> StellarBleData {
        let setMode: UInt8 = 0x02
        let cctValue: [UInt8] = UInt16(delta).bigEndian.data.array
        var content: [UInt8] = []
        content.append(setMode)
        content.append(contentsOf: cctValue)
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .CCT_SET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getDeviceInfo(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = []
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .DEVICE_INFO_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func getSNData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = []
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .SN_GET, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func startUpgradeData(seq: UInt8, upgradeSwVersion: Int) -> StellarBleData {
        let content: [UInt8] = UInt16(upgradeSwVersion).bigEndian.data.array
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .UPGRADE_START, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func sendUpgradeContentData(seq: UInt8, offset: UInt32, data: Data) -> StellarBleData {
        var content: [UInt8] = []
        content.append(contentsOf: offset.bigEndian.data.bytes)
        content.append(contentsOf: data.bytes)
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .UPGRADE_DATA_SEND, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func finishUpgradeData(seq: UInt8, size: UInt32, fileCRC: UInt32) -> StellarBleData {
        var content: [UInt8] = []
        content.append(contentsOf: size.bigEndian.data.bytes)
        content.append(contentsOf: fileCRC.data.bytes)
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, seq: seq, code: .UPGRADE_DATA_END, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    static func switchFrimwareData(seq: UInt8) -> StellarBleData {
        let content: [UInt8] = []
        let model = StellarBleData.init(prefix: STELLAR_BLE_PREFIX_POST, ack: .NEED_RESPONSE, seq: seq, code: .SWITCH_SOFTWARE, content: content, suffix: STELLAR_BLE_SUFFIX_POST)
        return model
    }
    var isOn: Bool? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .SWITCHER_GET || self.code == .SWITCHER_SET || self.code == .SWITCHER_POST else{
            return nil
        }
        guard let switcherByte = content.last else {
            return nil
        }
        if switcherByte == 0x00 {
            return false
        }else if switcherByte == 0x01{
            return true
        }else{
            return nil
        }
    }
    var brightness: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .BRIGHTNESS_POST || self.code == .BRIGHTNESS_GET || self.code == .BRIGHTNESS_SET else{
            return nil
        }
        guard let briByte = content.last else {
            return nil
        }
        return Int(briByte)
    }
    var delayTime: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DELAY_SET || self.code == .DELAY_GET else{
            return nil
        }
        guard self.content.count == 4 else {
            return nil
        }
        let delayTimeBytes: [UInt8] = [UInt8](content[0...1])
        let result: UInt16 = delayTimeBytes.uint16.bigEndian
        return Int(result)
    }
    var restTime: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DELAY_SET || self.code == .DELAY_GET else{
            return nil
        }
        guard self.content.count == 4 else {
            return nil
        }
        let delayTimeBytes: [UInt8] = [UInt8](content[2...3])
        let result: UInt16 = delayTimeBytes.uint16.bigEndian
        return Int(result)
    }
    var color: UIColor? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .COLOR_SET || self.code == .COLOR_GET || self.code == .COLOR_POST else{
            return nil
        }
        guard self.content.count == 3 else {
            return nil
        }
        let r: Int = Int(content[0])
        let g: Int = Int(content[1])
        let b: Int = Int(content[2])
        return UIColor.ss.rgbColor(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    var cct: Int?{
        guard isStellarRecv == true else{
            return nil
        }
        guard ((self.code == .CCT_GET || self.code == .CCT_SET) && self.content.count == 3)
            || (self.code == .CCT_POST && self.content.count == 2) else{
            return nil
        }
        let cctBytes: [UInt8] = [UInt8](content[content.count-2...content.count-1])
        let result: UInt16 = cctBytes.uint16.bigEndian
        return Int(result)
    }
    var mac: String? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DEVICE_INFO_GET else{
            return nil
        }
        guard self.content.count == 13 else {
            return nil
        }
        let macDataArr: [UInt8] = [UInt8](content[0...5])
        return macDataArr.toHexString()
    }
    var fwType: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DEVICE_INFO_GET else{
            return nil
        }
        guard self.content.count == 13 else {
            return nil
        }
        let macDataArr: [UInt8] = [UInt8](content[6...7])
        return Int(macDataArr.uint16.bigEndian)
    }
    var hwVersion: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DEVICE_INFO_GET else{
            return nil
        }
        guard self.content.count == 13 else {
            return nil
        }
        let hwVersionByte: UInt8 = content[8]
        return Int(hwVersionByte)
    }
    var swVersion: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DEVICE_INFO_GET else{
            return nil
        }
        guard self.content.count == 13 else {
            return nil
        }
        let swVersionByte: [UInt8] = [UInt8](content[9...10])
        return Int(swVersionByte.uint16.bigEndian)
    }
    var newSwVersion: Int? {
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .DEVICE_INFO_GET else{
            return nil
        }
        guard self.content.count == 13 else {
            return nil
        }
        let swVersionByte: [UInt8] = [UInt8](content[11...12])
        return Int(swVersionByte.uint16.bigEndian)
    }
    var sn: String?{
        guard isStellarRecv == true else{
            return nil
        }
        guard self.code == .SN_GET else{
            return nil
        }
        guard self.content.count > 1 else {
            return nil
        }
        let len: Int = Int(content[0])
        guard self.content.count == len + 1 else{
            return nil
        }
        return String.init(data: Data.init([UInt8](content.suffix(from: 1))), encoding: .utf8)
    }
}
class BleEquipmentModel: Convertible {
    var name: String = ""
    var UUIDString: String = ""
    var macAddress: String = ""
    var peripheral: CBPeripheral?
    var fwType: String = ""
    var swVersion: String = ""
    var latestVersion: String = ""
    var sn: String = ""
    var mac: String = ""
    required init() {}
}
