import Foundation
#if SWIFT_PACKAGE
import ReactiveCocoaObjC
#endif
import ReactiveSwift
extension Reactive where Base: NSObject {
	public func producer(forKeyPath keyPath: String) -> SignalProducer<Any?, Never> {
		return SignalProducer { observer, lifetime in
			let disposable = KeyValueObserver.observe(
				self.base,
				keyPath: keyPath,
				options: [.initial, .new],
				action: observer.send
			)
			lifetime.observeEnded(disposable.dispose)
			if let lifetimeDisposable = self.lifetime.observeEnded(observer.sendCompleted) {
				lifetime.observeEnded(lifetimeDisposable.dispose)
			}
		}
	}
	public func signal(forKeyPath keyPath: String) -> Signal<Any?, Never> {
		return Signal { observer, signalLifetime in
			signalLifetime += KeyValueObserver.observe(
				self.base,
				keyPath: keyPath,
				options: [.new],
				action: observer.send
			)
			signalLifetime += lifetime.observeEnded(observer.sendCompleted)
		}
	}
	private func producer<U>(
		for keyPath: KeyPath<Base, U>,
		transform: @escaping (Any?) -> U
	) -> SignalProducer<U, Never> {
		guard let kvcKeyPath = keyPath._kvcKeyPathString else {
			fatalError("Cannot use `producer(for:)` on a non Objective-C property.")
		}
		return SignalProducer { observer, lifetime in
			lifetime += KeyValueObserver.observe(
				self.base,
				keyPath: kvcKeyPath,
				options: [.initial, .new],
				action: { observer.send(value: transform($0)) }
			)
			lifetime += self.lifetime.observeEnded(observer.sendCompleted)
		}
	}
	private func signal<U>(
		for keyPath: KeyPath<Base, U>,
		transform: @escaping (Any?) -> U
	) -> Signal<U, Never> {
		guard let kvcKeyPath = keyPath._kvcKeyPathString else {
			fatalError("Cannot use `signal(for:)` on a non Objective-C property.")
		}
		return Signal { observer, lifetime in
			lifetime += KeyValueObserver.observe(
				self.base,
				keyPath: kvcKeyPath,
				options: [.new],
				action: { observer.send(value: transform($0)) }
			)
			lifetime += self.lifetime.observeEnded(observer.sendCompleted)
		}
	}
	public func producer<U>(for keyPath: KeyPath<Base, U?>) -> SignalProducer<U?, Never> {
		return producer(for: keyPath) { $0 as! U? }
	}
	public func producer<U>(for keyPath: KeyPath<Base, U?>) -> SignalProducer<U?, Never> where U: RawRepresentable {
		return producer(for: keyPath) {
			$0.flatMap { value in U(rawValue: value as! U.RawValue)! }
		}
	}
	public func signal<U>(for keyPath: KeyPath<Base, U?>) -> Signal<U?, Never> {
		return signal(for: keyPath) { $0 as! U? }
	}
	public func signal<U>(for keyPath: KeyPath<Base, U?>) -> Signal<U?, Never> where U: RawRepresentable {
		return signal(for: keyPath) {
			$0.flatMap { value in U(rawValue: value as! U.RawValue) }
		}
	}
	public func producer<U>(for keyPath: KeyPath<Base, U>) -> SignalProducer<U, Never> {
		return producer(for: keyPath) { $0 as! U }
	}
	public func producer<U>(for keyPath: KeyPath<Base, U>) -> SignalProducer<U, Never> where U: RawRepresentable {
		return producer(for: keyPath) { U(rawValue: $0 as! U.RawValue)! }
	}
	public func signal<U>(for keyPath: KeyPath<Base, U>) -> Signal<U, Never> {
		return signal(for: keyPath) { $0 as! U }
	}
	public func signal<U>(for keyPath: KeyPath<Base, U>) -> Signal<U, Never> where U: RawRepresentable {
		return signal(for: keyPath) { U(rawValue: $0 as! U.RawValue)! }
	}
}
extension Property where Value: OptionalProtocol {
	public convenience init(object: NSObject, keyPath: String) {
		self.init(UnsafeKVOProperty(object: object, optionalAttributeKeyPath: keyPath))
	}
}
extension Property {
	public convenience init(object: NSObject, keyPath: String) {
		self.init(UnsafeKVOProperty(object: object, nonOptionalAttributeKeyPath: keyPath))
	}
}
private final class UnsafeKVOProperty<Value>: PropertyProtocol {
	var value: Value { fatalError() }
	var signal: Signal<Value, Never> { fatalError() }
	let producer: SignalProducer<Value, Never>
	init(producer: SignalProducer<Value, Never>) {
		self.producer = producer
	}
	convenience init(object: NSObject, nonOptionalAttributeKeyPath keyPath: String) {
		self.init(producer: object.reactive.producer(forKeyPath: keyPath).map { $0 as! Value })
	}
}
private extension UnsafeKVOProperty where Value: OptionalProtocol {
	convenience init(object: NSObject, optionalAttributeKeyPath keyPath: String) {
		self.init(producer: object.reactive.producer(forKeyPath: keyPath).map {
			return Value(reconstructing: $0.optional as? Value.Wrapped)
		})
	}
}
extension BindingTarget {
	public init(object: NSObject, keyPath: String) {
		self.init(lifetime: object.reactive.lifetime) { [weak object] value in
			object?.setValue(value, forKey: keyPath)
		}
	}
}
internal final class KeyValueObserver: NSObject {
	typealias Action = (_ object: AnyObject?) -> Void
	private static let context = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 0)
	unowned(unsafe) let unsafeObject: NSObject
	let key: String
	let action: Action
	fileprivate init(observing object: NSObject, key: String, options: NSKeyValueObservingOptions, action: @escaping Action) {
		self.unsafeObject = object
		self.key = key
		self.action = action
		super.init()
		object.addObserver(
			self,
			forKeyPath: key,
			options: options,
			context: KeyValueObserver.context
		)
	}
	func detach() {
		unsafeObject.removeObserver(self, forKeyPath: key, context: KeyValueObserver.context)
	}
	override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey : Any]?,
		context: UnsafeMutableRawPointer?
	) {
		if context == KeyValueObserver.context {
			action(object as! NSObject)
		}
	}
}
extension KeyValueObserver {
	static func observe(
		_ object: NSObject,
		keyPath: String,
		options: NSKeyValueObservingOptions,
		action: @escaping (_ value: AnyObject?) -> Void
	) -> AnyDisposable {
		let components = keyPath.components(separatedBy: ".")
		precondition(!components.isEmpty, "Received an empty key path.")
		let isNested = components.count > 1
		let keyPathHead = components[0]
		let keyPathTail = components[1 ..< components.endIndex].joined(separator: ".")
		let headSerialDisposable = SerialDisposable()
		let (shouldObserveDeinit, isWeak) = keyPathHead.withCString { cString -> (Bool, Bool) in
			if let propertyPointer = class_getProperty(type(of: object), cString) {
				let attributes = PropertyAttributes(property: propertyPointer)
				return (attributes.isObject && attributes.objectClass != NSClassFromString("Protocol") && !attributes.isBlock, attributes.isWeak)
			}
			return (false, false)
		}
		let observer: KeyValueObserver
		if isNested {
			observer = KeyValueObserver(observing: object, key: keyPathHead, options: options.union(.initial)) { object in
				guard let value = object?.value(forKey: keyPathHead) as! NSObject? else {
					headSerialDisposable.inner = nil
					action(nil)
					return
				}
				let headDisposable = CompositeDisposable()
				headSerialDisposable.inner = headDisposable
				if shouldObserveDeinit {
					let disposable = value.reactive.lifetime.observeEnded {
						if isWeak {
							action(nil)
						}
						headSerialDisposable.inner = nil
					}
					headDisposable += disposable
				}
				let disposable = KeyValueObserver.observe(
					value,
					keyPath: keyPathTail,
					options: options.subtracting(.initial),
					action: action
				)
				headDisposable += disposable
				action(value.value(forKeyPath: keyPathTail) as AnyObject?)
			}
		} else {
			observer = KeyValueObserver(observing: object, key: keyPathHead, options: options) { object in
				guard let value = object?.value(forKey: keyPathHead) as AnyObject? else {
					action(nil)
					return
				}
				if shouldObserveDeinit && isWeak {
					let disposable = Lifetime.of(value).observeEnded {
						action(nil)
					}
					headSerialDisposable.inner = disposable
				}
				action(value)
			}
		}
		return AnyDisposable {
			observer.detach()
			headSerialDisposable.dispose()
		}
	}
}
internal struct PropertyAttributes {
	struct Code {
		static let start = Int8(UInt8(ascii: "T"))
		static let quote = Int8(UInt8(ascii: "\""))
		static let nul = Int8(UInt8(ascii: "\0"))
		static let comma = Int8(UInt8(ascii: ","))
		struct ContainingType {
			static let object = Int8(UInt8(ascii: "@"))
			static let block = Int8(UInt8(ascii: "?"))
		}
		struct Attribute {
			static let readonly = Int8(UInt8(ascii: "R"))
			static let copy = Int8(UInt8(ascii: "C"))
			static let retain = Int8(UInt8(ascii: "&"))
			static let nonatomic = Int8(UInt8(ascii: "N"))
			static let getter = Int8(UInt8(ascii: "G"))
			static let setter = Int8(UInt8(ascii: "S"))
			static let dynamic = Int8(UInt8(ascii: "D"))
			static let ivar = Int8(UInt8(ascii: "V"))
			static let weak = Int8(UInt8(ascii: "W"))
			static let collectable = Int8(UInt8(ascii: "P"))
			static let oldTypeEncoding = Int8(UInt8(ascii: "t"))
		}
	}
	let objectClass: AnyClass?
	let isWeak: Bool
	let isObject: Bool
	let isBlock: Bool
	init(property: objc_property_t) {
		guard let attrString = property_getAttributes(property) else {
			preconditionFailure("Could not get attribute string from property.")
		}
		precondition(attrString[0] == Code.start, "Expected attribute string to start with 'T'.")
		let typeString = attrString + 1
		let _next = NSGetSizeAndAlignment(typeString, nil, nil)
		guard _next != typeString else {
			let string = String(validatingUTF8: attrString)
			preconditionFailure("Could not read past type in attribute string: \(String(describing: string)).")
		}
		var next = UnsafeMutablePointer<Int8>(mutating: _next)
		let typeLength = typeString.distance(to: next)
		precondition(typeLength > 0, "Invalid type in attribute string.")
		var objectClass: AnyClass? = nil
		if typeString[0] == Code.ContainingType.object && typeString[1] == Code.quote {
			let className = typeString + 2;
			guard let endQuote = strchr(className, Int32(Code.quote)) else {
				preconditionFailure("Could not read class name in attribute string.")
			}
			next = endQuote
			if className != UnsafePointer(next) {
				let length = className.distance(to: next)
				let name = UnsafeMutablePointer<Int8>.allocate(capacity: length + 1)
				name.initialize(from: UnsafeMutablePointer<Int8>(mutating: className), count: length)
				(name + length).initialize(to: Code.nul)
				objectClass = objc_getClass(name) as! AnyClass?
				name.deinitialize(count: length + 1)
				name.deallocate()
			}
		}
		if next.pointee != Code.nul {
			next = strchr(next, Int32(Code.comma))
		}
		let emptyString = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
		emptyString.initialize(to: Code.nul)
		defer {
			emptyString.deinitialize(count: 1)
			emptyString.deallocate()
		}
		var isWeak = false
		while next.pointee == Code.comma {
			let flag = next[1]
			next += 2
			switch flag {
			case Code.nul:
				break;
			case Code.Attribute.readonly:
				break;
			case Code.Attribute.copy:
				break;
			case Code.Attribute.retain:
				break;
			case Code.Attribute.nonatomic:
				break;
			case Code.Attribute.getter:
				fallthrough
			case Code.Attribute.setter:
					next = strchr(next, Int32(Code.comma)) ?? emptyString
			case Code.Attribute.dynamic:
				break
			case Code.Attribute.ivar:
				if next.pointee != Code.nul {
					next = emptyString
				}
			case Code.Attribute.weak:
				isWeak = true
			case Code.Attribute.collectable:
				break
			case Code.Attribute.oldTypeEncoding:
				let string = String(validatingUTF8: attrString)
				assertionFailure("Old-style type encoding is unsupported in attribute string \"\(String(describing: string))\"")
				while next.pointee != Code.comma && next.pointee != Code.nul {
					next += 1
				}
			default:
				let pointer = UnsafeMutablePointer<Int8>.allocate(capacity: 2)
				pointer.initialize(to: flag)
				(pointer + 1).initialize(to: Code.nul)
				let flag = String(validatingUTF8: pointer)
				let string = String(validatingUTF8: attrString)
				preconditionFailure("ERROR: Unrecognized attribute string flag '\(String(describing: flag))' in attribute string \"\(String(describing: string))\".")
			}
		}
		if next.pointee != Code.nul {
			let unparsedData = String(validatingUTF8: next)
			let string = String(validatingUTF8: attrString)
			assertionFailure("Warning: Unparsed data \"\(String(describing: unparsedData))\" in attribute string \"\(String(describing: string))\".")
		}
		self.objectClass = objectClass
		self.isWeak = isWeak
		self.isObject = typeString[0] == Code.ContainingType.object
		self.isBlock = isObject && typeString[1] == Code.ContainingType.block
	}
}