#if DEBUG
import Foundation
#endif
public enum MaybeTrait { }
public typealias Maybe<Element> = PrimitiveSequence<MaybeTrait, Element>
public enum MaybeEvent<Element> {
    case success(Element)
    case error(Swift.Error)
    case completed
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public typealias MaybeObserver = (MaybeEvent<Element>) -> Void
    public static func create(subscribe: @escaping (@escaping MaybeObserver) -> Disposable) -> PrimitiveSequence<Trait, Element> {
        let source = Observable<Element>.create { observer in
            return subscribe { event in
                switch event {
                case .success(let element):
                    observer.on(.next(element))
                    observer.on(.completed)
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
        return PrimitiveSequence(raw: source)
    }
    public func subscribe(_ observer: @escaping (MaybeEvent<Element>) -> Void) -> Disposable {
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
                observer(.completed)
            }
        }
    }
    public func subscribe(onSuccess: ((Element) -> Void)? = nil,
                          onError: ((Swift.Error) -> Void)? = nil,
                          onCompleted: (() -> Void)? = nil) -> Disposable {
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
            case .completed:
                onCompleted?()
            }
        }
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func just(_ element: Element) -> Maybe<Element> {
        return Maybe(raw: Observable.just(element))
    }
    public static func just(_ element: Element, scheduler: ImmediateSchedulerType) -> Maybe<Element> {
        return Maybe(raw: Observable.just(element, scheduler: scheduler))
    }
    public static func error(_ error: Swift.Error) -> Maybe<Element> {
        return PrimitiveSequence(raw: Observable.error(error))
    }
    public static func never() -> Maybe<Element> {
        return PrimitiveSequence(raw: Observable.never())
    }
    public static func empty() -> Maybe<Element> {
        return Maybe(raw: Observable.empty())
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public func `do`(onNext: ((Element) throws -> Void)? = nil,
                     afterNext: ((Element) throws -> Void)? = nil,
                     onError: ((Swift.Error) throws -> Void)? = nil,
                     afterError: ((Swift.Error) throws -> Void)? = nil,
                     onCompleted: (() throws -> Void)? = nil,
                     afterCompleted: (() throws -> Void)? = nil,
                     onSubscribe: (() -> Void)? = nil,
                     onSubscribed: (() -> Void)? = nil,
                     onDispose: (() -> Void)? = nil)
        -> Maybe<Element> {
            return Maybe(raw: self.primitiveSequence.source.do(
                onNext: onNext,
                afterNext: afterNext,
                onError: onError,
                afterError: afterError,
                onCompleted: onCompleted,
                afterCompleted: afterCompleted,
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
        -> Maybe<Result> {
            return Maybe(raw: self.primitiveSequence.source.map(transform))
    }
    public func compactMap<Result>(_ transform: @escaping (Element) throws -> Result?)
        -> Maybe<Result> {
        return Maybe(raw: self.primitiveSequence.source.compactMap(transform))
    }
    public func flatMap<Result>(_ selector: @escaping (Element) throws -> Maybe<Result>)
        -> Maybe<Result> {
            return Maybe<Result>(raw: self.primitiveSequence.source.flatMap(selector))
    }
    public func ifEmpty(default: Element) -> Single<Element> {
        return Single(raw: self.primitiveSequence.source.ifEmpty(default: `default`))
    }
    public func ifEmpty(switchTo other: Maybe<Element>) -> Maybe<Element> {
        return Maybe(raw: self.primitiveSequence.source.ifEmpty(switchTo: other.primitiveSequence.source))
    }
    public func ifEmpty(switchTo other: Single<Element>) -> Single<Element> {
        return Single(raw: self.primitiveSequence.source.ifEmpty(switchTo: other.primitiveSequence.source))
    }
    public func catchErrorJustReturn(_ element: Element)
        -> PrimitiveSequence<Trait, Element> {
        return PrimitiveSequence(raw: self.primitiveSequence.source.catchErrorJustReturn(element))
    }
}