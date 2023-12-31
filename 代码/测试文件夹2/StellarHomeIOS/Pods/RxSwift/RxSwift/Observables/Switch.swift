extension ObservableType {
    public func flatMapLatest<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source)
        -> Observable<Source.Element> {
            return FlatMapLatest(source: self.asObservable(), selector: selector)
    }
}
extension ObservableType where Element : ObservableConvertibleType {
    public func switchLatest() -> Observable<Element.Element> {
        return Switch(source: self.asObservable())
    }
}
private class SwitchSink<SourceType, Source: ObservableConvertibleType, Observer: ObserverType>
    : Sink<Observer>
    , ObserverType where Source.Element == Observer.Element {
    typealias Element = SourceType
    private let _subscriptions: SingleAssignmentDisposable = SingleAssignmentDisposable()
    private let _innerSubscription: SerialDisposable = SerialDisposable()
    let _lock = RecursiveLock()
    fileprivate var _stopped = false
    fileprivate var _latest = 0
    fileprivate var _hasLatest = false
    override init(observer: Observer, cancel: Cancelable) {
        super.init(observer: observer, cancel: cancel)
    }
    func run(_ source: Observable<SourceType>) -> Disposable {
        let subscription = source.subscribe(self)
        self._subscriptions.setDisposable(subscription)
        return Disposables.create(_subscriptions, _innerSubscription)
    }
    func performMap(_ element: SourceType) throws -> Source {
        rxAbstractMethod()
    }
    @inline(__always)
    final private func nextElementArrived(element: Element) -> (Int, Observable<Source.Element>)? {
        self._lock.lock(); defer { self._lock.unlock() } 
            do {
                let observable = try self.performMap(element).asObservable()
                self._hasLatest = true
                self._latest = self._latest &+ 1
                return (self._latest, observable)
            }
            catch let error {
                self.forwardOn(.error(error))
                self.dispose()
            }
            return nil
    }
    func on(_ event: Event<Element>) {
        switch event {
        case .next(let element):
            if let (latest, observable) = self.nextElementArrived(element: element) {
                let d = SingleAssignmentDisposable()
                self._innerSubscription.disposable = d
                let observer = SwitchSinkIter(parent: self, id: latest, _self: d)
                let disposable = observable.subscribe(observer)
                d.setDisposable(disposable)
            }
        case .error(let error):
            self._lock.lock(); defer { self._lock.unlock() }
            self.forwardOn(.error(error))
            self.dispose()
        case .completed:
            self._lock.lock(); defer { self._lock.unlock() }
            self._stopped = true
            self._subscriptions.dispose()
            if !self._hasLatest {
                self.forwardOn(.completed)
                self.dispose()
            }
        }
    }
}
final private class SwitchSinkIter<SourceType, Source: ObservableConvertibleType, Observer: ObserverType>
    : ObserverType
    , LockOwnerType
    , SynchronizedOnType where Source.Element == Observer.Element {
    typealias Element = Source.Element
    typealias Parent = SwitchSink<SourceType, Source, Observer>
    private let _parent: Parent
    private let _id: Int
    private let _self: Disposable
    var _lock: RecursiveLock {
        return self._parent._lock
    }
    init(parent: Parent, id: Int, _self: Disposable) {
        self._parent = parent
        self._id = id
        self._self = _self
    }
    func on(_ event: Event<Element>) {
        self.synchronizedOn(event)
    }
    func _synchronized_on(_ event: Event<Element>) {
        switch event {
        case .next: break
        case .error, .completed:
            self._self.dispose()
        }
        if self._parent._latest != self._id {
            return
        }
        switch event {
        case .next:
            self._parent.forwardOn(event)
        case .error:
            self._parent.forwardOn(event)
            self._parent.dispose()
        case .completed:
            self._parent._hasLatest = false
            if self._parent._stopped {
                self._parent.forwardOn(event)
                self._parent.dispose()
            }
        }
    }
}
final private class SwitchIdentitySink<Source: ObservableConvertibleType, Observer: ObserverType>: SwitchSink<Source, Source, Observer>
    where Observer.Element == Source.Element {
    override init(observer: Observer, cancel: Cancelable) {
        super.init(observer: observer, cancel: cancel)
    }
    override func performMap(_ element: Source) throws -> Source {
        return element
    }
}
final private class MapSwitchSink<SourceType, Source: ObservableConvertibleType, Observer: ObserverType>: SwitchSink<SourceType, Source, Observer> where Observer.Element == Source.Element {
    typealias Selector = (SourceType) throws -> Source
    private let _selector: Selector
    init(selector: @escaping Selector, observer: Observer, cancel: Cancelable) {
        self._selector = selector
        super.init(observer: observer, cancel: cancel)
    }
    override func performMap(_ element: SourceType) throws -> Source {
        return try self._selector(element)
    }
}
final private class Switch<Source: ObservableConvertibleType>: Producer<Source.Element> {
    private let _source: Observable<Source>
    init(source: Observable<Source>) {
        self._source = source
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Source.Element {
        let sink = SwitchIdentitySink<Source, Observer>(observer: observer, cancel: cancel)
        let subscription = sink.run(self._source)
        return (sink: sink, subscription: subscription)
    }
}
final private class FlatMapLatest<SourceType, Source: ObservableConvertibleType>: Producer<Source.Element> {
    typealias Selector = (SourceType) throws -> Source
    private let _source: Observable<SourceType>
    private let _selector: Selector
    init(source: Observable<SourceType>, selector: @escaping Selector) {
        self._source = source
        self._selector = selector
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Source.Element {
        let sink = MapSwitchSink<SourceType, Source, Observer>(selector: self._selector, observer: observer, cancel: cancel)
        let subscription = sink.run(self._source)
        return (sink: sink, subscription: subscription)
    }
}