import Foundation
open class SessionDelegate: NSObject {
    open var sessionDidBecomeInvalidWithError: ((URLSession, Error?) -> Void)?
    open var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    open var sessionDidFinishEventsForBackgroundURLSession: ((URLSession) -> Void)?
    open var taskWillPerformHTTPRedirection: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest) -> URLRequest?)?
    open var taskWillPerformHTTPRedirectionWithCompletion: ((URLSession, URLSessionTask, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?
    open var taskDidReceiveChallenge: ((URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?))?
    open var taskDidReceiveChallengeWithCompletion: ((URLSession, URLSessionTask, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    open var taskNeedNewBodyStream: ((URLSession, URLSessionTask) -> InputStream?)?
    open var taskNeedNewBodyStreamWithCompletion: ((URLSession, URLSessionTask, @escaping (InputStream?) -> Void) -> Void)?
    open var taskDidSendBodyData: ((URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
    open var taskDidComplete: ((URLSession, URLSessionTask, Error?) -> Void)?
    open var dataTaskDidReceiveResponse: ((URLSession, URLSessionDataTask, URLResponse) -> URLSession.ResponseDisposition)?
    open var dataTaskDidReceiveResponseWithCompletion: ((URLSession, URLSessionDataTask, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?
    open var dataTaskDidBecomeDownloadTask: ((URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
    open var dataTaskDidReceiveData: ((URLSession, URLSessionDataTask, Data) -> Void)?
    open var dataTaskWillCacheResponse: ((URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
    open var dataTaskWillCacheResponseWithCompletion: ((URLSession, URLSessionDataTask, CachedURLResponse, @escaping (CachedURLResponse?) -> Void) -> Void)?
    open var downloadTaskDidFinishDownloadingToURL: ((URLSession, URLSessionDownloadTask, URL) -> Void)?
    open var downloadTaskDidWriteData: ((URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
    open var downloadTaskDidResumeAtOffset: ((URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
#if !os(watchOS)
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskReadClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskReadClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskReadClosed = newValue
        }
    }
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskWriteClosed: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskWriteClosed as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskWriteClosed = newValue
        }
    }
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskBetterRouteDiscovered: ((URLSession, URLSessionStreamTask) -> Void)? {
        get {
            return _streamTaskBetterRouteDiscovered as? (URLSession, URLSessionStreamTask) -> Void
        }
        set {
            _streamTaskBetterRouteDiscovered = newValue
        }
    }
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    open var streamTaskDidBecomeInputAndOutputStreams: ((URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void)? {
        get {
            return _streamTaskDidBecomeInputStream as? (URLSession, URLSessionStreamTask, InputStream, OutputStream) -> Void
        }
        set {
            _streamTaskDidBecomeInputStream = newValue
        }
    }
    var _streamTaskReadClosed: Any?
    var _streamTaskWriteClosed: Any?
    var _streamTaskBetterRouteDiscovered: Any?
    var _streamTaskDidBecomeInputStream: Any?
#endif
    var retrier: RequestRetrier?
    weak var sessionManager: SessionManager?
    var requests: [Int: Request] = [:]
    private let lock = NSLock()
    open subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }
    public override init() {
        super.init()
    }
    open override func responds(to selector: Selector) -> Bool {
        #if !os(macOS)
            if selector == #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:)) {
                return sessionDidFinishEventsForBackgroundURLSession != nil
            }
        #endif
        #if !os(watchOS)
            if #available(iOS 9.0, macOS 10.11, tvOS 9.0, *) {
                switch selector {
                case #selector(URLSessionStreamDelegate.urlSession(_:readClosedFor:)):
                    return streamTaskReadClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:writeClosedFor:)):
                    return streamTaskWriteClosed != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:betterRouteDiscoveredFor:)):
                    return streamTaskBetterRouteDiscovered != nil
                case #selector(URLSessionStreamDelegate.urlSession(_:streamTask:didBecome:outputStream:)):
                    return streamTaskDidBecomeInputAndOutputStreams != nil
                default:
                    break
                }
            }
        #endif
        switch selector {
        case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
            return sessionDidBecomeInvalidWithError != nil
        case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
            return (sessionDidReceiveChallenge != nil  || sessionDidReceiveChallengeWithCompletion != nil)
        case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
            return (taskWillPerformHTTPRedirection != nil || taskWillPerformHTTPRedirectionWithCompletion != nil)
        case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
            return (dataTaskDidReceiveResponse != nil || dataTaskDidReceiveResponseWithCompletion != nil)
        default:
            return type(of: self).instancesRespond(to: selector)
        }
    }
}
extension SessionDelegate: URLSessionDelegate {
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError?(session, error)
    }
    open func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard sessionDidReceiveChallengeWithCompletion == nil else {
            sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
            return
        }
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        if let sessionDidReceiveChallenge = sessionDidReceiveChallenge {
            (disposition, credential) = sessionDidReceiveChallenge(session, challenge)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let host = challenge.protectionSpace.host
            if
                let serverTrustPolicy = session.serverTrustPolicyManager?.serverTrustPolicy(forHost: host),
                let serverTrust = challenge.protectionSpace.serverTrust
            {
                if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: serverTrust)
                } else {
                    disposition = .cancelAuthenticationChallenge
                }
            }
        }
        completionHandler(disposition, credential)
    }
#if !os(macOS)
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        sessionDidFinishEventsForBackgroundURLSession?(session)
    }
#endif
}
extension SessionDelegate: URLSessionTaskDelegate {
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        guard taskWillPerformHTTPRedirectionWithCompletion == nil else {
            taskWillPerformHTTPRedirectionWithCompletion?(session, task, response, request, completionHandler)
            return
        }
        var redirectRequest: URLRequest? = request
        if let taskWillPerformHTTPRedirection = taskWillPerformHTTPRedirection {
            redirectRequest = taskWillPerformHTTPRedirection(session, task, response, request)
        }
        completionHandler(redirectRequest)
    }
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        guard taskDidReceiveChallengeWithCompletion == nil else {
            taskDidReceiveChallengeWithCompletion?(session, task, challenge, completionHandler)
            return
        }
        if let taskDidReceiveChallenge = taskDidReceiveChallenge {
            let result = taskDidReceiveChallenge(session, task, challenge)
            completionHandler(result.0, result.1)
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(
                session,
                task: task,
                didReceive: challenge,
                completionHandler: completionHandler
            )
        } else {
            urlSession(session, didReceive: challenge, completionHandler: completionHandler)
        }
    }
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {
        guard taskNeedNewBodyStreamWithCompletion == nil else {
            taskNeedNewBodyStreamWithCompletion?(session, task, completionHandler)
            return
        }
        if let taskNeedNewBodyStream = taskNeedNewBodyStream {
            completionHandler(taskNeedNewBodyStream(session, task))
        } else if let delegate = self[task]?.delegate {
            delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
        }
    }
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
        if let taskDidSendBodyData = taskDidSendBodyData {
            taskDidSendBodyData(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
        } else if let delegate = self[task]?.delegate as? UploadTaskDelegate {
            delegate.URLSession(
                session,
                task: task,
                didSendBodyData: bytesSent,
                totalBytesSent: totalBytesSent,
                totalBytesExpectedToSend: totalBytesExpectedToSend
            )
        }
    }
