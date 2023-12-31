#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIApplication {
	public var applicationIconBadgeNumber: BindingTarget<Int> {
		return makeBindingTarget({ $0.applicationIconBadgeNumber = $1 })
	}
}
#endif