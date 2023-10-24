import RxSwift
extension ObservableType {
    public func bind<Observer: ObserverType>(to observers: Observer...) -> Disposable where Observer.Element == Element {
        return self.bind(to: observers)
    }
    public func bind<Observer: ObserverType>(to observers: Observer...) -> Disposable where Observer.Element == Element? {
        return self.map { $0 as Element? }.bind(to: observers)
    }
    private func bind<Observer: ObserverType>(to observers: [Observer]) -> Disposable where Observer.Element == Element {
        return self.subscribe { event in
            observers.forEach { $0.on(event) }
        }
    }
    public func bind<Result>(to binder: (Self) -> Result) -> Result {
        return binder(self)
    }
    public func bind<R1, R2>(to binder: (Self) -> (R1) -> R2, curriedArgument: R1) -> R2 {
         return binder(self)(curriedArgument)
    }
    public func bind(onNext: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext, onError: { error in
            rxFatalErrorInDebug("Binding error: \(error)")
        })
    }
}