import Foundation
import Result
public enum NetworkActivityChangeType {
    case began, ended
}
public final class NetworkActivityPlugin: PluginType {
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType, _ target: TargetType) -> Void
    let networkActivityClosure: NetworkActivityClosure
    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    public func willSend(_ request: RequestType, target: TargetType) {
        networkActivityClosure(.began, target)
    }
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        networkActivityClosure(.ended, target)
    }
}