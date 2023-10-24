public struct GroupedObservable<Key, Element> : ObservableType {
    public let key: Key
    private let source: Observable<Element>
    public init(key: Key, source: Observable<Element>) {
        self.key = key
        self.source = source
    }
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self.source.subscribe(observer)
    }
    public func asObservable() -> Observable<Element> {
        return self.source
    }
}