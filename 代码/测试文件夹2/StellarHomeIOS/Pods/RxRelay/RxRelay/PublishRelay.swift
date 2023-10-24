import RxSwift
public final class PublishRelay<Element>: ObservableType {
    private let _subject: PublishSubject<Element>
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }
    public init() {
        self._subject = PublishSubject()
    }
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}