import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.Date
import struct Foundation.TimeInterval
import class Foundation.JSONSerialization
import class Foundation.NSError
import var Foundation.NSURLErrorCancelled
import var Foundation.NSURLErrorDomain
#if canImport(FoundationNetworking)
import struct FoundationNetworking.URLRequest
import class FoundationNetworking.HTTPURLResponse
import class FoundationNetworking.URLSession
import class FoundationNetworking.URLResponse
#else
import struct Foundation.URLRequest
import class Foundation.HTTPURLResponse
import class Foundation.URLSession
import class Foundation.URLResponse
#endif
#if os(Linux)
    import Foundation
#endif
import RxSwift
public enum RxCocoaURLError
    : Swift.Error {
    case unknown
    case nonHTTPResponse(response: URLResponse)
    case httpRequestFailed(response: HTTPURLResponse, data: Data?)
    case deserializationError(error: Swift.Error)
}
extension RxCocoaURLError
    : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "Unknown error has occurred."
        case let .nonHTTPResponse(response):
            return "Response is not NSHTTPURLResponse `\(response)`."
        case let .httpRequestFailed(response, _):
            return "HTTP request failed with `\(response.statusCode)`."
        case let .deserializationError(error):
            return "Error during deserialization of the response: \(error)"
        }
    }
}
private func escapeTerminalString(_ value: String) -> String {
    return value.replacingOccurrences(of: "\"", with: "\\\"", options:[], range: nil)
}
private func convertURLRequestToCurlCommand(_ request: URLRequest) -> String {
    let method = request.httpMethod ?? "GET"
    var returnValue = "curl -X \(method) "
    if let httpBody = request.httpBody, request.httpMethod == "POST" || request.httpMethod == "PUT" {
        let maybeBody = String(data: httpBody, encoding: String.Encoding.utf8)
        if let body = maybeBody {
            returnValue += "-d \"\(escapeTerminalString(body))\" "
        }
    }
    for (key, value) in request.allHTTPHeaderFields ?? [:] {
        let escapedKey = escapeTerminalString(key as String)
        let escapedValue = escapeTerminalString(value as String)
        returnValue += "\n    -H \"\(escapedKey): \(escapedValue)\" "
    }
    let URLString = request.url?.absoluteString ?? "<unknown url>"
    returnValue += "\n\"\(escapeTerminalString(URLString))\""
    returnValue += " -i -v"
    return returnValue
}
private func convertResponseToString(_ response: URLResponse?, _ error: NSError?, _ interval: TimeInterval) -> String {
    let ms = Int(interval * 1000)
    if let response = response as? HTTPURLResponse {
        if 200 ..< 300 ~= response.statusCode {
            return "Success (\(ms)ms): Status \(response.statusCode)"
        }
        else {
            return "Failure (\(ms)ms): Status \(response.statusCode)"
        }
    }
    if let error = error {
        if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
            return "Canceled (\(ms)ms)"
        }
        return "Failure (\(ms)ms): NSError > \(error)"
    }
    return "<Unhandled response from server>"
}
extension Reactive where Base: URLSession {
    public func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.create { observer in
            let d: Date?
            if Logging.URLRequests(request) {
                d = Date()
            }
            else {
               d = nil
            }
            let task = self.base.dataTask(with: request) { data, response, error in
                if Logging.URLRequests(request) {
                    let interval = Date().timeIntervalSince(d ?? Date())
                    print(convertURLRequestToCurlCommand(request))
                    #if os(Linux)
                        print(convertResponseToString(response, error.flatMap { $0 as NSError }, interval))
                    #else
                        print(convertResponseToString(response, error.map { $0 as NSError }, interval))
                    #endif
                }
                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
    public func data(request: URLRequest) -> Observable<Data> {
        return self.response(request: request).map { pair -> Data in
            if 200 ..< 300 ~= pair.0.statusCode {
                return pair.1
            }
            else {
                throw RxCocoaURLError.httpRequestFailed(response: pair.0, data: pair.1)
            }
        }
    }
    public func json(request: URLRequest, options: JSONSerialization.ReadingOptions = []) -> Observable<Any> {
        return self.data(request: request).map { data -> Any in
            do {
                return try JSONSerialization.jsonObject(with: data, options: options)
            } catch let error {
                throw RxCocoaURLError.deserializationError(error: error)
            }
        }
    }
    public func json(url: Foundation.URL) -> Observable<Any> {
        return self.json(request: URLRequest(url: url))
    }
}