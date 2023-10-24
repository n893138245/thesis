import Foundation
public class RetryContext {
    public let source: Source
    public let error: KingfisherError
    public var retriedCount: Int
    public internal(set) var userInfo: Any? = nil
    init(source: Source, error: KingfisherError) {
        self.source = source
        self.error = error
        self.retriedCount = 0
    }
    @discardableResult
    func increaseRetryCount() -> RetryContext {
        retriedCount += 1
        return self
    }
}
public enum RetryDecision {
    case retry(userInfo: Any?)
    case stop
}
public protocol RetryStrategy {
    func retry(context: RetryContext, retryHandler: @escaping (RetryDecision) -> Void)
}
public struct DelayRetryStrategy: RetryStrategy {
    public enum Interval {
        case seconds(TimeInterval)
        case accumulated(TimeInterval)
        case custom(block: (_ retriedCount: Int) -> TimeInterval)
        func timeInterval(for retriedCount: Int) -> TimeInterval {
            let retryAfter: TimeInterval
            switch self {
            case .seconds(let interval):
                retryAfter = interval
            case .accumulated(let interval):
                retryAfter = Double(retriedCount + 1) * interval
            case .custom(let block):
                retryAfter = block(retriedCount)
            }
            return retryAfter
        }
    }
    public let maxRetryCount: Int
    public let retryInterval: Interval
    public init(maxRetryCount: Int, retryInterval: Interval = .seconds(3)) {
        self.maxRetryCount = maxRetryCount
        self.retryInterval = retryInterval
    }
    public func retry(context: RetryContext, retryHandler: @escaping (RetryDecision) -> Void) {
        guard context.retriedCount < maxRetryCount else {
            retryHandler(.stop)
            return
        }
        guard !context.error.isTaskCancelled else {
            retryHandler(.stop)
            return
        }
        guard case KingfisherError.responseError = context.error else {
            retryHandler(.stop)
            return
        }
        let interval = retryInterval.timeInterval(for: context.retriedCount)
        if interval == 0 {
            retryHandler(.retry(userInfo: nil))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                retryHandler(.retry(userInfo: nil))
            }
        }
    }
}