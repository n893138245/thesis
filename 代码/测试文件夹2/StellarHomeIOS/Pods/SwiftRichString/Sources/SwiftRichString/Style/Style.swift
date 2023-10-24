import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public class Style: StyleProtocol {
	public typealias StyleInitHandler = ((Style) -> (Void))
	public var fontData: FontData? = FontData()
	private var innerAttributes: [NSAttributedString.Key : Any] = [:]
	private var cachedAttributes: [NSAttributedString.Key : Any]? = nil
    public var textTransforms: [TextTransform]?
	public var size: CGFloat? {
		set {
			self.fontData?.size = newValue
			self.invalidateCache()
		}
		get {
			return self.fontData?.size
		}
	}
	public var font: FontConvertible? {
		set {
			self.fontData?.font = newValue
			if let f = newValue as? Font {
				self.fontData?.size = f.pointSize
			}
			self.invalidateCache()
		}
		get {
			return self.fontData?.font
		}
	}
	#if os(tvOS) || os(watchOS) || os(iOS)
    @available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
    public var dynamicText: DynamicText? {
        set { self.fontData?.dynamicText = newValue }
        get { return self.fontData?.dynamicText }
    }
	#endif
	public var color: ColorConvertible? {
		set { self.set(attribute: newValue?.color, forKey: .foregroundColor) }
		get { return self.get(attributeForKey: .foregroundColor) }
	}
	public var backColor: ColorConvertible? {
		set { self.set(attribute: newValue?.color, forKey: .backgroundColor) }
		get { return self.get(attributeForKey: .backgroundColor) }
	}
	public var underline: (style: NSUnderlineStyle?, color: ColorConvertible?)? {
		set {
			self.set(attribute: NSNumber.from(underlineStyle: newValue?.style), forKey: .underlineStyle)
			self.set(attribute: newValue?.color?.color, forKey: .underlineColor)
		}
		get {
			let style: NSNumber? = self.get(attributeForKey: .underlineStyle)
			let color: Color? = self.get(attributeForKey: .underlineColor)
			return (style?.toUnderlineStyle(),color)
		}
	}
	public var stroke: (color: ColorConvertible?, width: Float?)? {
		set {
			self.set(attribute: newValue?.color?.color, forKey: .strokeColor)
			self.set(attribute: NSNumber.from(float: newValue?.width), forKey: .strokeWidth)
		}
		get {
			let color: Color? = self.get(attributeForKey: .strokeColor)
			let width: NSNumber? = self.get(attributeForKey: .strokeWidth)
			return (color,width?.floatValue)
		}
	}
	public var strikethrough: (style: NSUnderlineStyle?, color: ColorConvertible?)? {
		set {
			self.set(attribute: NSNumber.from(underlineStyle: newValue?.style), forKey: .strikethroughStyle)
			self.set(attribute: newValue?.color?.color, forKey: .strikethroughColor)
		}
		get {
			let style: NSNumber? = self.get(attributeForKey: .strikethroughStyle)
			let color: Color? = self.get(attributeForKey: .strikethroughColor)
			return (style?.toUnderlineStyle(),color)
		}
	}
	public var baselineOffset: Float? {
		set { self.set(attribute: NSNumber.from(float: newValue), forKey: .baselineOffset) }
		get {
			let value: NSNumber? = self.get(attributeForKey: .baselineOffset)
			return value?.floatValue
		}
	}
	public var paragraph: NSMutableParagraphStyle {
		set {
			self.invalidateCache()
			self.set(attribute: newValue, forKey: .paragraphStyle)
		}
		get {
			if let paragraph: NSMutableParagraphStyle = self.get(attributeForKey: .paragraphStyle) {
				return paragraph
			}
			let paragraph = NSMutableParagraphStyle()
			self.set(attribute: paragraph, forKey: .paragraphStyle)
			return paragraph
		}
	}
	public var lineSpacing: CGFloat {
		set { self.paragraph.lineSpacing = newValue }
		get { return self.paragraph.lineSpacing }
	}
	public var paragraphSpacingBefore: CGFloat {
		set { self.paragraph.paragraphSpacingBefore = newValue }
		get { return self.paragraph.paragraphSpacingBefore }
	}
	public var paragraphSpacingAfter: CGFloat {
		set { self.paragraph.paragraphSpacing = newValue }
		get { return self.paragraph.paragraphSpacing }
	}
	public var alignment: NSTextAlignment {
		set { self.paragraph.alignment = newValue }
		get { return self.paragraph.alignment }
	}
	public var firstLineHeadIndent: CGFloat {
		set { self.paragraph.firstLineHeadIndent = newValue }
		get { return self.paragraph.firstLineHeadIndent }
	}
	public var headIndent: CGFloat {
		set { self.paragraph.headIndent = newValue }
		get { return self.paragraph.headIndent }
	}
	public var tailIndent: CGFloat {
		set { self.paragraph.tailIndent = newValue }
		get { return self.paragraph.tailIndent }
	}
	public var lineBreakMode: LineBreak {
		set { self.paragraph.lineBreakMode = newValue }
		get { return self.paragraph.lineBreakMode }
	}
	public var minimumLineHeight: CGFloat {
		set { self.paragraph.minimumLineHeight = newValue }
		get { return self.paragraph.minimumLineHeight }
	}
	public var maximumLineHeight: CGFloat {
		set { self.paragraph.maximumLineHeight = newValue }
		get { return self.paragraph.maximumLineHeight }
	}
	public var baseWritingDirection: NSWritingDirection {
		set { self.paragraph.baseWritingDirection = newValue }
		get { return self.paragraph.baseWritingDirection }
	}
	public var lineHeightMultiple: CGFloat {
		set { self.paragraph.lineHeightMultiple = newValue }
		get { return self.paragraph.lineHeightMultiple }
	}
	public var hyphenationFactor: Float {
		set { self.paragraph.hyphenationFactor = newValue }
		get { return self.paragraph.hyphenationFactor }
	}
	public var ligatures: Ligatures? {
		set {
			self.set(attribute: NSNumber.from(int: newValue?.rawValue), forKey: .ligature)
		}
		get {
			guard let value: NSNumber = self.get(attributeForKey: .ligature) else { return nil }
			return Ligatures(rawValue: value.intValue)
		}
	}
	#if os(iOS) || os(tvOS) || os(macOS)
	public var shadow: NSShadow? {
		set {
			self.set(attribute: newValue, forKey: .shadow)
		}
		get {
			return self.get(attributeForKey: .shadow)
		}
	}
	#endif
	#if os(iOS) || os(tvOS) || os(watchOS)
	public var speaksPunctuation: Bool? {
		set { self.set(attribute: newValue, forKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechPunctuation))) }
		get { return self.get(attributeForKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechPunctuation))) }
	}
	public var speakingLanguage: String? {
		set { self.set(attribute: newValue, forKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechLanguage))) }
		get { return self.get(attributeForKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechLanguage))) }
	}
	public var speakingPitch: Double? {
		set { self.set(attribute: newValue, forKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechPitch))) }
		get { return self.get(attributeForKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechPitch))) }
	}
	@available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
	public var speakingPronunciation: String? {
		set { self.set(attribute: newValue, forKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechIPANotation))) }
		get { return self.get(attributeForKey: NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechIPANotation))) }
	}
	@available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
	public var shouldQueueSpeechAnnouncement: Bool? {
		set {
			let key = NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechQueueAnnouncement))
			guard let v = newValue else {
				self.innerAttributes.removeValue(forKey: key)
				return
			}
			self.set(attribute: NSNumber.init(value: v), forKey: key)
		}
		get {
			let key = NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilitySpeechQueueAnnouncement))
			if let n: NSNumber = self.get(attributeForKey: key) {
				return n.boolValue
			} else { return false }
		}
	}
	@available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
	public var headingLevel: HeadingLevel? {
		set {
			let key = NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilityTextHeadingLevel))
			guard let v = newValue else {
				self.innerAttributes.removeValue(forKey: key)
				return
			}
			self.set(attribute: v.rawValue, forKey: key)
		}
		get {
			let key = NSAttributedString.Key(convertFromNSAttributedStringKey(NSAttributedString.Key.accessibilityTextHeadingLevel))
			if let n: Int = self.get(attributeForKey: key) {
				return HeadingLevel(rawValue: n)
			} else { return nil }
		}
	}
	#endif
	public var linkURL: URLRepresentable? {
		set { self.set(attribute: newValue, forKey: .link) }
		get { return self.get(attributeForKey: .link) }
	}
	#if os(OSX) || os(iOS) || os(tvOS)
	public var numberCase: NumberCase? {
		set { self.fontData?.numberCase = newValue }
		get { return self.fontData?.numberCase }
	}
	public var numberSpacing: NumberSpacing? {
		set { self.fontData?.numberSpacing = newValue }
		get { return self.fontData?.numberSpacing }
	}
	public var fractions: Fractions? {
		set { self.fontData?.fractions = newValue }
		get { return self.fontData?.fractions }
	}
	public var superscript: Bool? {
		set { self.fontData?.superscript = newValue }
		get { return self.fontData?.superscript }
	}
	public var `subscript`: Bool? {
		set { self.fontData?.subscript = newValue }
		get { return self.fontData?.subscript }
	}
	public var ordinals: Bool? {
		set { self.fontData?.ordinals = newValue }
		get { return self.fontData?.ordinals }
	}
	public var scientificInferiors: Bool? {
		set { self.fontData?.scientificInferiors = newValue }
		get { return self.fontData?.scientificInferiors }
	}
	public var smallCaps: Set<SmallCaps> {
		set { self.fontData?.smallCaps = newValue }
		get { return self.fontData?.smallCaps ?? Set() }
	}
	public var stylisticAlternates: StylisticAlternates {
		set { self.fontData?.stylisticAlternates = newValue }
		get { return self.fontData?.stylisticAlternates ?? StylisticAlternates() }
	}
	public var contextualAlternates: ContextualAlternates {
		set { self.fontData?.contextualAlternates = newValue }
		get { return self.fontData?.contextualAlternates ?? ContextualAlternates() }
	}
	public var kerning: Kerning? {
		set { self.fontData?.kerning = newValue }
		get { return self.fontData?.kerning }
	}
	public var traitVariants: TraitVariant? {
		set { self.fontData?.traitVariants = newValue }
		get { return self.fontData?.traitVariants }
	}
	#endif
	public init(_ handler: StyleInitHandler? = nil) {
		self.fontData?.style = self
		handler?(self)
	}
    public init(dictionary: [NSAttributedString.Key: Any]?, textTransforms: [TextTransform]? = nil) {
		self.fontData?.style = self
		if let font = dictionary?[.font] as? Font {
			self.fontData?.font = font
			self.fontData?.size = font.pointSize
		}
		self.innerAttributes = (dictionary ?? [:])
        self.textTransforms = textTransforms
	}
	public init(style: Style) {
		self.fontData?.style = self
		self.innerAttributes = style.innerAttributes
		self.fontData = style.fontData
	}
	internal func invalidateCache() {
		self.cachedAttributes = nil
	}
	public func set<T>(attribute value: T?, forKey key: NSAttributedString.Key) {
		guard let value = value else {
			self.innerAttributes.removeValue(forKey: key)
			return
		}
		self.innerAttributes[key] = value
		self.invalidateCache()
	}
	public func get<T>(attributeForKey key: NSAttributedString.Key) -> T? {
		return (self.innerAttributes[key] as? T)
	}
	public var attributes: [NSAttributedString.Key : Any] {
		if let cachedAttributes = self.cachedAttributes {
			return cachedAttributes
		}
		let fontAttributes = self.fontData?.attributes ?? [:]
		self.cachedAttributes = self.innerAttributes.merging(fontAttributes) { (_, new) in return new }
		return self.cachedAttributes!
	}
	public func byAdding(_ handler: StyleInitHandler) -> Style {
		let styleCopy = Style(style: self)
		handler(styleCopy)
		return styleCopy
	}
}