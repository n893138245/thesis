import UIKit
class GatewayModel: BasicDeviceModel {
    var devicesList: [String] = []
    var status: GatewayStatus = GatewayStatus()
    override func kj_JSONValue(from modelValue: Any?, _ property: Property) -> Any? {
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
}
struct GatewayStatus: Convertible {
    var online: Bool = false
}