import Foundation
import Alamofire
public typealias Manager = Alamofire.SessionManager
internal typealias Request = Alamofire.Request
internal typealias DownloadRequest = Alamofire.DownloadRequest
internal typealias UploadRequest = Alamofire.UploadRequest
internal typealias DataRequest = Alamofire.DataRequest
internal typealias URLRequestConvertible = Alamofire.URLRequestConvertible
public typealias Method = Alamofire.HTTPMethod
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias URLEncoding = Alamofire.URLEncoding
public typealias PropertyListEncoding = Alamofire.PropertyListEncoding
public typealias RequestMultipartFormData = Alamofire.MultipartFormData
public typealias MultipartFormDataEncodingResult = Manager.MultipartFormDataEncodingResult
public typealias DownloadDestination = Alamofire.DownloadRequest.DownloadFileDestination
extension Request: RequestType { }
public final class CancellableToken: Cancellable, CustomDebugStringConvertible {
    let cancelAction: () -> Void
    let request: Request?
    public fileprivate(set) var isCancelled = false
    fileprivate var lock: DispatchSemaphore = DispatchSemaphore(value: 1)
    public func cancel() {
        _ = lock.wait(timeout: DispatchTime.distantFuture)
        defer { lock.signal() }
        guard !isCancelled else { return }
        isCancelled = true
        cancelAction()
    }
    public init(action: @escaping () -> Void) {
        self.cancelAction = action
        self.request = nil
    }
    init(request: Request) {
        self.request = request
        self.cancelAction = {
            request.cancel()
        }
    }
    public var debugDescription: String {
        guard let request = self.request else {
            return "Empty Request"
        }
        return request.debugDescription
    }
}
internal typealias RequestableCompletion = (HTTPURLResponse?, URLRequest?, Data?, Swift.Error?) -> Void
internal protocol Requestable {
    func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self
}
extension DataRequest: Requestable {
    internal func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self {
        return response(queue: callbackQueue) { handler  in
            completionHandler(handler.response, handler.request, handler.data, handler.error)
        }
    }
}
extension DownloadRequest: Requestable {
    internal func response(callbackQueue: DispatchQueue?, completionHandler: @escaping RequestableCompletion) -> Self {
        return response(queue: callbackQueue) { handler  in
            completionHandler(handler.response, handler.request, nil, handler.error)
        }
    }
}