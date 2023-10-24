#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UISegmentedControl {
	public var selectedSegmentIndex: BindingTarget<Int> {
		return makeBindingTarget { $0.selectedSegmentIndex = $1 }
	}
	public var selectedSegmentIndexes: Signal<Int, Never> {
		return mapControlEvents(.valueChanged) { $0.selectedSegmentIndex }
	}
}
#endif