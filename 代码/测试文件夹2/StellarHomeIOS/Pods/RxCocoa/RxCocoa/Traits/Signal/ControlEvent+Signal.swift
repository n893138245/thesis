import RxSwift
extension ControlEvent {
    public func asSignal() -> Signal<Element> {
        return self.asSignal { _ -> Signal<Element> in
            #if DEBUG
                rxFatalError("Somehow signal received error from a source that shouldn't fail.")
            #else
                return Signal.empty()
            #endif
        }
    }
}