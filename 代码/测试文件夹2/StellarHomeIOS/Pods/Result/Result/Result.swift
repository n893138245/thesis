public enum Result<Value, Error: Swift.Error>: ResultProtocol, CustomStringConvertible, CustomDebugStringConvertible {
	case success(Value)
	case failure(Error)
	public typealias Success = Value
	public typealias Failure = Error
	public init(value: Value) {
		self = .success(value)
	}
	public init(error: Error) {
		self = .failure(error)
	}
	public init(_ value: Value?, failWith: @autoclosure () -> Error) {
		self = value.map(Result.success) ?? .failure(failWith())
	}
	public init(_ f: @autoclosure () throws -> Value) {
		self.init(catching: f)
	}
	@available(*, deprecated, renamed: "init(catching:)")
	public init(attempt f: () throws -> Value) {
		self.init(catching: f)
	}
	public init(catching body: () throws -> Success) {
		do {
			self = .success(try body())
		} catch var error {
			if Error.self == AnyError.self {
				error = AnyError(error)
			}
			self = .failure(error as! Error)
		}
	}
	@available(*, deprecated, renamed: "get()")
	public func dematerialize() throws -> Value {
		return try get()
	}
	public func get() throws -> Success {
		switch self {
		case let .success(value):
			return value
		case let .failure(error):
			throw error
		}
	}
	public func analysis<Result>(ifSuccess: (Value) -> Result, ifFailure: (Error) -> Result) -> Result {
		switch self {
		case let .success(value):
			return ifSuccess(value)
		case let .failure(value):
			return ifFailure(value)
		}
	}
	public static var errorDomain: String { return "com.antitypical.Result" }
	public static var functionKey: String { return "\(errorDomain).function" }
	public static var fileKey: String { return "\(errorDomain).file" }
	public static var lineKey: String { return "\(errorDomain).line" }
	public static func error(_ message: String? = nil, function: String = #function, file: String = #file, line: Int = #line) -> NSError {
		var userInfo: [String: Any] = [
			functionKey: function,
			fileKey: file,
			lineKey: line,
		]
		if let message = message {
			userInfo[NSLocalizedDescriptionKey] = message
		}
		return NSError(domain: errorDomain, code: 0, userInfo: userInfo)
	}
	public var description: String {
		switch self {
		case let .success(value): return ".success(\(value))"
		case let .failure(error): return ".failure(\(error))"
		}
	}
	public var debugDescription: String {
		return description
	}
	public var result: Result<Value, Error> {
		return self
	}
}
extension Result where Result.Failure == AnyError {
	public init(_ f: @autoclosure () throws -> Value) {
		self.init(attempt: f)
	}
	public init(attempt f: () throws -> Value) {
		do {
			self = .success(try f())
		} catch {
			self = .failure(AnyError(error))
		}
	}
}
@available(*, deprecated, renamed: "Result.init(attempt:)")
public func materialize<T>(_ f: () throws -> T) -> Result<T, AnyError> {
	return Result(attempt: f)
}
@available(*, deprecated, renamed: "Result.init(_:)")
public func materialize<T>(_ f: @autoclosure () throws -> T) -> Result<T, AnyError> {
	return Result(try f())
}
extension NSError: ErrorConvertible {
	public static func error(from error: Swift.Error) -> Self {
		func cast<T: NSError>(_ error: Swift.Error) -> T {
			return error as! T
		}
		return cast(error)
	}
}
@available(*, unavailable, message: "Use the overload which returns `Result<T, AnyError>` instead")
public func materialize<T>(_ f: () throws -> T) -> Result<T, NSError> {
	fatalError()
}
@available(*, unavailable, message: "Use the overload which returns `Result<T, AnyError>` instead")
public func materialize<T>(_ f: @autoclosure () throws -> T) -> Result<T, NSError> {
	fatalError()
}
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
@available(*, unavailable, message: "This has been removed. Use `Result.init(attempt:)` instead. See https:
public func `try`<T>(_ function: String = #function, file: String = #file, line: Int = #line, `try`: (NSErrorPointer) -> T?) -> Result<T, NSError> {
	fatalError()
}
@available(*, unavailable, message: "This has been removed. Use `Result.init(attempt:)` instead. See https:
public func `try`(_ function: String = #function, file: String = #file, line: Int = #line, `try`: (NSErrorPointer) -> Bool) -> Result<(), NSError> {
	fatalError()
}
#endif
import Foundation