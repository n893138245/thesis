extension ObservableType {
    public func enumerated()
        -> Observable<(index: Int, element: Element)> {
        return Enumerated(source: self.asObservable())
    }
}
final private class EnumeratedSink<Element, Observer: ObserverType>: Sink<Observer>, ObserverType where Observer.Element == (index: Int, element: Element) {
    var index = 0
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            do {
                let nextIndex = try incrementChecked(&self.index)
                let next = (index: nextIndex, element: value)
                self.forwardOn(.next(next))
            }
            catch let e {
                self.forwardOn(.error(e))
                self.dispose()
            }
        case .completed:
            self.forwardOn(.completed)
            self.dispose()
        case .error(let error):
            self.forwardOn(.error(error))
            self.dispose()
        }
    }
}
final private class Enumerated<Element>: Producer<(index: Int, element: Element)> {
    private let _source: Observable<Element>
    init(source: Observable<Element>) {
        self._source = source
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == (index: Int, element: Element) {
        let sink = EnumeratedSink<Element, Observer>(observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}