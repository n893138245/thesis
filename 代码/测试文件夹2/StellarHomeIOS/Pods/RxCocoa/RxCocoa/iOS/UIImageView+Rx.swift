#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UIImageView {
    public var image: Binder<UIImage?> {
        return Binder(base) { imageView, image in
            imageView.image = image
        }
    }
}
#endif