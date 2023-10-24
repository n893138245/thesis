public protocol OptionalProtocol: ExpressibleByNilLiteral {
	associatedtype Wrapped
	init(reconstructing value: Wrapped?)
	var optional: Wrapped? { get }
}
extension Optional: OptionalProtocol {
	public var optional: Wrapped? {
		return self
	}
	public init(reconstructing value: Wrapped?) {
		self = value
	}
}
extension Signal {
	internal func optionalize() -> Signal<Value?, Error> {
		return map(Optional.init)
	}
}
extension SignalProducer {
	internal func optionalize() -> SignalProducer<Value?, Error> {
		return lift { $0.optionalize() }
	}
}