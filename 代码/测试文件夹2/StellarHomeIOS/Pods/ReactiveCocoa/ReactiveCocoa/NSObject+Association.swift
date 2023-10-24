import Foundation
#if SWIFT_PACKAGE
import ReactiveCocoaObjC
#endif
import ReactiveSwift
internal struct AssociationKey<Value> {
	fileprivate let address: UnsafeRawPointer
	fileprivate let `default`: Value!
	init(default: Value? = nil) {
		self.address = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
		self.default = `default`
	}
	init(_ key: StaticString, default: Value? = nil) {
		assert(key.hasPointerRepresentation)
		self.address = UnsafeRawPointer(key.utf8Start)
		self.default = `default`
	}
	init(_ key: Selector, default: Value? = nil) {
		self.address = UnsafeRawPointer(key.utf8Start)
		self.default = `default`
	}
}
internal struct Associations<Base: AnyObject> {
	fileprivate let base: Base
	init(_ base: Base) {
		self.base = base
	}
}
extension Reactive where Base: NSObjectProtocol {
	internal func associatedValue<T>(forKey key: StaticString = #function, initial: (Base) -> T) -> T {
		let key = AssociationKey<T?>(key)
		if let value = base.associations.value(forKey: key) {
			return value
		}
		let value = initial(base)
		base.associations.setValue(value, forKey: key)
		return value
	}
}
extension NSObjectProtocol {
	@nonobjc internal var associations: Associations<Self> {
		return Associations(self)
	}
}
extension Associations {
	internal func value<Value>(forKey key: AssociationKey<Value>) -> Value {
		return (objc_getAssociatedObject(base, key.address) as! Value?) ?? key.default
	}
	internal func value<Value>(forKey key: AssociationKey<Value?>) -> Value? {
		return objc_getAssociatedObject(base, key.address) as! Value?
	}
	internal func setValue<Value>(_ value: Value, forKey key: AssociationKey<Value>) {
		objc_setAssociatedObject(base, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
	internal func setValue<Value>(_ value: Value?, forKey key: AssociationKey<Value?>) {
		objc_setAssociatedObject(base, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}
internal func unsafeSetAssociatedValue<Value>(_ value: Value?, forKey key: AssociationKey<Value>, forObjectAt address: UnsafeRawPointer) {
	_rac_objc_setAssociatedObject(address, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}