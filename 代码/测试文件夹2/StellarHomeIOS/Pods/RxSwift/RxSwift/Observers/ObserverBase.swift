class ObserverBase<Element> : Disposable, ObserverType {
    private let _isStopped = AtomicInt(0)
    func on(_ event: Event<Element>) {
        switch event {
        case .next:
            if load(self._isStopped) == 0 {
                self.onCore(event)
            }
        case .error, .completed:
            if fetchOr(self._isStopped, 1) == 0 {
                self.onCore(event)
            }
        }
    }
    func onCore(_ event: Event<Element>) {
        rxAbstractMethod()
    }
    func dispose() {
        fetchOr(self._isStopped, 1)
    }
}