open class VirtualTimeScheduler<Converter: VirtualTimeConverterType>
    : SchedulerType {
    public typealias VirtualTime = Converter.VirtualTimeUnit
    public typealias VirtualTimeInterval = Converter.VirtualTimeIntervalUnit
    private var _running : Bool
    private var _clock: VirtualTime
    private var _schedulerQueue : PriorityQueue<VirtualSchedulerItem<VirtualTime>>
    private var _converter: Converter
    private var _nextId = 0
    public var now: RxTime {
        return self._converter.convertFromVirtualTime(self.clock)
    }
    public var clock: VirtualTime {
        return self._clock
    }
    public init(initialClock: VirtualTime, converter: Converter) {
        self._clock = initialClock
        self._running = false
        self._converter = converter
        self._schedulerQueue = PriorityQueue(hasHigherPriority: {
            switch converter.compareVirtualTime($0.time, $1.time) {
            case .lessThan:
                return true
            case .equal:
                return $0.id < $1.id
            case .greaterThan:
                return false
            }
        }, isEqual: { $0 === $1 })
        #if TRACE_RESOURCES
            _ = Resources.incrementTotal()
        #endif
    }
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        return self.scheduleRelative(state, dueTime: .microseconds(0)) { a in
            return action(a)
        }
    }
    public func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        let time = self.now.addingDispatchInterval(dueTime)
        let absoluteTime = self._converter.convertToVirtualTime(time)
        let adjustedTime = self.adjustScheduledTime(absoluteTime)
        return self.scheduleAbsoluteVirtual(state, time: adjustedTime, action: action)
    }
    public func scheduleRelativeVirtual<StateType>(_ state: StateType, dueTime: VirtualTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        let time = self._converter.offsetVirtualTime(self.clock, offset: dueTime)
        return self.scheduleAbsoluteVirtual(state, time: time, action: action)
    }
    public func scheduleAbsoluteVirtual<StateType>(_ state: StateType, time: VirtualTime, action: @escaping (StateType) -> Disposable) -> Disposable {
        MainScheduler.ensureExecutingOnScheduler()
        let compositeDisposable = CompositeDisposable()
        let item = VirtualSchedulerItem(action: {
            return action(state)
        }, time: time, id: self._nextId)
        self._nextId += 1
        self._schedulerQueue.enqueue(item)
        _ = compositeDisposable.insert(item)
        return compositeDisposable
    }
    open func adjustScheduledTime(_ time: VirtualTime) -> VirtualTime {
        return time
    }
    public func start() {
        MainScheduler.ensureExecutingOnScheduler()
        if self._running {
            return
        }
        self._running = true
        repeat {
            guard let next = self.findNext() else {
                break
            }
            if self._converter.compareVirtualTime(next.time, self.clock).greaterThan {
                self._clock = next.time
            }
            next.invoke()
            self._schedulerQueue.remove(next)
        } while self._running
        self._running = false
    }
    func findNext() -> VirtualSchedulerItem<VirtualTime>? {
        while let front = self._schedulerQueue.peek() {
            if front.isDisposed {
                self._schedulerQueue.remove(front)
                continue
            }
            return front
        }
        return nil
    }
    public func advanceTo(_ virtualTime: VirtualTime) {
        MainScheduler.ensureExecutingOnScheduler()
        if self._running {
            fatalError("Scheduler is already running")
        }
        self._running = true
        repeat {
            guard let next = self.findNext() else {
                break
            }
            if self._converter.compareVirtualTime(next.time, virtualTime).greaterThan {
                break
            }
            if self._converter.compareVirtualTime(next.time, self.clock).greaterThan {
                self._clock = next.time
            }
            next.invoke()
            self._schedulerQueue.remove(next)
        } while self._running
        self._clock = virtualTime
        self._running = false
    }
    public func sleep(_ virtualInterval: VirtualTimeInterval) {
        MainScheduler.ensureExecutingOnScheduler()
        let sleepTo = self._converter.offsetVirtualTime(self.clock, offset: virtualInterval)
        if self._converter.compareVirtualTime(sleepTo, self.clock).lessThen {
            fatalError("Can't sleep to past.")
        }
        self._clock = sleepTo
    }
    public func stop() {
        MainScheduler.ensureExecutingOnScheduler()
        self._running = false
    }
    #if TRACE_RESOURCES
        deinit {
            _ = Resources.decrementTotal()
        }
    #endif
}
extension VirtualTimeScheduler: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self._schedulerQueue.debugDescription
    }
}
final class VirtualSchedulerItem<Time>
    : Disposable {
    typealias Action = () -> Disposable
    let action: Action
    let time: Time
    let id: Int
    var isDisposed: Bool {
        return self.disposable.isDisposed
    }
    var disposable = SingleAssignmentDisposable()
    init(action: @escaping Action, time: Time, id: Int) {
        self.action = action
        self.time = time
        self.id = id
    }
    func invoke() {
         self.disposable.setDisposable(self.action())
    }
    func dispose() {
        self.disposable.dispose()
    }
}
extension VirtualSchedulerItem
    : CustomDebugStringConvertible {
    var debugDescription: String {
        return "\(self.time)"
    }
}