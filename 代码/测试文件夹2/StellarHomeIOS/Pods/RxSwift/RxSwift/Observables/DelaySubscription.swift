extension ObservableType {
    public func delaySubscription(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
        -> Observable<Element> {
        return DelaySubscription(source: self.asObservable(), dueTime: dueTime, scheduler: scheduler)
    }
}
final private class DelaySubscriptionSink<Observer: ObserverType>
    : Sink<Observer>, ObserverType {
    typealias Element = Observer.Element 
    func on(_ event: Event<Element>) {
        self.forwardOn(event)
        if event.isStopEvent {
            self.dispose()
        }
    }
}
final private class DelaySubscription<Element>: Producer<Element> {
    private let _source: Observable<Element>
    private let _dueTime: RxTimeInterval
    private let _scheduler: SchedulerType
    init(source: Observable<Element>, dueTime: RxTimeInterval, scheduler: SchedulerType) {
        self._source = source
        self._dueTime = dueTime
        self._scheduler = scheduler
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = DelaySubscriptionSink(observer: observer, cancel: cancel)
        let subscription = self._scheduler.scheduleRelative((), dueTime: self._dueTime) { _ in
            return self._source.subscribe(sink)
        }
        return (sink: sink, subscription: subscription)
    }
}