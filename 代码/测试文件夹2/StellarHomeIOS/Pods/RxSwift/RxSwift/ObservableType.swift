public protocol ObservableType: ObservableConvertibleType {
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element
}
extension ObservableType {
    public func asObservable() -> Observable<Element> {
        return Observable.create { o in
            return self.subscribe(o)
        }
    }
}