import Foundation
public struct DefaultDataResponse {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
    public let error: Error?
    public let timeline: Timeline
    var _metrics: AnyObject?
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        timeline: Timeline = Timeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.timeline = timeline
    }
}
public struct DataResponse<Value> {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
    public let result: Result<Value>
    public let timeline: Timeline
    public var value: Value? { return result.value }
    public var error: Error? { return result.error }
    var _metrics: AnyObject?
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: Result<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.timeline = timeline
    }
}
extension DataResponse: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return result.debugDescription
    }
    public var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { "\($0)" } ?? "nil"
        let responseBody = data.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        return """
        [Request]: \(requestDescription)
        [Request Body]: \n\(requestBody)
        [Response]: \(responseDescription)
        [Response Body]: \n\(responseBody)
        [Result]: \(result)
        [Timeline]: \(timeline.debugDescription)
        """
    }
}
extension DataResponse {
    public func map<T>(_ transform: (Value) -> T) -> DataResponse<T> {
        var response = DataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.map(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func flatMap<T>(_ transform: (Value) throws -> T) -> DataResponse<T> {
        var response = DataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMap(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func mapError<E: Error>(_ transform: (Error) -> E) -> DataResponse {
        var response = DataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.mapError(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> DataResponse {
        var response = DataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMapError(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
}
public struct DefaultDownloadResponse {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let temporaryURL: URL?
    public let destinationURL: URL?
    public let resumeData: Data?
    public let error: Error?
    public let timeline: Timeline
    var _metrics: AnyObject?
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        error: Error?,
        timeline: Timeline = Timeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.error = error
        self.timeline = timeline
    }
}
public struct DownloadResponse<Value> {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let temporaryURL: URL?
    public let destinationURL: URL?
    public let resumeData: Data?
    public let result: Result<Value>
    public let timeline: Timeline
    public var value: Value? { return result.value }
    public var error: Error? { return result.error }
    var _metrics: AnyObject?
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        temporaryURL: URL?,
        destinationURL: URL?,
        resumeData: Data?,
        result: Result<Value>,
        timeline: Timeline = Timeline())
    {
        self.request = request
        self.response = response
        self.temporaryURL = temporaryURL
        self.destinationURL = destinationURL
        self.resumeData = resumeData
        self.result = result
        self.timeline = timeline
    }
}
extension DownloadResponse: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return result.debugDescription
    }
    public var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { "\($0)" } ?? "nil"
        return """
        [Request]: \(requestDescription)
        [Request Body]: \n\(requestBody)
        [Response]: \(responseDescription)
        [TemporaryURL]: \(temporaryURL?.path ?? "nil")
        [DestinationURL]: \(destinationURL?.path ?? "nil")
        [ResumeData]: \(resumeData?.count ?? 0) bytes
        [Result]: \(result)
        [Timeline]: \(timeline.debugDescription)
        """
    }
}
extension DownloadResponse {
    public func map<T>(_ transform: (Value) -> T) -> DownloadResponse<T> {
        var response = DownloadResponse<T>(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.map(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func flatMap<T>(_ transform: (Value) throws -> T) -> DownloadResponse<T> {
        var response = DownloadResponse<T>(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.flatMap(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func mapError<E: Error>(_ transform: (Error) -> E) -> DownloadResponse {
        var response = DownloadResponse(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.mapError(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
    public func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> DownloadResponse {
        var response = DownloadResponse(
            request: request,
            response: self.response,
            temporaryURL: temporaryURL,
            destinationURL: destinationURL,
            resumeData: resumeData,
            result: result.flatMapError(transform),
            timeline: timeline
        )
        response._metrics = _metrics
        return response
    }
}
protocol Response {
    var _metrics: AnyObject? { get set }
    mutating func add(_ metrics: AnyObject?)
}
extension Response {
    mutating func add(_ metrics: AnyObject?) {
        #if !os(watchOS)
            guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) else { return }
            guard let metrics = metrics as? URLSessionTaskMetrics else { return }
            _metrics = metrics
        #endif
    }
}
@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDataResponse: Response {
#if !os(watchOS)
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DataResponse: Response {
#if !os(watchOS)
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DefaultDownloadResponse: Response {
#if !os(watchOS)
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension DownloadResponse: Response {
#if !os(watchOS)
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}