import RxSwift
extension ControlProperty {
    public func asDriver() -> Driver<Element> {
        return self.asDriver { _ -> Driver<Element> in
            #if DEBUG
                rxFatalError("Somehow driver received error from a source that shouldn't fail.")
            #else
                return Driver.empty()
            #endif
        }
    }
}