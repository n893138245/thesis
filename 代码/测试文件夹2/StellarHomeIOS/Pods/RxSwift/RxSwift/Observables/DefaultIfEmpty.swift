extension ObservableType {
    public func ifEmpty(default: Element) -> Observable<Element> {
        return DefaultIfEmpty(source: self.asObservable(), default: `default`)
    }
}
final private class DefaultIfEmptySink<Observer: ObserverType>: Sink<Observer>, ObserverType {
    typealias Element = Observer.Element 
    private let _default: Element
    private var _isEmpty = true
    init(default: Element, observer: Observer, cancel: Cancelable) {
        self._default = `default`
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            self._isEmpty = false
            self.forwardOn(event)
        case .error:
            self.forwardOn(event)
            self.dispose()
        case .completed:
            if self._isEmpty {
                self.forwardOn(.next(self._default))
            }
            self.forwardOn(.completed)
            self.dispose()
        }
    }
}
final private class DefaultIfEmpty<SourceType>: Producer<SourceType> {
    private let _source: Observable<SourceType>
    private let _default: SourceType
    init(source: Observable<SourceType>, `default`: SourceType) {
        self._source = source
        self._default = `default`
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == SourceType {
        let sink = DefaultIfEmptySink(default: self._default, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}