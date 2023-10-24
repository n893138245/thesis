extension ObservableType {
    public static func empty() -> Observable<Element> {
        return EmptyProducer<Element>()
    }
}
final private class EmptyProducer<Element>: Producer<Element> {
    override func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        observer.on(.completed)
        return Disposables.create()
    }
}