import Foundation
public protocol ImageModifier {
    func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage
}
public struct AnyImageModifier: ImageModifier {
    let block: (KFCrossPlatformImage) throws -> KFCrossPlatformImage
    public init(modify: @escaping (KFCrossPlatformImage) throws -> KFCrossPlatformImage) {
        block = modify
    }
    public func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage {
        return (try? block(image)) ?? image
    }
}
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public struct RenderingModeImageModifier: ImageModifier {
    public let renderingMode: UIImage.RenderingMode
    public init(renderingMode: UIImage.RenderingMode = .automatic) {
        self.renderingMode = renderingMode
    }
    public func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage {
        return image.withRenderingMode(renderingMode)
    }
}
public struct FlipsForRightToLeftLayoutDirectionImageModifier: ImageModifier {
    public init() {}
    public func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage {
        return image.imageFlippedForRightToLeftLayoutDirection()
    }
}
public struct AlignmentRectInsetsImageModifier: ImageModifier {
    public let alignmentInsets: UIEdgeInsets
    public init(alignmentInsets: UIEdgeInsets) {
        self.alignmentInsets = alignmentInsets
    }
    public func modify(_ image: KFCrossPlatformImage) -> KFCrossPlatformImage {
        return image.withAlignmentRectInsets(alignmentInsets)
    }
}
#endif