import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public protocol FontConvertible {
	func font(size: CGFloat?) -> Font
}
extension Font: FontConvertible {
	public func font(size: CGFloat?) -> Font {
		#if os(tvOS)
		return Font(name: self.fontName, size: (size ?? TVOS_SYSTEMFONT_SIZE))!
		#elseif os(watchOS)
		return Font(name: self.fontName, size: (size ?? WATCHOS_SYSTEMFONT_SIZE))!
		#elseif os(macOS)
		return Font(descriptor: self.fontDescriptor, size: (size ?? Font.systemFontSize))!
		#else
		return Font(descriptor: self.fontDescriptor, size: (size ?? Font.systemFontSize))
		#endif
	}
}
extension String: FontConvertible {
	public func font(size: CGFloat?) -> Font {
		#if os(tvOS)
		return Font(name: self, size:  (size ?? TVOS_SYSTEMFONT_SIZE))!
		#elseif os(watchOS)
		return Font(name: self, size:  (size ?? WATCHOS_SYSTEMFONT_SIZE))!
		#else
		return Font(name: self, size: (size ?? Font.systemFontSize))!
		#endif
	}
}