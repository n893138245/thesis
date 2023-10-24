public final class ValidatingProperty<Value, ValidationError: Swift.Error>: MutablePropertyProtocol {
	private let getter: () -> Value
	private let setter: (Value) -> Void
	public let result: Property<Result>
	public var value: Value {
		get { return getter() }
		set { setter(newValue) }
	}
	public let producer: SignalProducer<Value, Never>
	public let signal: Signal<Value, Never>
	public let lifetime: Lifetime
	public init<Inner: ComposableMutablePropertyProtocol>(
		_ inner: Inner,
		_ validator: @escaping (Value) -> Decision
	) where Inner.Value == Value {
		getter = { inner.value }
		producer = inner.producer
		signal = inner.signal
		lifetime = inner.lifetime
		var isSettingInnerValue = false
		(result, setter) = inner.withValue { initial in
			let mutableResult = MutableProperty(Result(initial, validator(initial)))
			mutableResult <~ inner.signal
				.filter { _ in !isSettingInnerValue }
				.map { Result($0, validator($0)) }
			return (Property(capturing: mutableResult), { input in
				inner.withValue { _ in
					let writebackValue: Value? = mutableResult.modify { result in
						result = Result(input, validator(input))
						return result.value
					}
					if let value = writebackValue {
						isSettingInnerValue = true
						inner.value = value
						isSettingInnerValue = false
					}
				}
			})
		}
	}
	public convenience init(
		_ initial: Value,
		_ validator: @escaping (Value) -> Decision
	) {
		self.init(MutableProperty(initial), validator)
	}
	public convenience init<Other: PropertyProtocol>(
		_ inner: MutableProperty<Value>,
		with other: Other,
		_ validator: @escaping (Value, Other.Value) -> Decision
	) {
		let other = Property(other)
		self.init(inner) { input in
			return validator(input, other.value)
		}
		other.signal
			.take(during: lifetime)
			.observeValues { [weak self] _ in
				guard let s = self else { return }
				switch s.result.value {
				case let .invalid(value, _):
					s.value = value
				case let .coerced(_, value, _):
					s.value = value
				case let .valid(value):
					s.value = value
				}
		}
	}
	public convenience init<Other: PropertyProtocol>(
		_ initial: Value,
		with other: Other,
		_ validator: @escaping (Value, Other.Value) -> Decision
	) {
		self.init(MutableProperty(initial), with: other, validator)
	}
	public convenience init<U, E>(
		_ initial: Value,
		with other: ValidatingProperty<U, E>,
		_ validator: @escaping (Value, U) -> Decision
	) {
		self.init(MutableProperty(initial), with: other, validator)
	}
	public convenience init<U, E>(
		_ inner: MutableProperty<Value>,
		with other: ValidatingProperty<U, E>,
		_ validator: @escaping (Value, U) -> Decision
	) {
		let otherValidations = other.result
		self.init(inner) { input in
			let otherValue: U
			switch otherValidations.value {
			case let .valid(value):
				otherValue = value
			case let .coerced(_, value, _):
				otherValue = value
			case let .invalid(value, _):
				otherValue = value
			}
			return validator(input, otherValue)
		}
		otherValidations.signal
			.take(during: lifetime)
			.observeValues { [weak self] _ in
				guard let s = self else { return }
				switch s.result.value {
				case let .invalid(value, _):
					s.value = value
				case let .coerced(_, value, _):
					s.value = value
				case let .valid(value):
					s.value = value
				}
			}
	}
	public enum Decision {
		case valid
		case coerced(Value, ValidationError?)
		case invalid(ValidationError)
	}
	public enum Result {
		case valid(Value)
		case coerced(replacement: Value, proposed: Value, error: ValidationError?)
		case invalid(Value, ValidationError)
		public var isInvalid: Bool {
			if case .invalid = self {
				return true
			} else {
				return false
			}
		}
		public var value: Value? {
			switch self {
			case let .valid(value):
				return value
			case let .coerced(value, _, _):
				return value
			case .invalid:
				return nil
			}
		}
		public var error: ValidationError? {
			if case let .invalid(_, error) = self {
				return error
			} else {
				return nil
			}
		}
		fileprivate init(_ value: Value, _ decision: Decision) {
			switch decision {
			case .valid:
				self = .valid(value)
			case let .coerced(replacement, error):
				self = .coerced(replacement: replacement, proposed: value, error: error)
			case let .invalid(error):
				self = .invalid(value, error)
			}
		}
	}
}