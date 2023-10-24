import Foundation
import Result
public protocol AccessTokenAuthorizable {
    var authorizationType: AuthorizationType { get }
}
public enum AuthorizationType {
    case none
    case basic
    case bearer
    case custom(String)
    public var value: String? {
        switch self {
        case .none: return nil
        case .basic: return "Basic"
        case .bearer: return "Bearer"
        case .custom(let customValue): return customValue
        }
    }
}
public struct AccessTokenPlugin: PluginType {
    public let tokenClosure: () -> String
    public init(tokenClosure: @escaping () -> String) {
        self.tokenClosure = tokenClosure
    }
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        let authorizationType = authorizable.authorizationType
        var request = request
        switch authorizationType {
        case .basic, .bearer, .custom:
            if let value = authorizationType.value {
                let authValue = value + " " + tokenClosure()
                request.addValue(authValue, forHTTPHeaderField: "Authorization")
            }
        case .none:
            break
        }
        return request
    }
}