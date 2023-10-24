import Foundation
import ReactiveSwift
internal class DelegateProxy<Delegate: NSObjectProtocol>: NSObject {
	internal weak var forwardee: Delegate? {
		didSet {
			originalSetter(self)
		}
	}
	internal var interceptedSelectors: Set<Selector> = []
	private let lifetime: Lifetime
	private let originalSetter: (AnyObject) -> Void
	required init(lifetime: Lifetime, _ originalSetter: @escaping (AnyObject) -> Void) {
		self.lifetime = lifetime
		self.originalSetter = originalSetter
	}
	override func forwardingTarget(for selector: Selector!) -> Any? {
		return interceptedSelectors.contains(selector) ? nil : forwardee
	}
	func intercept(_ selector: Selector) -> Signal<(), Never> {
		interceptedSelectors.insert(selector)
		originalSetter(self)
		return self.reactive.trigger(for: selector).take(during: lifetime)
	}
	func intercept(_ selector: Selector) -> Signal<[Any?], Never> {
		interceptedSelectors.insert(selector)
		originalSetter(self)
		return self.reactive.signal(for: selector).take(during: lifetime)
	}
	override func responds(to selector: Selector!) -> Bool {
		if interceptedSelectors.contains(selector) {
			return true
		}
		return (forwardee?.responds(to: selector) ?? false) || super.responds(to: selector)
	}
}
private let hasSwizzledKey = AssociationKey<Bool>(default: false)
extension DelegateProxy {
	internal static func proxy<P: DelegateProxy<Delegate>>(
		for instance: NSObject,
		setter: Selector,
		getter: Selector
	) -> P {
		return _proxy(for: instance, setter: setter, getter: getter) as! P
	}
	private static func _proxy(
		for instance: NSObject,
		setter: Selector,
		getter: Selector
	) -> AnyObject {
		return synchronized(instance) {
			let key = AssociationKey<AnyObject?>(setter.delegateProxyAlias)
			if let proxy = instance.associations.value(forKey: key) {
				return proxy
			}
			let superclass: AnyClass = class_getSuperclass(swizzleClass(instance))!
			let invokeSuperSetter: @convention(c) (NSObject, AnyClass, Selector, AnyObject?) -> Void = { object, superclass, selector, delegate in
				typealias Setter = @convention(c) (NSObject, Selector, AnyObject?) -> Void
				let impl = class_getMethodImplementation(superclass, selector)
				unsafeBitCast(impl, to: Setter.self)(object, selector, delegate)
			}
			let newSetterImpl: @convention(block) (NSObject, AnyObject?) -> Void = { object, delegate in
				if let proxy = object.associations.value(forKey: key) as! DelegateProxy<Delegate>? {
					proxy.forwardee = (delegate as! Delegate?)
				} else {
					invokeSuperSetter(object, superclass, setter, delegate)
				}
			}
			instance.swizzle((setter, newSetterImpl), key: hasSwizzledKey)
			let proxy = self.init(lifetime: instance.reactive.lifetime) { [weak instance] proxy in
				guard let instance = instance else { return }
				invokeSuperSetter(instance, superclass, setter, proxy)
			}
			typealias Getter = @convention(c) (NSObject, Selector) -> AnyObject?
			let getterImpl: IMP = class_getMethodImplementation(object_getClass(instance), getter)!
			let original = unsafeBitCast(getterImpl, to: Getter.self)(instance, getter) as! Delegate?
			proxy.forwardee = original
			instance.associations.setValue(proxy, forKey: key)
			return proxy
		}
	}
}