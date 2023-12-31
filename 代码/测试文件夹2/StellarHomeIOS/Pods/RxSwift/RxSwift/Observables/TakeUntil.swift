extension ObservableType {
    public func takeUntil<Source: ObservableType>(_ other: Source)
        -> Observable<Element> {
        return TakeUntil(source: self.asObservable(), other: other.asObservable())
    }
    public func takeUntil(_ behavior: TakeUntilBehavior,
                          predicate: @escaping (Element) throws -> Bool)
        -> Observable<Element> {
        return TakeUntilPredicate(source: self.asObservable(),
                                  behavior: behavior,
                                  predicate: predicate)
    }
}
public enum TakeUntilBehavior {
    case inclusive
    case exclusive
}
final private class TakeUntilSinkOther<Other, Observer: ObserverType>
    : ObserverType
    , LockOwnerType
    , SynchronizedOnType {
    typealias Parent = TakeUntilSink<Other, Observer>
    typealias Element = Other
    private let _parent: Parent
    var _lock: RecursiveLock {
        return self._parent._lock
    }
    fileprivate let _subscription = SingleAssignmentDisposable()
    init(parent: Parent) {
        self._parent = parent
#if TRACE_RESOURCES
        _ = Resources.incrementTotal()
#endif
    }
    func on(_ event: Event<Element>) {
        self.synchronizedOn(event)
    }
    func _synchronized_on(_ event: Event<Element>) {
        switch event {
        case .next:
            self._parent.forwardOn(.completed)
            self._parent.dispose()
        case .error(let e):
            self._parent.forwardOn(.error(e))
            self._parent.dispose()
        case .completed:
            self._subscription.dispose()
        }
    }
#if TRACE_RESOURCES
    deinit {
        _ = Resources.decrementTotal()
    }
#endif
}
final private class TakeUntilSink<Other, Observer: ObserverType>
    : Sink<Observer>
    , LockOwnerType
    , ObserverType
    , SynchronizedOnType {
    typealias Element = Observer.Element 
    typealias Parent = TakeUntil<Element, Other>
    private let _parent: Parent
    let _lock = RecursiveLock()
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        self.synchronizedOn(event)
    }
    func _synchronized_on(_ event: Event<Element>) {
        switch event {
        case .next:
            self.forwardOn(event)
        case .error:
            self.forwardOn(event)
            self.dispose()
        case .completed:
            self.forwardOn(event)
            self.dispose()
        }
    }
    func run() -> Disposable {
        let otherObserver = TakeUntilSinkOther(parent: self)
        let otherSubscription = self._parent._other.subscribe(otherObserver)
        otherObserver._subscription.setDisposable(otherSubscription)
        let sourceSubscription = self._parent._source.subscribe(self)
        return Disposables.create(sourceSubscription, otherObserver._subscription)
    }
}
final private class TakeUntil<Element, Other>: Producer<Element> {
    fileprivate let _source: Observable<Element>
    fileprivate let _other: Observable<Other>
    init(source: Observable<Element>, other: Observable<Other>) {
        self._source = source
        self._other = other
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = TakeUntilSink(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}
final private class TakeUntilPredicateSink<Observer: ObserverType>
    : Sink<Observer>, ObserverType {
    typealias Element = Observer.Element 
    typealias Parent = TakeUntilPredicate<Element>
    private let _parent: Parent
    private var _running = true
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            if !self._running {
                return
            }
            do {
                self._running = try !self._parent._predicate(value)
            } catch let e {
                self.forwardOn(.error(e))
                self.dispose()
                return
            }
            if self._running {
                self.forwardOn(.next(value))
            } else {
                if self._parent._behavior == .inclusive {
                    self.forwardOn(.next(value))
                }
                self.forwardOn(.completed)
                self.dispose()
            }
        case .error, .completed:
            self.forwardOn(event)
            self.dispose()
        }
    }
}
final private class TakeUntilPredicate<Element>: Producer<Element> {
    typealias Predicate = (Element) throws -> Bool
    private let _source: Observable<Element>
    fileprivate let _predicate: Predicate
    fileprivate let _behavior: TakeUntilBehavior
    init(source: Observable<Element>,
         behavior: TakeUntilBehavior,
         predicate: @escaping Predicate) {
        self._source = source
        self._behavior = behavior
        self._predicate = predicate
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = TakeUntilPredicateSink(parent: self, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}