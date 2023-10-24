import Foundation
import ReactiveSwift
private let isSwizzledKey = AssociationKey<Bool>(default: false)
private let lifetimeKey = AssociationKey<Lifetime?>(default: nil)
private let lifetimeTokenKey = AssociationKey<Lifetime.Token?>(default: nil)
public extension Lifetime {
	static func of(_ object: AnyObject) -> Lifetime {
		if let object = object as? NSObject {
			return .of(object)
		}
		return synchronized(object) {
			let associations = Associations(object)
			if let lifetime = associations.value(forKey: lifetimeKey) {
				return lifetime
			}
			let (lifetime, token) = Lifetime.make()
			associations.setValue(token, forKey: lifetimeTokenKey)
			associations.setValue(lifetime, forKey: lifetimeKey)
			return lifetime
		}
	}
	static func of(_ object: NSObject) -> Lifetime {
		return synchronized(object) {
			if let lifetime = object.associations.value(forKey: lifetimeKey) {
				return lifetime
			}
			let (lifetime, token) = Lifetime.make()
			let objcClass: AnyClass = (object as AnyObject).objcClass
			let objcClassAssociations = Associations(objcClass as AnyObject)
			#if swift(>=4.0)
			let deallocSelector = sel_registerName("dealloc")
			#else
			let deallocSelector = sel_registerName("dealloc")!
			#endif
			synchronized(objcClass) {
				if !objcClassAssociations.value(forKey: isSwizzledKey) {
					objcClassAssociations.setValue(true, forKey: isSwizzledKey)
					var existingImpl: IMP? = nil
					let newImplBlock: @convention(block) (UnsafeRawPointer) -> Void = { objectRef in
						unsafeSetAssociatedValue(nil, forKey: lifetimeTokenKey, forObjectAt: objectRef)
						let impl: IMP
						if let existingImpl = existingImpl {
							impl = existingImpl
						} else {
							let superclass: AnyClass = class_getSuperclass(objcClass)!
							impl = class_getMethodImplementation(superclass, deallocSelector)!
						}
						typealias Impl = @convention(c) (UnsafeRawPointer, Selector) -> Void
						unsafeBitCast(impl, to: Impl.self)(objectRef, deallocSelector)
					}
					let newImpl =  imp_implementationWithBlock(newImplBlock as Any)
					if !class_addMethod(objcClass, deallocSelector, newImpl, "v@:") {
						let deallocMethod = class_getInstanceMethod(objcClass, deallocSelector)!
						existingImpl = method_getImplementation(deallocMethod)
						existingImpl = method_setImplementation(deallocMethod, newImpl)
					}
				}
			}
			object.associations.setValue(token, forKey: lifetimeTokenKey)
			object.associations.setValue(lifetime, forKey: lifetimeKey)
			return lifetime
		}
	}
}
extension Reactive where Base: AnyObject {
	@nonobjc public var lifetime: Lifetime {
		return .of(base)
	}
}