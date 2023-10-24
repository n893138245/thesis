import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif
public enum Values {
    static func value(_ val: Any?,
                      _ type: Any.Type,
                      _ defaultValue: @autoclosure () -> Any? = nil) -> Any? {
        guard let v = val.kj_value else { return nil }
        if Swift.type(of: v) == type { return v }
        if v is NSNull { return nil }
        switch type {
        case is NumberValue.Type: return _number(v, type)
        case is StringValue.Type: return _string(v, type)
        case let ct as Convertible.Type: return _model(v, ct, defaultValue)
        case is ArrayValue.Type: return _array(v, type)
        case is DateValue.Type: return _date(v)
        case is DictionaryValue.Type: return _dictionary(v, type)
        case is URLValue.Type: return _url(v)
        case is DataValue.Type: return _data(v, type)
        case is SetValue.Type: return _set(v, type)
        case let enumType as ConvertibleEnum.Type:
            let vv = value(v, enumType.kj_valueType)
            return enumType.kj_convert(from: vv as Any)
        default: return nil
        }
    }
    static func JSONValue(_ value: Any?) -> Any? {
        guard let v = value.kj_value else { return nil }
        if v is NSNull { return nil }
        switch v {
        case let num as NumberValue: return _JSONValue(from: num)
        case let model as Convertible: return model.kj_JSONObject()
        case let array as [Any]: return _JSONValue(from: array)
        case let date as Date: return date.timeIntervalSince1970
        case let dict as [String: Any]: return _JSONValue(from: dict)
        case let url as URL: return url.absoluteString
        case let set as SetValue: return _JSONValue(from: set)
        case let `enum` as ConvertibleEnum: return JSONValue(`enum`.kj_value)
        default: return v as? NSCoding
        }
    }
    static func JSONString(_ value: Any?,
                           prettyPrinted: Bool = false) -> String? {
        if let str = JSONSerialization.kj_string(JSONValue(value),
                                                 prettyPrinted: prettyPrinted) {
            return str
        }
        Logger.error("Failed to get JSONString from JSON.")
        return nil
    }
}
private extension Values {
    static func _numberString(_ value: Any) -> String? {
        if let date = value as? Date {
            return "\(date.timeIntervalSince1970)"
        }
        let lower = "\(value)".lowercased()
        if lower == "true" || lower == "yes" { return "1" }
        if lower == "false" || lower == "no" { return "0" }
        return lower
    }
    static func _model(_ value: Any,
                       _ type: Convertible.Type,
                       _ defaultValue: () -> Any?) -> Convertible? {
        guard let json = value as? [String: Any] else { return nil }
        if var model = defaultValue().kj_value as? Convertible {
            model.kj_convert(from: json)
            return model
        }
        return json.kj.model(type: type)
    }
    static func _anyArray(_ value: Any) -> [Any]? {
        guard let set = value as? SetValue else { return value as? [Any] }
        return set.kj_array()
    }
    static func _array(_ value: Any, _ type: Any.Type) -> ArrayValue? {
        guard let json = _anyArray(value) else { return nil }
        let mt = Metadata.type(type)
        if let type = (mt as? NominalType)?.genericTypes?.first {
            if let modelType = type~! as? Convertible.Type {
                return json.kj.modelArray(type: modelType)
            } else if let enumType = type~! as? ConvertibleEnum.Type {
                return json.kj.enumArray(type: enumType)
            }
        }
        return type is NSMutableArray.Type
            ? NSMutableArray(array: json) : json
    }
    static func _set(_ value: Any, _ type: Any.Type) -> SetValue? {
        guard let arr = _array(value, type) as? [Any]
            else { return nil }
        return type is NSMutableSet.Type
            ? NSMutableSet(array: arr)
            : NSSet(array: arr)
    }
    static func _dictionary(_ value: Any, _ type: Any.Type) -> DictionaryValue? {
        guard let dict = value as? [String: Any] else { return nil }
        let mt = Metadata.type(type)
        guard type is SwiftDictionaryValue.Type,
            let valueType = (mt as? NominalType)?.genericTypes?.last else {
            return type is NSMutableDictionary.Type
                ? NSMutableDictionary(dictionary: dict) : dict
        }
        if let json = value as? [String: [String: Any]?],
            let modelType = valueType~! as? Convertible.Type {
            var modelDict = [String: Any]()
            for (k, v) in json {
                guard let e = v?.kj.model(type: modelType) else { continue }
                modelDict[k] = e
            }
            return modelDict.isEmpty ? nil : modelDict
        }
        if let enumType = valueType~! as? ConvertibleEnum.Type {
            var enumDict = [String: Any]()
            for (k, v) in dict {
                guard let m = Values.value(v, enumType) else { continue }
                enumDict[k] = m
            }
            return enumDict.isEmpty ? nil : enumDict
        }
        guard let json = value as? [String: [Any]?],
            let subtype = (Metadata.type(valueType~!) as? NominalType)?.genericTypes?.last
            else { return dict }
        if let json = value as? [String: [[String: Any]?]?],
            let modelType = subtype~! as? Convertible.Type {
            var modelArrayDict = [String: Any]()
            for (k, v) in json {
                guard let ma = v?.kj.modelArray(type: modelType) else { continue }
                modelArrayDict[k] = ma
            }
            return modelArrayDict.isEmpty ? nil : modelArrayDict
        }
        if let enumType = subtype~! as? ConvertibleEnum.Type {
            var enumArrayDict = [String: Any]()
            for (k, v) in json {
                guard let ea = v?.kj.enumArray(type: enumType) else { continue }
                enumArrayDict[k] = ea
            }
            return enumArrayDict.isEmpty ? nil : enumArrayDict
        }
        return dict
    }
    static func _string(_ value: Any, _ type: Any.Type) -> StringValue? {
        var str: String
        switch value {
        case let url as URL: str = url.standardizedFileURL.absoluteString
        case let date as Date: str = "\(Int64(date.timeIntervalSince1970))"
        default: str = "\(value)"
        }
        return type is NSMutableString.Type ? NSMutableString(string: str) : str
    }
    static func _data(_ value: Any, _ type: Any.Type) -> DataValue? {
        var data: Data?
        if let str = value as? String {
            data = str.data(using: .utf8)
        } else {
            data = value as? Data
        }
        guard let v = data else { return nil }
        return type is NSMutableData.Type ? NSMutableData(data: v) : v
    }
    static func _date(_ value: Any) -> DateValue? {
        if let v = value as? Date { return v }
        guard let time = Double("\(value)") else { return nil }
        return Date(timeIntervalSince1970: time)
    }
    static func _url(_ value: Any) -> URLValue? {
        guard let str = value as? String, str.contains(":
            else { return value as? URL }
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed).flatMap { URL(string: $0) }
    }
    static func _number(_ value: Any, _ type: Any.Type) -> NumberValue? {
        guard let str = _numberString(value) else { return nil }
        guard let decimal = Decimal(string: str) else { return nil }
        if let digitType = type as? DigitValue.Type {
            return Double("\(decimal)")
                .flatMap { NSNumber(value: $0) }
                .flatMap { digitType.init(truncating: $0) }
        }
        if type is NSDecimalNumber.Type {
            return NSDecimalNumber(decimal: decimal)
        }
        if type is Decimal.Type { return decimal }
        return Double("\(decimal)").flatMap { NSNumber(value: $0) }
    }
    static func _JSONValue(from set: SetValue) -> Any {
        return _JSONValue(from: set.kj_array())
    }
    static func _JSONValue(from array: [Any]) -> Any {
        return array.compactMap { JSONValue($0) }
    }
    static func _JSONValue(from dict: [String: Any]) -> Any {
        return dict.compactMapValues { JSONValue($0) }
    }
    static func _JSONValue(from num: NumberValue) -> Any? {
        if num is Bool || num is IntegerValue { return num }
        if num is DecimalValue { return "\(num)" }
        return NSDecimalNumber(string: "\(num)")
    }
}
public extension Values {
    static func value<T>(_ val: Any?, of type: T.Type)-> T? {
        return value(val, type) as? T
    }
    static func string(_ val: Any?)-> String? {
        return value(val, String.self) as? String
    }
    static func bool(_ val: Any?)-> Bool? {
        return value(val, Bool.self) as? Bool
    }
    static func int(_ val: Any?)-> Int? {
        return value(val, Int.self) as? Int
    }
    static func int8(_ val: Any?)-> Int8? {
        return value(val, Int8.self) as? Int8
    }
    static func int16(_ val: Any?)-> Int16? {
        return value(val, Int16.self) as? Int16
    }
    static func int32(_ val: Any?)-> Int32? {
        return value(val, Int32.self) as? Int32
    }
    static func int64(_ val: Any?)-> Int64? {
        return value(val, Int64.self) as? Int64
    }
    static func uInt(_ val: Any?)-> UInt? {
        return value(val, UInt.self) as? UInt
    }
    static func uInt8(_ val: Any?)-> UInt8? {
        return value(val, UInt8.self) as? UInt8
    }
    static func uInt16(_ val: Any?)-> UInt16? {
        return value(val, UInt16.self) as? UInt16
    }
    static func uInt32(_ val: Any?)-> UInt32? {
        return value(val, UInt32.self) as? UInt32
    }
    static func uInt64(_ val: Any?)-> UInt64? {
        return value(val, UInt64.self) as? UInt64
    }
    static func float(_ val: Any?)-> Float? {
        return value(val, Float.self) as? Float
    }
    static func double(_ val: Any?)-> Double? {
        return value(val, Double.self) as? Double
    }
    #if canImport(CoreGraphics)
    static func cgFloat(_ val: Any?)-> CGFloat? {
        return value(val, CGFloat.self) as? CGFloat
    }
    #endif
    static func decimal(_ val: Any?)-> Decimal? {
        return value(val, Decimal.self) as? Decimal
    }
    static func number(_ val: Any?)-> NSNumber? {
        return value(val, NSNumber.self) as? NSNumber
    }
    static func decimalNumber(_ val: Any?)-> NSDecimalNumber? {
        return value(val, NSDecimalNumber.self) as? NSDecimalNumber
    }
}
protocol CollectionValue {}
protocol DictionaryValue: CollectionValue {}
extension NSDictionary: DictionaryValue {}
protocol SwiftDictionaryValue: DictionaryValue {}
extension Dictionary: SwiftDictionaryValue {}
protocol ArrayValue: CollectionValue {}
extension NSArray: ArrayValue {}
protocol SwiftArrayValue: ArrayValue {}
extension Array: SwiftArrayValue {}
protocol SetValue: CollectionValue {
    func kj_array() -> [Any]
}
extension SetValue where Self: Sequence {
    func kj_array() -> [Any] {
        return map { $0 }
    }
}
extension NSSet: SetValue {}
protocol SwiftSetValue: SetValue {}
extension Set: SwiftSetValue {}
protocol StringValue {}
extension String: StringValue {}
extension NSString: StringValue {}
protocol NumberValue {}
protocol DecimalValue {}
extension NSNumber: NumberValue {}
extension Decimal: NumberValue, DecimalValue {}
extension NSDecimalNumber: DecimalValue {}
protocol DigitValue: NumberValue {
    init?(truncating: NSNumber)
}
protocol FloatValue: DigitValue { }
extension Double: FloatValue {}
extension Float: FloatValue {}
#if canImport(CoreGraphics)
import CoreGraphics
extension CGFloat: FloatValue {}
#endif
extension Bool: DigitValue {}
protocol IntegerValue: DigitValue { }
extension Int: IntegerValue {}
extension Int64: IntegerValue {}
extension Int32: IntegerValue {}
extension Int16: IntegerValue {}
extension Int8: IntegerValue {}
extension UInt: IntegerValue {}
extension UInt64: IntegerValue {}
extension UInt32: IntegerValue {}
extension UInt16: IntegerValue {}
extension UInt8: IntegerValue {}
protocol URLValue {}
extension NSURL: URLValue {}
extension URL: URLValue {}
protocol DataValue {}
extension NSData: DataValue {}
extension Data: DataValue {}
protocol DateValue {}
extension NSDate: DateValue {}
extension Date: DateValue {}
postfix operator ~!
postfix func ~! (_ type: Any.Type) -> Any.Type {
    guard let ot = Metadata.type(type) as? OptionalType else { return type }
    return ot.wrapType
}
postfix func ~! (_ value: Any) -> Any? {
    guard let ov = value as? OptionalValue else { return value }
    return ov.kj_value
}
postfix func ~! (_ value: Any?) -> Any? {
    return (value as OptionalValue).kj_value
}