import RxSwift
import RxRelay
extension PublishRelay {
    public func asSignal() -> Signal<Element> {
        let source = self.asObservable()
            .observeOn(SignalSharingStrategy.scheduler)
        return SharedSequence(source)
    }
}