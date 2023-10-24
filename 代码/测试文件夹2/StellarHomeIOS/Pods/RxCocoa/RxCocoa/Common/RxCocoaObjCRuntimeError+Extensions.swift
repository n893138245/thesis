#if SWIFT_PACKAGE && !DISABLE_SWIZZLING && !os(Linux)
    import RxCocoaRuntime
#endif
#if !DISABLE_SWIZZLING && !os(Linux)
    public enum RxCocoaInterceptionMechanism {
        case unknown
        case kvo
    }
    public enum RxCocoaObjCRuntimeError
        : Swift.Error
        , CustomDebugStringConvertible {
        case unknown(target: AnyObject)
        case objectMessagesAlreadyBeingIntercepted(target: AnyObject, interceptionMechanism: RxCocoaInterceptionMechanism)
        case selectorNotImplemented(target: AnyObject)
        case cantInterceptCoreFoundationTollFreeBridgedObjects(target: AnyObject)
        case threadingCollisionWithOtherInterceptionMechanism(target: AnyObject)
        case savingOriginalForwardingMethodFailed(target: AnyObject)
        case replacingMethodWithForwardingImplementation(target: AnyObject)
        case observingPerformanceSensitiveMessages(target: AnyObject)
        case observingMessagesWithUnsupportedReturnType(target: AnyObject)
    }
    extension RxCocoaObjCRuntimeError {
        public var debugDescription: String {
            switch self {
            case let .unknown(target):
                return "Unknown error occurred.\nTarget: `\(target)`"
            case let .objectMessagesAlreadyBeingIntercepted(target, interceptionMechanism):
                let interceptionMechanismDescription = interceptionMechanism == .kvo ? "KVO" : "other interception mechanism"
                return "Collision between RxCocoa interception mechanism and \(interceptionMechanismDescription)."
                    + " To resolve this conflict please use this interception mechanism first.\nTarget: \(target)"
            case let .selectorNotImplemented(target):
                return "Trying to observe messages for selector that isn't implemented.\nTarget: \(target)"
            case let .cantInterceptCoreFoundationTollFreeBridgedObjects(target):
                return "Interception of messages sent to Core Foundation isn't supported.\nTarget: \(target)"
            case let .threadingCollisionWithOtherInterceptionMechanism(target):
                return "Detected a conflict while modifying ObjC runtime.\nTarget: \(target)"
            case let .savingOriginalForwardingMethodFailed(target):
                return "Saving original method implementation failed.\nTarget: \(target)"
            case let .replacingMethodWithForwardingImplementation(target):
                return "Intercepting a sent message by replacing a method implementation with `_objc_msgForward` failed for some reason.\nTarget: \(target)"
            case let .observingPerformanceSensitiveMessages(target):
                return "Attempt to intercept one of the performance sensitive methods. \nTarget: \(target)"
            case let .observingMessagesWithUnsupportedReturnType(target):
                return "Attempt to intercept a method with unsupported return type. \nTarget: \(target)"
            }
        }
    }
    extension Error {
        func rxCocoaErrorForTarget(_ target: AnyObject) -> RxCocoaObjCRuntimeError {
            let error = self as NSError
            if error.domain == RXObjCRuntimeErrorDomain {
                let errorCode = RXObjCRuntimeError(rawValue: error.code) ?? .unknown
                switch errorCode {
                case .unknown:
                    return .unknown(target: target)
                case .objectMessagesAlreadyBeingIntercepted:
                    let isKVO = (error.userInfo[RXObjCRuntimeErrorIsKVOKey] as? NSNumber)?.boolValue ?? false
                    return .objectMessagesAlreadyBeingIntercepted(target: target, interceptionMechanism: isKVO ? .kvo : .unknown)
                case .selectorNotImplemented:
                    return .selectorNotImplemented(target: target)
                case .cantInterceptCoreFoundationTollFreeBridgedObjects:
                    return .cantInterceptCoreFoundationTollFreeBridgedObjects(target: target)
                case .threadingCollisionWithOtherInterceptionMechanism:
                    return .threadingCollisionWithOtherInterceptionMechanism(target: target)
                case .savingOriginalForwardingMethodFailed:
                    return .savingOriginalForwardingMethodFailed(target: target)
                case .replacingMethodWithForwardingImplementation:
                    return .replacingMethodWithForwardingImplementation(target: target)
                case .observingPerformanceSensitiveMessages:
                    return .observingPerformanceSensitiveMessages(target: target)
                case .observingMessagesWithUnsupportedReturnType:
                    return .observingMessagesWithUnsupportedReturnType(target: target)
                @unknown default:
                    fatalError("Unhandled Objective C Runtime Error")
                }
            }
            return RxCocoaObjCRuntimeError.unknown(target: target)
        }
    }
#endif