import Foundation
public typealias ModelKeyConfig = (Property) -> ModelPropertyKey
public typealias ModelValueConfig = (Any?, Property) -> Any?
public typealias JSONKeyConfig = (Property) -> JSONPropertyKey
public typealias JSONValueConfig = (Any?, Property) -> Any?
public class ConvertibleConfig {
    private class Item {
        var modelKey: ModelKeyConfig?
        var modelValue: ModelValueConfig?
        var jsonKey: JSONKeyConfig?
        var jsonValue: JSONValueConfig?
        init() {}
        init(modelKey: @escaping ModelKeyConfig) { self.modelKey = modelKey }
        init(modelValue: @escaping ModelValueConfig) { self.modelValue = modelValue }
        init(jsonKey: @escaping JSONKeyConfig) { self.jsonKey = jsonKey }
        init(jsonValue: @escaping JSONValueConfig) { self.jsonValue = jsonValue }
    }
    private static let global = Item()
    private static var items: [TypeKey: Item] = [:]
    public static func modelKey(from property: Property) -> ModelPropertyKey {
        guard let fn = global.modelKey else { return property.name }
        return fn(property)
    }
    public static func modelKey(from property: Property,
                                _ model: Convertible) -> ModelPropertyKey {
        return modelKey(from: property, type(of: model))
    }
    public static func modelKey(from property: Property,
                                _ type: Convertible.Type) -> ModelPropertyKey {
        if let fn = items[typeKey(type)]?.modelKey {
            return fn(property)
        }
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        guard let fn = global.modelKey else {
            return property.name
        }
        return fn(property)
    }
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property) -> Any? {
        guard let fn = global.modelValue else { return jsonValue }
        return fn(jsonValue, property)
    }
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property,
                                  _ model: Convertible) -> Any? {
        return modelValue(from: jsonValue, property, type(of: model))
    }
    public static func modelValue(from jsonValue: Any?,
                                  _ property: Property,
                                  _ type: Convertible.Type) -> Any? {
        let key = typeKey(type)
        if let fn = items[key]?.modelValue {
            return fn(jsonValue, property)
        }
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.modelValue {
                    items[key]?.modelValue = fn
                    return fn(jsonValue, property)
                }
                classMt = superMt
            }
        }
        guard let fn = global.modelValue else {
            items[key]?.modelValue = { v, _ in v }
            return jsonValue
        }
        items[key]?.modelValue = fn
        return fn(jsonValue, property)
    }
    public static func JSONKey(from property: Property) -> JSONPropertyKey {
        guard let fn = global.jsonKey else { return property.name }
        return fn(property)
    }
    public static func JSONKey(from property: Property,
                               _ model: Convertible) -> JSONPropertyKey {
        return JSONKey(from: property, type(of: model))
    }
    public static func JSONKey(from property: Property,
                               _ type: Convertible.Type) -> JSONPropertyKey {
        if let fn = items[typeKey(type)]?.jsonKey {
            return fn(property)
        }
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonKey {
                    return fn(property)
                }
                classMt = superMt
            }
        }
        guard let fn = global.jsonKey else {
            return property.name
        }
        return fn(property)
    }
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property) -> Any? {
        guard let fn = global.modelValue else { return modelValue }
        return fn(modelValue, property)
    }
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property,
                                 _ model: Convertible) -> Any? {
        return JSONValue(from: modelValue, property, type(of: model))
    }
    public static func JSONValue(from modelValue: Any?,
                                 _ property: Property,
                                 _ type: Convertible.Type) -> Any? {
        let key = typeKey(type)
        if let fn = items[key]?.jsonValue {
            return fn(modelValue, property)
        }
        let mt = Metadata.type(type)
        if var classMt = mt as? ClassType {
            while let superMt = classMt.super {
                if let fn = items[typeKey(superMt.type)]?.jsonValue {
                    items[key]?.jsonValue = fn
                    return fn(modelValue, property)
                }
                classMt = superMt
            }
        }
        guard let fn = global.modelValue else {
            items[key]?.jsonValue = { v, _ in v}
            return modelValue
        }
        items[key]?.jsonValue = fn
        return fn(modelValue, property)
    }
    public static func setModelKey(for type: Convertible.Type,
                                   _ modelKey: @escaping ModelKeyConfig) {
        setModelKey(for: [type], modelKey)
    }
    public static func setModelKey(for types: [Convertible.Type] = [],
                                   _ modelKey: @escaping ModelKeyConfig) {
        if types.count == 0 {
            global.modelKey = modelKey
            return
        }
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.modelKey = modelKey
                return
            }
            items[key] = Item(modelKey: modelKey)
        }
    }
    public static func setModelValue(for type: Convertible.Type,
                                     modelValue: @escaping ModelValueConfig) {
        setModelValue(for: [type], modelValue: modelValue)
    }
    public static func setModelValue(for types: [Convertible.Type] = [],
                                     modelValue: @escaping ModelValueConfig) {
        if types.count == 0 {
            global.modelValue = modelValue
            return
        }
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.modelValue = modelValue
                return
            }
            items[key] = Item(modelValue: modelValue)
        }
    }
    public static func setJSONKey(for type: Convertible.Type,
                                  jsonKey: @escaping JSONKeyConfig) {
        setJSONKey(for: [type], jsonKey: jsonKey)
    }
    public static func setJSONKey(for types: [Convertible.Type] = [],
                                  jsonKey: @escaping JSONKeyConfig) {
        if types.count == 0 {
            global.jsonKey = jsonKey
            return
        }
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.jsonKey = jsonKey
                return
            }
            items[key] = Item(jsonKey: jsonKey)
        }
    }
    public static func setJSONValue(for type: Convertible.Type,
                                    jsonValue: @escaping JSONValueConfig) {
        setJSONValue(for: [type], jsonValue: jsonValue)
    }
    public static func setJSONValue(for types: [Convertible.Type] = [],
                                    jsonValue: @escaping JSONValueConfig) {
        if types.count == 0 {
            global.jsonValue = jsonValue
            return
        }
        types.forEach {
            let key = typeKey($0)
            if let item = items[key] {
                item.jsonValue = jsonValue
                return
            }
            items[key] = Item(jsonValue: jsonValue)
        }
    }
}