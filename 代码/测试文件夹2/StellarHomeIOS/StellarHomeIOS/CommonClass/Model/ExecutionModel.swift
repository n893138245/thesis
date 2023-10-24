import UIKit
public class ExecutionModel: Convertible, Equatable {
    public static func == (lhs: ExecutionModel, rhs: ExecutionModel) -> Bool {
        return lhs.device == rhs.device &&
            lhs.groupId == rhs.groupId &&
            lhs.room == rhs.room &&
            lhs.id == rhs.id &&
            lhs.scene == rhs.scene &&
            lhs.execution == rhs.execution
    }
    var device: String?
    var groupId: Int?
    var room: Int?
    var execution: [ExecutionDetail] = [];
    var id :String = ""
    var scene: String?
    required public init() {
    }
}
class ExecutionDetail:Convertible, Equatable {
    static func == (lhs: ExecutionDetail, rhs: ExecutionDetail) -> Bool {
        return lhs.command == rhs.command &&
            lhs.params == rhs.params
    }
    var command: Traits = .onOff
    var params: ExecutionDetailParams?
    required init() {
    }
}
class ExecutionDetailParams: Convertible, Equatable {
    static func == (lhs: ExecutionDetailParams, rhs: ExecutionDetailParams) -> Bool {
        return lhs.cct == rhs.cct &&
            lhs.brightness == rhs.brightness &&
            lhs.onOff == rhs.onOff &&
            lhs.color?.r == rhs.color?.r &&
            lhs.color?.g == rhs.color?.g &&
            lhs.color?.b == rhs.color?.b &&
            lhs.id == rhs.id
    }
    var id: Int?
    var cct: Int?
    var brightness: Int?
    var onOff: String?
    var fallDownAlert: Bool?
    var vitalSignDisappearAlert: Bool?
    var color: (r: Int, g: Int, b: Int)?
    required init() {
    }
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any? {
        if property.name == "color",let dic = jsonValue as? [String: Int] {
            return (dic["r"],dic["g"],dic["b"])
        }
        return jsonValue
    }
    func kj_JSONValue(from modelValue: Any?, _ property: Property) -> Any? {
        if property.name == "color", let value = modelValue as? (Int, Int , Int) {
            return ["r": value.0,"g": value.1,"b": value.2]
        }
        return modelValue
    }
}