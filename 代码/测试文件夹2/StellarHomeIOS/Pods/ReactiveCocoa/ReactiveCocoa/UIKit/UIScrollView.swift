#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIScrollView {
	public var contentInset: BindingTarget<UIEdgeInsets> {
		return makeBindingTarget { $0.contentInset = $1 }
	}
	public var scrollIndicatorInsets: BindingTarget<UIEdgeInsets> {
		return makeBindingTarget { $0.scrollIndicatorInsets = $1 }
	}
	public var isScrollEnabled: BindingTarget<Bool> {
		return makeBindingTarget { $0.isScrollEnabled = $1 }
	}
	public var zoomScale: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.zoomScale = $1 }
	}
	public var minimumZoomScale: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.minimumZoomScale = $1 }
	}
	public var maximumZoomScale: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.maximumZoomScale = $1 }
	}
	#if os(iOS)
	public var scrollsToTop: BindingTarget<Bool> {
		return makeBindingTarget { $0.scrollsToTop = $1 }
	}
	#endif
}
#endif