import Foundation
#if SWIFT_PACKAGE
import ReactiveCocoaObjC
#endif
import ReactiveSwift
fileprivate let runtimeSubclassedKey = AssociationKey(default: false)
fileprivate let knownRuntimeSubclassKey = AssociationKey<AnyClass?>(default: nil)
extension NSObject {
	internal func swizzle(_ pairs: (Selector, Any)..., key hasSwizzledKey: AssociationKey<Bool>) {
		let subclass: AnyClass = swizzleClass(self)
		ReactiveCocoa.synchronized(subclass) {
			let subclassAssociations = Associations(subclass as AnyObject)
			if !subclassAssociations.value(forKey: hasSwizzledKey) {
				subclassAssociations.setValue(true, forKey: hasSwizzledKey)
				for (selector, body) in pairs {
					let method = class_getInstanceMethod(subclass, selector)!
					let typeEncoding = method_getTypeEncoding(method)!
					if method_getImplementation(method) == _rac_objc_msgForward {
						let succeeds = class_addMethod(subclass, selector.interopAlias, imp_implementationWithBlock(body), typeEncoding)
						precondition(succeeds, "RAC attempts to swizzle a selector that has message forwarding enabled with a runtime injected implementation. This is unsupported in the current version.")
					} else {
						let succeeds = class_addMethod(subclass, selector, imp_implementationWithBlock(body), typeEncoding)
						precondition(succeeds, "RAC attempts to swizzle a selector that has already a runtime injected implementation. This is unsupported in the current version.")
					}
				}
			}
		}
	}
}
internal func swizzleClass(_ instance: NSObject) -> AnyClass {
	if let knownSubclass = instance.associations.value(forKey: knownRuntimeSubclassKey) {
		return knownSubclass
	}
	let perceivedClass: AnyClass = instance.objcClass
	let realClass: AnyClass = object_getClass(instance)!
	let realClassAssociations = Associations(realClass as AnyObject)
	if perceivedClass != realClass {
		synchronized(realClass) {
			let isSwizzled = realClassAssociations.value(forKey: runtimeSubclassedKey)
			if !isSwizzled {
				replaceGetClass(in: realClass, decoy: perceivedClass)
				realClassAssociations.setValue(true, forKey: runtimeSubclassedKey)
			}
		}
		return realClass
	} else {
		let name = subclassName(of: perceivedClass)
		let subclass: AnyClass = name.withCString { cString in
			if let existingClass = objc_getClass(cString) as! AnyClass? {
				return existingClass
			} else {
				let subclass: AnyClass = objc_allocateClassPair(perceivedClass, cString, 0)!
				replaceGetClass(in: subclass, decoy: perceivedClass)
				objc_registerClassPair(subclass)
				return subclass
			}
		}
		object_setClass(instance, subclass)
		instance.associations.setValue(subclass, forKey: knownRuntimeSubclassKey)
		return subclass
	}
}
private func subclassName(of class: AnyClass) -> String {
	return String(cString: class_getName(`class`)).appending("_RACSwift")
}
private func replaceGetClass(in class: AnyClass, decoy perceivedClass: AnyClass) {
	let getClass: @convention(block) (UnsafeRawPointer?) -> AnyClass = { _ in
		return perceivedClass
	}
	let impl = imp_implementationWithBlock(getClass as Any)
	_ = class_replaceMethod(`class`,
	                        ObjCSelector.getClass,
	                        impl,
	                        ObjCMethodEncoding.getClass)
	_ = class_replaceMethod(object_getClass(`class`),
	                        ObjCSelector.getClass,
	                        impl,
	                        ObjCMethodEncoding.getClass)
}