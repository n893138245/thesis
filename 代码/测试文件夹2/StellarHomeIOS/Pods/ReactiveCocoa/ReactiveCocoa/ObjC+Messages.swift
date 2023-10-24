import Foundation
internal let NSInvocation: AnyClass = NSClassFromString("NSInvocation")!
internal let NSMethodSignature: AnyClass = NSClassFromString("NSMethodSignature")!
@objc internal protocol ObjCClassReporting {
	@objc(class)
	var objcClass: AnyClass! { get }
	@objc(methodSignatureForSelector:)
	func objcMethodSignature(for selector: Selector) -> AnyObject
}
@objc internal protocol ObjCInvocation {
	@objc(setSelector:)
	func objcSetSelector(_ selector: Selector)
	@objc(methodSignature)
	var objcMethodSignature: AnyObject { get }
	@objc(getArgument:atIndex:)
	func objcCopy(to buffer: UnsafeMutableRawPointer?, forArgumentAt index: Int)
	@objc(invoke)
	func objcInvoke()
	@objc(invocationWithMethodSignature:)
	static func objcInvocation(withMethodSignature signature: AnyObject) -> AnyObject
}
@objc internal protocol ObjCMethodSignature {
	@objc(numberOfArguments)
	var objcNumberOfArguments: UInt { get }
	@objc(getArgumentTypeAtIndex:)
	func objcArgumentType(at index: UInt) -> UnsafePointer<CChar>
	@objc(signatureWithObjCTypes:)
	static func objcSignature(withObjCTypes typeEncoding: UnsafePointer<Int8>) -> AnyObject
}