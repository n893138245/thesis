import RxSwift
public typealias Driver<Element> = SharedSequence<DriverSharingStrategy, Element>
public struct DriverSharingStrategy: SharingStrategyProtocol {
    public static var scheduler: SchedulerType { return SharingScheduler.make() }
    public static func share<Element>(_ source: Observable<Element>) -> Observable<Element> {
        return source.share(replay: 1, scope: .whileConnected)
    }
}
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    public func asDriver() -> Driver<Element> {
        return self.asSharedSequence()
    }
}