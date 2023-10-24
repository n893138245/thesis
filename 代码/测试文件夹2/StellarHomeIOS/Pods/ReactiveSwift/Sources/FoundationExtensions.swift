import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif
import Dispatch
#if os(Linux)
	import let CDispatch.NSEC_PER_USEC
	import let CDispatch.NSEC_PER_SEC
#endif
extension NotificationCenter: ReactiveExtensionsProvider {}
extension Reactive where Base: NotificationCenter {
	public func notifications(forName name: Notification.Name?, object: AnyObject? = nil) -> Signal<Notification, Never> {
		return Signal { [base = self.base] observer, lifetime in
			let notificationObserver = base.addObserver(forName: name, object: object, queue: nil) { notification in
				observer.send(value: notification)
			}
			lifetime.observeEnded {
				base.removeObserver(notificationObserver)
			}
		}
	}
}
private let defaultSessionError = NSError(domain: "org.reactivecocoa.ReactiveSwift.Reactivity.URLSession.dataWithRequest",
                                          code: 1,
                                          userInfo: nil)
extension URLSession: ReactiveExtensionsProvider {}
extension Reactive where Base: URLSession {
	public func data(with request: URLRequest) -> SignalProducer<(Data, URLResponse), Error> {
		return SignalProducer { [base = self.base] observer, lifetime in
			let task = base.dataTask(with: request) { data, response, error in
				if let data = data, let response = response {
					observer.send(value: (data, response))
					observer.sendCompleted()
				} else {
					observer.send(error: error ?? defaultSessionError)
				}
			}
			lifetime.observeEnded(task.cancel)
			task.resume()
		}
	}
}
extension Date {
	internal func addingTimeInterval(_ interval: DispatchTimeInterval) -> Date {
		return addingTimeInterval(interval.timeInterval)
	}
}
extension DispatchTimeInterval {
	internal var timeInterval: TimeInterval {
		switch self {
		case let .seconds(s):
			return TimeInterval(s)
		case let .milliseconds(ms):
			return TimeInterval(TimeInterval(ms) / 1000.0)
		case let .microseconds(us):
			return TimeInterval(Int64(us)) * TimeInterval(NSEC_PER_USEC) / TimeInterval(NSEC_PER_SEC)
		case let .nanoseconds(ns):
			return TimeInterval(ns) / TimeInterval(NSEC_PER_SEC)
		case .never:
			return .infinity
		@unknown default:
			return .infinity
		}
	}
	internal static prefix func -(lhs: DispatchTimeInterval) -> DispatchTimeInterval {
		switch lhs {
		case let .seconds(s):
			return .seconds(-s)
		case let .milliseconds(ms):
			return .milliseconds(-ms)
		case let .microseconds(us):
			return .microseconds(-us)
		case let .nanoseconds(ns):
			return .nanoseconds(-ns)
		case .never:
			return .never
		@unknown default:
			return .never
		}
	}
	internal static func *(lhs: DispatchTimeInterval, rhs: Double) -> DispatchTimeInterval {
		let seconds = lhs.timeInterval * rhs
		var result: DispatchTimeInterval = .never
		if let integerTimeInterval = Int(exactly: (seconds * 1000 * 1000 * 1000).rounded()) {
			result = .nanoseconds(integerTimeInterval)
		} else if let integerTimeInterval = Int(exactly: (seconds * 1000 * 1000).rounded()) {
			result = .microseconds(integerTimeInterval)
		} else if let integerTimeInterval = Int(exactly: (seconds * 1000).rounded()) {
			result = .milliseconds(integerTimeInterval)
		} else if let integerTimeInterval = Int(exactly: (seconds).rounded()) {
			result = .seconds(integerTimeInterval)
		}
		return result
	}
}