extension ObservableType {
    public func retryWhen<TriggerObservable: ObservableType, Error: Swift.Error>(_ notificationHandler: @escaping (Observable<Error>) -> TriggerObservable)
        -> Observable<Element> {
        return RetryWhenSequence(sources: InfiniteSequence(repeatedValue: self.asObservable()), notificationHandler: notificationHandler)
    }
    public func retryWhen<TriggerObservable: ObservableType>(_ notificationHandler: @escaping (Observable<Swift.Error>) -> TriggerObservable)
        -> Observable<Element> {
        return RetryWhenSequence(sources: InfiniteSequence(repeatedValue: self.asObservable()), notificationHandler: notificationHandler)
    }
}
final private class RetryTriggerSink<Sequence: Swift.Sequence, Observer: ObserverType, TriggerObservable: ObservableType, Error>
    : ObserverType where Sequence.Element: ObservableType, Sequence.Element.Element == Observer.Element {
    typealias Element = TriggerObservable.Element
    typealias Parent = RetryWhenSequenceSinkIter<Sequence, Observer, TriggerObservable, Error>
    private let _parent: Parent
    init(parent: Parent) {
        self._parent = parent
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            self._parent._parent._lastError = nil
            self._parent._parent.schedule(.moveNext)
        case .error(let e):
            self._parent._parent.forwardOn(.error(e))
            self._parent._parent.dispose()
        case .completed:
            self._parent._parent.forwardOn(.completed)
            self._parent._parent.dispose()
        }
    }
}
final private class RetryWhenSequenceSinkIter<Sequence: Swift.Sequence, Observer: ObserverType, TriggerObservable: ObservableType, Error>
    : ObserverType
    , Disposable where Sequence.Element: ObservableType, Sequence.Element.Element == Observer.Element {
    typealias Element = Observer.Element 
    typealias Parent = RetryWhenSequenceSink<Sequence, Observer, TriggerObservable, Error>
    fileprivate let _parent: Parent
    private let _errorHandlerSubscription = SingleAssignmentDisposable()
    private let _subscription: Disposable
    init(parent: Parent, subscription: Disposable) {
        self._parent = parent
        self._subscription = subscription
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            self._parent.forwardOn(event)
        case .error(let error):
            self._parent._lastError = error
            if let failedWith = error as? Error {
                self._subscription.dispose()
                let errorHandlerSubscription = self._parent._notifier.subscribe(RetryTriggerSink(parent: self))
                self._errorHandlerSubscription.setDisposable(errorHandlerSubscription)
                self._parent._errorSubject.on(.next(failedWith))
            }
            else {
                self._parent.forwardOn(.error(error))
                self._parent.dispose()
            }
        case .completed:
            self._parent.forwardOn(event)
            self._parent.dispose()
        }
    }
    final func dispose() {
        self._subscription.dispose()
        self._errorHandlerSubscription.dispose()
    }
}
final private class RetryWhenSequenceSink<Sequence: Swift.Sequence, Observer: ObserverType, TriggerObservable: ObservableType, Error>
    : TailRecursiveSink<Sequence, Observer> where Sequence.Element: ObservableType, Sequence.Element.Element == Observer.Element {
    typealias Element = Observer.Element 
    typealias Parent = RetryWhenSequence<Sequence, TriggerObservable, Error>
    let _lock = RecursiveLock()
    private let _parent: Parent
    fileprivate var _lastError: Swift.Error?
    fileprivate let _errorSubject = PublishSubject<Error>()
    private let _handler: Observable<TriggerObservable.Element>
    fileprivate let _notifier = PublishSubject<TriggerObservable.Element>()
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        self._handler = parent._notificationHandler(self._errorSubject).asObservable()
        super.init(observer: observer, cancel: cancel)
    }
    override func done() {
        if let lastError = self._lastError {
            self.forwardOn(.error(lastError))
            self._lastError = nil
        }
        else {
            self.forwardOn(.completed)
        }
        self.dispose()
    }
    override func extract(_ observable: Observable<Element>) -> SequenceGenerator? {
        return nil
    }
    override func subscribeToNext(_ source: Observable<Element>) -> Disposable {
        let subscription = SingleAssignmentDisposable()
        let iter = RetryWhenSequenceSinkIter(parent: self, subscription: subscription)
        subscription.setDisposable(source.subscribe(iter))
        return iter
    }
    override func run(_ sources: SequenceGenerator) -> Disposable {
        let triggerSubscription = self._handler.subscribe(self._notifier.asObserver())
        let superSubscription = super.run(sources)
        return Disposables.create(superSubscription, triggerSubscription)
    }
}
final private class RetryWhenSequence<Sequence: Swift.Sequence, TriggerObservable: ObservableType, Error>: Producer<Sequence.Element.Element> where Sequence.Element: ObservableType {
    typealias Element = Sequence.Element.Element
    private let _sources: Sequence
    fileprivate let _notificationHandler: (Observable<Error>) -> TriggerObservable
    init(sources: Sequence, notificationHandler: @escaping (Observable<Error>) -> TriggerObservable) {
        self._sources = sources
        self._notificationHandler = notificationHandler
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = RetryWhenSequenceSink<Sequence, Observer, TriggerObservable, Error>(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run((self._sources.makeIterator(), nil))
        return (sink: sink, subscription: subscription)
    }
}