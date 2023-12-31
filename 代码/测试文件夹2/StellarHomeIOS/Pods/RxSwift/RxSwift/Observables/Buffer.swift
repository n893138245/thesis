extension ObservableType {
    public func buffer(timeSpan: RxTimeInterval, count: Int, scheduler: SchedulerType)
        -> Observable<[Element]> {
        return BufferTimeCount(source: self.asObservable(), timeSpan: timeSpan, count: count, scheduler: scheduler)
    }
}
final private class BufferTimeCount<Element>: Producer<[Element]> {
    fileprivate let _timeSpan: RxTimeInterval
    fileprivate let _count: Int
    fileprivate let _scheduler: SchedulerType
    fileprivate let _source: Observable<Element>
    init(source: Observable<Element>, timeSpan: RxTimeInterval, count: Int, scheduler: SchedulerType) {
        self._source = source
        self._timeSpan = timeSpan
        self._count = count
        self._scheduler = scheduler
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == [Element] {
        let sink = BufferTimeCountSink(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}
final private class BufferTimeCountSink<Element, Observer: ObserverType>
    : Sink<Observer>
    , LockOwnerType
    , ObserverType
    , SynchronizedOnType where Observer.Element == [Element] {
    typealias Parent = BufferTimeCount<Element>
    private let _parent: Parent
    let _lock = RecursiveLock()
    private let _timerD = SerialDisposable()
    private var _buffer = [Element]()
    private var _windowID = 0
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func run() -> Disposable {
        self.createTimer(self._windowID)
        return Disposables.create(_timerD, _parent._source.subscribe(self))
    }
    func startNewWindowAndSendCurrentOne() {
        self._windowID = self._windowID &+ 1
        let windowID = self._windowID
        let buffer = self._buffer
        self._buffer = []
        self.forwardOn(.next(buffer))
        self.createTimer(windowID)
    }
    func on(_ event: Event<Element>) {
        self.synchronizedOn(event)
    }
    func _synchronized_on(_ event: Event<Element>) {
        switch event {
        case .next(let element):
            self._buffer.append(element)
            if self._buffer.count == self._parent._count {
                self.startNewWindowAndSendCurrentOne()
            }
        case .error(let error):
            self._buffer = []
            self.forwardOn(.error(error))
            self.dispose()
        case .completed:
            self.forwardOn(.next(self._buffer))
            self.forwardOn(.completed)
            self.dispose()
        }
    }
    func createTimer(_ windowID: Int) {
        if self._timerD.isDisposed {
            return
        }
        if self._windowID != windowID {
            return
        }
        let nextTimer = SingleAssignmentDisposable()
        self._timerD.disposable = nextTimer
        let disposable = self._parent._scheduler.scheduleRelative(windowID, dueTime: self._parent._timeSpan) { previousWindowID in
            self._lock.performLocked {
                if previousWindowID != self._windowID {
                    return
                }
                self.startNewWindowAndSendCurrentOne()
            }
            return Disposables.create()
        }
        nextTimer.setDisposable(disposable)
    }
}