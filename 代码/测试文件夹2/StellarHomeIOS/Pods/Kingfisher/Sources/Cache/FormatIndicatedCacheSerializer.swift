import Foundation
import CoreGraphics
public struct FormatIndicatedCacheSerializer: CacheSerializer {
    public static let png = FormatIndicatedCacheSerializer(imageFormat: .PNG, jpegCompressionQuality: nil)
    public static let jpeg = FormatIndicatedCacheSerializer(imageFormat: .JPEG, jpegCompressionQuality: 1.0)
    public static func jpeg(compressionQuality: CGFloat) -> FormatIndicatedCacheSerializer {
        return FormatIndicatedCacheSerializer(imageFormat: .JPEG, jpegCompressionQuality: compressionQuality)
    }
    public static let gif = FormatIndicatedCacheSerializer(imageFormat: .GIF, jpegCompressionQuality: nil)
    private let imageFormat: ImageFormat
    private let jpegCompressionQuality: CGFloat?
    public func data(with image: KFCrossPlatformImage, original: Data?) -> Data? {
        func imageData(withFormat imageFormat: ImageFormat) -> Data? {
            return autoreleasepool { () -> Data? in
                switch imageFormat {
                case .PNG: return image.kf.pngRepresentation()
                case .JPEG: return image.kf.jpegRepresentation(compressionQuality: jpegCompressionQuality ?? 1.0)
                case .GIF: return image.kf.gifRepresentation()
                case .unknown: return nil
                }
            }
        }
        if let data = imageData(withFormat: imageFormat) {
            return data
        }
        let originalFormat = original?.kf.imageFormat ?? .unknown
        if originalFormat != imageFormat, let data = imageData(withFormat: originalFormat) {
            return data
        }
        return original ?? image.kf.normalized.kf.pngRepresentation()
    }
    public func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        return KingfisherWrapper.image(data: data, options: options.imageCreatingOptions)
    }
}