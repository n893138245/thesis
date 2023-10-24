import RxSwift
public typealias Signal<Element> = SharedSequence<SignalSharingStrategy, Element>
public struct SignalSharingStrategy: SharingStrategyProtocol {
    public static var scheduler: SchedulerType { return SharingScheduler.make() }
    public static func share<Element>(_ source: Observable<Element>) -> Observable<Element> {
        return source.share(scope: .whileConnected)
    }
}
extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    public func asSignal() -> Signal<Element> {
        return self.asSharedSequence()
    }
}