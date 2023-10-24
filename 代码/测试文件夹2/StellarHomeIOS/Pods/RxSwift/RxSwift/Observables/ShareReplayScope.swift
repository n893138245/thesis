public enum SubjectLifetimeScope {
    case whileConnected
    case forever
}
extension ObservableType {
    public func share(replay: Int = 0, scope: SubjectLifetimeScope = .whileConnected)
        -> Observable<Element> {
        switch scope {
        case .forever:
            switch replay {
            case 0: return self.multicast(PublishSubject()).refCount()
            default: return self.multicast(ReplaySubject.create(bufferSize: replay)).refCount()
            }
        case .whileConnected:
            switch replay {
            case 0: return ShareWhileConnected(source: self.asObservable())
            case 1: return ShareReplay1WhileConnected(source: self.asObservable())
            default: return self.multicast(makeSubject: { ReplaySubject.create(bufferSize: replay) }).refCount()
            }
        }
    }
}
private final class ShareReplay1WhileConnectedConnection<Element>
    : ObserverType
    , SynchronizedUnsubscribeType {
    typealias Observers = AnyObserver<Element>.s
    typealias DisposeKey = Observers.KeyType
    typealias Parent = ShareReplay1WhileConnected<Element>
    private let _parent: Parent
    private let _subscription = SingleAssignmentDisposable()
    private let _lock: RecursiveLock
    private var _disposed: Bool = false
    fileprivate var _observers = Observers()
    private var _element: Element?
    init(parent: Parent, lock: RecursiveLock) {
        self._parent = parent
        self._lock = lock
        #if TRACE_RESOURCES
            _ = Resources.incrementTotal()
        #endif
    }
    final func on(_ event: Event<Element>) {
        self._lock.lock()
        let observers = self._synchronized_on(event)
        self._lock.unlock()
        dispatch(observers, event)
    }
    final private func _synchronized_on(_ event: Event<Element>) -> Observers {
        if self._disposed {
            return Observers()
        }
        switch event {
        case .next(let element):
            self._element = element
            return self._observers
        case .error, .completed:
            let observers = self._observers
            self._synchronized_dispose()
            return observers
        }
    }
    final func connect() {
        self._subscription.setDisposable(self._parent._source.subscribe(self))
    }
    final func _synchronized_subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        self._lock.lock(); defer { self._lock.unlock() }
        if let element = self._element {
            observer.on(.next(element))
        }
        let disposeKey = self._observers.insert(observer.on)
        return SubscriptionDisposable(owner: self, key: disposeKey)
    }
    final private func _synchronized_dispose() {
        self._disposed = true
        if self._parent._connection === self {
            self._parent._connection = nil
        }
        self._observers = Observers()
    }
    final func synchronizedUnsubscribe(_ disposeKey: DisposeKey) {
        self._lock.lock()
        let shouldDisconnect = self._synchronized_unsubscribe(disposeKey)
        self._lock.unlock()
        if shouldDisconnect {
            self._subscription.dispose()
        }
    }
    @inline(__always)
    final private func _synchronized_unsubscribe(_ disposeKey: DisposeKey) -> Bool {
        if self._observers.removeKey(disposeKey) == nil {
            return false
        }
        if self._observers.count == 0 {
            self._synchronized_dispose()
            return true
        }
        return false
    }
    #if TRACE_RESOURCES
        deinit {
            _ = Resources.decrementTotal()
        }
    #endif
}
final private class ShareReplay1WhileConnected<Element>
    : Observable<Element> {
    fileprivate typealias Connection = ShareReplay1WhileConnectedConnection<Element>
    fileprivate let _source: Observable<Element>
    private let _lock = RecursiveLock()
    fileprivate var _connection: Connection?
    init(source: Observable<Element>) {
        self._source = source
    }
    override func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        self._lock.lock()
        let connection = self._synchronized_subscribe(observer)
        let count = connection._observers.count
        let disposable = connection._synchronized_subscribe(observer)
        self._lock.unlock()
        if count == 0 {
            connection.connect()
        }
        return disposable
    }
    @inline(__always)
    private func _synchronized_subscribe<Observer: ObserverType>(_ observer: Observer) -> Connection where Observer.Element == Element {
        let connection: Connection
        if let existingConnection = self._connection {
            connection = existingConnection
        }
        else {
            connection = ShareReplay1WhileConnectedConnection<Element>(
                parent: self,
                lock: self._lock)
            self._connection = connection
        }
        return connection
    }
}
private final class ShareWhileConnectedConnection<Element>
    : ObserverType
    , SynchronizedUnsubscribeType {
    typealias Observers = AnyObserver<Element>.s
    typealias DisposeKey = Observers.KeyType
    typealias Parent = ShareWhileConnected<Element>
    private let _parent: Parent
    private let _subscription = SingleAssignmentDisposable()
    private let _lock: RecursiveLock
    private var _disposed: Bool = false
    fileprivate var _observers = Observers()
    init(parent: Parent, lock: RecursiveLock) {
        self._parent = parent
        self._lock = lock
        #if TRACE_RESOURCES
            _ = Resources.incrementTotal()
        #endif
    }
    final func on(_ event: Event<Element>) {
        self._lock.lock()
        let observers = self._synchronized_on(event)
        self._lock.unlock()
        dispatch(observers, event)
    }
    final private func _synchronized_on(_ event: Event<Element>) -> Observers {
        if self._disposed {
            return Observers()
        }
        switch event {
        case .next:
            return self._observers
        case .error, .completed:
            let observers = self._observers
            self._synchronized_dispose()
            return observers
        }
    }
    final func connect() {
        self._subscription.setDisposable(self._parent._source.subscribe(self))
    }
    final func _synchronized_subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        self._lock.lock(); defer { self._lock.unlock() }
        let disposeKey = self._observers.insert(observer.on)
        return SubscriptionDisposable(owner: self, key: disposeKey)
    }
    final private func _synchronized_dispose() {
        self._disposed = true
        if self._parent._connection === self {
            self._parent._connection = nil
        }
        self._observers = Observers()
    }
    final func synchronizedUnsubscribe(_ disposeKey: DisposeKey) {
        self._lock.lock()
        let shouldDisconnect = self._synchronized_unsubscribe(disposeKey)
        self._lock.unlock()
        if shouldDisconnect {
            self._subscription.dispose()
        }
    }
    @inline(__always)
    final private func _synchronized_unsubscribe(_ disposeKey: DisposeKey) -> Bool {
        if self._observers.removeKey(disposeKey) == nil {
            return false
        }
        if self._observers.count == 0 {
            self._synchronized_dispose()
            return true
        }
        return false
    }
    #if TRACE_RESOURCES
    deinit {
        _ = Resources.decrementTotal()
    }
    #endif
}
final private class ShareWhileConnected<Element>
    : Observable<Element> {
    fileprivate typealias Connection = ShareWhileConnectedConnection<Element>
    fileprivate let _source: Observable<Element>
    private let _lock = RecursiveLock()
    fileprivate var _connection: Connection?
    init(source: Observable<Element>) {
        self._source = source
    }
    override func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        self._lock.lock()
        let connection = self._synchronized_subscribe(observer)
        let count = connection._observers.count
        let disposable = connection._synchronized_subscribe(observer)
        self._lock.unlock()
        if count == 0 {
            connection.connect()
        }
        return disposable
    }
    @inline(__always)
    private func _synchronized_subscribe<Observer: ObserverType>(_ observer: Observer) -> Connection where Observer.Element == Element {
        let connection: Connection
        if let existingConnection = self._connection {
            connection = existingConnection
        }
        else {
            connection = ShareWhileConnectedConnection<Element>(
                parent: self,
                lock: self._lock)
            self._connection = connection
        }
        return connection
    }
}