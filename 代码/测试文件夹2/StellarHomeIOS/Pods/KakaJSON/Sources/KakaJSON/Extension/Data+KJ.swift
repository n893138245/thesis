import Foundation
extension Data: KJCompatible {}
extension NSData: KJCompatible {}
public extension KJ where Base == Data {
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return model(type: type) as? M
    }
    func model(type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kj_JSON(base, [String: Any].self) {
            return json.kj.model(type: type)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
    func modelArray<M: Convertible>(_ type: M.Type) -> [M] {
        return modelArray(type: type) as! [M]
    }
    func modelArray(type: Convertible.Type) -> [Convertible] {
        if let json = JSONSerialization.kj_JSON(base, [Any].self) {
            return json.kj.modelArray(type: type)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return []
    }
}
public extension KJ where Base: NSData {
    func model<M: Convertible>(_ type: M.Type) -> M? {
        return (base as Data).kj.model(type)
    }
    func model(type: Convertible.Type) -> Convertible? {
        return (base as Data).kj.model(type: type)
    }
    func modelArray<M: Convertible>(_ type: M.Type) -> [M] {
        return (base as Data).kj.modelArray(type)
    }
    func modelArray(type: Convertible.Type) -> [Convertible] {
        return (base as Data).kj.modelArray(type: type)
    }
}
extension Data {
    func kj_fastModel(_ type: Convertible.Type) -> Convertible? {
        if let json = JSONSerialization.kj_JSON(self, [String: Any].self) {
            return json.kj_fastModel(type)
        }
        Logger.error("Failed to get JSON from JSONData.")
        return nil
    }
}