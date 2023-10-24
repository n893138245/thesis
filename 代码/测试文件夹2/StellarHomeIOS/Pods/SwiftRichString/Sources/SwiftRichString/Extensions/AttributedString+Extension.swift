import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public extension AttributedString {
	@discardableResult
	func add(style: String, range: NSRange? = nil) -> AttributedString {
		guard let style = Styles[style] else { return self }
		return style.add(to: self, range: range)
	}
	@discardableResult
	func add(styles: [String], range: NSRange? = nil) -> AttributedString {
		guard let styles = Styles[styles] else { return self }
		return styles.mergeStyle().set(to: self, range: range)
	}
	@discardableResult
	func set(style: String, range: NSRange? = nil) -> AttributedString {
		guard let style = Styles[style] else { return self }
		return style.set(to: self, range: range)
	}
	@discardableResult
	func set(styles: [String], range: NSRange? = nil) -> AttributedString {
		guard let styles = Styles[styles] else { return self }
		return styles.mergeStyle().set(to: self, range: range)
	}
	@discardableResult
	func add(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
		return style.add(to: self, range: range)
	}
	@discardableResult
	func add(styles: [StyleProtocol], range: NSRange? = nil) -> AttributedString {
		return styles.mergeStyle().add(to: self, range: range)
	}
	@discardableResult
	func set(style: StyleProtocol, range: NSRange? = nil) -> AttributedString {
		return style.set(to: self, range: range)
	}
	@discardableResult
	func set(styles: [StyleProtocol], range: NSRange? = nil) -> AttributedString {
		return styles.mergeStyle().set(to: self, range: range)
	}
	@discardableResult
	func removeAttributes(_ keys: [NSAttributedString.Key], range: NSRange) -> Self {
		keys.forEach { self.removeAttribute($0, range: range) }
		return self
	}
	func remove(_ style: StyleProtocol) -> Self {
		self.removeAttributes(Array(style.attributes.keys), range: NSMakeRange(0, self.length))
		return self
	}
}
public func + (lhs: AttributedString, rhs: AttributedString) -> AttributedString {
	let final = NSMutableAttributedString(attributedString: lhs)
	final.append(rhs)
	return final
}
public func + (lhs: String, rhs: AttributedString) -> AttributedString {
	let final = NSMutableAttributedString(string: lhs)
	final.append(rhs)
	return final
}
public func + (lhs: AttributedString, rhs: String) -> AttributedString {
	let final = NSMutableAttributedString(attributedString: lhs)
	final.append(NSMutableAttributedString(string: rhs))
	return final
}