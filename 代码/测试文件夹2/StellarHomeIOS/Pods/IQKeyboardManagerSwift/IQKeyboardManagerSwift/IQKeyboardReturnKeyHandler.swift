import Foundation
import UIKit
private class IQTextFieldViewInfoModal: NSObject {
    fileprivate weak var textFieldDelegate: UITextFieldDelegate?
    fileprivate weak var textViewDelegate: UITextViewDelegate?
    fileprivate weak var textFieldView: UIView?
    fileprivate var originalReturnKeyType = UIReturnKeyType.default
    init(textFieldView: UIView?, textFieldDelegate: UITextFieldDelegate?, textViewDelegate: UITextViewDelegate?, originalReturnKeyType: UIReturnKeyType = .default) {
        self.textFieldView = textFieldView
        self.textFieldDelegate = textFieldDelegate
        self.textViewDelegate = textViewDelegate
        self.originalReturnKeyType = originalReturnKeyType
    }
}
public class IQKeyboardReturnKeyHandler: NSObject, UITextFieldDelegate, UITextViewDelegate {
    @objc public weak var delegate: (UITextFieldDelegate & UITextViewDelegate)?
    @objc public var lastTextFieldReturnKeyType: UIReturnKeyType = UIReturnKeyType.default {
        didSet {
            for modal in textFieldInfoCache {
                if let view = modal.textFieldView {
                    updateReturnKeyTypeOnTextField(view)
                }
            }
        }
    }
    @objc public override init() {
        super.init()
    }
    @objc public init(controller: UIViewController) {
        super.init()
        addResponderFromView(controller.view)
    }
    deinit {
        for modal in textFieldInfoCache {
            if let textField = modal.textFieldView as? UITextField {
                textField.returnKeyType = modal.originalReturnKeyType
                textField.delegate = modal.textFieldDelegate
            } else if let textView = modal.textFieldView as? UITextView {
                textView.returnKeyType = modal.originalReturnKeyType
                textView.delegate = modal.textViewDelegate
            }
        }
        textFieldInfoCache.removeAll()
    }
    private var textFieldInfoCache          =   [IQTextFieldViewInfoModal]()
    private func textFieldViewCachedInfo(_ textField: UIView) -> IQTextFieldViewInfoModal? {
        for modal in textFieldInfoCache {
            if let view = modal.textFieldView {
                if view == textField {
                    return modal
                }
            }
        }
        return nil
    }
    private func updateReturnKeyTypeOnTextField(_ view: UIView) {
        var superConsideredView: UIView?
        for disabledClass in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {
            superConsideredView = view.superviewOfClassType(disabledClass)
            if superConsideredView != nil {
                break
            }
        }
        var textFields = [UIView]()
        if let unwrappedTableView = superConsideredView {     
            textFields = unwrappedTableView.deepResponderViews()
        } else {  
            textFields = view.responderSiblings()
            switch IQKeyboardManager.shared.toolbarManageBehaviour {
            case .byTag:        textFields = textFields.sortedArrayByTag()
            case .byPosition:   textFields = textFields.sortedArrayByPosition()
            default:    break
            }
        }
        if let lastView = textFields.last {
            if let textField = view as? UITextField {
                textField.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            } else if let textView = view as? UITextView {
                textView.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            }
        }
    }
    @objc public func addTextFieldView(_ view: UIView) {
        let modal = IQTextFieldViewInfoModal(textFieldView: view, textFieldDelegate: nil, textViewDelegate: nil)
        if let textField = view as? UITextField {
            modal.originalReturnKeyType = textField.returnKeyType
            modal.textFieldDelegate = textField.delegate
            textField.delegate = self
        } else if let textView = view as? UITextView {
            modal.originalReturnKeyType = textView.returnKeyType
            modal.textViewDelegate = textView.delegate
            textView.delegate = self
        }
        textFieldInfoCache.append(modal)
    }
    @objc public func removeTextFieldView(_ view: UIView) {
        if let modal = textFieldViewCachedInfo(view) {
            if let textField = view as? UITextField {
                textField.returnKeyType = modal.originalReturnKeyType
                textField.delegate = modal.textFieldDelegate
            } else if let textView = view as? UITextView {
                textView.returnKeyType = modal.originalReturnKeyType
                textView.delegate = modal.textViewDelegate
            }
            if let index = textFieldInfoCache.firstIndex(where: { $0.textFieldView == view}) {
                textFieldInfoCache.remove(at: index)
            }
        }
    }
    @objc public func addResponderFromView(_ view: UIView) {
        let textFields = view.deepResponderViews()
        for textField in textFields {
            addTextFieldView(textField)
        }
    }
    @objc public func removeResponderFromView(_ view: UIView) {
        let textFields = view.deepResponderViews()
        for textField in textFields {
            removeTextFieldView(textField)
        }
    }
    @discardableResult private func goToNextResponderOrResign(_ view: UIView) -> Bool {
        var superConsideredView: UIView?
        for disabledClass in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {
            superConsideredView = view.superviewOfClassType(disabledClass)
            if superConsideredView != nil {
                break
            }
        }
        var textFields = [UIView]()
        if let unwrappedTableView = superConsideredView {     
            textFields = unwrappedTableView.deepResponderViews()
        } else {  
            textFields = view.responderSiblings()
            switch IQKeyboardManager.shared.toolbarManageBehaviour {
            case .byTag:        textFields = textFields.sortedArrayByTag()
            case .byPosition:   textFields = textFields.sortedArrayByPosition()
            default:
                break
            }
        }
        if let index = textFields.firstIndex(of: view) {
            if index < (textFields.count - 1) {
                let nextTextField = textFields[index+1]
                nextTextField.becomeFirstResponder()
                return false
            } else {
                view.resignFirstResponder()
                return true
            }
        } else {
            return true
        }
    }
    @objc public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) {
                    return unwrapDelegate.textFieldShouldBeginEditing?(textField) == true
                }
            }
        }
        return true
    }
    @objc public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) {
                    return unwrapDelegate.textFieldShouldEndEditing?(textField) == true
                }
            }
        }
        return true
    }
    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateReturnKeyTypeOnTextField(textField)
        var aDelegate: UITextFieldDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        aDelegate?.textFieldDidBeginEditing?(textField)
    }
    @objc public func textFieldDidEndEditing(_ textField: UITextField) {
        var aDelegate: UITextFieldDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        aDelegate?.textFieldDidEndEditing?(textField)
    }
    #if swift(>=4.2)
    @available(iOS 10.0, *)
    @objc public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var aDelegate: UITextFieldDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        aDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    #else
    @available(iOS 10.0, *)
    @objc public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        var aDelegate: UITextFieldDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textField) {
                aDelegate = modal.textFieldDelegate
            }
        }
        aDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    #endif
    @objc public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) {
                    return unwrapDelegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == true
                }
            }
        }
        return true
    }
    @objc public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) {
                    return unwrapDelegate.textFieldShouldClear?(textField) == true
                }
            }
        }
        return true
    }
    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var shouldReturn = true
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) {
                    shouldReturn = unwrapDelegate.textFieldShouldReturn?(textField) == true
                }
            }
        }
        if shouldReturn == true {
            goToNextResponderOrResign(textField)
            return true
        } else {
            return goToNextResponderOrResign(textField)
        }
    }
    @objc public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textViewShouldBeginEditing(_:))) {
                    return unwrapDelegate.textViewShouldBeginEditing?(textView) == true
                }
            }
        }
        return true
    }
    @objc public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textViewShouldEndEditing(_:))) {
                    return unwrapDelegate.textViewShouldEndEditing?(textView) == true
                }
            }
        }
        return true
    }
    @objc public func textViewDidBeginEditing(_ textView: UITextView) {
        updateReturnKeyTypeOnTextField(textView)
        var aDelegate: UITextViewDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        aDelegate?.textViewDidBeginEditing?(textView)
    }
    @objc public func textViewDidEndEditing(_ textView: UITextView) {
        var aDelegate: UITextViewDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        aDelegate?.textViewDidEndEditing?(textView)
    }
    @objc public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var shouldReturn = true
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(textView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:))) {
                    shouldReturn = (unwrapDelegate.textView?(textView, shouldChangeTextIn: range, replacementText: text)) == true
                }
            }
        }
        if shouldReturn == true && text == "\n" {
            shouldReturn = goToNextResponderOrResign(textView)
        }
        return shouldReturn
    }
    @objc public func textViewDidChange(_ textView: UITextView) {
        var aDelegate: UITextViewDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        aDelegate?.textViewDidChange?(textView)
    }
    @objc public func textViewDidChangeSelection(_ textView: UITextView) {
        var aDelegate: UITextViewDelegate? = delegate
        if aDelegate == nil {
            if let modal = textFieldViewCachedInfo(textView) {
                aDelegate = modal.textViewDelegate
            }
        }
        aDelegate?.textViewDidChangeSelection?(textView)
    }
    @available(iOS 10.0, *)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, URL, NSRange, UITextItemInteraction) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: URL, in: characterRange, interaction: interaction) == true
                }
            }
        }
        return true
    }
    @available(iOS 10.0, *)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) == true
                }
            }
        }
        return true
    }
    @available(iOS, deprecated: 10.0)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, URL, NSRange) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: URL, in: characterRange) == true
                }
            }
        }
        return true
    }
    @available(iOS, deprecated: 10.0)
    @objc public func textView(_ aTextView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        if delegate == nil {
            if let unwrapDelegate = textFieldViewCachedInfo(aTextView)?.textViewDelegate {
                if unwrapDelegate.responds(to: #selector(textView as (UITextView, NSTextAttachment, NSRange) -> Bool)) {
                    return unwrapDelegate.textView?(aTextView, shouldInteractWith: textAttachment, in: characterRange) == true
                }
            }
        }
        return true
    }
}