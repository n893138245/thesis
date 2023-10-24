#if DEBUG
import Foundation
#endif
public enum SingleTrait { }
public typealias Single<Element> = PrimitiveSequence<SingleTrait, Element>
public enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public typealias SingleObserver = (SingleEvent<Element>) -> Void
    public static func create(subscribe: @escaping (@escaping SingleObserver) -> Disposable) -> Single<Element> {
        let source = Observable<Element>.create { observer in
            return subscribe { event in
                switch event {
                case .success(let element):
                    observer.on(.next(element))
                    observer.on(.completed)
                case .error(let error):
                    observer.on(.error(error))
                }
            }
        }
        return PrimitiveSequence(raw: source)
    }
    public func subscribe(_ observer: @escaping (SingleEvent<Element>) -> Void) -> Disposable {
        var stopped = false
        return self.primitiveSequence.asObservable().subscribe { event in
            if stopped { return }
            stopped = true
            switch event {
            case .next(let element):
                observer(.success(element))
            case .error(let error):
                observer(.error(error))
            case .completed:
                rxFatalErrorInDebug("Singles can't emit a completion event")
            }
        }
    }
    public func subscribe(onSuccess: ((Element) -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil) -> Disposable {
        #if DEBUG
             let callStack = Hooks.recordCallStackOnError ? Thread.callStackSymbols : []
        #else
            let callStack = [String]()
        #endif
        return self.primitiveSequence.subscribe { event in
            switch event {
            case .success(let element):
                onSuccess?(element)
            case .error(let error):
                if let onError = onError {
                    onError(error)
                } else {
                    Hooks.defaultErrorHandler(callStack, error)
                }
            }
        }
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func just(_ element: Element) -> Single<Element> {
        return Single(raw: Observable.just(element))
    }
    public static func just(_ element: Element, scheduler: ImmediateSchedulerType) -> Single<Element> {
        return Single(raw: Observable.just(element, scheduler: scheduler))
    }
    public static func error(_ error: Swift.Error) -> Single<Element> {
        return PrimitiveSequence(raw: Observable.error(error))
    }
    public static func never() -> Single<Element> {
        return PrimitiveSequence(raw: Observable.never())
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public func `do`(onSuccess: ((Element) throws -> Void)? = nil,
                     afterSuccess: ((Element) throws -> Void)? = nil,
                     onError: ((Swift.Error) throws -> Void)? = nil,
                     afterError: ((Swift.Error) throws -> Void)? = nil,
                     onSubscribe: (() -> Void)? = nil,
                     onSubscribed: (() -> Void)? = nil,
                     onDispose: (() -> Void)? = nil)
        -> Single<Element> {
            return Single(raw: self.primitiveSequence.source.do(
                onNext: onSuccess,
                afterNext: afterSuccess,
                onError: onError,
                afterError: afterError,
                onSubscribe: onSubscribe,
                onSubscribed: onSubscribed,
                onDispose: onDispose)
            )
    }
    public func filter(_ predicate: @escaping (Element) throws -> Bool)
        -> Maybe<Element> {
            return Maybe(raw: self.primitiveSequence.source.filter(predicate))
    }
    public func map<Result>(_ transform: @escaping (Element) throws -> Result)
        -> Single<Result> {
            return Single(raw: self.primitiveSequence.source.map(transform))
    }
    public func compactMap<Result>(_ transform: @escaping (Element) throws -> Result?)
        -> Maybe<Result> {
        return Maybe(raw: self.primitiveSequence.source.compactMap(transform))
    }
    public func flatMap<Result>(_ selector: @escaping (Element) throws -> Single<Result>)
        -> Single<Result> {
            return Single<Result>(raw: self.primitiveSequence.source.flatMap(selector))
    }
    public func flatMapMaybe<Result>(_ selector: @escaping (Element) throws -> Maybe<Result>)
        -> Maybe<Result> {
            return Maybe<Result>(raw: self.primitiveSequence.source.flatMap(selector))
    }
    public func flatMapCompletable(_ selector: @escaping (Element) throws -> Completable)
        -> Completable {
            return Completable(raw: self.primitiveSequence.source.flatMap(selector))
    }
    public static func zip<Collection: Swift.Collection, Result>(_ collection: Collection, resultSelector: @escaping ([Element]) throws -> Result) -> PrimitiveSequence<Trait, Result> where Collection.Element == PrimitiveSequence<Trait, Element> {
        if collection.isEmpty {
            return PrimitiveSequence<Trait, Result>.deferred {
                return PrimitiveSequence<Trait, Result>(raw: .just(try resultSelector([])))
            }
        }
        let raw = Observable.zip(collection.map { $0.asObservable() }, resultSelector: resultSelector)
        return PrimitiveSequence<Trait, Result>(raw: raw)
    }
    public static func zip<Collection: Swift.Collection>(_ collection: Collection) -> PrimitiveSequence<Trait, [Element]> where Collection.Element == PrimitiveSequence<Trait, Element> {
        if collection.isEmpty {
            return PrimitiveSequence<Trait, [Element]>(raw: .just([]))
        }
        let raw = Observable.zip(collection.map { $0.asObservable() })
        return PrimitiveSequence(raw: raw)
    }
    public func catchErrorJustReturn(_ element: Element)
        -> PrimitiveSequence<Trait, Element> {
        return PrimitiveSequence(raw: self.primitiveSequence.source.catchErrorJustReturn(element))
    }
    public func asMaybe() -> Maybe<Element> {
        return Maybe(raw: self.primitiveSequence.source)
    }
    public func asCompletable() -> Completable {
        return self.primitiveSequence.source.ignoreElements()
    }
}