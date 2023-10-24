#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UITextField {
    public var text: ControlProperty<String?> {
        return value
    }
    public var value: ControlProperty<String?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.text
            },
            setter: { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
    public var attributedText: ControlProperty<NSAttributedString?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.attributedText
            },
            setter: { textField, value in
                if textField.attributedText != value {
                    textField.attributedText = value
                }
            }
        )
    }
    public var isSecureTextEntry: Binder<Bool> {
        return Binder(self.base) { textField, isSecureTextEntry in
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
}
#endif