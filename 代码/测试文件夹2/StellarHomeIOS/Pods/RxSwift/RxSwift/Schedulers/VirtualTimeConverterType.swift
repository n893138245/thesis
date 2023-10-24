import Foundation
public protocol VirtualTimeConverterType {
    associatedtype VirtualTimeUnit
    associatedtype VirtualTimeIntervalUnit
    func convertFromVirtualTime(_ virtualTime: VirtualTimeUnit) -> RxTime
    func convertToVirtualTime(_ time: RxTime) -> VirtualTimeUnit
    func convertFromVirtualTimeInterval(_ virtualTimeInterval: VirtualTimeIntervalUnit) -> TimeInterval
    func convertToVirtualTimeInterval(_ timeInterval: TimeInterval) -> VirtualTimeIntervalUnit
    func offsetVirtualTime(_ time: VirtualTimeUnit, offset: VirtualTimeIntervalUnit) -> VirtualTimeUnit
    func compareVirtualTime(_ lhs: VirtualTimeUnit, _ rhs: VirtualTimeUnit) -> VirtualTimeComparison
}
public enum VirtualTimeComparison {
    case lessThan
    case equal
    case greaterThan
}
extension VirtualTimeComparison {
    var lessThen: Bool {
        return self == .lessThan
    }
    var greaterThan: Bool {
        return self == .greaterThan
    }
    var equal: Bool {
        return self == .equal
    }
}