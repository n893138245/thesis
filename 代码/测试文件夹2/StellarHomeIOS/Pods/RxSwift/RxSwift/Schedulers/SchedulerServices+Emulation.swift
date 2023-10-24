enum SchedulePeriodicRecursiveCommand {
    case tick
    case dispatchStart
}
final class SchedulePeriodicRecursive<State> {
    typealias RecursiveAction = (State) -> State
    typealias RecursiveScheduler = AnyRecursiveScheduler<SchedulePeriodicRecursiveCommand>
    private let _scheduler: SchedulerType
    private let _startAfter: RxTimeInterval
    private let _period: RxTimeInterval
    private let _action: RecursiveAction
    private var _state: State
    private let _pendingTickCount = AtomicInt(0)
    init(scheduler: SchedulerType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping RecursiveAction, state: State) {
        self._scheduler = scheduler
        self._startAfter = startAfter
        self._period = period
        self._action = action
        self._state = state
    }
    func start() -> Disposable {
        return self._scheduler.scheduleRecursive(SchedulePeriodicRecursiveCommand.tick, dueTime: self._startAfter, action: self.tick)
    }
    func tick(_ command: SchedulePeriodicRecursiveCommand, scheduler: RecursiveScheduler) {
        switch command {
        case .tick:
            scheduler.schedule(.tick, dueTime: self._period)
            if increment(self._pendingTickCount) == 0 {
                self.tick(.dispatchStart, scheduler: scheduler)
            }
        case .dispatchStart:
            self._state = self._action(self._state)
            if decrement(self._pendingTickCount) > 1 {
                scheduler.schedule(SchedulePeriodicRecursiveCommand.dispatchStart)
            }
        }
    }
}