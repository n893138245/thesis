import RxSwift
import RxRelay
extension SharedSequenceConvertibleType where SharingStrategy == SignalSharingStrategy {
    public func emit<Observer: ObserverType>(to observer: Observer) -> Disposable where Observer.Element == Element {
        return self.asSharedSequence().asObservable().subscribe(observer)
    }
    public func emit<Observer: ObserverType>(to observer: Observer) -> Disposable where Observer.Element == Element? {
        return self.asSharedSequence().asObservable().map { $0 as Element? }.subscribe(observer)
    }
    public func emit(to relay: BehaviorRelay<Element>) -> Disposable {
        return self.emit(onNext: { e in
            relay.accept(e)
        })
    }
    public func emit(to relay: BehaviorRelay<Element?>) -> Disposable {
        return self.emit(onNext: { e in
            relay.accept(e)
        })
    }
    public func emit(to relay: PublishRelay<Element>) -> Disposable {
        return self.emit(onNext: { e in
            relay.accept(e)
        })
    }
    public func emit(to relay: PublishRelay<Element?>) -> Disposable {
        return self.emit(onNext: { e in
            relay.accept(e)
        })
    }
    public func emit(onNext: ((Element) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable {
        return self.asObservable().subscribe(onNext: onNext, onCompleted: onCompleted, onDisposed: onDisposed)
    }
}