import Foundation
public protocol ImageDownloadRedirectHandler {
    func handleHTTPRedirection(
        for task: SessionDataTask,
        response: HTTPURLResponse,
        newRequest: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
}
public struct AnyRedirectHandler: ImageDownloadRedirectHandler {
    let block: (SessionDataTask, HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void
    public func handleHTTPRedirection(
        for task: SessionDataTask,
        response: HTTPURLResponse,
        newRequest: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        block(task, response, newRequest, completionHandler)
    }
    public init(handle: @escaping (SessionDataTask, HTTPURLResponse, URLRequest, (URLRequest?) -> Void) -> Void) {
        block = handle
    }
}