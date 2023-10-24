import class Foundation.NSNull
@_exported import RxRelay
import RxSwift
#if os(iOS)
    import UIKit
#endif
public enum RxCocoaError
    : Swift.Error
    , CustomDebugStringConvertible {
    case unknown
    case invalidOperation(object: Any)
    case itemsNotYetBound(object: Any)
    case invalidPropertyName(object: Any, propertyName: String)
    case invalidObjectOnKeyPath(object: Any, sourceObject: AnyObject, propertyName: String)
    case errorDuringSwizzling
    case castingError(object: Any, targetType: Any.Type)
}
extension RxCocoaError {
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "Unknown error occurred."
        case let .invalidOperation(object):
            return "Invalid operation was attempted on `\(object)`."
        case let .itemsNotYetBound(object):
            return "Data source is set, but items are not yet bound to user interface for `\(object)`."
        case let .invalidPropertyName(object, propertyName):
            return "Object `\(object)` doesn't have a property named `\(propertyName)`."
        case let .invalidObjectOnKeyPath(object, sourceObject, propertyName):
            return "Unobservable object `\(object)` was observed as `\(propertyName)` of `\(sourceObject)`."
        case .errorDuringSwizzling:
            return "Error during swizzling."
        case let .castingError(object, targetType):
            return "Error casting `\(object)` to `\(targetType)`"
        }
    }
}
func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
#if DEBUG
    rxFatalError(error)
#else
    print(error)
#endif
}
func rxAbstractMethod(message: String = "Abstract method", file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    rxFatalError(message, file: file, line: line)
}
func rxFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never  {
    fatalError(lastMessage(), file: file, line: line)
}
func rxFatalErrorInDebug(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
        fatalError(lastMessage(), file: file, line: line)
    #else
        print("\(file):\(line): \(lastMessage())")
    #endif
}
func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}
func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}
func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: AnyObject) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}
func castOrFatalError<T>(_ value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError(message)
    }
    return result
}
func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    return result
}
let dataSourceNotSet = "DataSource not set"
let delegateNotSet = "Delegate not set"
func rxFatalError(_ lastMessage: String) -> Never  {
    fatalError(lastMessage)
}