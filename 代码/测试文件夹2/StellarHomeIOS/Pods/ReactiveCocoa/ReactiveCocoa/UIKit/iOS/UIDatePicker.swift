#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIDatePicker {
	public var date: BindingTarget<Date> {
		return makeBindingTarget { $0.date = $1 }
	}
	public var dates: Signal<Date, Never> {
		return mapControlEvents(.valueChanged) { $0.date }
	}
}
#endif