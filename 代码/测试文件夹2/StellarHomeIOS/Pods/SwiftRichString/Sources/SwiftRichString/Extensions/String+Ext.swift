import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public extension String {
	func set(style: String, range: NSRange? = nil) -> AttributedString? {
		return StylesManager.shared[style]?.set(to: self, range: range)
	}
	func set(styles: [String], range: NSRange? = nil) -> AttributedString? {
		return StylesManager.shared[styles]?.mergeStyle().set(to: self, range: range)
	}
	func set(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
		return style.set(to: self, range: range)
	}
	func set(styles: [StyleProtocol], range: NSRange? = nil) -> AttributedString {
		return styles.mergeStyle().set(to: self, range: range)
	}
}
public func + (lhs: String, rhs: StyleProtocol) -> AttributedString {
	return rhs.set(to: lhs, range: nil)
}