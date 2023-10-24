import RxSwift
extension ObservableConvertibleType {
    public func asDriver(onErrorJustReturn: Element) -> Driver<Element> {
        let source = self
            .asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
            .catchErrorJustReturn(onErrorJustReturn)
        return Driver(source)
    }
    public func asDriver(onErrorDriveWith: Driver<Element>) -> Driver<Element> {
        let source = self
            .asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
            .catchError { _ in
                onErrorDriveWith.asObservable()
            }
        return Driver(source)
    }
    public func asDriver(onErrorRecover: @escaping (_ error: Swift.Error) -> Driver<Element>) -> Driver<Element> {
        let source = self
            .asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
            .catchError { error in
                onErrorRecover(error).asObservable()
            }
        return Driver(source)
    }
}