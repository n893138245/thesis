#if os(iOS)
import UIKit
import RxSwift
public protocol RxPickerViewDataSourceType {
    associatedtype Element
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>)
}
#endif