#if !os(watchOS)
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
    @objc(URLSession:task:didFinishCollectingMetrics:)
    open func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self[task]?.delegate.metrics = metrics
    }
#endif
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let completeTask: (URLSession, URLSessionTask, Error?) -> Void = { [weak self] session, task, error in
            guard let strongSelf = self else { return }
            strongSelf.taskDidComplete?(session, task, error)
            strongSelf[task]?.delegate.urlSession(session, task: task, didCompleteWithError: error)
            var userInfo: [String: Any] = [Notification.Key.Task: task]
            if let data = (strongSelf[task]?.delegate as? DataTaskDelegate)?.data {
                userInfo[Notification.Key.ResponseData] = data
            }
            NotificationCenter.default.post(
                name: Notification.Name.Task.DidComplete,
                object: strongSelf,
                userInfo: userInfo
            )
            strongSelf[task] = nil
        }
        guard let request = self[task], let sessionManager = sessionManager else {
            completeTask(session, task, error)
            return
        }
        request.validations.forEach { $0() }
        var error: Error? = error
        if request.delegate.error != nil {
            error = request.delegate.error
        }
        if let retrier = retrier, let error = error {
            retrier.should(sessionManager, retry: request, with: error) { [weak self] shouldRetry, timeDelay in
                guard shouldRetry else { completeTask(session, task, error) ; return }
                DispatchQueue.utility.after(timeDelay) { [weak self] in
                    guard let strongSelf = self else { return }
                    let retrySucceeded = strongSelf.sessionManager?.retry(request) ?? false
                    if retrySucceeded, let task = request.task {
                        strongSelf[task] = request
                        return
                    } else {
                        completeTask(session, task, error)
                    }
                }
            }
        } else {
            completeTask(session, task, error)
        }
    }
}
extension SessionDelegate: URLSessionDataDelegate {
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        guard dataTaskDidReceiveResponseWithCompletion == nil else {
            dataTaskDidReceiveResponseWithCompletion?(session, dataTask, response, completionHandler)
            return
        }
        var disposition: URLSession.ResponseDisposition = .allow
        if let dataTaskDidReceiveResponse = dataTaskDidReceiveResponse {
            disposition = dataTaskDidReceiveResponse(session, dataTask, response)
        }
        completionHandler(disposition)
    }
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
        if let dataTaskDidBecomeDownloadTask = dataTaskDidBecomeDownloadTask {
            dataTaskDidBecomeDownloadTask(session, dataTask, downloadTask)
        } else {
            self[downloadTask]?.delegate = DownloadTaskDelegate(task: downloadTask)
        }
    }
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let dataTaskDidReceiveData = dataTaskDidReceiveData {
            dataTaskDidReceiveData(session, dataTask, data)
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
    }
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        guard dataTaskWillCacheResponseWithCompletion == nil else {
            dataTaskWillCacheResponseWithCompletion?(session, dataTask, proposedResponse, completionHandler)
            return
        }
        if let dataTaskWillCacheResponse = dataTaskWillCacheResponse {
            completionHandler(dataTaskWillCacheResponse(session, dataTask, proposedResponse))
        } else if let delegate = self[dataTask]?.delegate as? DataTaskDelegate {
            delegate.urlSession(
                session,
                dataTask: dataTask,
                willCacheResponse: proposedResponse,
                completionHandler: completionHandler
            )
        } else {
            completionHandler(proposedResponse)
        }
    }
}
extension SessionDelegate: URLSessionDownloadDelegate {
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        if let downloadTaskDidFinishDownloadingToURL = downloadTaskDidFinishDownloadingToURL {
            downloadTaskDidFinishDownloadingToURL(session, downloadTask, location)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
    }
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        if let downloadTaskDidWriteData = downloadTaskDidWriteData {
            downloadTaskDidWriteData(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten,
                totalBytesExpectedToWrite: totalBytesExpectedToWrite
            )
        }
    }
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
        if let downloadTaskDidResumeAtOffset = downloadTaskDidResumeAtOffset {
            downloadTaskDidResumeAtOffset(session, downloadTask, fileOffset, expectedTotalBytes)
        } else if let delegate = self[downloadTask]?.delegate as? DownloadTaskDelegate {
            delegate.urlSession(
                session,
                downloadTask: downloadTask,
                didResumeAtOffset: fileOffset,
                expectedTotalBytes: expectedTotalBytes
            )
        }
    }
}
#if !os(watchOS)
@available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
extension SessionDelegate: URLSessionStreamDelegate {
    open func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        streamTaskReadClosed?(session, streamTask)
    }
    open func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        streamTaskWriteClosed?(session, streamTask)
    }
    open func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        streamTaskBetterRouteDiscovered?(session, streamTask)
    }
    open func urlSession(
        _ session: URLSession,
        streamTask: URLSessionStreamTask,
        didBecome inputStream: InputStream,
        outputStream: OutputStream)
    {
        streamTaskDidBecomeInputAndOutputStreams?(session, streamTask, inputStream, outputStream)
    }
}
#endif