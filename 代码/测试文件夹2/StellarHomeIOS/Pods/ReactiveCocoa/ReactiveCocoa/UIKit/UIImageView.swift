#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIImageView {
	public var image: BindingTarget<UIImage?> {
		return makeBindingTarget { $0.image = $1 }
	}
	public var highlightedImage: BindingTarget<UIImage?> {
		return makeBindingTarget { $0.highlightedImage = $1 }
	}
}
#endif