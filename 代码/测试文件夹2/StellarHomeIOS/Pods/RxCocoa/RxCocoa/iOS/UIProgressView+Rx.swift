#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UIProgressView {
    public var progress: Binder<Float> {
        return Binder(self.base) { progressView, progress in
            progressView.progress = progress
        }
    }
}
#endif