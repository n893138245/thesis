import RxSwift
extension ObservableType {
    public func bind(to relays: PublishRelay<Element>...) -> Disposable {
        return bind(to: relays)
    }
    public func bind(to relays: PublishRelay<Element?>...) -> Disposable {
        return self.map { $0 as Element? }.bind(to: relays)
    }
    private func bind(to relays: [PublishRelay<Element>]) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element)
                }
            case let .error(error):
                rxFatalErrorInDebug("Binding error to publish relay: \(error)")
            case .completed:
                break
            }
        }
    }
    public func bind(to relays: BehaviorRelay<Element>...) -> Disposable {
        return self.bind(to: relays)
    }
    public func bind(to relays: BehaviorRelay<Element?>...) -> Disposable {
        return self.map { $0 as Element? }.bind(to: relays)
    }
    private func bind(to relays: [BehaviorRelay<Element>]) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element)
                }
            case let .error(error):
                rxFatalErrorInDebug("Binding error to behavior relay: \(error)")
            case .completed:
                break
            }
        }
    }
}