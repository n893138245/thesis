#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import UIKit
import ReactiveSwift
extension Reactive where Base: UISlider {
	public var value: BindingTarget<Float> {
		return makeBindingTarget { $0.value = $1 }
	}
	public var minimumValue: BindingTarget<Float> {
		return makeBindingTarget { $0.minimumValue = $1 }
	}
	public var maximumValue: BindingTarget<Float> {
		return makeBindingTarget { $0.maximumValue = $1 }
	}
	public var values: Signal<Float, Never> {
		return mapControlEvents(.valueChanged) { $0.value }
	}
}
#endif