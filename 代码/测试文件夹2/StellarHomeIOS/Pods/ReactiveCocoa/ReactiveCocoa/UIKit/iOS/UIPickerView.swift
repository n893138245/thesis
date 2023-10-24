#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import Foundation
import ReactiveSwift
import UIKit
private class PickerViewDelegateProxy: DelegateProxy<UIPickerViewDelegate>, UIPickerViewDelegate {
	@objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		forwardee?.pickerView?(pickerView, didSelectRow: row, inComponent: component)
	}
}
extension Reactive where Base: UIPickerView {
	private var proxy: PickerViewDelegateProxy {
		return .proxy(for: base,
		              setter: #selector(setter: base.delegate),
		              getter: #selector(getter: base.delegate))
	}
	public func selectedRow(inComponent component: Int) -> BindingTarget<Int> {
		return makeBindingTarget { $0.selectRow($1, inComponent: component, animated: false) }
	}
	public var reloadAllComponents: BindingTarget<()> {
		return makeBindingTarget { base, _ in base.reloadAllComponents() }
	}
	public var reloadComponent: BindingTarget<Int> {
		return makeBindingTarget { $0.reloadComponent($1) }
	}
	public var selections: Signal<(row: Int, component: Int), Never> {
		return proxy.intercept(#selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:)))
			.map { (row: $0[1] as! Int, component: $0[2] as! Int) }
	}
}
#endif