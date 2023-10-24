import RxSwift
extension ObservableConvertibleType {
    public func asSharedSequence<S>(sharingStrategy: S.Type = S.self, onErrorJustReturn: Element) -> SharedSequence<S, Element> {
        let source = self
            .asObservable()
            .observeOn(S.scheduler)
            .catchErrorJustReturn(onErrorJustReturn)
        return SharedSequence(source)
    }
    public func asSharedSequence<S>(sharingStrategy: S.Type = S.self, onErrorDriveWith: SharedSequence<S, Element>) -> SharedSequence<S, Element> {
        let source = self
            .asObservable()
            .observeOn(S.scheduler)
            .catchError { _ in
                onErrorDriveWith.asObservable()
            }
        return SharedSequence(source)
    }
    public func asSharedSequence<S>(sharingStrategy: S.Type = S.self, onErrorRecover: @escaping (_ error: Swift.Error) -> SharedSequence<S, Element>) -> SharedSequence<S, Element> {
        let source = self
            .asObservable()
            .observeOn(S.scheduler)
            .catchError { error in
                onErrorRecover(error).asObservable()
            }
        return SharedSequence(source)
    }
}