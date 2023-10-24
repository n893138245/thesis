import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public class StyleRegEx: StyleProtocol {
	public private(set) var regex: NSRegularExpression
	public private(set) var baseStyle: StyleProtocol?
	private var style: StyleProtocol
	public var attributes: [NSAttributedString.Key : Any] {
		return self.style.attributes
	}
    public var textTransforms: [TextTransform]?
	public var fontData: FontData? {
		return self.style.fontData
	}
	public init?(base: StyleProtocol? = nil,
				 pattern: String, options: NSRegularExpression.Options = .caseInsensitive,
				 handler: @escaping Style.StyleInitHandler) {
		do {
			self.regex = try NSRegularExpression(pattern: pattern, options: options)
			self.baseStyle = base
			self.style = Style(handler)
		} catch {
			return nil
		}
	}
	public func set(to source: String, range: NSRange?) -> AttributedString {
		let attributed = NSMutableAttributedString(string: source, attributes: (self.baseStyle?.attributes ?? [:]))
		return self.applyStyle(to: attributed, add: false, range: range)
	}
	public func add(to source: AttributedString, range: NSRange?) -> AttributedString {
		if let base = self.baseStyle {
			source.addAttributes(base.attributes, range: (range ?? NSMakeRange(0, source.length)))
		}
		return self.applyStyle(to: source, add: true, range: range)
	}
	public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
		if let base = self.baseStyle {
			source.setAttributes(base.attributes, range: (range ?? NSMakeRange(0, source.length)))
		}
		return self.applyStyle(to: source, add: false, range: range)
	}
	private func applyStyle(to str: AttributedString, add: Bool, range: NSRange?) -> AttributedString {
		let rangeValue = (range ?? NSMakeRange(0, str.length))
		let matchOpts = NSRegularExpression.MatchingOptions(rawValue: 0)
		self.regex.enumerateMatches(in: str.string, options: matchOpts, range: rangeValue) {
			(result : NSTextCheckingResult?, _, _) in
			if let r = result {
				if add {
					str.addAttributes(self.attributes, range: r.range)
				} else {
					str.setAttributes(self.attributes, range: r.range)
				}
			}
		}
		return str
	}
}