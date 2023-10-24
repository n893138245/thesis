extension ObservableType {
    public static func error(_ error: Swift.Error) -> Observable<Element> {
        return ErrorProducer(error: error)
    }
}
final private class ErrorProducer<Element>: Producer<Element> {
    private let _error: Swift.Error
    init(error: Swift.Error) {
        self._error = error
    }
    override func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        observer.on(.error(self._error))
        return Disposables.create()
    }
}