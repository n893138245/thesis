import UIKit
let StellarServicePort: Int = 13434
let BROADCAST_IP: String = "255.255.255.255"
protocol StellarLocalRequsetDelegte {
    func didSendWifiSuccess(mac: String)
    func didReceivedBulbInfo(mac: String, connType: StellarDeviceConnectionType, sVer: UInt8,
                             hVer: UInt8, devType: StellarDeviceType, sn: String?)
    func didReceivedSendTokenSuccess(mac: String)
    func didReceivedSendServerSuccess(mac: String)
    func didReceivedStartRegisterSuccess(mac: String)
}
extension StellarLocalRequsetDelegte{
    func didSendWifiSuccess(mac: String){}
    func didReceivedBulbInfo(mac: String, connType: StellarDeviceConnectionType, sVer: UInt8,
                             hVer: UInt8, devType: StellarDeviceType, sn: String?){}
    func didReceivedSendTokenSuccess(mac: String){}
    func didReceivedSendServerSuccess(mac: String){}
    func didReceivedStartRegisterSuccess(mac: String){}
}
private func GetIPAddresses() -> String? {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first
}
class StellarLocalRequset: NSObject{
    var delegate: StellarLocalRequsetDelegte?
    var targetIp: String!
    static let sharedInstance = StellarLocalRequset.init()
    override init() {
        targetIp = "192.168.6.1"
        super.init()
    }
    private lazy var udpSocket: GCDAsyncUdpSocket = {
        let tempSocket = GCDAsyncUdpSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        return tempSocket
    }()
    private var tag: Int = 0;
    private func setupSocket() {
        do {
            try udpSocket.bind(toPort: 0)
        } catch _ {
            print("Error binding....bind")
            udpSocket.close()
        }
        do {
            try udpSocket.enableBroadcast(true)
        } catch _ {
            print("Error binding....enableBroadcast")
            udpSocket.close()
        }
        do {
            try udpSocket.beginReceiving()
        } catch _ {
            print("Error binding....beginReceiving")
            udpSocket.close()
        }
        tag = 0
        print("socket ready")
    }
    private func ssendFrame(f: StellarWiFiFrame, host: String) {
        if udpSocket.isClosed() == true {
            setupSocket()
        }
        print("qqtt - \(f.data.array.toHexString())")
        udpSocket.send(f.data, toHost: host, port: UInt16(StellarServicePort), withTimeout: -1, tag: tag+1)
    }
    func connectToWifi(mac: String, SSID: String, password: String){
        let macData = NSData.init(fromHexString: mac) as Data
        guard let f = StellarWiFiFrame.createFrame(mac:macData as NSData, wifiSSID: SSID, password: password) else {
            print("发生错误-\(#function)-\(#line)")
            return
        }
        ssendFrame(f: f, host: self.targetIp)
    }
    func sendDeviceToken(mac: String,token:String){
        let macData = NSData.init(fromHexString: mac) as Data
        guard let f = StellarWiFiFrame.createFrame(mac: macData as NSData, token: token) else {
            print("发生错误-\(#function)-\(#line)")
            return
        }
        ssendFrame(f: f, host: self.targetIp)
    }
    func setupService(mac: String,url:String,port:UInt16){
        let macData = NSData.init(fromHexString: mac) as Data
        guard let f = StellarWiFiFrame.createFrame(mac:macData as NSData, url: url, port: port) else {
            print("发生错误-\(#function)-\(#line)")
            return
        }
        ssendFrame(f: f, host: self.targetIp)
    }
    func begainRegistAction(mac: String){
        let macData = NSData.init(fromHexString: mac) as Data
        guard let f = StellarWiFiFrame.begainRegistAction(mac:macData as NSData) else {
            print("发生错误-\(#function)-\(#line)")
            return
        }
        ssendFrame(f: f, host: self.targetIp)
    }
    func getDeviceInfo() {
        guard let f = StellarWiFiFrame.queryDeviceInfoFrameToBroadcastMac() else {
            print("发生错误-\(#function)-\(#line)")
            return
        }
        ssendFrame(f: f, host: self.targetIp)
    }
}
extension StellarLocalRequset: GCDAsyncUdpSocketDelegate{
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        var host: NSString?
        var port: UInt16 = 0;
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address)
        guard let frame = StellarWiFiFrame.initWithData(data) else{
            print("发生错误-\(#function)-\(#line)")
            return
        }
        print("qqtt - \(data.array.toHexString())")
        if frame.prefix == StellarFramePrefixDevice {
            if frame.code == StellarFrameCodeSuccess {
                switch frame.type {
                case StellarFrameTypeSetWifiAccess:
                    if let temp = self.delegate {
                        let mac = frame.mac
                        temp.didSendWifiSuccess(mac: mac)
                    }
                case StellarFrameTypeQueryDeviceInfoNew:
                    let mac = frame.mac
                    var connectType: UInt8 = 0
                    var softVersion: UInt8 = 0
                    var hardwareVersion: UInt8 = 0
                    var deviceType: UInt16 = 0
                    var snLength: UInt8 = 0
                    let contentData: NSData = frame.contentData as NSData
                    var range = NSRange.init(location: 1, length: 1)
                    contentData.getBytes(&connectType, range: range)
                    range.location += 1
                    contentData.getBytes(&softVersion, range: range)
                    range.location += 1
                    contentData.getBytes(&hardwareVersion, range: range)
                    range.location += 1
                    range.length = 2
                    contentData.getBytes(&deviceType, range: range)
                    range.location += 2
                    range.length = 1
                    contentData.getBytes(&snLength, range: range)
                    range.location += 1
                    range.length = Int(snLength)
                    let snData = contentData.subdata(with: range)
                    let sn = String(decoding: snData.array, as: UTF8.self)
                    deviceType = deviceType.bigEndian
                    if let temp = self.delegate {
                        temp.didReceivedBulbInfo(mac: mac, connType: StellarDeviceConnectionType(rawValue: connectType), sVer: softVersion, hVer: hardwareVersion, devType: StellarDeviceType(rawValue: deviceType), sn: sn)
                    }
                case StellarFrameTypeSetUpService:
                    if let temp = self.delegate {
                        let mac = frame.mac
                        temp.didReceivedSendServerSuccess(mac: mac)
                    }
                case StellarFrameTypeSendDeviceToken:
                    if let temp = self.delegate {
                        let mac = frame.mac
                        temp.didReceivedSendTokenSuccess(mac: mac)
                    }
                case StellarFrameTypeBegainRegist:
                    if let temp = self.delegate {
                        let mac = frame.mac
                        temp.didReceivedStartRegisterSuccess(mac: mac)
                    }
                default:
                    break
                }
            }
        }
    }
}