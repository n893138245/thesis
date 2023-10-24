#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UILabel {
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
    public var attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
}
#endif