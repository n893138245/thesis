import struct Foundation.Date
extension ObservableType {
    public func delay(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
        -> Observable<Element> {
            return Delay(source: self.asObservable(), dueTime: dueTime, scheduler: scheduler)
    }
}
final private class DelaySink<Observer: ObserverType>
    : Sink<Observer>
    , ObserverType {
    typealias Element = Observer.Element 
    typealias Source = Observable<Element>
    typealias DisposeKey = Bag<Disposable>.KeyType
    private let _lock = RecursiveLock()
    private let _dueTime: RxTimeInterval
    private let _scheduler: SchedulerType
    private let _sourceSubscription = SingleAssignmentDisposable()
    private let _cancelable = SerialDisposable()
    private var _active = false
    private var _running = false
    private var _errorEvent: Event<Element>?
    private var _queue = Queue<(eventTime: RxTime, event: Event<Element>)>(capacity: 0)
    private var _disposed = false
    init(observer: Observer, dueTime: RxTimeInterval, scheduler: SchedulerType, cancel: Cancelable) {
        self._dueTime = dueTime
        self._scheduler = scheduler
        super.init(observer: observer, cancel: cancel)
    }
    func drainQueue(state: (), scheduler: AnyRecursiveScheduler<()>) {
        self._lock.lock()    
            let hasFailed = self._errorEvent != nil
            if !hasFailed {
                self._running = true
            }
        self._lock.unlock()  
        if hasFailed {
            return
        }
        var ranAtLeastOnce = false
        while true {
            self._lock.lock() 
                let errorEvent = self._errorEvent
                let eventToForwardImmediately = ranAtLeastOnce ? nil : self._queue.dequeue()?.event
                let nextEventToScheduleOriginalTime: Date? = ranAtLeastOnce && !self._queue.isEmpty ? self._queue.peek().eventTime : nil
                if errorEvent == nil {
                    if eventToForwardImmediately != nil {
                    }
                    else if nextEventToScheduleOriginalTime != nil {
                        self._running = false
                    }
                    else {
                        self._running = false
                        self._active = false
                    }
                }
            self._lock.unlock() 
            if let errorEvent = errorEvent {
                self.forwardOn(errorEvent)
                self.dispose()
                return
            }
            else {
                if let eventToForwardImmediately = eventToForwardImmediately {
                    ranAtLeastOnce = true
                    self.forwardOn(eventToForwardImmediately)
                    if case .completed = eventToForwardImmediately {
                        self.dispose()
                        return
                    }
                }
                else if let nextEventToScheduleOriginalTime = nextEventToScheduleOriginalTime {
                    scheduler.schedule((), dueTime: self._dueTime.reduceWithSpanBetween(earlierDate: nextEventToScheduleOriginalTime, laterDate: self._scheduler.now))
                    return
                }
                else {
                    return
                }
            }
        }
    }
    func on(_ event: Event<Element>) {
        if event.isStopEvent {
            self._sourceSubscription.dispose()
        }
        switch event {
        case .error:
            self._lock.lock()    
                let shouldSendImmediately = !self._running
                self._queue = Queue(capacity: 0)
                self._errorEvent = event
            self._lock.unlock()  
            if shouldSendImmediately {
                self.forwardOn(event)
                self.dispose()
            }
        default:
            self._lock.lock()    
                let shouldSchedule = !self._active
                self._active = true
                self._queue.enqueue((self._scheduler.now, event))
            self._lock.unlock()  
            if shouldSchedule {
                self._cancelable.disposable = self._scheduler.scheduleRecursive((), dueTime: self._dueTime, action: self.drainQueue)
            }
        }
    }
    func run(source: Observable<Element>) -> Disposable {
        self._sourceSubscription.setDisposable(source.subscribe(self))
        return Disposables.create(_sourceSubscription, _cancelable)
    }
}
final private class Delay<Element>: Producer<Element> {
    private let _source: Observable<Element>
    private let _dueTime: RxTimeInterval
    private let _scheduler: SchedulerType
    init(source: Observable<Element>, dueTime: RxTimeInterval, scheduler: SchedulerType) {
        self._source = source
        self._dueTime = dueTime
        self._scheduler = scheduler
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = DelaySink(observer: observer, dueTime: self._dueTime, scheduler: self._scheduler, cancel: cancel)
        let subscription = sink.run(source: self._source)
        return (sink: sink, subscription: subscription)
    }
}