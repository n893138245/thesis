import Dispatch
import Foundation
#if os(Linux)
	import let CDispatch.NSEC_PER_SEC
#endif
public protocol Scheduler: AnyObject {
	@discardableResult
	func schedule(_ action: @escaping () -> Void) -> Disposable?
}
public protocol DateScheduler: Scheduler {
	var currentDate: Date { get }
	@discardableResult
	func schedule(after date: Date, action: @escaping () -> Void) -> Disposable?
	@discardableResult
	func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable?
}
public final class ImmediateScheduler: Scheduler {
	public init() {}
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		action()
		return nil
	}
}
public final class UIScheduler: Scheduler {
	private static let dispatchSpecificKey = DispatchSpecificKey<UInt8>()
	private static let dispatchSpecificValue = UInt8.max
	private static var __once: () = {
			DispatchQueue.main.setSpecific(key: UIScheduler.dispatchSpecificKey,
			                               value: dispatchSpecificValue)
	}()
	#if os(Linux)
	private var queueLength: Atomic<Int32> = Atomic(0)
	#else
	private let queueLength: UnsafeMutablePointer<Int32> = {
		let memory = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
		memory.initialize(to: 0)
		return memory
	}()
	deinit {
		queueLength.deinitialize(count: 1)
		queueLength.deallocate()
	}
	#endif
	public init() {
		_ = UIScheduler.__once
	}
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		let positionInQueue = enqueue()
		if positionInQueue == 1 && DispatchQueue.getSpecific(key: UIScheduler.dispatchSpecificKey) == UIScheduler.dispatchSpecificValue {
			action()
			dequeue()
			return nil
		} else {
			let disposable = AnyDisposable()
			DispatchQueue.main.async {
				defer { self.dequeue() }
				guard !disposable.isDisposed else { return }
				action()
			}
			return disposable
		}
	}
	private func dequeue() {
		#if os(Linux)
			queueLength.modify { $0 -= 1 }
		#else
			OSAtomicDecrement32(queueLength)
		#endif
	}
	private func enqueue() -> Int32 {
		#if os(Linux)
		return queueLength.modify { value -> Int32 in
			value += 1
			return value
		}
		#else
		return OSAtomicIncrement32(queueLength)
		#endif
	}
}
private final class DispatchSourceTimerWrapper: Hashable {
	private let value: DispatchSourceTimer
	#if swift(>=4.1.50)
	fileprivate func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
	#else
	fileprivate var hashValue: Int {
		return ObjectIdentifier(self).hashValue
	}
	#endif
	fileprivate init(_ value: DispatchSourceTimer) {
		self.value = value
	}
	fileprivate static func ==(lhs: DispatchSourceTimerWrapper, rhs: DispatchSourceTimerWrapper) -> Bool {
		return lhs === rhs
	}
}
public final class QueueScheduler: DateScheduler {
	public static let main = QueueScheduler(internalQueue: DispatchQueue.main)
	public var currentDate: Date {
		return Date()
	}
	public let queue: DispatchQueue
	private var timers: Atomic<Set<DispatchSourceTimerWrapper>>
	internal init(internalQueue: DispatchQueue) {
		queue = internalQueue
		timers = Atomic(Set())
	}
	@available(OSX, deprecated:10.10, obsoleted:10.11, message:"Use init(qos:name:targeting:) instead")
	@available(iOS, deprecated:8.0, obsoleted:9.0, message:"Use init(qos:name:targeting:) instead.")
	public convenience init(queue: DispatchQueue, name: String = "org.reactivecocoa.ReactiveSwift.QueueScheduler") {
		self.init(internalQueue: DispatchQueue(label: name, target: queue))
	}
	@available(OSX 10.10, *)
	public convenience init(
		qos: DispatchQoS = .default,
		name: String = "org.reactivecocoa.ReactiveSwift.QueueScheduler",
		targeting targetQueue: DispatchQueue? = nil
	) {
		self.init(internalQueue: DispatchQueue(
			label: name,
			qos: qos,
			target: targetQueue
		))
	}
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		let d = AnyDisposable()
		queue.async {
			if !d.isDisposed {
				action()
			}
		}
		return d
	}
	private func wallTime(with date: Date) -> DispatchWallTime {
		let (seconds, frac) = modf(date.timeIntervalSince1970)
		let nsec: Double = frac * Double(NSEC_PER_SEC)
		let walltime = timespec(tv_sec: Int(seconds), tv_nsec: Int(nsec))
		return DispatchWallTime(timespec: walltime)
	}
	@discardableResult
	public func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
		let d = AnyDisposable()
		queue.asyncAfter(wallDeadline: wallTime(with: date)) {
			if !d.isDisposed {
				action()
			}
		}
		return d
	}
	@discardableResult
	public func schedule(after date: Date, interval: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		return schedule(after: date, interval: interval, leeway: interval * 0.1, action: action)
	}
	@discardableResult
	public func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		precondition(interval.timeInterval >= 0)
		precondition(leeway.timeInterval >= 0)
		let timer = DispatchSource.makeTimerSource(
			flags: DispatchSource.TimerFlags(rawValue: UInt(0)),
			queue: queue
		)
		#if swift(>=4.0)
		timer.schedule(wallDeadline: wallTime(with: date),
		               repeating: interval,
		               leeway: leeway)
		#else
		timer.scheduleRepeating(wallDeadline: wallTime(with: date),
		                        interval: interval,
		                        leeway: leeway)
		#endif
		timer.setEventHandler(handler: action)
		timer.resume()
		let wrappedTimer = DispatchSourceTimerWrapper(timer)
		timers.modify { timers in
			timers.insert(wrappedTimer)
		}
		return AnyDisposable { [weak self] in
			timer.cancel()
			if let scheduler = self {
				scheduler.timers.modify { timers in
					timers.remove(wrappedTimer)
				}
			}
		}
	}
}
public final class TestScheduler: DateScheduler {
	private final class ScheduledAction {
		let date: Date
		let action: () -> Void
		init(date: Date, action: @escaping () -> Void) {
			self.date = date
			self.action = action
		}
		func less(_ rhs: ScheduledAction) -> Bool {
			return date < rhs.date
		}
	}
	private let lock = NSRecursiveLock()
	private var _currentDate: Date
	public var currentDate: Date {
		let d: Date
		lock.lock()
		d = _currentDate
		lock.unlock()
		return d
	}
	private var scheduledActions: [ScheduledAction] = []
	public init(startDate: Date = Date(timeIntervalSinceReferenceDate: 0)) {
		lock.name = "org.reactivecocoa.ReactiveSwift.TestScheduler"
		_currentDate = startDate
	}
	private func schedule(_ action: ScheduledAction) -> Disposable {
		lock.lock()
		scheduledActions.append(action)
		scheduledActions.sort { $0.less($1) }
		lock.unlock()
		return AnyDisposable {
			self.lock.lock()
			self.scheduledActions = self.scheduledActions.filter { $0 !== action }
			self.lock.unlock()
		}
	}
	@discardableResult
	public func schedule(_ action: @escaping () -> Void) -> Disposable? {
		return schedule(ScheduledAction(date: currentDate, action: action))
	}
	@discardableResult
	public func schedule(after delay: DispatchTimeInterval, action: @escaping () -> Void) -> Disposable? {
		return schedule(after: currentDate.addingTimeInterval(delay), action: action)
	}
	@discardableResult
	public func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
		return schedule(ScheduledAction(date: date, action: action))
	}
	private func schedule(after date: Date, interval: DispatchTimeInterval, disposable: SerialDisposable, action: @escaping () -> Void) {
		precondition(interval.timeInterval >= 0)
		disposable.inner = schedule(after: date) { [unowned self] in
			action()
			self.schedule(after: date.addingTimeInterval(interval), interval: interval, disposable: disposable, action: action)
		}
	}
	@discardableResult
	public func schedule(after delay: DispatchTimeInterval, interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), action: @escaping () -> Void) -> Disposable? {
		return schedule(after: currentDate.addingTimeInterval(delay), interval: interval, leeway: leeway, action: action)
	}
	public func schedule(after date: Date, interval: DispatchTimeInterval, leeway: DispatchTimeInterval = .seconds(0), action: @escaping () -> Void) -> Disposable? {
		let disposable = SerialDisposable()
		schedule(after: date, interval: interval, disposable: disposable, action: action)
		return disposable
	}
	public func advance() {
		advance(by: .nanoseconds(1))
	}
	public func advance(by interval: DispatchTimeInterval) {
		lock.lock()
		advance(to: currentDate.addingTimeInterval(interval))
		lock.unlock()
	}
	public func advance(to newDate: Date) {
		lock.lock()
		assert(currentDate <= newDate)
		while scheduledActions.count > 0 {
			if newDate < scheduledActions[0].date {
				break
			}
			_currentDate = scheduledActions[0].date
			let scheduledAction = scheduledActions.remove(at: 0)
			scheduledAction.action()
		}
		_currentDate = newDate
		lock.unlock()
	}
	public func run() {
		advance(to: Date.distantFuture)
	}
	public func rewind(by interval: DispatchTimeInterval) {
		lock.lock()
		let newDate = currentDate.addingTimeInterval(-interval)
		assert(currentDate >= newDate)
		_currentDate = newDate
		lock.unlock()
	}
}