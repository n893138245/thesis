import Foundation
public protocol ModelPropertyKey {}
extension String: ModelPropertyKey {}
extension Array: ModelPropertyKey where Element == String {}
public typealias JSONPropertyKey = String
public protocol Convertible {
    init()
    func kj_modelKey(from property: Property) -> ModelPropertyKey
    func kj_modelValue(from jsonValue: Any?,
                       _ property: Property) -> Any?
    func kj_modelType(from jsonValue: Any?,
                      _ property: Property) -> Convertible.Type?
    mutating func kj_willConvertToModel(from json: [String: Any])
    mutating func kj_didConvertToModel(from json: [String: Any])
    func kj_JSONKey(from property: Property) -> JSONPropertyKey
    func kj_JSONValue(from modelValue: Any?,
                      _ property: Property) -> Any?
    func kj_willConvertToJSON()
    func kj_didConvertToJSON(json: [String: Any])
}
public extension Convertible {
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return ConvertibleConfig.modelKey(from: property, Self.self)
    }
    func kj_modelValue(from jsonValue: Any?,
                       _ property: Property) -> Any? {
        return ConvertibleConfig.modelValue(from: jsonValue, property, Self.self)
    }
    func kj_modelType(from jsonValue: Any?,
                      _ property: Property) -> Convertible.Type? { return nil }
    func kj_willConvertToModel(from json: [String: Any]) {}
    func kj_didConvertToModel(from json: [String: Any]) {}
    func kj_JSONKey(from property: Property) -> JSONPropertyKey {
        return ConvertibleConfig.JSONKey(from: property, Self.self)
    }
    func kj_JSONValue(from modelValue: Any?,
                      _ property: Property) -> Any? {
        return ConvertibleConfig.JSONValue(from: modelValue, property, Self.self)
    }
    func kj_willConvertToJSON() {}
    func kj_didConvertToJSON(json: [String: Any]) {}
}
public extension Convertible {
    static var kj: ConvertibleKJ<Self>.Type {
        get { return ConvertibleKJ<Self>.self }
        set {}
    }
    var kj: ConvertibleKJ<Self> {
        get { return ConvertibleKJ(self) }
        set {}
    }
    var kj_m: ConvertibleKJ_M<Self> {
        mutating get { return ConvertibleKJ_M(&self) }
        set {}
    }
}
public struct ConvertibleKJ_M<T: Convertible> {
    var basePtr: UnsafeMutablePointer<T>
    init(_ basePtr: UnsafeMutablePointer<T>) {
        self.basePtr = basePtr
    }
    public func convert(from jsonData: Data) {
        basePtr.pointee.kj_convert(from: jsonData)
    }
    public func convert(from jsonData: NSData) {
        basePtr.pointee.kj_convert(from: jsonData as Data)
    }
    public func convert(from jsonString: String) {
        basePtr.pointee.kj_convert(from: jsonString)
    }
    public func convert(from jsonString: NSString) {
        basePtr.pointee.kj_convert(from: jsonString as String)
    }
    public func convert(from json: [String: Any]) {
        basePtr.pointee.kj_convert(from: json)
    }
    public func convert(from json: [NSString: Any]) {
        basePtr.pointee.kj_convert(from: json as [String: Any])
    }
    public func convert(from json: NSDictionary) {
        basePtr.pointee.kj_convert(from: json as! [String: Any])
    }
}
public struct ConvertibleKJ<T: Convertible> {
    var base: T
    init(_ base: T) {
        self.base = base
    }
    public func JSONObject() -> [String: Any] {
        return base.kj_JSONObject()
    }
    public func JSONString(prettyPrinted: Bool = false) -> String {
        return base.kj_JSONString(prettyPrinted: prettyPrinted)
    }
}
private extension Convertible {
    mutating func _ptr() -> UnsafeMutableRawPointer {
        return (Metadata.type(self)!.kind == .struct)
            ? withUnsafeMutablePointer(to: &self) { UnsafeMutableRawPointer($0) }
            : self ~>> UnsafeMutableRawPointer.self
    }
}
extension Convertible {
    mutating func kj_convert(from jsonData: Data) {
        if let json = JSONSerialization.kj_JSON(jsonData, [String: Any].self) {
            kj_convert(from: json)
            return
        }
        Logger.error("Failed to get JSON from JSONData.")
    }
    mutating func kj_convert(from jsonString: String) {
        if let json = JSONSerialization.kj_JSON(jsonString, [String: Any].self) {
            kj_convert(from: json)
            return
        }
        Logger.error("Failed to get JSON from JSONString.")
    }
    mutating func kj_convert(from json: [String: Any]) {
        guard let mt = Metadata.type(self) as? ModelType else {
            Logger.warnning("Not a class or struct instance.")
            return
        }
        guard let properties = mt.properties else {
            Logger.warnning("Don't have any property.")
            return
        }
        let model = _ptr()
        kj_willConvertToModel(from: json)
        for property in properties {
            let key = mt.modelKey(from: property.name,
                                  kj_modelKey(from: property))
            guard let newValue = kj_modelValue(
                from: json.kj_value(for: key),
                property)~! else { continue }
            let propertyType = property.dataType
            if Swift.type(of: newValue) == propertyType {
                property.set(newValue, for: model)
                continue
            }
            if let modelType = kj_modelType(from: newValue, property),
                let value = _modelTypeValue(newValue, modelType, propertyType) {
                property.set(value, for: model)
                continue
            }
            guard let value = Values.value(newValue,
                                           propertyType,
                                           property.get(from: model)) else {
                property.set(newValue, for: model)
                continue
            }
            property.set(value, for: model)
        }
        kj_didConvertToModel(from: json)
    }
    private mutating
    func _modelTypeValue(_ jsonValue: Any,
                         _ modelType: Convertible.Type,
                         _ propertyType: Any.Type) -> Any? {
        if let json = jsonValue as? [Any] {
            let models = json.kj.modelArray(type: modelType)
            if !models.isEmpty {
                return propertyType is NSMutableArray.Type
                    ? NSMutableArray(array: models)
                    : models
            }
        }
        if let json = jsonValue as? [String: Any] {
            if let jsonDict = jsonValue as? [String: [String: Any]?] {
                var modelDict = [String: Any]()
                for (k, v) in jsonDict {
                    guard let m = v?.kj.model(type: modelType) else { continue }
                    modelDict[k] = m
                }
                guard modelDict.count > 0 else { return jsonValue }
                return propertyType is NSMutableDictionary.Type
                    ? NSMutableDictionary(dictionary: modelDict)
                    : modelDict
            } else {
                return json.kj.model(type: modelType)
            }
        }
        return jsonValue
    }
}
extension Convertible {
    func kj_JSONObject() -> [String: Any] {
        var json = [String: Any]()
        guard let mt = Metadata.type(self) as? ModelType else {
            Logger.warnning("Not a class or struct instance.")
            return json
        }
        guard let properties = mt.properties else {
            Logger.warnning("Don't have any property.")
            return json
        }
        kj_willConvertToJSON()
        var model = self
        let ptr = model._ptr()
        for property in properties {
            guard let value = kj_JSONValue(
                from: property.get(from: ptr)~!,
                property)~! else { continue }
            guard let v = Values.JSONValue(value) else { continue }
            json[mt.JSONKey(from: property.name,
                            kj_JSONKey(from: property))] = v
        }
        kj_didConvertToJSON(json: json)
        return json
    }
    func kj_JSONString(prettyPrinted: Bool = false) -> String {
        if let str = JSONSerialization.kj_string(kj_JSONObject() as Any,
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return ""
    }
}