extension ObservableType {
    public static func deferred(_ observableFactory: @escaping () throws -> Observable<Element>)
        -> Observable<Element> {
        return Deferred(observableFactory: observableFactory)
    }
}
final private class DeferredSink<Source: ObservableType, Observer: ObserverType>: Sink<Observer>, ObserverType where Source.Element == Observer.Element {
    typealias Element = Observer.Element 
    private let _observableFactory: () throws -> Source
    init(observableFactory: @escaping () throws -> Source, observer: Observer, cancel: Cancelable) {
        self._observableFactory = observableFactory
        super.init(observer: observer, cancel: cancel)
    }
    func run() -> Disposable {
        do {
            let result = try self._observableFactory()
            return result.subscribe(self)
        }
        catch let e {
            self.forwardOn(.error(e))
            self.dispose()
            return Disposables.create()
        }
    }
    func on(_ event: Event<Element>) {
        self.forwardOn(event)
        switch event {
        case .next:
            break
        case .error:
            self.dispose()
        case .completed:
            self.dispose()
        }
    }
}
final private class Deferred<Source: ObservableType>: Producer<Source.Element> {
    typealias Factory = () throws -> Source
    private let _observableFactory : Factory
    init(observableFactory: @escaping Factory) {
        self._observableFactory = observableFactory
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable)
             where Observer.Element == Source.Element {
        let sink = DeferredSink(observableFactory: self._observableFactory, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}