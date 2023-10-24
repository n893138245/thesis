#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIActivityIndicatorView {
	public var isAnimating: BindingTarget<Bool> {
		return makeBindingTarget { $1 ? $0.startAnimating() : $0.stopAnimating() }
	}
}
#endif