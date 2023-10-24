#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UITextField {
	public var text: BindingTarget<String?> {
		return makeBindingTarget { $0.text = $1 }
	}
	public var textValues: Signal<String, Never> {
		return mapControlEvents([.editingDidEnd, .editingDidEndOnExit]) { $0.text ?? "" }
	}
	public var continuousTextValues: Signal<String, Never> {
		return mapControlEvents(.allEditingEvents) { $0.text ?? "" }
	}
	public var attributedText: BindingTarget<NSAttributedString?> {
		return makeBindingTarget { $0.attributedText = $1 }
	}
	public var placeholder: BindingTarget<String?> {
		return makeBindingTarget { $0.placeholder = $1 }
	}
	public var textColor: BindingTarget<UIColor> {
		return makeBindingTarget { $0.textColor = $1 }
	}
	public var attributedTextValues: Signal<NSAttributedString, Never> {
		return mapControlEvents([.editingDidEnd, .editingDidEndOnExit]) { $0.attributedText ?? NSAttributedString() }
	}
	public var continuousAttributedTextValues: Signal<NSAttributedString, Never> {
		return mapControlEvents(.allEditingEvents) { $0.attributedText ?? NSAttributedString() }
	}
	public var isSecureTextEntry: BindingTarget<Bool> {
		return makeBindingTarget { $0.isSecureTextEntry = $1 }
	}
}
#endif