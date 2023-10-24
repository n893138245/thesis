#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIBarItem {
	public var isEnabled: BindingTarget<Bool> {
		return makeBindingTarget { $0.isEnabled = $1 }
	}
	public var image: BindingTarget<UIImage?> {
		return makeBindingTarget { $0.image = $1 }
	}
	public var title: BindingTarget<String?> {
		return makeBindingTarget { $0.title = $1 }
	}
}
#endif