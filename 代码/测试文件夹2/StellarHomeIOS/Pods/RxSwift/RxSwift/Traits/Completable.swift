#if DEBUG
import Foundation
#endif
public enum CompletableTrait { }
public typealias Completable = PrimitiveSequence<CompletableTrait, Swift.Never>
public enum CompletableEvent {
    case error(Swift.Error)
    case completed
}
extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    public typealias CompletableObserver = (CompletableEvent) -> Void
    public static func create(subscribe: @escaping (@escaping CompletableObserver) -> Disposable) -> PrimitiveSequence<Trait, Element> {
        let source = Observable<Element>.create { observer in
            return subscribe { event in
                switch event {
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
        return PrimitiveSequence(raw: source)
    }
    public func subscribe(_ observer: @escaping (CompletableEvent) -> Void) -> Disposable {
        var stopped = false
        return self.primitiveSequence.asObservable().subscribe { event in
            if stopped { return }
            stopped = true
            switch event {
            case .next:
                rxFatalError("Completables can't emit values")
            case .error(let error):
                observer(.error(error))
            case .completed:
                observer(.completed)
            }
        }
    }
    public func subscribe(onCompleted: (() -> Void)? = nil, onError: ((Swift.Error) -> Void)? = nil) -> Disposable {
        #if DEBUG
                let callStack = Hooks.recordCallStackOnError ? Thread.callStackSymbols : []
        #else
                let callStack = [String]()
        #endif
        return self.primitiveSequence.subscribe { event in
            switch event {
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
extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    public static func error(_ error: Swift.Error) -> Completable {
        return PrimitiveSequence(raw: Observable.error(error))
    }
    public static func never() -> Completable {
        return PrimitiveSequence(raw: Observable.never())
    }
    public static func empty() -> Completable {
        return Completable(raw: Observable.empty())
    }
}
extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {
    public func `do`(onError: ((Swift.Error) throws -> Void)? = nil,
                     afterError: ((Swift.Error) throws -> Void)? = nil,
                     onCompleted: (() throws -> Void)? = nil,
                     afterCompleted: (() throws -> Void)? = nil,
                     onSubscribe: (() -> Void)? = nil,
                     onSubscribed: (() -> Void)? = nil,
                     onDispose: (() -> Void)? = nil)
        -> Completable {
            return Completable(raw: self.primitiveSequence.source.do(
                onError: onError,
                afterError: afterError,
                onCompleted: onCompleted,
                afterCompleted: afterCompleted,
                onSubscribe: onSubscribe,
                onSubscribed: onSubscribed,
                onDispose: onDispose)
            )
    }
    public func concat(_ second: Completable) -> Completable {
        return Completable.concat(self.primitiveSequence, second)
    }
    public static func concat<Sequence: Swift.Sequence>(_ sequence: Sequence) -> Completable
        where Sequence.Element == Completable {
            let source = Observable.concat(sequence.lazy.map { $0.asObservable() })
            return Completable(raw: source)
    }
    public static func concat<Collection: Swift.Collection>(_ collection: Collection) -> Completable
        where Collection.Element == Completable {
            let source = Observable.concat(collection.map { $0.asObservable() })
            return Completable(raw: source)
    }
    public static func concat(_ sources: Completable ...) -> Completable {
        let source = Observable.concat(sources.map { $0.asObservable() })
        return Completable(raw: source)
    }
    public static func zip<Collection: Swift.Collection>(_ sources: Collection) -> Completable
           where Collection.Element == Completable {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return Completable(raw: source)
    }
    public static func zip(_ sources: [Completable]) -> Completable {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return Completable(raw: source)
    }
    public static func zip(_ sources: Completable...) -> Completable {
        let source = Observable.merge(sources.map { $0.asObservable() })
        return Completable(raw: source)
    }
}