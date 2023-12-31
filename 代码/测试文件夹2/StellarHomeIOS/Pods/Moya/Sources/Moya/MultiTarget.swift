import Foundation
public enum MultiTarget: TargetType {
    case target(TargetType)
    public init(_ target: TargetType) {
        self = MultiTarget.target(target)
    }
    public var path: String {
        return target.path
    }
    public var baseURL: URL {
        return target.baseURL
    }
    public var method: Moya.Method {
        return target.method
    }
    public var sampleData: Data {
        return target.sampleData
    }
    public var task: Task {
        return target.task
    }
    public var validationType: ValidationType {
        return target.validationType
    }
    public var headers: [String: String]? {
        return target.headers
    }
    public var target: TargetType {
        switch self {
        case .target(let target): return target
        }
    }
}