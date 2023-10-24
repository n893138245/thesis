import Foundation
public protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: Moya.Method { get }
    var sampleData: Data { get }
    var task: Task { get }
    var validationType: ValidationType { get }
    var headers: [String: String]? { get }
}
public extension TargetType {
    var validationType: ValidationType {
        return .none
    }
}