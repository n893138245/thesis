#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIResponder {
	public var becomeFirstResponder: BindingTarget<()> {
		return makeBindingTarget { base, _ in base.becomeFirstResponder() }
	}
	public var resignFirstResponder: BindingTarget<()> {
		return makeBindingTarget { base, _ in base.resignFirstResponder() }
	}
}
#endif