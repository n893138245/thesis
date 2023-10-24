#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import ReactiveSwift
import UIKit
@available(iOS 10.0, *)
extension Reactive where Base: UINotificationFeedbackGenerator {
	public var notificationOccurred: BindingTarget<UINotificationFeedbackGenerator.FeedbackType> {
		return makeBindingTarget { $0.notificationOccurred($1) }
	}
}
#endif