import Foundation
internal func class_getImmediateMethod(_ `class`: AnyClass, _ selector: Selector) -> Method? {
	var total: UInt32 = 0
	if let methods = class_copyMethodList(`class`, &total) {
		defer { free(methods) }
		for index in 0 ..< Int(total) {
			let method = methods[index]
			if method_getName(method) == selector {
				return method
			}
		}
	}
	return nil
}