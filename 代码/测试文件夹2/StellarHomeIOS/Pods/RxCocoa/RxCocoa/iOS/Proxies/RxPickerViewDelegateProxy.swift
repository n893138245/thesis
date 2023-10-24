#if os(iOS)
    import RxSwift
    import UIKit
    extension UIPickerView: HasDelegate {
        public typealias Delegate = UIPickerViewDelegate
    }
    open class RxPickerViewDelegateProxy
        : DelegateProxy<UIPickerView, UIPickerViewDelegate>
        , DelegateProxyType 
        , UIPickerViewDelegate {
        public weak private(set) var pickerView: UIPickerView?
        public init(pickerView: ParentObject) {
            self.pickerView = pickerView
            super.init(parentObject: pickerView, delegateProxy: RxPickerViewDelegateProxy.self)
        }
        public static func registerKnownImplementations() {
            self.register { RxPickerViewDelegateProxy(pickerView: $0) }
        }
    }
#endif