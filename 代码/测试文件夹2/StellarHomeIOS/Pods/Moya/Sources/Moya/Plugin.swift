import Foundation
import Result
public protocol PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest
    func willSend(_ request: RequestType, target: TargetType)
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType)
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
}
public extension PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest { return request }
    func willSend(_ request: RequestType, target: TargetType) { }
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) { }
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> { return result }
}
public protocol RequestType {
    var request: URLRequest? { get }
    func authenticate(user: String, password: String, persistence: URLCredential.Persistence) -> Self
    func authenticate(usingCredential credential: URLCredential) -> Self
}