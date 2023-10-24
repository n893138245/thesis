import RxSwift
import RxRelay
extension BehaviorRelay {
    public func asDriver() -> Driver<Element> {
        let source = self.asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
        return SharedSequence(source)
    }
}