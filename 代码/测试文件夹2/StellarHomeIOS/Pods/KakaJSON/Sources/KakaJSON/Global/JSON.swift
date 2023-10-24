public func JSONObject<M: Convertible>(from model: M) -> [String: Any] {
    return model.kj_JSONObject()
}
public func JSONObjectArray<M: Convertible>(from models: [M]) -> [[String: Any]] {
    return models.kj.JSONObjectArray()
}
public func JSONString(from value: Any,
                       prettyPrinted: Bool = false) -> String {
    return Values.JSONString(value, prettyPrinted: prettyPrinted) ?? ""
}