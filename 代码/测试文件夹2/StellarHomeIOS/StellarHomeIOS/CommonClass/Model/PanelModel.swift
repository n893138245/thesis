import UIKit
class PanelModel: BasicDeviceModel {
    var gatewaySn: String = ""
    var buttonCount: Int = 0
    var buttons: [ButttonModel] = []
    var status: PanelStatus = PanelStatus()
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
struct PanelStatus: Convertible {
    var online: Bool = false
}