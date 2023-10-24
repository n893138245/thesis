import Foundation
public struct HistoricalSchedulerTimeConverter : VirtualTimeConverterType {
    public typealias VirtualTimeUnit = RxTime
    public typealias VirtualTimeIntervalUnit = TimeInterval
    public func convertFromVirtualTime(_ virtualTime: VirtualTimeUnit) -> RxTime {
        return virtualTime
    }
    public func convertToVirtualTime(_ time: RxTime) -> VirtualTimeUnit {
        return time
    }
    public func convertFromVirtualTimeInterval(_ virtualTimeInterval: VirtualTimeIntervalUnit) -> TimeInterval {
        return virtualTimeInterval
    }
    public func convertToVirtualTimeInterval(_ timeInterval: TimeInterval) -> VirtualTimeIntervalUnit {
        return timeInterval
    }
    public func offsetVirtualTime(_ time: VirtualTimeUnit, offset: VirtualTimeIntervalUnit) -> VirtualTimeUnit {
        return time.addingTimeInterval(offset)
    }
    public func compareVirtualTime(_ lhs: VirtualTimeUnit, _ rhs: VirtualTimeUnit) -> VirtualTimeComparison {
        switch lhs.compare(rhs as Date) {
        case .orderedAscending:
            return .lessThan
        case .orderedSame:
            return .equal
        case .orderedDescending:
            return .greaterThan
        }
    }
}