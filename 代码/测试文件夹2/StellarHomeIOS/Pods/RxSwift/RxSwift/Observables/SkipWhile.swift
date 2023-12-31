extension ObservableType {
    public func skipWhile(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
        return SkipWhile(source: self.asObservable(), predicate: predicate)
    }
}
final private class SkipWhileSink<Observer: ObserverType>: Sink<Observer>, ObserverType {
    typealias Element = Observer.Element 
    typealias Parent = SkipWhile<Element>
    private let _parent: Parent
    private var _running = false
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            if !self._running {
                do {
                    self._running = try !self._parent._predicate(value)
                } catch let e {
                    self.forwardOn(.error(e))
                    self.dispose()
                    return
                }
            }
            if self._running {
                self.forwardOn(.next(value))
            }
        case .error, .completed:
            self.forwardOn(event)
            self.dispose()
        }
    }
}
final private class SkipWhile<Element>: Producer<Element> {
    typealias Predicate = (Element) throws -> Bool
    private let _source: Observable<Element>
    fileprivate let _predicate: Predicate
    init(source: Observable<Element>, predicate: @escaping Predicate) {
        self._source = source
        self._predicate = predicate
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = SkipWhileSink(parent: self, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}