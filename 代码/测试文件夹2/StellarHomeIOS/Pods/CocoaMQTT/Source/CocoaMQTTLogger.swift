import Foundation
func printDebug(_ message: String) {
    CocoaMQTTLogger.logger.debug(message)
}
func printInfo(_ message: String) {
    CocoaMQTTLogger.logger.info(message)
}
func printWarning(_ message: String) {
    CocoaMQTTLogger.logger.warning(message)
}
func printError(_ message: String) {
    CocoaMQTTLogger.logger.error(message)
}
public enum CocoaMQTTLoggerLevel: Int {
    case debug = 0, info, warning, error, off
}
class CocoaMQTTLogger: NSObject {
    static let logger = CocoaMQTTLogger()
    private override init() {}
    var minLevel: CocoaMQTTLoggerLevel = .warning
    func log(level: CocoaMQTTLoggerLevel, message: String) {
        guard level.rawValue >= minLevel.rawValue else { return }
        print("CocoaMQTT(\(level)): \(message)")
    }
    func debug(_ message: String) {
        log(level: .debug, message: message)
    }
    func info(_ message: String) {
        log(level: .info, message: message)
    }
    func warning(_ message: String) {
        log(level: .warning, message: message)
    }
    func error(_ message: String) {
        log(level: .error, message: message)
    }
}