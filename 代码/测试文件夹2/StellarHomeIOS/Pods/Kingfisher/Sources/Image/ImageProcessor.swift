import Foundation
import CoreGraphics
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif
public enum ImageProcessItem {
    case image(KFCrossPlatformImage)
    case data(Data)
}
public protocol ImageProcessor {
    var identifier: String { get }
    @available(*, deprecated,
    message: "Deprecated. Implement the method with same name but with `KingfisherParsedOptionsInfo` instead.")
    func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> KFCrossPlatformImage?
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage?
}
extension ImageProcessor {
    public func process(item: ImageProcessItem, options: KingfisherOptionsInfo) -> KFCrossPlatformImage? {
        return process(item: item, options: KingfisherParsedOptionsInfo(options))
    }
}
extension ImageProcessor {
    public func append(another: ImageProcessor) -> ImageProcessor {
        let newIdentifier = identifier.appending("|>\(another.identifier)")
        return GeneralProcessor(identifier: newIdentifier) {
            item, options in
            if let image = self.process(item: item, options: options) {
                return another.process(item: .image(image), options: options)
            } else {
                return nil
            }
        }
    }
}
func ==(left: ImageProcessor, right: ImageProcessor) -> Bool {
    return left.identifier == right.identifier
}
func !=(left: ImageProcessor, right: ImageProcessor) -> Bool {
    return !(left == right)
}
typealias ProcessorImp = ((ImageProcessItem, KingfisherParsedOptionsInfo) -> KFCrossPlatformImage?)
struct GeneralProcessor: ImageProcessor {
    let identifier: String
    let p: ProcessorImp
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        return p(item, options)
    }
}
public struct DefaultImageProcessor: ImageProcessor {
    public static let `default` = DefaultImageProcessor()
    public let identifier = ""
    public init() {}
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
        case .data(let data):
            return KingfisherWrapper.image(data: data, options: options.imageCreatingOptions)
        }
    }
}
public struct RectCorner: OptionSet {
    public let rawValue: Int
    public static let topLeft = RectCorner(rawValue: 1 << 0)
    public static let topRight = RectCorner(rawValue: 1 << 1)
    public static let bottomLeft = RectCorner(rawValue: 1 << 2)
    public static let bottomRight = RectCorner(rawValue: 1 << 3)
    public static let all: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    var cornerIdentifier: String {
        if self == .all {
            return ""
        }
        return "_corner(\(rawValue))"
    }
}
#if !os(macOS)
public struct BlendImageProcessor: ImageProcessor {
    public let identifier: String
    public let blendMode: CGBlendMode
    public let alpha: CGFloat
    public let backgroundColor: KFCrossPlatformColor?
    public init(blendMode: CGBlendMode, alpha: CGFloat = 1.0, backgroundColor: KFCrossPlatformColor? = nil) {
        self.blendMode = blendMode
        self.alpha = alpha
        self.backgroundColor = backgroundColor
        var identifier = "com.onevcat.Kingfisher.BlendImageProcessor(\(blendMode.rawValue),\(alpha))"
        if let color = backgroundColor {
            identifier.append("_\(color.hex)")
        }
        self.identifier = identifier
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.image(withBlendMode: blendMode, alpha: alpha, backgroundColor: backgroundColor)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
#endif
#if os(macOS)
public struct CompositingImageProcessor: ImageProcessor {
    public let identifier: String
    public let compositingOperation: NSCompositingOperation
    public let alpha: CGFloat
    public let backgroundColor: KFCrossPlatformColor?
    public init(compositingOperation: NSCompositingOperation,
                alpha: CGFloat = 1.0,
                backgroundColor: KFCrossPlatformColor? = nil)
    {
        self.compositingOperation = compositingOperation
        self.alpha = alpha
        self.backgroundColor = backgroundColor
        var identifier = "com.onevcat.Kingfisher.CompositingImageProcessor(\(compositingOperation.rawValue),\(alpha))"
        if let color = backgroundColor {
            identifier.append("_\(color.hex)")
        }
        self.identifier = identifier
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.image(
                            withCompositingOperation: compositingOperation,
                            alpha: alpha,
                            backgroundColor: backgroundColor)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
#endif
public struct RoundCornerImageProcessor: ImageProcessor {
    public enum Radius {
        case widthFraction(CGFloat)
        case heightFraction(CGFloat)
        case point(CGFloat)
        var radiusIdentifier: String {
            switch self {
            case .widthFraction(let f):
                return "w_frac_\(f)"
            case .heightFraction(let f):
                return "h_frac_\(f)"
            case .point(let p):
                return p.description
            }
        }
    }
    public let identifier: String
    @available(*, deprecated, message: "Use `radius` property instead.")
    public var cornerRadius: CGFloat {
        switch radius {
        case .widthFraction, .heightFraction:
            return 0.0
        case .point(let value):
            return value
        }
    }
    public let radius: Radius
    public let roundingCorners: RectCorner
    public let targetSize: CGSize?
    public let backgroundColor: KFCrossPlatformColor?
    public init(
        cornerRadius: CGFloat,
        targetSize: CGSize? = nil,
        roundingCorners corners: RectCorner = .all,
        backgroundColor: KFCrossPlatformColor? = nil
    )
    {
        let radius = Radius.point(cornerRadius)
        self.init(radius: radius, targetSize: targetSize, roundingCorners: corners, backgroundColor: backgroundColor)
    }
    public init(
        radius: Radius,
        targetSize: CGSize? = nil,
        roundingCorners corners: RectCorner = .all,
        backgroundColor: KFCrossPlatformColor? = nil
    )
    {
        self.radius = radius
        self.targetSize = targetSize
        self.roundingCorners = corners
        self.backgroundColor = backgroundColor
        self.identifier = {
            var identifier = ""
            if let size = targetSize {
                identifier = "com.onevcat.Kingfisher.RoundCornerImageProcessor" +
                             "(\(radius.radiusIdentifier)_\(size)\(corners.cornerIdentifier))"
            } else {
                identifier = "com.onevcat.Kingfisher.RoundCornerImageProcessor" +
                             "(\(radius.radiusIdentifier)\(corners.cornerIdentifier))"
            }
            if let backgroundColor = backgroundColor {
                identifier += "_\(backgroundColor)"
            }
            return identifier
        }()
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            let size = targetSize ?? image.kf.size
            let cornerRadius: CGFloat
            switch radius {
            case .point(let point):
                cornerRadius = point
            case .widthFraction(let widthFraction):
                cornerRadius = size.width * widthFraction
            case .heightFraction(let heightFraction):
                cornerRadius = size.height * heightFraction
            }
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.image(
                            withRoundRadius: cornerRadius,
                            fit: size,
                            roundingCorners: roundingCorners,
                            backgroundColor: backgroundColor)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public enum ContentMode {
    case none
    case aspectFit
    case aspectFill
}
public struct ResizingImageProcessor: ImageProcessor {
    public let identifier: String
    public let referenceSize: CGSize
    public let targetContentMode: ContentMode
    public init(referenceSize: CGSize, mode: ContentMode = .none) {
        self.referenceSize = referenceSize
        self.targetContentMode = mode
        if mode == .none {
            self.identifier = "com.onevcat.Kingfisher.ResizingImageProcessor(\(referenceSize))"
        } else {
            self.identifier = "com.onevcat.Kingfisher.ResizingImageProcessor(\(referenceSize), \(mode))"
        }
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.resize(to: referenceSize, for: targetContentMode)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct BlurImageProcessor: ImageProcessor {
    public let identifier: String
    public let blurRadius: CGFloat
    public init(blurRadius: CGFloat) {
        self.blurRadius = blurRadius
        self.identifier = "com.onevcat.Kingfisher.BlurImageProcessor(\(blurRadius))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            let radius = blurRadius * options.scaleFactor
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.blurred(withRadius: radius)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct OverlayImageProcessor: ImageProcessor {
    public let identifier: String
    public let overlay: KFCrossPlatformColor
    public let fraction: CGFloat
    public init(overlay: KFCrossPlatformColor, fraction: CGFloat = 0.5) {
        self.overlay = overlay
        self.fraction = fraction
        self.identifier = "com.onevcat.Kingfisher.OverlayImageProcessor(\(overlay.hex)_\(fraction))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.overlaying(with: overlay, fraction: fraction)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct TintImageProcessor: ImageProcessor {
    public let identifier: String
    public let tint: KFCrossPlatformColor
    public init(tint: KFCrossPlatformColor) {
        self.tint = tint
        self.identifier = "com.onevcat.Kingfisher.TintImageProcessor(\(tint.hex))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.tinted(with: tint)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct ColorControlsProcessor: ImageProcessor {
    public let identifier: String
    public let brightness: CGFloat
    public let contrast: CGFloat
    public let saturation: CGFloat
    public let inputEV: CGFloat
    public init(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat, inputEV: CGFloat) {
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.inputEV = inputEV
        self.identifier = "com.onevcat.Kingfisher.ColorControlsProcessor(\(brightness)_\(contrast)_\(saturation)_\(inputEV))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.adjusted(brightness: brightness, contrast: contrast, saturation: saturation, inputEV: inputEV)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct BlackWhiteProcessor: ImageProcessor {
    public let identifier = "com.onevcat.Kingfisher.BlackWhiteProcessor"
    public init() {}
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        return ColorControlsProcessor(brightness: 0.0, contrast: 1.0, saturation: 0.0, inputEV: 0.7)
            .process(item: item, options: options)
    }
}
public struct CroppingImageProcessor: ImageProcessor {
    public let identifier: String
    public let size: CGSize
    public let anchor: CGPoint
    public init(size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.size = size
        self.anchor = anchor
        self.identifier = "com.onevcat.Kingfisher.CroppingImageProcessor(\(size)_\(anchor))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.scaled(to: options.scaleFactor)
                        .kf.crop(to: size, anchorOn: anchor)
        case .data: return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct DownsamplingImageProcessor: ImageProcessor {
    public let size: CGSize
    public let identifier: String
    public init(size: CGSize) {
        self.size = size
        self.identifier = "com.onevcat.Kingfisher.DownsamplingImageProcessor(\(size))"
    }
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            guard let data = image.kf.data(format: .unknown) else {
                return nil
            }
            return KingfisherWrapper.downsampledImage(data: data, to: size, scale: options.scaleFactor)
        case .data(let data):
            return KingfisherWrapper.downsampledImage(data: data, to: size, scale: options.scaleFactor)
        }
    }
}
@available(*, deprecated,
message: "Will be removed soon. Use `|>` instead.",
renamed: "|>")
public func >>(left: ImageProcessor, right: ImageProcessor) -> ImageProcessor {
    return left.append(another: right)
}
infix operator |>: AdditionPrecedence
public func |>(left: ImageProcessor, right: ImageProcessor) -> ImageProcessor {
    return left.append(another: right)
}
extension KFCrossPlatformColor {
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        #if os(macOS)
        (usingColorSpace(.sRGB) ?? self).getRed(&r, green: &g, blue: &b, alpha: &a)
        #else
        getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        let rInt = Int(r * 255) << 24
        let gInt = Int(g * 255) << 16
        let bInt = Int(b * 255) << 8
        let aInt = Int(a * 255)
        let rgba = rInt | gInt | bInt | aInt
        return String(format:"#%08x", rgba)
    }
}