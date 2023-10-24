import Accelerate
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
extension KingfisherWrapper where Base: KFCrossPlatformImage {
    #if !os(macOS)
    public func image(withBlendMode blendMode: CGBlendMode,
                      alpha: CGFloat = 1.0,
                      backgroundColor: KFCrossPlatformColor? = nil) -> KFCrossPlatformImage
    {
        guard let _ = cgImage else {
            assertionFailure("[Kingfisher] Blend mode image only works for CG-based image.")
            return base
        }
        let rect = CGRect(origin: .zero, size: size)
        return draw(to: rect.size) { _ in
            if let backgroundColor = backgroundColor {
                backgroundColor.setFill()
                UIRectFill(rect)
            }
            base.draw(in: rect, blendMode: blendMode, alpha: alpha)
            return false
        }
    }
    #endif
    #if os(macOS)
    public func image(withCompositingOperation compositingOperation: NSCompositingOperation,
                      alpha: CGFloat = 1.0,
                      backgroundColor: KFCrossPlatformColor? = nil) -> KFCrossPlatformImage
    {
        guard let _ = cgImage else {
            assertionFailure("[Kingfisher] Compositing Operation image only works for CG-based image.")
            return base
        }
        let rect = CGRect(origin: .zero, size: size)
        return draw(to: rect.size) { _ in
            if let backgroundColor = backgroundColor {
                backgroundColor.setFill()
                rect.fill()
            }
            base.draw(in: rect, from: .zero, operation: compositingOperation, fraction: alpha)
            return false
        }
    }
    #endif
    public func image(withRoundRadius radius: CGFloat,
                      fit size: CGSize,
                      roundingCorners corners: RectCorner = .all,
                      backgroundColor: KFCrossPlatformColor? = nil) -> KFCrossPlatformImage
    {
        guard let _ = cgImage else {
            assertionFailure("[Kingfisher] Round corner image only works for CG-based image.")
            return base
        }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return draw(to: size) { _ in
            #if os(macOS)
            if let backgroundColor = backgroundColor {
                let rectPath = NSBezierPath(rect: rect)
                backgroundColor.setFill()
                rectPath.fill()
            }
            let path = NSBezierPath(roundedRect: rect, byRoundingCorners: corners, radius: radius)
            #if swift(>=4.2)
            path.windingRule = .evenOdd
            #else
            path.windingRule = .evenOddWindingRule
            #endif
            path.addClip()
            base.draw(in: rect)
            #else
            guard let context = UIGraphicsGetCurrentContext() else {
                assertionFailure("[Kingfisher] Failed to create CG context for image.")
                return false
            }
            if let backgroundColor = backgroundColor {
                let rectPath = UIBezierPath(rect: rect)
                backgroundColor.setFill()
                rectPath.fill()
            }
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners.uiRectCorner,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            context.addPath(path.cgPath)
            context.clip()
            base.draw(in: rect)
            #endif
            return false
        }
    }
    #if os(iOS) || os(tvOS)
    func resize(to size: CGSize, for contentMode: UIView.ContentMode) -> KFCrossPlatformImage {
        switch contentMode {
        case .scaleAspectFit:
            return resize(to: size, for: .aspectFit)
        case .scaleAspectFill:
            return resize(to: size, for: .aspectFill)
        default:
            return resize(to: size)
        }
    }
    #endif
    public func resize(to size: CGSize) -> KFCrossPlatformImage {
        guard let _ = cgImage else {
            assertionFailure("[Kingfisher] Resize only works for CG-based image.")
            return base
        }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return draw(to: size) { _ in
            #if os(macOS)
            base.draw(in: rect, from: .zero, operation: .copy, fraction: 1.0)
            #else
            base.draw(in: rect)
            #endif
            return false
        }
    }
    public func resize(to targetSize: CGSize, for contentMode: ContentMode) -> KFCrossPlatformImage {
        let newSize = size.kf.resize(to: targetSize, for: contentMode)
        return resize(to: newSize)
    }
    public func crop(to size: CGSize, anchorOn anchor: CGPoint) -> KFCrossPlatformImage {
        guard let cgImage = cgImage else {
            assertionFailure("[Kingfisher] Crop only works for CG-based image.")
            return base
        }
        let rect = self.size.kf.constrainedRect(for: size, anchor: anchor)
        guard let image = cgImage.cropping(to: rect.scaled(scale)) else {
            assertionFailure("[Kingfisher] Cropping image failed.")
            return base
        }
        return KingfisherWrapper.image(cgImage: image, scale: scale, refImage: base)
    }
    public func blurred(withRadius radius: CGFloat) -> KFCrossPlatformImage {
        guard let cgImage = cgImage else {
            assertionFailure("[Kingfisher] Blur only works for CG-based image.")
            return base
        }
        let s = max(radius, 2.0)
        let pi2 = 2 * CGFloat.pi
        let sqrtPi2 = sqrt(pi2)
        var targetRadius = floor(s * 3.0 * sqrtPi2 / 4.0 + 0.5)
        if targetRadius.isEven { targetRadius += 1 }
        let iterations: Int
        if radius < 0.5 {
            iterations = 1
        } else if radius < 1.5 {
            iterations = 2
        } else {
            iterations = 3
        }
        let w = Int(size.width)
        let h = Int(size.height)
        func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
            let data = context.data
            let width = vImagePixelCount(context.width)
            let height = vImagePixelCount(context.height)
            let rowBytes = context.bytesPerRow
            return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
        }
        guard let context = beginContext(size: size, scale: scale, inverting: true) else {
            assertionFailure("[Kingfisher] Failed to create CG context for blurring image.")
            return base
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: w, height: h))
        endContext()
        var inBuffer = createEffectBuffer(context)
        guard let outContext = beginContext(size: size, scale: scale, inverting: true) else {
            assertionFailure("[Kingfisher] Failed to create CG context for blurring image.")
            return base
        }
        defer { endContext() }
        var outBuffer = createEffectBuffer(outContext)
        for _ in 0 ..< iterations {
            let flag = vImage_Flags(kvImageEdgeExtend)
            vImageBoxConvolve_ARGB8888(
                &inBuffer, &outBuffer, nil, 0, 0, UInt32(targetRadius), UInt32(targetRadius), nil, flag)
            (inBuffer, outBuffer) = (outBuffer, inBuffer)
        }
        #if os(macOS)
        let result = outContext.makeImage().flatMap {
            fixedForRetinaPixel(cgImage: $0, to: size)
        }
        #else
        let result = outContext.makeImage().flatMap {
            KFCrossPlatformImage(cgImage: $0, scale: base.scale, orientation: base.imageOrientation)
        }
        #endif
        guard let blurredImage = result else {
            assertionFailure("[Kingfisher] Can not make an blurred image within this context.")
            return base
        }
        return blurredImage
    }
    public func overlaying(with color: KFCrossPlatformColor, fraction: CGFloat) -> KFCrossPlatformImage {
        guard let _ = cgImage else {
            assertionFailure("[Kingfisher] Overlaying only works for CG-based image.")
            return base
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return draw(to: rect.size) { context in
            #if os(macOS)
            base.draw(in: rect)
            if fraction > 0 {
                color.withAlphaComponent(1 - fraction).set()
                rect.fill(using: .sourceAtop)
            }
            #else
            color.set()
            UIRectFill(rect)
            base.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
            if fraction > 0 {
                base.draw(in: rect, blendMode: .sourceAtop, alpha: fraction)
            }
            #endif
            return false
        }
    }
    public func tinted(with color: KFCrossPlatformColor) -> KFCrossPlatformImage {
        #if os(watchOS)
        return base
        #else
        return apply(.tint(color))
        #endif
    }
    public func adjusted(brightness: CGFloat, contrast: CGFloat, saturation: CGFloat, inputEV: CGFloat) -> KFCrossPlatformImage {
        #if os(watchOS)
        return base
        #else
        return apply(.colorControl((brightness, contrast, saturation, inputEV)))
        #endif
    }
    public func scaled(to scale: CGFloat) -> KFCrossPlatformImage {
        guard scale != self.scale else {
            return base
        }
        guard let cgImage = cgImage else {
            assertionFailure("[Kingfisher] Scaling only works for CG-based image.")
            return base
        }
        return KingfisherWrapper.image(cgImage: cgImage, scale: scale, refImage: base)
    }
}
extension KingfisherWrapper where Base: KFCrossPlatformImage {
    public var decoded: KFCrossPlatformImage { return decoded(scale: scale) }
    public func decoded(scale: CGFloat) -> KFCrossPlatformImage {
        #if os(iOS)
        if imageSource != nil { return base }
        #else
        if images != nil { return base }
        #endif
        guard let imageRef = cgImage else {
            assertionFailure("[Kingfisher] Decoding only works for CG-based image.")
            return base
        }
        let size = CGSize(width: CGFloat(imageRef.width) / scale, height: CGFloat(imageRef.height) / scale)
        return draw(to: size, inverting: true, scale: scale) { context in
            context.draw(imageRef, in: CGRect(origin: .zero, size: size))
            return true
        }
    }
}
extension KingfisherWrapper where Base: KFCrossPlatformImage {
    func beginContext(size: CGSize, scale: CGFloat, inverting: Bool = false) -> CGContext? {
        #if os(macOS)
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: cgImage?.bitsPerComponent ?? 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0) else
        {
            assertionFailure("[Kingfisher] Image representation cannot be created.")
            return nil
        }
        rep.size = size
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext(bitmapImageRep: rep) else {
            assertionFailure("[Kingfisher] Image context cannot be created.")
            return nil
        }
        NSGraphicsContext.current = context
        return context.cgContext
        #else
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        if inverting { 
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -size.height)
        }
        return context
        #endif
    }
    func endContext() {
        #if os(macOS)
        NSGraphicsContext.restoreGraphicsState()
        #else
        UIGraphicsEndImageContext()
        #endif
    }
    func draw(
        to size: CGSize,
        inverting: Bool = false,
        scale: CGFloat? = nil,
        refImage: KFCrossPlatformImage? = nil,
        draw: (CGContext) -> Bool 
    ) -> KFCrossPlatformImage
    {
        let targetScale = scale ?? self.scale
        guard let context = beginContext(size: size, scale: targetScale, inverting: inverting) else {
            assertionFailure("[Kingfisher] Failed to create CG context for blurring image.")
            return base
        }
        defer { endContext() }
        let useRefImage = draw(context)
        guard let cgImage = context.makeImage() else {
            return base
        }
        let ref = useRefImage ? (refImage ?? base) : nil
        return KingfisherWrapper.image(cgImage: cgImage, scale: targetScale, refImage: ref)
    }
    #if os(macOS)
    func fixedForRetinaPixel(cgImage: CGImage, to size: CGSize) -> KFCrossPlatformImage {
        let image = KFCrossPlatformImage(cgImage: cgImage, size: base.size)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        return draw(to: self.size) { context in
            image.draw(in: rect, from: .zero, operation: .copy, fraction: 1.0)
            return false
        }
    }
    #endif
}