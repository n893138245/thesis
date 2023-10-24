#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import UIKit
import ReactiveSwift
extension Reactive where Base: UIStepper {
	public var value: BindingTarget<Double> {
		return makeBindingTarget { $0.value = $1 }
	}
	public var minimumValue: BindingTarget<Double> {
		return makeBindingTarget { $0.minimumValue = $1 }
	}
	public var maximumValue: BindingTarget<Double> {
		return makeBindingTarget { $0.maximumValue = $1 }
	}
	public var values: Signal<Double, Never> {
		return mapControlEvents(.valueChanged) { $0.value }
	}
}
#endif