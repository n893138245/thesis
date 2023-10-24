extension ObservableType {
    public func concat<Source: ObservableConvertibleType>(_ second: Source) -> Observable<Element> where Source.Element == Element {
        return Observable.concat([self.asObservable(), second.asObservable()])
    }
}
extension ObservableType {
    public static func concat<Sequence: Swift.Sequence>(_ sequence: Sequence) -> Observable<Element>
        where Sequence.Element == Observable<Element> {
            return Concat(sources: sequence, count: nil)
    }
    public static func concat<Collection: Swift.Collection>(_ collection: Collection) -> Observable<Element>
        where Collection.Element == Observable<Element> {
            return Concat(sources: collection, count: Int64(collection.count))
    }
    public static func concat(_ sources: Observable<Element> ...) -> Observable<Element> {
        return Concat(sources: sources, count: Int64(sources.count))
    }
}
final private class ConcatSink<Sequence: Swift.Sequence, Observer: ObserverType>
    : TailRecursiveSink<Sequence, Observer>
    , ObserverType where Sequence.Element: ObservableConvertibleType, Sequence.Element.Element == Observer.Element {
    typealias Element = Observer.Element 
    override init(observer: Observer, cancel: Cancelable) {
        super.init(observer: observer, cancel: cancel)
    }
    func on(_ event: Event<Element>){
        switch event {
        case .next:
            self.forwardOn(event)
        case .error:
            self.forwardOn(event)
            self.dispose()
        case .completed:
            self.schedule(.moveNext)
        }
    }
    override func subscribeToNext(_ source: Observable<Element>) -> Disposable {
        return source.subscribe(self)
    }
    override func extract(_ observable: Observable<Element>) -> SequenceGenerator? {
        if let source = observable as? Concat<Sequence> {
            return (source._sources.makeIterator(), source._count)
        }
        else {
            return nil
        }
    }
}
final private class Concat<Sequence: Swift.Sequence>: Producer<Sequence.Element.Element> where Sequence.Element: ObservableConvertibleType {
    typealias Element = Sequence.Element.Element
    fileprivate let _sources: Sequence
    fileprivate let _count: IntMax?
    init(sources: Sequence, count: IntMax?) {
        self._sources = sources
        self._count = count
    }
    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Element {
        let sink = ConcatSink<Sequence, Observer>(observer: observer, cancel: cancel)
        let subscription = sink.run((self._sources.makeIterator(), self._count))
        return (sink: sink, subscription: subscription)
    }
}