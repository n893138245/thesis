#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import ReactiveSwift
import UIKit
@available(iOS 10.0, *)
extension Reactive where Base: UIFeedbackGenerator {
	public var prepare: BindingTarget<()> {
		return makeBindingTarget { generator, _ in
			generator.prepare()
		}
	}
}
#endif