import Foundation
import ReactiveSwift
public final class DynamicProperty<Value>: MutablePropertyProtocol {
	private weak var object: NSObject?
	private let keyPath: String
	private let cache: Property<Value>
	private let transform: (Value) -> Any?
	public var value: Value {
		get { return cache.value }
		set { object?.setValue(transform(newValue), forKeyPath: keyPath) }
	}
	public var lifetime: Lifetime {
		return object?.reactive.lifetime ?? .empty
	}
	public var bindingTarget: BindingTarget<Value> {
		return BindingTarget(lifetime: lifetime) { [weak object, keyPath] value in
			object?.setValue(value, forKey: keyPath)
		}
	}
	public var producer: SignalProducer<Value, Never> {
		return cache.producer
	}
	public var signal: Signal<Value, Never> {
		return cache.signal
	}
	internal init(object: NSObject, keyPath: String, cache: Property<Value>, transform: @escaping (Value) -> Any?) {
		self.object = object
		self.keyPath = keyPath
		self.cache = cache
		self.transform = transform
	}
	public convenience init(object: NSObject, keyPath: String) {
		self.init(object: object, keyPath: keyPath, cache: Property(object: object, keyPath: keyPath), transform: { $0 })
	}
}
extension DynamicProperty where Value: OptionalProtocol {
	public convenience init(object: NSObject, keyPath: String) {
		self.init(object: object, keyPath: keyPath, cache: Property(object: object, keyPath: keyPath), transform: { $0.optional })
	}
}