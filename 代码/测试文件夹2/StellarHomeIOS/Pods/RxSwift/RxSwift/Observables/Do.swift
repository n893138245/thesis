extension ObservableType {
    public func `do`(onNext: ((Element) throws -> Void)? = nil, afterNext: ((Element) throws -> Void)? = nil, onError: ((Swift.Error) throws -> Void)? = nil, afterError: ((Swift.Error) throws -> Void)? = nil, onCompleted: (() throws -> Void)? = nil, afterCompleted: (() throws -> Void)? = nil, onSubscribe: (() -> Void)? = nil, onSubscribed: (() -> Void)? = nil, onDispose: (() -> Void)? = nil)
        -> Observable<Element> {
            return Do(source: self.asObservable(), eventHandler: { e in
                switch e {
                case .next(let element):
                    try onNext?(element)
                case .error(let e):
                    try onError?(e)
                case .completed:
                    try onCompleted?()
                }
            }, afterEventHandler: { e in
                switch e {
                case .next(let element):
                    try afterNext?(element)
                case .error(let e):
                    try afterError?(e)
                case .completed:
                    try afterCompleted?()
                }
            }, onSubscribe: onSubscribe, onSubscribed: onSubscribed, onDispose: onDispose)
    }
}
final private class DoSink<Observer: ObserverType>: Sink<Observer>, ObserverType {
    typealias Element = Observer.Element 
    typealias EventHandler = (Event<Element>) throws -> Void
    typealias AfterEventHandler = (Event<Element>) throws -> Void
    private let _eventHandler: EventHandler
    private let _afterEventHandler: AfterEventHandler
    init(eventHandler: @escaping EventHandler, afterEventHandler: @escaping AfterEventHandler, observer: Observer, cancel: Cancelable) {
        self._eventHandler = eventHandler
        self._afterEventHandler = afterEventHandler
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        do {
            try self._eventHandler(event)
            self.forwardOn(event)
            try self._afterEventHandler(event)
            if event.isStopEvent {
                self.dispose()
            }
        }
        catch let error {
            self.forwardOn(.error(error))
            self.dispose()
        }
    }
}
final private class Do<Element>: Producer<Element> {
    typealias EventHandler = (Event<Element>) throws -> Void
    typealias AfterEventHandler = (Event<Element>) throws -> Void
    private let _source: Observable<Element>
    private let _eventHandler: EventHandler
    private let _afterEventHandler: AfterEventHandler
    private let _onSubscribe: (() -> Void)?
    private let _onSubscribed: (() -> Void)?
    private let _onDispose: (() -> Void)?
    init(source: Observable<Element>, eventHandler: @escaping EventHandler, afterEventHandler: @escaping AfterEventHandler, onSubscribe: (() -> Void)?, onSubscribed: (() -> Void)?, onDispose: (() -> Void)?) {
        self._source = source
        self._eventHandler = eventHandler
        self._afterEventHandler = afterEventHandler
        self._onSubscribe = onSubscribe
        self._onSubscribed = onSubscribed
        self._onDispose = onDispose
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        self._onSubscribe?()
        let sink = DoSink(eventHandler: self._eventHandler, afterEventHandler: self._afterEventHandler, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        self._onSubscribed?()
        let onDispose = self._onDispose
        let allSubscriptions = Disposables.create {
            subscription.dispose()
            onDispose?()
        }
        return (sink: sink, subscription: allSubscriptions)
    }
}