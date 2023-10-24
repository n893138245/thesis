import RxSwift
extension ObservableConvertibleType {
    public func asSignal(onErrorJustReturn: Element) -> Signal<Element> {
        let source = self
            .asObservable()
            .observeOn(SignalSharingStrategy.scheduler)
            .catchErrorJustReturn(onErrorJustReturn)
        return Signal(source)
    }
    public func asSignal(onErrorSignalWith: Signal<Element>) -> Signal<Element> {
        let source = self
            .asObservable()
            .observeOn(SignalSharingStrategy.scheduler)
            .catchError { _ in
                onErrorSignalWith.asObservable()
            }
        return Signal(source)
    }
    public func asSignal(onErrorRecover: @escaping (_ error: Swift.Error) -> Signal<Element>) -> Signal<Element> {
        let source = self
            .asObservable()
            .observeOn(SignalSharingStrategy.scheduler)
            .catchError { error in
                onErrorRecover(error).asObservable()
            }
        return Signal(source)
    }
}