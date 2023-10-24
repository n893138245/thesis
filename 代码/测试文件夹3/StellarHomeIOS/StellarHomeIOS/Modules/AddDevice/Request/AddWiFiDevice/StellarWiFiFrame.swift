import UIKit
class StellarWiFiFrame {
    private let length_length: Int = 2
    private let mac_length: Int = 8
    private let code_length: Int = 1
    private let crc_length: Int = 2
    private let prefix_length: Int = 1
    private let postfix_length: Int = 1
    private let frameType_length: Int = 1
    var data: Data
    var prefix: StellarFramePrefix {
        return getFramePrefix()
    }
    var code: StellarFrameCode {
        return getFrameCode()
    }
    var type: StellarFrameType {
        return getFrameContentType()
    }
    var contentData: Data {
        return getContentData()
    }
    var mac: String {
        return getMac()
    }
    var crc: StellarFrameCrcType {
        return getDataCrc()
    }
    init() {
        self.data = Data()
    }
    static func initWithData(_ data: Data) -> StellarWiFiFrame? {
        let frame = StellarWiFiFrame()
        frame.data = data
        if frame.checkFrameCrc() {
            return frame
        }
        return nil
    }
    private func getFramePrefix() -> StellarFramePrefix {
        var result: UInt8 = 0
        data.copyBytes(to: &result, count: prefix_length)
        return  StellarFramePrefix(rawValue: result)
    }
    func getFrameDeviceName() -> String {
        let pData = getContentData() as NSData
        if type == StellarFrameTypeQueryDeviceName {
            var deviceNameLength: UInt8 = 0
            var range = NSRange.init(location: 1, length: 1)
            pData.getBytes(&deviceNameLength, range: range)
            range.location += 1
            range.length = Int(deviceNameLength)
            let deviceNameData = pData.subdata(with: range)
            let deviceName = String(decoding: deviceNameData.array, as: UTF8.self)
            return deviceName
        }
        return  ""
    }
    private func getFrameCode() -> StellarFrameCode {
        var result: UInt8 = 0
        let location = prefix_length + length_length + mac_length
        data.copyBytes(to: &result, from: location..<(location + code_length))
        return StellarFrameCode(rawValue: result)
    }
    private func getFrameContentType() -> StellarFrameType {
        var result: UInt8 = 0
        let location = prefix_length + length_length + mac_length + code_length
        data.copyBytes(to: &result, from: location..<(location + frameType_length))
        return StellarFrameType(rawValue: result)
    }
    private func getContentData() -> Data {
        var len: UInt16 = 0
        let dd = NSData(data: data)
        dd.getBytes(&len, range: NSRange(location: prefix_length, length: length_length))
        len = CFSwapInt16BigToHost(len)
        let contentLength = len - UInt16(length_length + mac_length + code_length + crc_length)
        let location = prefix_length + length_length + mac_length + code_length
        let d = data.subdata(in: location..<Int(location + Int(contentLength)))
        return d
    }
    private func getMac() -> String {
        let location = prefix_length + length_length
        let d = data.subdata(in: location..<(mac_length + location))
        let dd = d as NSData
        var str = ""
        for i in 0..<d.count {
            let v = dd.bytes.load(fromByteOffset: i, as: UInt8.self)
            str += String(format: "%02lx", v)
        }
        return str.uppercased()
    }
    private func getDataCrc() -> UInt16 {
        var result: UInt16 = 0
        let location = data.count - postfix_length - crc_length
        let d = data as NSData
        d.getBytes(&result, range: NSRange(location: location, length: crc_length))
        result = result.bigEndian
        return result
    }
    static func createFrame(mac: NSData = NSData(bytes: [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF], length: Int(StellarFrameMacLength)),wifiSSID: String,password: String) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeSetWifiAccess
        content.append(&type, length: 1)
        let ssid_byteLength = wifiSSID.lengthOfBytes(using: .utf8)
        var ssid = Character.init(UnicodeScalar.init(ssid_byteLength) ?? UnicodeScalar(0))
        content.append(&ssid, length: 1)
        content.append(wifiSSID.data(using: .utf8) ?? Data())
        let key = "pssVmKbeDgYGWLsy"
        let initData = password.data(using: .utf8) ?? Data()
        guard let encryptData = QPUtilities.cryptoRC4(initData, key: key.cString(using: .utf8), keylen: UInt(key.lengthOfBytes(using: .utf8)), isEncrypt: true) else {
            return nil
        }
        var c = Character(UnicodeScalar(encryptData.count) ?? UnicodeScalar(0))
        content.append(&c, length: 1)
        content.append(encryptData)
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func createFrame(mac: NSData = NSData(bytes: [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF], length: Int(StellarFrameMacLength)),token: String) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeSendDeviceToken
        content.append(&type, length: 1)
        var token_byteLength: UInt16 = UInt16(token.count).bigEndian
        content.append(&token_byteLength, length: 2)
        content.append(token.data(using: .utf8) ?? Data())
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func createQueryDeviceNameFrame() -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeQueryDeviceName
        content.append(&type, length: 1)
        var b: [UInt8] = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF]
        let mac = NSData(bytes: &b, length: Int(StellarFrameMacLength))
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func createDUIInfoFrame(userid:String,authcode:String,codeVerify:String) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeDUIInfo
        content.append(&type, length: 1)
        var useridLength = UInt16(userid.count).bigEndian
        content.append(&useridLength, length: 2)
        let useridData = userid.data(using: .utf8) ?? Data()
        content.append(useridData)
        var authcodeLength = UInt16(authcode.count).bigEndian
        content.append(&authcodeLength, length: 2)
        let authcodeData = authcode.data(using: .utf8) ?? Data()
        content.append(authcodeData)
        var codeVerifyLength = UInt16(codeVerify.count).bigEndian
        content.append(&codeVerifyLength, length: 2)
        let codeVerify = codeVerify.data(using: .utf8) ?? Data()
        content.append(codeVerify)
        var b: [UInt8] = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF]
        let mac = NSData(bytes: &b, length: Int(StellarFrameMacLength))
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func createFrame(mac:NSData = NSData(bytes: [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF], length: Int(StellarFrameMacLength)),url:String,port:UInt16) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeSetUpService
        content.append(&type, length: 1)
        var url_byteLength: UInt16 = UInt16(url.count).bigEndian
        content.append(&url_byteLength, length: 2)
        content.append(url.data(using: .utf8) ?? Data())
        var fport = port.bigEndian
        content.append(&fport, length: 2)
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func begainRegistAction(mac:NSData = NSData(bytes: [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF], length: Int(StellarFrameMacLength))) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeBegainRegist
        content.append(&type, length: 1)
        let frame = StellarWiFiFrame.initHostFrameNeedAck(mac, content)
        return frame
    }
    static func queryDeviceInfoFrameToBroadcastMac() -> StellarWiFiFrame? {
        var b: [UInt8] = [0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF]
        let f = queryDeviceInfoFrame(NSData(bytes: &b, length: Int(StellarFrameMacLength)))
        return f
    }
    static func queryDeviceInfoFrame(_ mac: NSData) -> StellarWiFiFrame? {
        let content = NSMutableData()
        var type = StellarFrameTypeQueryDeviceInfoNew
        content.append(&type, length: 1)
        return StellarWiFiFrame.initHostFrameNeedAck(mac, content)
    }
    static func initHostFrameNeedAck(_ mac: NSData, _ content: NSData) -> StellarWiFiFrame? {
        return StellarWiFiFrame.initWithPrefix(StellarFramePrefixHost, mac, StellarFrameCodeAck, content)
    }
    static func initHostFrameNoNeedAck(_ mac: NSData, _ content: NSData) -> StellarWiFiFrame? {
        return StellarWiFiFrame.initWithPrefix(StellarFramePrefixHost, mac, StellarFrameCodeNoAck, content)
    }
    static func initWithPrefix(_ prefix: StellarFramePrefix, _ mac: NSData, _ code: StellarFrameCode, _ content: NSData) -> StellarWiFiFrame? {
        let frame = StellarWiFiFrame()
        let d = NSMutableData()
        var framePrefix = prefix
        d.append(&framePrefix, length: 1)
        let content_length = content.count
        var len: UInt16 = UInt16(frame.length_length + frame.mac_length + frame.code_length + content_length + frame.crc_length)
        len = len.bigEndian
        d.append(&len, length: frame.length_length)
        if mac.count != StellarFrameMacLength {
            print("Invalid length = \(mac.count)")
            return nil
        }
        d.append(mac as Data)
        var theCode = code
        d.append(&theCode, length: frame.code_length)
        d.append(content as Data)
        var crc = CRC(buffer: d.bytes + frame.prefix_length, buffer_length: UInt64(d.count - frame.prefix_length))
        crc = crc.bigEndian
        d.append(&crc, length: frame.crc_length)
        var postfix: StellarFramePostfix
        if prefix == StellarFramePrefixHost {
            postfix = StellarFramePostfixHost
        }else{
            postfix = StellarFramePostfixDevice
        }
        d.append(&postfix, length: 1)
        frame.data = d as Data
        return frame
    }
    func checkFrameCrc() -> Bool {
        let contentLength = data.count - prefix_length - postfix_length - crc_length
        let location = prefix_length
        guard let dataToCheck = data.subdata(in: location..<Int(contentLength + location)) as NSData? else {
            return false
        }
        let newCRC = CRC(buffer: dataToCheck.bytes, buffer_length: UInt64(dataToCheck.count))
        if newCRC != self.crc {
            print("checkCrc mismatch-\(#function)-\(#line)")
            return false
        }
        return true
    }
}
func  CRC(buffer: UnsafeRawPointer, buffer_length: UInt64) -> UInt16 {
    var c: UInt8 = 0
    var treat: UInt8 = 0
    var bcrc: UInt8 = 0
    var wcrc: UInt16 = 0
    for i in 0..<buffer_length {
        c = buffer.load(fromByteOffset: Int(i), as: UInt8.self)
        for _ in 0...7 {
            treat = c & 0x80
            c <<= 1
            bcrc = UInt8((wcrc >> 8) & 0x80)
            wcrc <<= 1
            if (treat != bcrc) {
                wcrc ^= 0x1021
            }
        }
    }
    return wcrc
}