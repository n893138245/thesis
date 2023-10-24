import RxSwift
public protocol ControlPropertyType : ObservableType, ObserverType {
    func asControlProperty() -> ControlProperty<Element>
}
public struct ControlProperty<PropertyType> : ControlPropertyType {
    public typealias Element = PropertyType
    let _values: Observable<PropertyType>
    let _valueSink: AnyObserver<PropertyType>
    public init<Values: ObservableType, Sink: ObserverType>(values: Values, valueSink: Sink) where Element == Values.Element, Element == Sink.Element {
        self._values = values.subscribeOn(ConcurrentMainScheduler.instance)
        self._valueSink = valueSink.asObserver()
    }
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._values.subscribe(observer)
    }
    public var changed: ControlEvent<PropertyType> {
        return ControlEvent(events: self._values.skip(1))
    }
    public func asObservable() -> Observable<Element> {
        return self._values
    }
    public func asControlProperty() -> ControlProperty<Element> {
        return self
    }
    public func on(_ event: Event<Element>) {
        switch event {
        case .error(let error):
            bindingError(error)
        case .next:
            self._valueSink.on(event)
        case .completed:
            self._valueSink.on(event)
        }
    }
}
extension ControlPropertyType where Element == String? {
    public var orEmpty: ControlProperty<String> {
        let original: ControlProperty<String?> = self.asControlProperty()
        let values: Observable<String> = original._values.map { $0 ?? "" }
        let valueSink: AnyObserver<String> = original._valueSink.mapObserver { $0 }
        return ControlProperty<String>(values: values, valueSink: valueSink)
    }
}