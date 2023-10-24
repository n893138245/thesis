import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import MachO
#endif
internal struct UnsafeAtomicState<State: RawRepresentable> where State.RawValue == Int32 {
	internal typealias Transition = (expected: State, next: State)
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
	private let value: UnsafeMutablePointer<Int32>
	internal init(_ initial: State) {
		value = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
		value.initialize(to: initial.rawValue)
	}
	internal func deinitialize() {
		value.deinitialize(count: 1)
		value.deallocate()
	}
	internal func `is`(_ expected: State) -> Bool {
		return expected.rawValue == value.pointee
	}
	internal func tryTransition(from expected: State, to next: State) -> Bool {
		return OSAtomicCompareAndSwap32Barrier(expected.rawValue,
		                                       next.rawValue,
		                                       value)
	}
#else
	private let value: Atomic<Int32>
	internal init(_ initial: State) {
		value = Atomic(initial.rawValue)
	}
	internal func deinitialize() {}
	internal func `is`(_ expected: State) -> Bool {
		return value.value == expected.rawValue
	}
	internal func tryTransition(from expected: State, to next: State) -> Bool {
		return value.modify { value in
			if value == expected.rawValue {
				value = next.rawValue
				return true
			}
			return false
		}
	}
#endif
}
internal class Lock {
	#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
	@available(iOS 10.0, *)
	@available(macOS 10.12, *)
	@available(tvOS 10.0, *)
	@available(watchOS 3.0, *)
	internal final class UnfairLock: Lock {
		private let _lock: os_unfair_lock_t
		override init() {
			_lock = .allocate(capacity: 1)
			_lock.initialize(to: os_unfair_lock())
			super.init()
		}
		override func lock() {
			os_unfair_lock_lock(_lock)
		}
		override func unlock() {
			os_unfair_lock_unlock(_lock)
		}
		override func `try`() -> Bool {
			return os_unfair_lock_trylock(_lock)
		}
		deinit {
			_lock.deinitialize(count: 1)
			_lock.deallocate()
		}
	}
	#endif
	internal final class PthreadLock: Lock {
		private let _lock: UnsafeMutablePointer<pthread_mutex_t>
		init(recursive: Bool = false) {
			_lock = .allocate(capacity: 1)
			_lock.initialize(to: pthread_mutex_t())
			let attr = UnsafeMutablePointer<pthread_mutexattr_t>.allocate(capacity: 1)
			attr.initialize(to: pthread_mutexattr_t())
			pthread_mutexattr_init(attr)
			defer {
				pthread_mutexattr_destroy(attr)
				attr.deinitialize(count: 1)
				attr.deallocate()
			}
			pthread_mutexattr_settype(attr, Int32(recursive ? PTHREAD_MUTEX_RECURSIVE : PTHREAD_MUTEX_ERRORCHECK))
			let status = pthread_mutex_init(_lock, attr)
			assert(status == 0, "Unexpected pthread mutex error code: \(status)")
			super.init()
		}
		override func lock() {
			let status = pthread_mutex_lock(_lock)
			assert(status == 0, "Unexpected pthread mutex error code: \(status)")
		}
		override func unlock() {
			let status = pthread_mutex_unlock(_lock)
			assert(status == 0, "Unexpected pthread mutex error code: \(status)")
		}
		override func `try`() -> Bool {
			let status = pthread_mutex_trylock(_lock)
			switch status {
			case 0:
				return true
			case EBUSY, EAGAIN, EDEADLK:
				return false
			default:
				assertionFailure("Unexpected pthread mutex error code: \(status)")
				return false
			}
		}
		deinit {
			let status = pthread_mutex_destroy(_lock)
			assert(status == 0, "Unexpected pthread mutex error code: \(status)")
			_lock.deinitialize(count: 1)
			_lock.deallocate()
		}
	}
	static func make() -> Lock {
		#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
		if #available(*, iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0) {
			return UnfairLock()
		}
		#endif
		return PthreadLock()
	}
	private init() {}
	func lock() { fatalError() }
	func unlock() { fatalError() }
	func `try`() -> Bool { fatalError() }
}
public final class Atomic<Value> {
	private let lock: Lock
	private var _value: Value
	public var value: Value {
		get {
			return withValue { $0 }
		}
		set(newValue) {
			swap(newValue)
		}
	}
	public init(_ value: Value) {
		_value = value
		lock = Lock.make()
	}
	@discardableResult
	public func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
		lock.lock()
		defer { lock.unlock() }
		return try action(&_value)
	}
	@discardableResult
	public func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
		lock.lock()
		defer { lock.unlock() }
		return try action(_value)
	}
	@discardableResult
	public func swap(_ newValue: Value) -> Value {
		return modify { (value: inout Value) in
			let oldValue = value
			value = newValue
			return oldValue
		}
	}
}