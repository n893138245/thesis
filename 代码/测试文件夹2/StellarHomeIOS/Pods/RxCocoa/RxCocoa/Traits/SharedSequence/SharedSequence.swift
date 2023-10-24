import RxSwift
public struct SharedSequence<SharingStrategy: SharingStrategyProtocol, Element> : SharedSequenceConvertibleType {
    let _source: Observable<Element>
    init(_ source: Observable<Element>) {
        self._source = SharingStrategy.share(source)
    }
    init(raw: Observable<Element>) {
        self._source = raw
    }
    #if EXPANDABLE_SHARED_SEQUENCE
    public static func createUnsafe<Source: ObservableType>(source: Source) -> SharedSequence<SharingStrategy, Source.Element> {
        return SharedSequence<SharingStrategy, Source.Element>(raw: source.asObservable())
    }
    #endif
    public func asObservable() -> Observable<Element> {
        return self._source
    }
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return self
    }
}
public protocol SharingStrategyProtocol {
    static var scheduler: SchedulerType { get }
    static func share<Element>(_ source: Observable<Element>) -> Observable<Element>
}
public protocol SharedSequenceConvertibleType : ObservableConvertibleType {
    associatedtype SharingStrategy: SharingStrategyProtocol
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element>
}
extension SharedSequenceConvertibleType {
    public func asObservable() -> Observable<Element> {
        return self.asSharedSequence().asObservable()
    }
}
extension SharedSequence {
    public static func empty() -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(raw: Observable.empty().subscribeOn(SharingStrategy.scheduler))
    }
    public static func never() -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(raw: Observable.never())
    }
    public static func just(_ element: Element) -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(raw: Observable.just(element).subscribeOn(SharingStrategy.scheduler))
    }
    public static func deferred(_ observableFactory: @escaping () -> SharedSequence<SharingStrategy, Element>)
        -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(Observable.deferred { observableFactory().asObservable() })
    }
    public static func of(_ elements: Element ...) -> SharedSequence<SharingStrategy, Element> {
        let source = Observable.from(elements, scheduler: SharingStrategy.scheduler)
        return SharedSequence(raw: source)
    }
}
extension SharedSequence {
    public static func from(_ array: [Element]) -> SharedSequence<SharingStrategy, Element> {
        let source = Observable.from(array, scheduler: SharingStrategy.scheduler)
        return SharedSequence(raw: source)
    }
    public static func from<Sequence: Swift.Sequence>(_ sequence: Sequence) -> SharedSequence<SharingStrategy, Element> where Sequence.Element == Element {
        let source = Observable.from(sequence, scheduler: SharingStrategy.scheduler)
        return SharedSequence(raw: source)
    }
    public static func from(optional: Element?) -> SharedSequence<SharingStrategy, Element> {
        let source = Observable.from(optional: optional, scheduler: SharingStrategy.scheduler)
        return SharedSequence(raw: source)
    }
}
extension SharedSequence where Element : RxAbstractInteger {
    public static func interval(_ period: RxTimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(Observable.interval(period, scheduler: SharingStrategy.scheduler))
    }
}
extension SharedSequence where Element: RxAbstractInteger {
    public static func timer(_ dueTime: RxTimeInterval, period: RxTimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return SharedSequence(Observable.timer(dueTime, period: period, scheduler: SharingStrategy.scheduler))
    }
}