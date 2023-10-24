#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
import Darwin.POSIX.pthread
#else
import Glibc
#endif
public protocol PropertyProtocol: AnyObject, BindingSource {
	var value: Value { get }
	var producer: SignalProducer<Value, Never> { get }
	var signal: Signal<Value, Never> { get }
}
public protocol MutablePropertyProtocol: PropertyProtocol, BindingTargetProvider {
	var value: Value { get set }
	var lifetime: Lifetime { get }
}
extension MutablePropertyProtocol {
	public var bindingTarget: BindingTarget<Value> {
		return BindingTarget(lifetime: lifetime) { [weak self] in self?.value = $0 }
	}
}
public protocol ComposableMutablePropertyProtocol: MutablePropertyProtocol {
	func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result
	func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result
}
extension PropertyProtocol {
	fileprivate func lift<U>(_ transform: @escaping (SignalProducer<Value, Never>) -> SignalProducer<U, Never>) -> Property<U> {
		return Property(unsafeProducer: transform(producer))
	}
	fileprivate func lift<P: PropertyProtocol, U>(_ transform: @escaping (SignalProducer<Value, Never>) -> (SignalProducer<P.Value, Never>) -> SignalProducer<U, Never>) -> (P) -> Property<U> {
		return { other in
			return Property(unsafeProducer: transform(self.producer)(other.producer))
		}
	}
}
extension PropertyProtocol {
	public func map<U>(_ transform: @escaping (Value) -> U) -> Property<U> {
		return lift { $0.map(transform) }
	}
	public func map<U>(value: U) -> Property<U> {
		return lift { $0.map(value: value) }
	}
	public func map<U>(_ keyPath: KeyPath<Value, U>) -> Property<U> {
		return lift { $0.map(keyPath) }
	}
	public func filter(initial: Value, _ predicate: @escaping (Value) -> Bool) -> Property<Value> {
		return Property(initial: initial, then: self.producer.filter(predicate))
	}
	public func combineLatest<P: PropertyProtocol>(with other: P) -> Property<(Value, P.Value)> {
		return Property.combineLatest(self, other)
	}
	public func zip<P: PropertyProtocol>(with other: P) -> Property<(Value, P.Value)> {
		return Property.zip(self, other)
	}
	public func combinePrevious(_ initial: Value) -> Property<(Value, Value)> {
		return lift { $0.combinePrevious(initial) }
	}
	public func skipRepeats(_ isEquivalent: @escaping (Value, Value) -> Bool) -> Property<Value> {
		return lift { $0.skipRepeats(isEquivalent) }
	}
}
extension PropertyProtocol where Value: Equatable {
	public func skipRepeats() -> Property<Value> {
		return lift { $0.skipRepeats() }
	}
}
extension PropertyProtocol where Value: PropertyProtocol {
	public func flatten(_ strategy: FlattenStrategy) -> Property<Value.Value> {
		return lift { $0.flatMap(strategy) { $0.producer } }
	}
}
extension PropertyProtocol {
	public func flatMap<P: PropertyProtocol>(_ strategy: FlattenStrategy, _ transform: @escaping (Value) -> P) -> Property<P.Value> {
		return lift { $0.flatMap(strategy) { transform($0).producer } }
	}
	public func uniqueValues<Identity: Hashable>(_ transform: @escaping (Value) -> Identity) -> Property<Value> {
		return lift { $0.uniqueValues(transform) }
	}
}
extension PropertyProtocol where Value: Hashable {
	public func uniqueValues() -> Property<Value> {
		return lift { $0.uniqueValues() }
	}
}
extension PropertyProtocol {
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol>(_ a: A, _ b: B) -> Property<(A.Value, B.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol>(_ a: A, _ b: B, _ c: C) -> Property<(Value, B.Value, C.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D) -> Property<(Value, B.Value, C.Value, D.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> Property<(Value, B.Value, C.Value, D.Value, E.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e, f) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e, f, g) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e, f, g, h) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol, I: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e, f, g, h, i) }
	}
	public static func combineLatest<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol, I: PropertyProtocol, J: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value, J.Value)> where A.Value == Value {
		return a.lift { SignalProducer.combineLatest($0, b, c, d, e, f, g, h, i, j) }
	}
	public static func combineLatest<S: Sequence>(_ properties: S) -> Property<[S.Iterator.Element.Value]>? where S.Iterator.Element: PropertyProtocol {
		let producers = properties.map { $0.producer }
		guard !producers.isEmpty else {
			return nil
		}
		return Property(unsafeProducer: SignalProducer.combineLatest(producers))
	}
	public static func combineLatest<S: Sequence>(
		_ properties: S,
		emptySentinel: [S.Iterator.Element.Value]
	) -> Property<[S.Iterator.Element.Value]> where S.Iterator.Element: PropertyProtocol {
		let producers = properties.map { $0.producer }
		return Property(unsafeProducer: SignalProducer.combineLatest(producers, emptySentinel: emptySentinel))
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol>(_ a: A, _ b: B) -> Property<(Value, B.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol>(_ a: A, _ b: B, _ c: C) -> Property<(Value, B.Value, C.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D) -> Property<(Value, B.Value, C.Value, D.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> Property<(Value, B.Value, C.Value, D.Value, E.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e, f) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e, f, g) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e, f, g, h) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol, I: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e, f, g, h, i) }
	}
	public static func zip<A: PropertyProtocol, B: PropertyProtocol, C: PropertyProtocol, D: PropertyProtocol, E: PropertyProtocol, F: PropertyProtocol, G: PropertyProtocol, H: PropertyProtocol, I: PropertyProtocol, J: PropertyProtocol>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) -> Property<(Value, B.Value, C.Value, D.Value, E.Value, F.Value, G.Value, H.Value, I.Value, J.Value)> where A.Value == Value {
		return a.lift { SignalProducer.zip($0, b, c, d, e, f, g, h, i, j) }
	}
	public static func zip<S: Sequence>(_ properties: S) -> Property<[S.Iterator.Element.Value]>? where S.Iterator.Element: PropertyProtocol {
		let producers = properties.map { $0.producer }
		guard !producers.isEmpty else {
			return nil
		}
		return Property(unsafeProducer: SignalProducer.zip(producers))
	}
	public static func zip<S: Sequence>(
		_ properties: S,
		emptySentinel: [S.Iterator.Element.Value]
	) -> Property<[S.Iterator.Element.Value]> where S.Iterator.Element: PropertyProtocol {
		let producers = properties.map { $0.producer }
		return Property(unsafeProducer: SignalProducer.zip(producers, emptySentinel: emptySentinel))
	}
}
extension PropertyProtocol where Value == Bool {
	public func negate() -> Property<Value> {
		return self.lift { $0.negate() }
	}
	public func and<P: PropertyProtocol>(_ property: P) -> Property<Value> where P.Value == Value {
		return self.lift(SignalProducer.and)(property)
	}
	public static func all<P: PropertyProtocol, Properties: Collection>(_ properties: Properties) -> Property<Value> where P.Value == Value, Properties.Element == P {
		return Property(initial: properties.map { $0.value }.reduce(true) { $0 && $1 }, then: SignalProducer.all(properties))
	}
    public static func all<P: PropertyProtocol>(_ properties: P...) -> Property<Value> where P.Value == Value {
        return .all(properties)
    }
	public func or<P: PropertyProtocol>(_ property: P) -> Property<Value> where P.Value == Value {
		return self.lift(SignalProducer.or)(property)
	}
	public static func any<P: PropertyProtocol, Properties: Collection>(_ properties: Properties) -> Property<Value> where P.Value == Value, Properties.Element == P {
		return Property(initial: properties.map { $0.value }.reduce(false) { $0 || $1 }, then: SignalProducer.any(properties))
	}
    public static func any<P: PropertyProtocol>(_ properties: P...) -> Property<Value> where P.Value == Value {
        return .any(properties)
    }
}
@propertyWrapper
public final class Property<Value>: PropertyProtocol {
	private let _value: () -> Value
	public var value: Value {
		return _value()
	}
	@inlinable
	public var wrappedValue: Value {
		return value
	}
	@inlinable
	public var projectedValue: Property<Value> {
		return self
	}
	public let producer: SignalProducer<Value, Never>
	public let signal: Signal<Value, Never>
	public init(value: Value) {
		_value = { value }
		producer = SignalProducer(value: value)
		signal = Signal<Value, Never>.empty
	}
	public init<P: PropertyProtocol>(capturing property: P) where P.Value == Value {
		_value = { property.value }
		producer = property.producer
		signal = property.signal
	}
	public convenience init<P: PropertyProtocol>(_ property: P) where P.Value == Value {
		self.init(unsafeProducer: property.producer)
	}
	public convenience init(initial: Value, then values: SignalProducer<Value, Never>) {
		self.init(unsafeProducer: SignalProducer { observer, lifetime in
			observer.send(value: initial)
			lifetime += values.start(Signal.Observer(mappingInterruptedToCompleted: observer))
		})
	}
	public convenience init<Values: SignalProducerConvertible>(initial: Value, then values: Values) where Values.Value == Value, Values.Error == Never {
		self.init(initial: initial, then: values.producer)
	}
	fileprivate init(unsafeProducer: SignalProducer<Value, Never>) {
		let box = PropertyBox<Value?>(nil)
		let disposable = SerialDisposable()
		let (relay, observer) = Signal<Value, Never>.pipe(disposable: disposable)
		disposable.inner = unsafeProducer.start { [weak box] event in
			guard let box = box else {
				return observer.send(event)
			}
			box.begin { storage in
				storage.modify { value in
					if let newValue = event.value {
						value = newValue
					}
				}
				observer.send(event)
			}
		}
		guard box.value != nil else {
			fatalError("The producer promised to send at least one value. Received none.")
		}
		_value = { box.value! }
		signal = relay
		producer = SignalProducer { [box, relay] observer, lifetime in
			box.withValue { value in
				observer.send(value: value!)
				lifetime += relay.observe(Signal.Observer(mappingInterruptedToCompleted: observer))
			}
		}
	}
}
extension Property where Value: OptionalProtocol {
	public convenience init(initial: Value, then values: SignalProducer<Value.Wrapped, Never>) {
		self.init(initial: initial, then: values.map(Value.init(reconstructing:)))
	}
	public convenience init<Values: SignalProducerConvertible>(initial: Value, then values: Values) where Values.Value == Value.Wrapped, Values.Error == Never {
		self.init(initial: initial, then: values.producer)
	}
}
@propertyWrapper
public final class MutableProperty<Value>: ComposableMutablePropertyProtocol {
	private let token: Lifetime.Token
	private let observer: Signal<Value, Never>.Observer
	private let box: PropertyBox<Value>
	public var value: Value {
		get { return box.value }
		set { modify { $0 = newValue } }
	}
	@inlinable
	public var wrappedValue: Value {
		get { value }
		set { value = newValue }
	}
	@inlinable
	public var projectedValue: MutableProperty<Value> {
		return self
	}
	public let lifetime: Lifetime
	public let signal: Signal<Value, Never>
	public var producer: SignalProducer<Value, Never> {
		return SignalProducer { [box, signal] observer, lifetime in
			box.withValue { value in
				observer.send(value: value)
				lifetime += signal.observe(Signal.Observer(mappingInterruptedToCompleted: observer))
			}
		}
	}
	public init(_ initialValue: Value) {
		(signal, observer) = Signal.pipe()
		(lifetime, token) = Lifetime.make()
		box = PropertyBox(initialValue)
	}
	public convenience init(wrappedValue: Value) {
		self.init(wrappedValue)
	}
	@discardableResult
	public func swap(_ newValue: Value) -> Value {
		return modify { value in
			defer { value = newValue }
			return value
		}
	}
	@discardableResult
	public func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
		return try box.begin { storage in
			defer { observer.send(value: storage.value) }
			return try storage.modify(action)
		}
	}
	@discardableResult
	internal func begin<Result>(_ action: (PropertyStorage<Value>) throws -> Result) rethrows -> Result {
		return try box.begin(action)
	}
	@discardableResult
	public func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
		return try box.withValue { try action($0) }
	}
	deinit {
		observer.sendCompleted()
	}
}
internal struct PropertyStorage<Value> {
	private unowned let box: PropertyBox<Value>
	var value: Value {
		return box._value
	}
	func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
		guard !box.isModifying else { fatalError("Nested modifications violate exclusivity of access.") }
		box.isModifying = true
		defer { box.isModifying = false }
		return try action(&box._value)
	}
	fileprivate init(_ box: PropertyBox<Value>) {
		self.box = box
	}
}
private final class PropertyBox<Value> {
	private let lock: Lock.PthreadLock
	fileprivate var _value: Value
	fileprivate var isModifying = false
	internal var value: Value {
		lock.lock()
		defer { lock.unlock() }
		return _value
	}
	init(_ value: Value) {
		_value = value
		lock = Lock.PthreadLock(recursive: true)
	}
	func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
		lock.lock()
		defer { lock.unlock() }
		return try action(_value)
	}
	func begin<Result>(_ action: (PropertyStorage<Value>) throws -> Result) rethrows -> Result {
		lock.lock()
		defer { lock.unlock() }
		return try action(PropertyStorage(self))
	}
}