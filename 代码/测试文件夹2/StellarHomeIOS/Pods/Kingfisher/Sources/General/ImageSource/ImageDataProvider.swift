import Foundation
public protocol ImageDataProvider {
    var cacheKey: String { get }
    func data(handler: @escaping (Result<Data, Error>) -> Void)
    var contentURL: URL? { get }
}
public extension ImageDataProvider {
    var contentURL: URL? { return nil }
}
public struct LocalFileImageDataProvider: ImageDataProvider {
    public let fileURL: URL
    public init(fileURL: URL, cacheKey: String? = nil) {
        self.fileURL = fileURL
        self.cacheKey = cacheKey ?? fileURL.absoluteString
    }
    public var cacheKey: String
    public func data(handler: (Result<Data, Error>) -> Void) {
        handler(Result(catching: { try Data(contentsOf: fileURL) }))
    }
    public var contentURL: URL? {
        return fileURL
    }
}
public struct Base64ImageDataProvider: ImageDataProvider {
    public let base64String: String
    public init(base64String: String, cacheKey: String) {
        self.base64String = base64String
        self.cacheKey = cacheKey
    }
    public var cacheKey: String
    public func data(handler: (Result<Data, Error>) -> Void) {
        let data = Data(base64Encoded: base64String)!
        handler(.success(data))
    }
}
public struct RawImageDataProvider: ImageDataProvider {
    public let data: Data
    public init(data: Data, cacheKey: String) {
        self.data = data
        self.cacheKey = cacheKey
    }
    public var cacheKey: String
    public func data(handler: @escaping (Result<Data, Error>) -> Void) {
        handler(.success(data))
    }
}