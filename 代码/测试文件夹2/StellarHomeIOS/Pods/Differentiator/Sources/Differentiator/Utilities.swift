import Foundation
enum DifferentiatorError : Error {
    case unwrappingOptional
    case preconditionFailed(message: String)
}
func precondition(_ condition: Bool, _ message: @autoclosure() -> String) throws -> () {
    if condition {
        return
    }
    debugFatalError("Precondition failed")
    throw DifferentiatorError.preconditionFailed(message: message())
}
func debugFatalError(_ error: Error) {
    debugFatalError("\(error)")
}
func debugFatalError(_ message: String) {
    #if DEBUG
        fatalError(message)
    #else
        print(message)
    #endif
}