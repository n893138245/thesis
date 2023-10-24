import Foundation
extension String: KJCompatible {}
extension NSString: KJCompatible {}
public extension KJ where Base: ExpressibleByStringLiteral {
    func camelCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        var upper = false
        for c in str {
            if c == "_" {
                upper = true
                continue
            }
            if upper, newStr.count > 0 {
                newStr += c.uppercased()
            } else {
                newStr.append(c)
            }
            upper = false
        }
        return newStr
    }
    func underlineCased() -> String {
        guard let str = base as? String else { return "" }
        var newStr = ""
        for c in str {
            if c.isUppercase {
                newStr += "_"
                newStr += c.lowercased()
            } else {
                newStr.append(c)
            }
        }
        return newStr
    }
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(type: type) as? M
    }
    func model(type: Convertible.Type) -> Convertible? {
        guard let string = base as? String else { return nil }
        return string.kj_fastModel(type)
    }
    func modelArray<M: Convertible>(_ type: M.Type) -> [M] {
        return modelArray(type: type) as! [M]
    }
    func modelArray(type: Convertible.Type) -> [Convertible] {
        guard let string = base as? String else { return [] }
        if let json = JSONSerialization.kj_JSON(string, [Any].self) {
            return json.kj.modelArray(type: type)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return []
    }
}
extension String {
    func kj_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kj_JSON(self, [String: Any].self) {
            return json.kj_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONString.")
        return nil
    }
}