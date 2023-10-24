extension ObservableType where Element: EventConvertible {
    public func dematerialize() -> Observable<Element.Element> {
        return Dematerialize(source: self.asObservable())
    }
}
private final class DematerializeSink<T: EventConvertible, Observer: ObserverType>: Sink<Observer>, ObserverType where Observer.Element == T.Element {
    fileprivate func on(_ event: Event<T>) {
        switch event {
        case .next(let element):
            self.forwardOn(element.event)
            if element.event.isStopEvent {
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
final private class Dematerialize<T: EventConvertible>: Producer<T.Element> {
    private let _source: Observable<T>
    init(source: Observable<T>) {
        self._source = source
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == T.Element {
        let sink = DematerializeSink<T, Observer>(observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}