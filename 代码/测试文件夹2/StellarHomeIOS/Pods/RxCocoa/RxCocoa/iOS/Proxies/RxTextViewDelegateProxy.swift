#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
open class RxTextViewDelegateProxy
    : RxScrollViewDelegateProxy
    , UITextViewDelegate {
    public weak private(set) var textView: UITextView?
    public init(textView: UITextView) {
        self.textView = textView
        super.init(scrollView: textView)
    }
    @objc open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let forwardToDelegate = self.forwardToDelegate() as? UITextViewDelegate
        return forwardToDelegate?.textView?(textView,
            shouldChangeTextIn: range,
            replacementText: text) ?? true
    }
}
#endif