public protocol ConnectableObservableType : ObservableType {
    func connect() -> Disposable
}