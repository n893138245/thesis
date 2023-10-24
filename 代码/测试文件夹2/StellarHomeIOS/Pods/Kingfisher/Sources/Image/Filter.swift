#if !os(watchOS)
import CoreImage
private let ciContext = CIContext(options: nil)
public typealias Transformer = (CIImage) -> CIImage?
public protocol CIImageProcessor: ImageProcessor {
    var filter: Filter { get }
}
extension CIImageProcessor {
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image.kf.apply(filter)
        case .data:
            return (DefaultImageProcessor.default |> self).process(item: item, options: options)
        }
    }
}
public struct Filter {
    let transform: Transformer
    public init(transform: @escaping Transformer) {
        self.transform = transform
    }
    public static var tint: (KFCrossPlatformColor) -> Filter = {
        color in
        Filter {
            input in
            let colorFilter = CIFilter(name: "CIConstantColorGenerator")!
            colorFilter.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            let filter = CIFilter(name: "CISourceOverCompositing")!
            let colorImage = colorFilter.outputImage
            filter.setValue(colorImage, forKey: kCIInputImageKey)
            filter.setValue(input, forKey: kCIInputBackgroundImageKey)
            return filter.outputImage?.cropped(to: input.extent)
        }
    }
    public typealias ColorElement = (CGFloat, CGFloat, CGFloat, CGFloat)
    public static var colorControl: (ColorElement) -> Filter = { arg -> Filter in
        let (brightness, contrast, saturation, inputEV) = arg
        return Filter { input in
            let paramsColor = [kCIInputBrightnessKey: brightness,
                               kCIInputContrastKey: contrast,
                               kCIInputSaturationKey: saturation]
            let blackAndWhite = input.applyingFilter("CIColorControls", parameters: paramsColor)
            let paramsExposure = [kCIInputEVKey: inputEV]
            return blackAndWhite.applyingFilter("CIExposureAdjust", parameters: paramsExposure)
        }
    }
}
extension KingfisherWrapper where Base: KFCrossPlatformImage {
    public func apply(_ filter: Filter) -> KFCrossPlatformImage {
        guard let cgImage = cgImage else {
            assertionFailure("[Kingfisher] Tint image only works for CG-based image.")
            return base
        }
        let inputImage = CIImage(cgImage: cgImage)
        guard let outputImage = filter.transform(inputImage) else {
            return base
        }
        guard let result = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            assertionFailure("[Kingfisher] Can not make an tint image within context.")
            return base
        }
        #if os(macOS)
            return fixedForRetinaPixel(cgImage: result, to: size)
        #else
            return KFCrossPlatformImage(cgImage: result, scale: base.scale, orientation: base.imageOrientation)
        #endif
    }
}
#endif