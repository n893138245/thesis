import Foundation
#if SWIFT_PACKAGE
import ReactiveCocoaObjC
#endif
import ReactiveSwift
fileprivate let interceptedKey = AssociationKey(default: false)
fileprivate let signatureCacheKey = AssociationKey<SignatureCache>()
fileprivate let selectorCacheKey = AssociationKey<SelectorCache>()
internal let noImplementation: IMP = unsafeBitCast(Int(0), to: IMP.self)
extension Reactive where Base: NSObject {
	public func trigger(for selector: Selector) -> Signal<(), Never> {
		return base.intercept(selector).map { _ in }
	}
	public func signal(for selector: Selector) -> Signal<[Any?], Never> {
		return base.intercept(selector).map(unpackInvocation)
	}
}
extension NSObject {
	@nonobjc fileprivate func intercept(_ selector: Selector) -> Signal<AnyObject, Never> {
		guard let method = class_getInstanceMethod(objcClass, selector) else {
			fatalError("Selector `\(selector)` does not exist in class `\(String(describing: objcClass))`.")
		}
		let typeEncoding = method_getTypeEncoding(method)!
		assert(checkTypeEncoding(typeEncoding))
		return synchronized(self) {
			let alias = selector.alias
			let stateKey = AssociationKey<InterceptingState?>(alias)
			let interopAlias = selector.interopAlias
			if let state = associations.value(forKey: stateKey) {
				return state.signal
			}
			let subclass: AnyClass = swizzleClass(self)
			let subclassAssociations = Associations(subclass as AnyObject)
			ReactiveCocoa.synchronized(subclass) {
				let isSwizzled = subclassAssociations.value(forKey: interceptedKey)
				let signatureCache: SignatureCache
				let selectorCache: SelectorCache
				if isSwizzled {
					signatureCache = subclassAssociations.value(forKey: signatureCacheKey)
					selectorCache = subclassAssociations.value(forKey: selectorCacheKey)
				} else {
					signatureCache = SignatureCache()
					selectorCache = SelectorCache()
					subclassAssociations.setValue(signatureCache, forKey: signatureCacheKey)
					subclassAssociations.setValue(selectorCache, forKey: selectorCacheKey)
					subclassAssociations.setValue(true, forKey: interceptedKey)
					enableMessageForwarding(subclass, selectorCache)
					setupMethodSignatureCaching(subclass, signatureCache)
				}
				selectorCache.cache(selector)
				if signatureCache[selector] == nil {
					let signature = NSMethodSignature.objcSignature(withObjCTypes: typeEncoding)
					signatureCache[selector] = signature
				}
				if !class_respondsToSelector(subclass, interopAlias) {
					let immediateImpl = class_getImmediateMethod(subclass, selector)
						.flatMap(method_getImplementation)
						.flatMap { $0 != _rac_objc_msgForward ? $0 : nil }
					if let impl = immediateImpl {
						let succeeds = class_addMethod(subclass, interopAlias, impl, typeEncoding)
						precondition(succeeds, "RAC attempts to swizzle a selector that has message forwarding enabled with a runtime injected implementation. This is unsupported in the current version.")
					}
				}
			}
			let state = InterceptingState(lifetime: reactive.lifetime)
			associations.setValue(state, forKey: stateKey)
			_ = class_replaceMethod(subclass, selector, _rac_objc_msgForward, typeEncoding)
			return state.signal
		}
	}
}
private func enableMessageForwarding(_ realClass: AnyClass, _ selectorCache: SelectorCache) {
	let perceivedClass: AnyClass = class_getSuperclass(realClass)!
	typealias ForwardInvocationImpl = @convention(block) (Unmanaged<NSObject>, AnyObject) -> Void
	let newForwardInvocation: ForwardInvocationImpl = { objectRef, invocation in
		let selector = invocation.selector!
		let alias = selectorCache.alias(for: selector)
		let interopAlias = selectorCache.interopAlias(for: selector)
		defer {
			let stateKey = AssociationKey<InterceptingState?>(alias)
			if let state = objectRef.takeUnretainedValue().associations.value(forKey: stateKey) {
				state.observer.send(value: invocation)
			}
		}
		let method = class_getInstanceMethod(perceivedClass, selector)
		let typeEncoding: String
		if let runtimeTypeEncoding = method.flatMap(method_getTypeEncoding) {
			typeEncoding = String(cString: runtimeTypeEncoding)
		} else {
			let methodSignature = (objectRef.takeUnretainedValue() as AnyObject)
				.objcMethodSignature(for: selector)
			let encodings = (0 ..< methodSignature.objcNumberOfArguments!)
				.map { UInt8(methodSignature.objcArgumentType(at: $0).pointee) }
			typeEncoding = String(bytes: encodings, encoding: .ascii)!
		}
		if class_respondsToSelector(realClass, interopAlias) {
			let topLevelClass: AnyClass = object_getClass(objectRef.takeUnretainedValue())!
			synchronized(topLevelClass) {
				func swizzle() {
					let interopImpl = class_getMethodImplementation(topLevelClass, interopAlias)!
					let previousImpl = class_replaceMethod(topLevelClass, selector, interopImpl, typeEncoding)
					invocation.objcInvoke()
					_ = class_replaceMethod(topLevelClass, selector, previousImpl ?? noImplementation, typeEncoding)
				}
				if topLevelClass != realClass {
					synchronized(realClass) {
						_ = class_replaceMethod(realClass, selector, noImplementation, typeEncoding)
						swizzle()
						_ = class_replaceMethod(realClass, selector, _rac_objc_msgForward, typeEncoding)
					}
				} else {
					swizzle()
				}
			}
			return
		}
		let impl: IMP = method.map(method_getImplementation) ?? _rac_objc_msgForward
		if impl != _rac_objc_msgForward {
			if class_getMethodImplementation(realClass, alias) != impl {
				_ = class_replaceMethod(realClass, alias, impl, typeEncoding)
			}
			invocation.objcSetSelector(alias)
			invocation.objcInvoke()
			return
		}
		typealias SuperForwardInvocation = @convention(c) (Unmanaged<NSObject>, Selector, AnyObject) -> Void
		let forwardInvocationImpl = class_getMethodImplementation(perceivedClass, ObjCSelector.forwardInvocation)
		let forwardInvocation = unsafeBitCast(forwardInvocationImpl, to: SuperForwardInvocation.self)
		forwardInvocation(objectRef, ObjCSelector.forwardInvocation, invocation)
	}
	_ = class_replaceMethod(realClass,
	                        ObjCSelector.forwardInvocation,
	                        imp_implementationWithBlock(newForwardInvocation as Any),
	                        ObjCMethodEncoding.forwardInvocation)
}
private func setupMethodSignatureCaching(_ realClass: AnyClass, _ signatureCache: SignatureCache) {
	let perceivedClass: AnyClass = class_getSuperclass(realClass)!
	let newMethodSignatureForSelector: @convention(block) (Unmanaged<NSObject>, Selector) -> AnyObject? = { objectRef, selector in
		if let signature = signatureCache[selector] {
			return signature
		}
		typealias SuperMethodSignatureForSelector = @convention(c) (Unmanaged<NSObject>, Selector, Selector) -> AnyObject?
		let impl = class_getMethodImplementation(perceivedClass, ObjCSelector.methodSignatureForSelector)
		let methodSignatureForSelector = unsafeBitCast(impl, to: SuperMethodSignatureForSelector.self)
		return methodSignatureForSelector(objectRef, ObjCSelector.methodSignatureForSelector, selector)
	}
	_ = class_replaceMethod(realClass,
	                        ObjCSelector.methodSignatureForSelector,
	                        imp_implementationWithBlock(newMethodSignatureForSelector as Any),
	                        ObjCMethodEncoding.methodSignatureForSelector)
}
private final class InterceptingState {
	let (signal, observer) = Signal<AnyObject, Never>.pipe()
	init(lifetime: Lifetime) {
		lifetime.ended.observeCompleted(observer.sendCompleted)
	}
}
private final class SelectorCache {
	private var map: [Selector: (main: Selector, interop: Selector)] = [:]
	init() {}
	@discardableResult
	func cache(_ selector: Selector) -> (main: Selector, interop: Selector) {
		if let pair = map[selector] {
			return pair
		}
		let aliases = (selector.alias, selector.interopAlias)
		map[selector] = aliases
		return aliases
	}
	func alias(for selector: Selector) -> Selector {
		if let (main, _) = map[selector] {
			return main
		}
		return selector.alias
	}
	func interopAlias(for selector: Selector) -> Selector {
		if let (_, interop) = map[selector] {
			return interop
		}
		return selector.interopAlias
	}
}
private final class SignatureCache {
	private var map: [Selector: AnyObject] = [:]
	init() {}
	subscript(selector: Selector) -> AnyObject? {
		get {
			return map[selector]
		}
		set {
			if map[selector] == nil {
				map[selector] = newValue
			}
		}
	}
}
private func checkTypeEncoding(_ types: UnsafePointer<CChar>) -> Bool {
	assert(types.pointee < Int8(UInt8(ascii: "1")) || types.pointee > Int8(UInt8(ascii: "9")),
	       "unknown method return type not supported in type encoding: \(String(cString: types))")
	assert(types.pointee != Int8(UInt8(ascii: "(")), "union method return type not supported")
	assert(types.pointee != Int8(UInt8(ascii: "{")), "struct method return type not supported")
	assert(types.pointee != Int8(UInt8(ascii: "[")), "array method return type not supported")
	assert(types.pointee != Int8(UInt8(ascii: "j")), "complex method return type not supported")
	return true
}
private func unpackInvocation(_ invocation: AnyObject) -> [Any?] {
	let invocation = invocation as AnyObject
	let methodSignature = invocation.objcMethodSignature!
	let count = methodSignature.objcNumberOfArguments!
	var bridged = [Any?]()
	bridged.reserveCapacity(Int(count - 2))
	for position in 2 ..< count {
		let rawEncoding = methodSignature.objcArgumentType(at: position)
		let encoding = ObjCTypeEncoding(rawValue: rawEncoding.pointee) ?? .undefined
		func extract<U>(_ type: U.Type) -> U {
			let pointer = UnsafeMutableRawPointer.allocate(byteCount: MemoryLayout<U>.size,
			                                               alignment: MemoryLayout<U>.alignment)
			defer {
				pointer.deallocate()
			}
			invocation.objcCopy(to: pointer, forArgumentAt: Int(position))
			return pointer.assumingMemoryBound(to: type).pointee
		}
		let value: Any?
		switch encoding {
		case .char:
			value = NSNumber(value: extract(CChar.self))
		case .int:
			value = NSNumber(value: extract(CInt.self))
		case .short:
			value = NSNumber(value: extract(CShort.self))
		case .long:
			value = NSNumber(value: extract(CLong.self))
		case .longLong:
			value = NSNumber(value: extract(CLongLong.self))
		case .unsignedChar:
			value = NSNumber(value: extract(CUnsignedChar.self))
		case .unsignedInt:
			value = NSNumber(value: extract(CUnsignedInt.self))
		case .unsignedShort:
			value = NSNumber(value: extract(CUnsignedShort.self))
		case .unsignedLong:
			value = NSNumber(value: extract(CUnsignedLong.self))
		case .unsignedLongLong:
			value = NSNumber(value: extract(CUnsignedLongLong.self))
		case .float:
			value = NSNumber(value: extract(CFloat.self))
		case .double:
			value = NSNumber(value: extract(CDouble.self))
		case .bool:
			value = NSNumber(value: extract(CBool.self))
		case .object:
			value = extract((AnyObject?).self)
		case .type:
			value = extract((AnyClass?).self)
		case .selector:
			value = extract((Selector?).self)
		case .undefined:
			var size = 0, alignment = 0
			NSGetSizeAndAlignment(rawEncoding, &size, &alignment)
			let buffer = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: alignment)
			defer { buffer.deallocate() }
			invocation.objcCopy(to: buffer, forArgumentAt: Int(position))
			value = NSValue(bytes: buffer, objCType: rawEncoding)
		}
		bridged.append(value)
	}
	return bridged
}