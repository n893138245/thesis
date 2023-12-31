extension ObservableType where Element : RxAbstractInteger {
    public static func range(start: Element, count: Element, scheduler: ImmediateSchedulerType = CurrentThreadScheduler.instance) -> Observable<Element> {
        return RangeProducer<Element>(start: start, count: count, scheduler: scheduler)
    }
}
final private class RangeProducer<Element: RxAbstractInteger>: Producer<Element> {
    fileprivate let _start: Element
    fileprivate let _count: Element
    fileprivate let _scheduler: ImmediateSchedulerType
    init(start: Element, count: Element, scheduler: ImmediateSchedulerType) {
        guard count >= 0 else {
            rxFatalError("count can't be negative")
        }
        guard start &+ (count - 1) >= start || count == 0 else {
            rxFatalError("overflow of count")
        }
        self._start = start
        self._count = count
        self._scheduler = scheduler
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = RangeSink(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}
final private class RangeSink<Observer: ObserverType>: Sink<Observer> where Observer.Element: RxAbstractInteger {
    typealias Parent = RangeProducer<Observer.Element>
    private let _parent: Parent
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func run() -> Disposable {
        return self._parent._scheduler.scheduleRecursive(0 as Observer.Element) { i, recurse in
            if i < self._parent._count {
                self.forwardOn(.next(self._parent._start + i))
                recurse(i + 1)
            }
            else {
                self.forwardOn(.completed)
                self.dispose()
            }
        }
    }
}