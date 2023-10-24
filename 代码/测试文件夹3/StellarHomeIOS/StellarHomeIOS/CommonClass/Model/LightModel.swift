import UIKit
enum LightCurrentMode: String, ConvertibleEnum {
    case color, cct, internalScene, mode
}
class LightModel: BasicDeviceModel {
    var gatewaySn: String = ""
    var internalScenes: [LightInternalScene] = []
    var colorModel: String = ""
    var colorTemperatureRange: (temperatureMinK: Int, temperatureMaxK: Int) = (0, 0)
    var status: LightStatus = LightStatus()
    var internalMode: [LightInternalMode] = []
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
        if property.name == "colorTemperatureRange",let values = modelValue as? (Int, Int) {
            let dic = ["temperatureMinK":values.0,"temperatureMaxK":values.1]
            return dic
        }
        return modelValue
    }
    override func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name == "colorTemperatureRange",let dic = jsonValue as? [String: Int] {
            return (dic["temperatureMinK"],dic["temperatureMaxK"])
        }
        return jsonValue
    }
}
struct LightInternalScene:Convertible {
    var id: Int = 0
    var name: String = ""
}
struct LightInternalMode: Convertible, Equatable {
    static func == (lhs: LightInternalMode, rhs: LightInternalMode) -> Bool {
        return lhs.name == rhs.name && lhs.params?.cct == rhs.params?.cct && lhs.id == rhs.id && lhs.params?.brightness == rhs.params?.brightness
    }
    var id: Int = -1
    var name: String = ""
    var params: LightInternalParams?
}
struct LightInternalParams: Convertible {
    var brightness: Int?
    var cct: Int = 0
}
struct LightStatus: Convertible {
    var online: Bool = false
    var onOff: String = "off"
    var brightness: Int = 0
    var color: (r: Int, g: Int, b: Int) = (255, 255, 255)
    var cct: Int = 0
    var internalSceneId: Int = 0
    var mode: Int = 0
    var currentMode: LightCurrentMode = .cct
    var radarVitalSigns: Bool?
    var radarLocationInfo: [RadarLocationInfo]?
    var vitalSignDisappearAlert: Bool?
    var fallDownAlert: Bool?
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "onOff": return "onoff"
        default: return property.name
        }
    }
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name == "color",let dic = jsonValue as? [String: Int] {
            return (dic["r"],dic["g"],dic["b"])
        }
        return jsonValue
    }
}
struct RadarLocationInfo: Convertible {
    var distance: Int = 0
    var speed: Int = 0
    var angle: Int = 0
}