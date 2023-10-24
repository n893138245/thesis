import Foundation
import Result
public typealias Completion = (_ result: Result<Moya.Response, MoyaError>) -> Void
public typealias ProgressBlock = (_ progress: ProgressResponse) -> Void
public struct ProgressResponse {
    public let response: Response?
    public let progressObject: Progress?
    public init(progress: Progress? = nil, response: Response? = nil) {
        self.progressObject = progress
        self.response = response
    }
    public var progress: Double {
        if completed {
            return 1.0
        } else if let progressObject = progressObject, progressObject.totalUnitCount > 0 {
            return progressObject.fractionCompleted
        } else {
            return 0.0
        }
    }
    public var completed: Bool {
        return response != nil
    }
}
public protocol MoyaProviderType: AnyObject {
    associatedtype Target: TargetType
    func request(_ target: Target, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable
}
open class MoyaProvider<Target: TargetType>: MoyaProviderType {
    public typealias EndpointClosure = (Target) -> Endpoint
    public typealias RequestResultClosure = (Result<URLRequest, MoyaError>) -> Void
    public typealias RequestClosure = (Endpoint, @escaping RequestResultClosure) -> Void
    public typealias StubClosure = (Target) -> Moya.StubBehavior
    public let endpointClosure: EndpointClosure
    public let requestClosure: RequestClosure
    public let stubClosure: StubClosure
    public let manager: Manager
    public let plugins: [PluginType]
    public let trackInflights: Bool
    open internal(set) var inflightRequests: [Endpoint: [Moya.Completion]] = [:]
    let callbackQueue: DispatchQueue?
    public init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
        self.endpointClosure = endpointClosure
        self.requestClosure = requestClosure
        self.stubClosure = stubClosure
        self.manager = manager
        self.plugins = plugins
        self.trackInflights = trackInflights
        self.callbackQueue = callbackQueue
    }
    open func endpoint(_ token: Target) -> Endpoint {
        return endpointClosure(token)
    }
    @discardableResult
    open func request(_ target: Target,
                      callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping Completion) -> Cancellable {
        let callbackQueue = callbackQueue ?? self.callbackQueue
        return requestNormal(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    @discardableResult
    open func stubRequest(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, completion: @escaping Moya.Completion, endpoint: Endpoint, stubBehavior: Moya.StubBehavior) -> CancellableToken {
        let callbackQueue = callbackQueue ?? self.callbackQueue
        let cancellableToken = CancellableToken { }
        notifyPluginsOfImpendingStub(for: request, target: target)
        let plugins = self.plugins
        let stub: () -> Void = createStubFunction(cancellableToken, forTarget: target, withCompletion: completion, endpoint: endpoint, plugins: plugins, request: request)
        switch stubBehavior {
        case .immediate:
            switch callbackQueue {
            case .none:
                stub()
            case .some(let callbackQueue):
                callbackQueue.async(execute: stub)
            }
        case .delayed(let delay):
            let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
            let killTime = DispatchTime.now() + Double(killTimeOffset) / Double(NSEC_PER_SEC)
            (callbackQueue ?? DispatchQueue.main).asyncAfter(deadline: killTime) {
                stub()
            }
        case .never:
            fatalError("Method called to stub request when stubbing is disabled.")
        }
        return cancellableToken
    }
}
public enum StubBehavior {
    case never
    case immediate
    case delayed(seconds: TimeInterval)
}
public extension MoyaProvider {
    final class func neverStub(_: Target) -> Moya.StubBehavior {
        return .never
    }
    final class func immediatelyStub(_: Target) -> Moya.StubBehavior {
        return .immediate
    }
    final class func delayedStub(_ seconds: TimeInterval) -> (Target) -> Moya.StubBehavior {
        return { _ in return .delayed(seconds: seconds) }
    }
}
public func convertResponseToResult(_ response: HTTPURLResponse?, request: URLRequest?, data: Data?, error: Swift.Error?) ->
    Result<Moya.Response, MoyaError> {
        switch (response, data, error) {
        case let (.some(response), data, .none):
            let response = Moya.Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            return .success(response)
        case let (.some(response), _, .some(error)):
            let response = Moya.Response(statusCode: response.statusCode, data: data ?? Data(), request: request, response: response)
            let error = MoyaError.underlying(error, response)
            return .failure(error)
        case let (_, _, .some(error)):
            let error = MoyaError.underlying(error, nil)
            return .failure(error)
        default:
            let error = MoyaError.underlying(NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil), nil)
            return .failure(error)
        }
}