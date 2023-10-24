#if os(macOS)
    import Cocoa
    import RxSwift
    extension Reactive where Base: NSView {
        public var isHidden:  Binder<Bool> {
            return Binder(self.base) { view, value in
                view.isHidden = value
            }
        }
        public var alpha: Binder<CGFloat> {
            return Binder(self.base) { view, value in
                view.alphaValue = value
            }
        }
    }
#endif