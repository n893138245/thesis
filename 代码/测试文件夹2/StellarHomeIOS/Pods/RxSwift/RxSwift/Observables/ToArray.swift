extension ObservableType {
    public func toArray()
        -> Single<[Element]> {
        return PrimitiveSequence(raw: ToArray(source: self.asObservable()))
    }
}
final private class ToArraySink<SourceType, Observer: ObserverType>: Sink<Observer>, ObserverType where Observer.Element == [SourceType] {
    typealias Parent = ToArray<SourceType>
    let _parent: Parent
    var _list = [SourceType]()
    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<SourceType>) {
        switch event {
        case .next(let value):
            self._list.append(value)
        case .error(let e):
            self.forwardOn(.error(e))
            self.dispose()
        case .completed:
            self.forwardOn(.next(self._list))
            self.forwardOn(.completed)
            self.dispose()
        }
    }
}
final private class ToArray<SourceType>: Producer<[SourceType]> {
    let _source: Observable<SourceType>
    init(source: Observable<SourceType>) {
        self._source = source
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == [SourceType] {
        let sink = ToArraySink(parent: self, observer: observer, cancel: cancel)
        let subscription = self._source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}