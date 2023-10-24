import Foundation
struct JSONHelper {
    static func dictionaryFromData(_ dictionaryAsData: Data?) -> [String: String]? {
        guard let dictionaryAsData = dictionaryAsData else {
            return nil
        }
        do {
            let dict = try JSONDecoder().decode([String: String].self, from: dictionaryAsData)
            return dict
        } catch {
            print("Could not read map from data")
        }
        return nil
    }
    static func dataFromDictionary(_ dictionary: [String: String]?) -> Data? {
        guard let dictionary = dictionary else {
            return nil
        }
        do {
            let data = try Data.init(base64Encoded: JSONEncoder().encode(dictionary).base64EncodedData())
            return data
        } catch {
            print("Could not create data from map")
        }
        return nil
    }
    static func arrayFromData(_ arrayAsData: Data?) -> [String]? {
        guard let arrayAsData = arrayAsData else {
            return nil
        }
        do {
            let array = try JSONDecoder().decode([String].self, from: arrayAsData)
            return array
        } catch {
            print("Could not read array from data")
        }
        return nil
    }
    static func dataFromArray(_ array:[String]?) -> Data? {
        guard let array = array else {
            return nil
        }
        do {
            let data = try Data.init(base64Encoded: JSONEncoder().encode(array).base64EncodedData())
            return data
        } catch {
            print("Could not create data from array")
        }
        return nil
    }
}