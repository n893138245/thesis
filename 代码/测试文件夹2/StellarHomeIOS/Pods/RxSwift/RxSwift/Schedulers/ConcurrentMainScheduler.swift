import struct Foundation.Date
import struct Foundation.TimeInterval
import Dispatch
public final class ConcurrentMainScheduler : SchedulerType {
    public typealias TimeInterval = Foundation.TimeInterval
    public typealias Time = Date
    private let _mainScheduler: MainScheduler
    private let _mainQueue: DispatchQueue
    public var now: Date {
        return self._mainScheduler.now as Date
    }
    private init(mainScheduler: MainScheduler) {
        self._mainQueue = DispatchQueue.main
        self._mainScheduler = mainScheduler
    }
    public static let instance = ConcurrentMainScheduler(mainScheduler: MainScheduler.instance)
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        if DispatchQueue.isMain {
            return action(state)
        }
        let cancel = SingleAssignmentDisposable()
        self._mainQueue.async {
            if cancel.isDisposed {
                return
            }
            cancel.setDisposable(action(state))
        }
        return cancel
    }
    public final func scheduleRelative<StateType>(_ state: StateType, dueTime: RxTimeInterval, action: @escaping (StateType) -> Disposable) -> Disposable {
        return self._mainScheduler.scheduleRelative(state, dueTime: dueTime, action: action)
    }
    public func schedulePeriodic<StateType>(_ state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: @escaping (StateType) -> StateType) -> Disposable {
        return self._mainScheduler.schedulePeriodic(state, startAfter: startAfter, period: period, action: action)
    }
}