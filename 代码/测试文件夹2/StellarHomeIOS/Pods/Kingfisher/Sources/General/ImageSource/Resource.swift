import Foundation
public protocol Resource {
    var cacheKey: String { get }
    var downloadURL: URL { get }
}
extension Resource {
    public func convertToSource() -> Source {
        return downloadURL.isFileURL ?
            .provider(LocalFileImageDataProvider(fileURL: downloadURL, cacheKey: cacheKey)) :
            .network(self)
    }
}
public struct ImageResource: Resource {
    public init(downloadURL: URL, cacheKey: String? = nil) {
        self.downloadURL = downloadURL
        self.cacheKey = cacheKey ?? downloadURL.absoluteString
    }
    public let cacheKey: String
    public let downloadURL: URL
}
extension URL: Resource {
    public var cacheKey: String { return absoluteString }
    public var downloadURL: URL { return self }
}