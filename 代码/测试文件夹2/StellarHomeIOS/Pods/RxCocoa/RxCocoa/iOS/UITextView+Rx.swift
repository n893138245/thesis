#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension Reactive where Base: UITextView {
    public var text: ControlProperty<String?> {
        return value
    }
    public var value: ControlProperty<String?> {
        let source: Observable<String?> = Observable.deferred { [weak textView = self.base] in
            let text = textView?.text
            let textChanged = textView?.textStorage
                .rx.didProcessEditingRangeChangeInLength
                .observeOn(MainScheduler.asyncInstance)
                .map { _ in
                    return textView?.textStorage.string
                }
                ?? Observable.empty()
            return textChanged
                .startWith(text)
        }
        let bindingObserver = Binder(self.base) { (textView, text: String?) in
            if textView.text != text {
                textView.text = text
            }
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    public var attributedText: ControlProperty<NSAttributedString?> {
        let source: Observable<NSAttributedString?> = Observable.deferred { [weak textView = self.base] in
            let attributedText = textView?.attributedText
            let textChanged: Observable<NSAttributedString?> = textView?.textStorage
                .rx.didProcessEditingRangeChangeInLength
                .observeOn(MainScheduler.asyncInstance)
                .map { _ in
                    return textView?.attributedText
                }
                ?? Observable.empty()
            return textChanged
                .startWith(attributedText)
        }
        let bindingObserver = Binder(self.base) { (textView, attributedText: NSAttributedString?) in
            if textView.attributedText != attributedText {
                textView.attributedText = attributedText
            }
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    public var didBeginEditing: ControlEvent<()> {
       return ControlEvent<()>(events: self.delegate.methodInvoked(#selector(UITextViewDelegate.textViewDidBeginEditing(_:)))
            .map { _ in
                return ()
            })
    }
    public var didEndEditing: ControlEvent<()> {
        return ControlEvent<()>(events: self.delegate.methodInvoked(#selector(UITextViewDelegate.textViewDidEndEditing(_:)))
            .map { _ in
                return ()
            })
    }
    public var didChange: ControlEvent<()> {
        return ControlEvent<()>(events: self.delegate.methodInvoked(#selector(UITextViewDelegate.textViewDidChange(_:)))
            .map { _ in
                return ()
            })
    }
    public var didChangeSelection: ControlEvent<()> {
        return ControlEvent<()>(events: self.delegate.methodInvoked(#selector(UITextViewDelegate.textViewDidChangeSelection(_:)))
            .map { _ in
                return ()
            })
    }
}
#endif