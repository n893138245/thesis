import Foundation
import CoreGraphics
public protocol CacheSerializer {
    func data(with image: KFCrossPlatformImage, original: Data?) -> Data?
    func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage?
    @available(*, deprecated,
    message: "Deprecated. Implement the method with same name but with `KingfisherParsedOptionsInfo` instead.")
    func image(with data: Data, options: KingfisherOptionsInfo?) -> KFCrossPlatformImage?
}
extension CacheSerializer {
    public func image(with data: Data, options: KingfisherOptionsInfo?) -> KFCrossPlatformImage? {
        return image(with: data, options: KingfisherParsedOptionsInfo(options))
    }
}
public struct DefaultCacheSerializer: CacheSerializer {
    public static let `default` = DefaultCacheSerializer()
    public var compressionQuality: CGFloat = 1.0
    public var preferCacheOriginalData: Bool = false
    public init() { }
    public func data(with image: KFCrossPlatformImage, original: Data?) -> Data? {
        if preferCacheOriginalData {
            return original ??
                image.kf.data(
                    format: original?.kf.imageFormat ?? .unknown,
                    compressionQuality: compressionQuality
                )
        } else {
            return image.kf.data(
                format: original?.kf.imageFormat ?? .unknown,
                compressionQuality: compressionQuality
            )
        }
    }
    public func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        return KingfisherWrapper.image(data: data, options: options.imageCreatingOptions)
    }
}