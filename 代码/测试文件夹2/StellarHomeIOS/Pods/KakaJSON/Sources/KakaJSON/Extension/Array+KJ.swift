import Foundation
extension NSArray: KJCompatible {}
extension Array: KJCompatible {}
extension Set: KJCompatible {}
extension NSSet: KJCompatible {}
public extension KJ where Base: ExpressibleByArrayLiteral & Sequence {
    func enumArray<M: ConvertibleEnum>(_ type: M.Type) -> [M] {
        return enumArray(type: type) as! [M]
    }
    func enumArray(type: ConvertibleEnum.Type) -> [ConvertibleEnum] {
        guard let _ = Metadata.type(type) as? EnumType else { return [] }
        return base.compactMap {
            let vv = Values.value($0, type.kj_valueType)
            return type.kj_convert(from: vv as Any)
        }
    }
    func modelArray<M: Convertible>(_ type: M.Type) -> [M] {
        return modelArray(type: type) as! [M]
    }
    func modelArray(type: Convertible.Type) -> [Convertible] {
        guard let mt = Metadata.type(type) as? ModelType,
            let _ = mt.properties
            else { return [] }
        return base.compactMap {
            switch $0 {
            case let dict as [String: Any]: return dict.kj_fastModel(type)
            case let dict as Data: return dict.kj_fastModel(type)
            case let dict as String: return dict.kj_fastModel(type)
            default: return nil
            }
        }
    }
    func JSONObjectArray() -> [[String: Any]] {
        return base.compactMap {
            ($0~! as? Convertible)?.kj_JSONObject()
        }
    }
    func JSONArray() -> [Any] {
        return Values.JSONValue(base) as! [Any]
    }
    func JSONString(prettyPrinted: Bool = false) -> String {
        if let str = JSONSerialization.kj_string(JSONArray(),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return ""
    }
}