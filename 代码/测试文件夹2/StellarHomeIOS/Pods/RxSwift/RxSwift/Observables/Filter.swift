extension ObservableType {
    public func filter(_ predicate: @escaping (Element) throws -> Bool)
        -> Observable<Element> {
        return Filter(source: self.asObservable(), predicate: predicate)
    }
}
extension ObservableType {
    public func ignoreElements()
        -> Completable {
            return self.flatMap { _ in
                return Observable<Never>.empty()
            }
            .asCompletable()
    }
}
final private class FilterSink<Observer: ObserverType>: Sink<Observer>, ObserverType {
    typealias Predicate = (Element) throws -> Bool
    typealias Element = Observer.Element
    private let _predicate: Predicate
    init(predicate: @escaping Predicate, observer: Observer, cancel: Cancelable) {
        self._predicate = predicate
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            do {
                let satisfies = try self._predicate(value)
                if satisfies {
                    self.forwardOn(.next(value))
                }
            }
            catch let e {
                self.forwardOn(.error(e))
                self.dispose()
            }
        case .completed, .error:
            self.forwardOn(event)
            self.dispose()
        }
    }
}
final private class Filter<Element>: Producer<Element> {
    typealias Predicate = (Element) throws -> Bool
    private let _source: Observable<Element>
    private let _predicate: Predicate
    init(source: Observable<Element>, predicate: @escaping Predicate) {
        self._source = source
        self._predicate = predicate
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = FilterSink(predicate: self._predicate, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}