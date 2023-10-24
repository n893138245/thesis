import Foundation
import ImageIO
public struct ImageCreatingOptions {
    public let scale: CGFloat
    public let duration: TimeInterval
    public let preloadAll: Bool
    public let onlyFirstFrame: Bool
    public init(
        scale: CGFloat = 1.0,
        duration: TimeInterval = 0.0,
        preloadAll: Bool = false,
        onlyFirstFrame: Bool = false)
    {
        self.scale = scale
        self.duration = duration
        self.preloadAll = preloadAll
        self.onlyFirstFrame = onlyFirstFrame
    }
}
class GIFAnimatedImage {
    let images: [KFCrossPlatformImage]
    let duration: TimeInterval
    init?(from imageSource: CGImageSource, for info: [String: Any], options: ImageCreatingOptions) {
        let frameCount = CGImageSourceGetCount(imageSource)
        var images = [KFCrossPlatformImage]()
        var gifDuration = 0.0
        for i in 0 ..< frameCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, info as CFDictionary) else {
                return nil
            }
            if frameCount == 1 {
                gifDuration = .infinity
            } else {
                gifDuration += GIFAnimatedImage.getFrameDuration(from: imageSource, at: i)
            }
            images.append(KingfisherWrapper.image(cgImage: imageRef, scale: options.scale, refImage: nil))
            if options.onlyFirstFrame { break }
        }
        self.images = images
        self.duration = gifDuration
    }
    static func getFrameDuration(from gifInfo: [String: Any]?) -> TimeInterval {
        let defaultFrameDuration = 0.1
        guard let gifInfo = gifInfo else { return defaultFrameDuration }
        let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
        let duration = unclampedDelayTime ?? delayTime
        guard let frameDuration = duration else { return defaultFrameDuration }
        return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : defaultFrameDuration
    }
    static func getFrameDuration(from imageSource: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil)
            as? [String: Any] else { return 0.0 }
        let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        return getFrameDuration(from: gifInfo)
    }
}