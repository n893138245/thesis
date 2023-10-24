import Foundation
extension NSObject {
	@nonobjc internal var objcClass: AnyClass {
		return (self as AnyObject).objcClass
	}
}