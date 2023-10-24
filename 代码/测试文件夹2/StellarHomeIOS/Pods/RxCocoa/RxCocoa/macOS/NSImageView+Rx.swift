#if os(macOS)
import RxSwift
import Cocoa
extension Reactive where Base: NSImageView {
    public var image: Binder<NSImage?> {
        return Binder(self.base) { imageView, image in
            imageView.image = image
        }
    }
}
#endif