#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIProgressView {
	public var progress: BindingTarget<Float> {
		return makeBindingTarget { $0.progress = $1 }
	}
}
#endif