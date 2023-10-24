import RxSwift
extension SharedSequenceConvertibleType {
    public func map<Result>(_ selector: @escaping (Element) -> Result) -> SharedSequence<SharingStrategy, Result> {
        let source = self
            .asObservable()
            .map(selector)
        return SharedSequence<SharingStrategy, Result>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func compactMap<Result>(_ selector: @escaping (Element) -> Result?) -> SharedSequence<SharingStrategy, Result> {
        let source = self
            .asObservable()
            .compactMap(selector)
        return SharedSequence<SharingStrategy, Result>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func filter(_ predicate: @escaping (Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        let source = self
            .asObservable()
            .filter(predicate)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType where Element : SharedSequenceConvertibleType {
    public func switchLatest() -> SharedSequence<Element.SharingStrategy, Element.Element> {
        let source: Observable<Element.Element> = self
            .asObservable()
            .map { $0.asSharedSequence() }
            .switchLatest()
        return SharedSequence<Element.SharingStrategy, Element.Element>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func flatMapLatest<Sharing, Result>(_ selector: @escaping (Element) -> SharedSequence<Sharing, Result>)
        -> SharedSequence<Sharing, Result> {
        let source: Observable<Result> = self
            .asObservable()
            .flatMapLatest(selector)
        return SharedSequence<Sharing, Result>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func flatMapFirst<Sharing, Result>(_ selector: @escaping (Element) -> SharedSequence<Sharing, Result>)
        -> SharedSequence<Sharing, Result> {
        let source: Observable<Result> = self
            .asObservable()
            .flatMapFirst(selector)
        return SharedSequence<Sharing, Result>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func `do`(onNext: ((Element) -> Void)? = nil, afterNext: ((Element) -> Void)? = nil, onCompleted: (() -> Void)? = nil, afterCompleted: (() -> Void)? = nil, onSubscribe: (() -> Void)? = nil, onSubscribed: (() -> Void)? = nil, onDispose: (() -> Void)? = nil)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .do(onNext: onNext, afterNext: afterNext, onCompleted: onCompleted, afterCompleted: afterCompleted, onSubscribe: onSubscribe, onSubscribed: onSubscribed, onDispose: onDispose)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public func debug(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType where Element: Equatable {
    public func distinctUntilChanged()
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .distinctUntilChanged({ $0 }, comparer: { ($0 == $1) })
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public func distinctUntilChanged<Key: Equatable>(_ keySelector: @escaping (Element) -> Key) -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .distinctUntilChanged(keySelector, comparer: { $0 == $1 })
        return SharedSequence(source)
    }
    public func distinctUntilChanged(_ comparer: @escaping (Element, Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .distinctUntilChanged({ $0 }, comparer: comparer)
        return SharedSequence<SharingStrategy, Element>(source)
    }
    public func distinctUntilChanged<K>(_ keySelector: @escaping (Element) -> K, comparer: @escaping (K, K) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .distinctUntilChanged(keySelector, comparer: comparer)
        return SharedSequence<SharingStrategy, Element>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func flatMap<Sharing, Result>(_ selector: @escaping (Element) -> SharedSequence<Sharing, Result>) -> SharedSequence<Sharing, Result> {
        let source = self.asObservable()
            .flatMap(selector)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public static func merge<Collection: Swift.Collection>(_ sources: Collection) -> SharedSequence<SharingStrategy, Element>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return SharedSequence<SharingStrategy, Element>(source)
    }
    public static func merge(_ sources: [SharedSequence<SharingStrategy, Element>]) -> SharedSequence<SharingStrategy, Element> {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return SharedSequence<SharingStrategy, Element>(source)
    }
    public static func merge(_ sources: SharedSequence<SharingStrategy, Element>...) -> SharedSequence<SharingStrategy, Element> {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return SharedSequence<SharingStrategy, Element>(source)
    }
}
extension SharedSequenceConvertibleType where Element : SharedSequenceConvertibleType {
    public func merge() -> SharedSequence<Element.SharingStrategy, Element.Element> {
        let source = self.asObservable()
            .map { $0.asSharedSequence() }
            .merge()
        return SharedSequence<Element.SharingStrategy, Element.Element>(source)
    }
    public func merge(maxConcurrent: Int)
        -> SharedSequence<Element.SharingStrategy, Element.Element> {
        let source = self.asObservable()
            .map { $0.asSharedSequence() }
            .merge(maxConcurrent: maxConcurrent)
        return SharedSequence<Element.SharingStrategy, Element.Element>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func throttle(_ dueTime: RxTimeInterval, latest: Bool = true)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .throttle(dueTime, latest: latest, scheduler: SharingStrategy.scheduler)
        return SharedSequence(source)
    }
    public func debounce(_ dueTime: RxTimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .debounce(dueTime, scheduler: SharingStrategy.scheduler)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public func scan<A>(_ seed: A, accumulator: @escaping (A, Element) -> A)
        -> SharedSequence<SharingStrategy, A> {
        let source = self.asObservable()
            .scan(seed, accumulator: accumulator)
        return SharedSequence<SharingStrategy, A>(source)
    }
}
extension SharedSequence {
    public static func concat<Sequence: Swift.Sequence>(_ sequence: Sequence) -> SharedSequence<SharingStrategy, Element>
        where Sequence.Element == SharedSequence<SharingStrategy, Element> {
            let source = Observable.concat(sequence.lazy.map { $0.asObservable() })
            return SharedSequence<SharingStrategy, Element>(source)
    }
    public static func concat<Collection: Swift.Collection>(_ collection: Collection) -> SharedSequence<SharingStrategy, Element>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
        let source = Observable.concat(collection.map { $0.asObservable() })
        return SharedSequence<SharingStrategy, Element>(source)
    }
}
extension SharedSequence {
    public static func zip<Collection: Swift.Collection, Result>(_ collection: Collection, resultSelector: @escaping ([Element]) throws -> Result) -> SharedSequence<SharingStrategy, Result>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
        let source = Observable.zip(collection.map { $0.asSharedSequence().asObservable() }, resultSelector: resultSelector)
        return SharedSequence<SharingStrategy, Result>(source)
    }
    public static func zip<Collection: Swift.Collection>(_ collection: Collection) -> SharedSequence<SharingStrategy, [Element]>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
            let source = Observable.zip(collection.map { $0.asSharedSequence().asObservable() })
            return SharedSequence<SharingStrategy, [Element]>(source)
    }
}
extension SharedSequence {
    public static func combineLatest<Collection: Swift.Collection, Result>(_ collection: Collection, resultSelector: @escaping ([Element]) throws -> Result) -> SharedSequence<SharingStrategy, Result>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
        let source = Observable.combineLatest(collection.map { $0.asObservable() }, resultSelector: resultSelector)
        return SharedSequence<SharingStrategy, Result>(source)
    }
    public static func combineLatest<Collection: Swift.Collection>(_ collection: Collection) -> SharedSequence<SharingStrategy, [Element]>
        where Collection.Element == SharedSequence<SharingStrategy, Element> {
        let source = Observable.combineLatest(collection.map { $0.asObservable() })
        return SharedSequence<SharingStrategy, [Element]>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func withLatestFrom<SecondO: SharedSequenceConvertibleType, ResultType>(_ second: SecondO, resultSelector: @escaping (Element, SecondO.Element) -> ResultType) -> SharedSequence<SharingStrategy, ResultType> where SecondO.SharingStrategy == SharingStrategy {
        let source = self.asObservable()
            .withLatestFrom(second.asSharedSequence(), resultSelector: resultSelector)
        return SharedSequence<SharingStrategy, ResultType>(source)
    }
    public func withLatestFrom<SecondO: SharedSequenceConvertibleType>(_ second: SecondO) -> SharedSequence<SharingStrategy, SecondO.Element> {
        let source = self.asObservable()
            .withLatestFrom(second.asSharedSequence())
        return SharedSequence<SharingStrategy, SecondO.Element>(source)
    }
}
extension SharedSequenceConvertibleType {
    public func skip(_ count: Int)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .skip(count)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public func startWith(_ element: Element)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
                .startWith(element)
        return SharedSequence(source)
    }
}
extension SharedSequenceConvertibleType {
    public func delay(_ dueTime: RxTimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .delay(dueTime, scheduler: SharingStrategy.scheduler)
        return SharedSequence(source)
    }
}