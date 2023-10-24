public struct AnyObserver<Element> : ObserverType {
    public typealias EventHandler = (Event<Element>) -> Void
    private let observer: EventHandler
    public init(eventHandler: @escaping EventHandler) {
        self.observer = eventHandler
    }
    public init<Observer: ObserverType>(_ observer: Observer) where Observer.Element == Element {
        self.observer = observer.on
    }
    public func on(_ event: Event<Element>) {
        return self.observer(event)
    }
    public func asObserver() -> AnyObserver<Element> {
        return self
    }
}
extension AnyObserver {
    typealias s = Bag<(Event<Element>) -> Void>
}
extension ObserverType {
    public func asObserver() -> AnyObserver<Element> {
        return AnyObserver(self)
    }
    public func mapObserver<Result>(_ transform: @escaping (Result) throws -> Element) -> AnyObserver<Result> {
        return AnyObserver { e in
            self.on(e.map(transform))
        }
    }
}