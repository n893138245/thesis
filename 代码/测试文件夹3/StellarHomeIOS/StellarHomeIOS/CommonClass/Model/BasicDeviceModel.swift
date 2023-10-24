import Foundation
public class BasicDeviceModel:Convertible {
    var sn: String = ""
    var manufacturer: String = ""
    var model: String = ""
    var hwVersion: Int = -1
    var swVersion: Int = -1
    var latestSwVersion: Int?
    var type: DeviceType = .unknown
    var remoteType:DeviceRemoteType = .unknown
    var fwType:Int  = -1
    var traits: [Traits]?
    var name: String = ""
    var willReportState: Bool = false
    var connection: ConnectionType = .softAP
    var mac:String = ""
    var room: Int?
    var isSetRoom: Bool {
        if self.room == nil || self.room! < 1 {
            return false
        }else{
            return true
        }
    }
    required public init() {
    }
    public func kj_JSONValue(from modelValue: Any?, _ property: Property) -> Any? {
        if (modelValue as? String) == "" {
            return nil
        }
        if (modelValue as? Int) == -1 {
            return nil
        }
        if (modelValue as? DeviceType) == DeviceType.unknown {
            return nil
        }
        if (modelValue as? DeviceRemoteType) == DeviceRemoteType.unknown {
            return nil
        }
        return modelValue
    }
    public func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        return jsonValue
    }
}