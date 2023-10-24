public protocol ResultProtocol {
	associatedtype Value
	associatedtype Error: Swift.Error
	init(value: Value)
	init(error: Error)
	var result: Result<Value, Error> { get }
}
extension Result {
	public var value: Value? {
		switch self {
		case let .success(value): return value
		case .failure: return nil
		}
	}
	public var error: Error? {
		switch self {
		case .success: return nil
		case let .failure(error): return error
		}
	}
	public func map<U>(_ transform: (Value) -> U) -> Result<U, Error> {
		return flatMap { .success(transform($0)) }
	}
	public func flatMap<U>(_ transform: (Value) -> Result<U, Error>) -> Result<U, Error> {
		switch self {
		case let .success(value): return transform(value)
		case let .failure(error): return .failure(error)
		}
	}
	public func fanout<U>(_ other: @autoclosure () -> Result<U, Error>) -> Result<(Value, U), Error> {
		return self.flatMap { left in other().map { right in (left, right) } }
	}
	public func mapError<Error2>(_ transform: (Error) -> Error2) -> Result<Value, Error2> {
		return flatMapError { .failure(transform($0)) }
	}
	public func flatMapError<Error2>(_ transform: (Error) -> Result<Value, Error2>) -> Result<Value, Error2> {
		switch self {
		case let .success(value): return .success(value)
		case let .failure(error): return transform(error)
		}
	}
	public func bimap<U, Error2>(success: (Value) -> U, failure: (Error) -> Error2) -> Result<U, Error2> {
		switch self {
		case let .success(value): return .success(success(value))
		case let .failure(error): return .failure(failure(error))
		}
	}
}
extension Result {
	public func recover(_ value: @autoclosure () -> Value) -> Value {
		return self.value ?? value()
	}
	public func recover(with result: @autoclosure () -> Result<Value, Error>) -> Result<Value, Error> {
		switch self {
		case .success: return self
		case .failure: return result()
		}
	}
}
public protocol ErrorConvertible: Swift.Error {
	static func error(from error: Swift.Error) -> Self
}
extension Result where Result.Failure: ErrorConvertible {
	public func tryMap<U>(_ transform: (Value) throws -> U) -> Result<U, Error> {
		return flatMap { value in
			do {
				return .success(try transform(value))
			}
			catch {
				let convertedError = Error.error(from: error)
				return .failure(convertedError)
			}
		}
	}
}
extension Result where Result.Success: Equatable, Result.Failure: Equatable {
	public static func ==(left: Result<Value, Error>, right: Result<Value, Error>) -> Bool {
		if let left = left.value, let right = right.value {
			return left == right
		} else if let left = left.error, let right = right.error {
			return left == right
		}
		return false
	}
}
#if swift(>=4.1)
	extension Result: Equatable where Result.Success: Equatable, Result.Failure: Equatable { }
#else
	extension Result where Result.Success: Equatable, Result.Failure: Equatable {
		public static func !=(left: Result<Value, Error>, right: Result<Value, Error>) -> Bool {
			return !(left == right)
		}
	}
#endif
extension Result {
	public static func ??(left: Result<Value, Error>, right: @autoclosure () -> Value) -> Value {
		return left.recover(right())
	}
	public static func ??(left: Result<Value, Error>, right: @autoclosure () -> Result<Value, Error>) -> Result<Value, Error> {
		return left.recover(with: right())
	}
}
@available(*, unavailable, renamed: "ErrorConvertible")
public protocol ErrorProtocolConvertible: ErrorConvertible {}