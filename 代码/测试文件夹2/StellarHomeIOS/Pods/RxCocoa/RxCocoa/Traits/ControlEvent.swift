import RxSwift
public protocol ControlEventType : ObservableType {
    func asControlEvent() -> ControlEvent<Element>
}
public struct ControlEvent<PropertyType> : ControlEventType {
    public typealias Element = PropertyType
    let _events: Observable<PropertyType>
    public init<Ev: ObservableType>(events: Ev) where Ev.Element == Element {
        self._events = events.subscribeOn(ConcurrentMainScheduler.instance)
    }
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._events.subscribe(observer)
    }
    public func asObservable() -> Observable<Element> {
        return self._events
    }
    public func asControlEvent() -> ControlEvent<Element> {
        return self
    }
}