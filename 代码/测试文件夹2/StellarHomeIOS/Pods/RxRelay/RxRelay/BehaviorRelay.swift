import RxSwift
public final class BehaviorRelay<Element>: ObservableType {
    private let _subject: BehaviorSubject<Element>
    public func accept(_ event: Element) {
        self._subject.onNext(event)
    }
    public var value: Element {
        return try! self._subject.value()
    }
    public init(value: Element) {
        self._subject = BehaviorSubject(value: value)
    }
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }
    public func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
}