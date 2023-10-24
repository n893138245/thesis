import Foundation
@_exported import Differentiator
enum RxDataSourceError : Error {
  case preconditionFailed(message: String)
}
func rxPrecondition(_ condition: Bool, _ message: @autoclosure() -> String) throws -> () {
  if condition {
    return
  }
  rxDebugFatalError("Precondition failed")
  throw RxDataSourceError.preconditionFailed(message: message())
}
func rxDebugFatalError(_ error: Error) {
  rxDebugFatalError("\(error)")
}
func rxDebugFatalError(_ message: String) {
  #if DEBUG
    fatalError(message)
  #else
    print(message)
  #endif
}