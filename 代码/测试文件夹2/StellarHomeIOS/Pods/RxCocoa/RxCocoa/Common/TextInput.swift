import RxSwift
#if os(iOS) || os(tvOS)
    import UIKit
    public struct TextInput<Base: UITextInput> {
        public let base: Base
        public let text: ControlProperty<String?>
        public init(base: Base, text: ControlProperty<String?>) {
            self.base = base
            self.text = text
        }
    }
    extension Reactive where Base: UITextField {
        public var textInput: TextInput<Base> {
            return TextInput(base: base, text: self.text)
        }
    }
    extension Reactive where Base: UITextView {
        public var textInput: TextInput<Base> {
            return TextInput(base: base, text: self.text)
        }
    }
#endif
#if os(macOS)
    import Cocoa
    public struct TextInput<Base: NSTextInputClient> {
        public let base: Base
        public let text: ControlProperty<String?>
        public init(base: Base, text: ControlProperty<String?>) {
            self.base = base
            self.text = text
        }
    }
    extension Reactive where Base: NSTextField, Base: NSTextInputClient {
        public var textInput: TextInput<Base> {
            return TextInput(base: self.base, text: self.text)
        }
    }
#endif