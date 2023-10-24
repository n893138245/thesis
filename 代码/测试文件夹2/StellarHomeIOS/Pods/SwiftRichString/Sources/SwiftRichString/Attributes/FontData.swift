import Foundation
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
internal let TVOS_SYSTEMFONT_SIZE: CGFloat = 29.0
internal let WATCHOS_SYSTEMFONT_SIZE: CGFloat = 12.0
public struct FontData {
	private static var DefaultFont = Font.systemFont(ofSize: 12.0)
	var font: FontConvertible? { didSet { self.style?.invalidateCache() } }
	#if os(tvOS) || os(watchOS) || os(iOS)
    public var dynamicText: DynamicText? { didSet { self.style?.invalidateCache() } }
    private var adpatsToDynamicType: Bool? { return dynamicText != nil }
	#endif
	var size: CGFloat? { didSet { self.style?.invalidateCache() } }
	#if os(OSX) || os(iOS) || os(tvOS)
	var numberCase: NumberCase? { didSet { self.style?.invalidateCache() } }
	var numberSpacing: NumberSpacing? { didSet { self.style?.invalidateCache() } }
	var fractions: Fractions? { didSet { self.style?.invalidateCache() } }
	var superscript: Bool? { didSet { self.style?.invalidateCache() } }
	var `subscript`: Bool? { didSet { self.style?.invalidateCache() } }
	var ordinals: Bool? { didSet { self.style?.invalidateCache() } }
	var scientificInferiors: Bool? { didSet { self.style?.invalidateCache() } }
	var smallCaps: Set<SmallCaps> = [] { didSet { self.style?.invalidateCache() } }
	var stylisticAlternates: StylisticAlternates = StylisticAlternates() { didSet { self.style?.invalidateCache() } }
	var contextualAlternates: ContextualAlternates = ContextualAlternates() { didSet { self.style?.invalidateCache() } }
	var traitVariants: TraitVariant? { didSet { self.style?.invalidateCache() } }
	var kerning: Kerning? { didSet { self.style?.invalidateCache() } }
	#endif
	weak var style: Style?
	init() {
		self.font = nil
		self.size = nil
	}
	var explicitFont: Bool {
		return (self.font != nil || self.size != nil)
	}
	var attributes: [NSAttributedString.Key:Any] {
		guard self.explicitFont == true else {
			return [:]
		}
		return attributes(currentFont: self.font, size: self.size)
	}
	internal func addAttributes(to source: AttributedString, range: NSRange?) {
		guard self.explicitFont else {
			return
		}
		let scanRange = (range ?? NSMakeRange(0, source.length))
		source.enumerateAttribute(.font, in: scanRange, options: []) { (fontValue, fontRange, shouldStop) in
			let currentFont = ((fontValue ?? FontData.DefaultFont) as? FontConvertible)
			let currentSize = (fontValue as? Font)?.pointSize
			let fontAttributes = self.attributes(currentFont: currentFont, size: currentSize)
			source.addAttributes(fontAttributes, range: fontRange)
		}
	}
	public func attributes(currentFont: FontConvertible?, size currentSize: CGFloat?) -> [NSAttributedString.Key:Any] {
		var finalAttributes: [NSAttributedString.Key:Any] = [:]
		guard let size = (self.size ?? currentSize) else { return [:] }
		guard var finalFont = (self.font ?? currentFont)?.font(size: size) else { return [:] }
		#if os(iOS) || os(tvOS) || os(OSX)
		var attributes: [FontInfoAttribute] = []
        attributes += [self.numberCase].compactMap { $0 }
        attributes += [self.numberSpacing].compactMap { $0 }
		attributes += [self.fractions].compactMap { $0 }
		attributes += [self.superscript].compactMap { $0 }.map { ($0 == true ? VerticalPosition.superscript : VerticalPosition.normal) } as [FontInfoAttribute]
		attributes += [self.subscript].compactMap { $0 }.map { ($0 ? VerticalPosition.`subscript` : VerticalPosition.normal) } as [FontInfoAttribute]
		attributes += [self.ordinals].compactMap { $0 }.map { $0 ? VerticalPosition.ordinals : VerticalPosition.normal } as [FontInfoAttribute]
		attributes += [self.scientificInferiors].compactMap { $0 }.map { $0 ? VerticalPosition.scientificInferiors : VerticalPosition.normal } as [FontInfoAttribute]
		attributes += self.smallCaps.map { $0 as FontInfoAttribute }
		attributes += [self.stylisticAlternates as FontInfoAttribute]
		attributes += [self.contextualAlternates as FontInfoAttribute]
		finalFont = finalFont.withAttributes(attributes)
		if let traitVariants = self.traitVariants { 
			let descriptor = finalFont.fontDescriptor
			let existingTraits = descriptor.symbolicTraits
			let newTraits = existingTraits.union(traitVariants.symbolicTraits)
			let newDescriptor: FontDescriptor? = descriptor.withSymbolicTraits(newTraits)
			if let newDesciptor = newDescriptor {
				#if os(OSX)
				finalFont = Font(descriptor: newDesciptor, size: 0)!
				#else
				finalFont = Font(descriptor: newDesciptor, size: 0)
				#endif
			}
		}
		if let tracking = self.kerning { 
			finalAttributes[.kern] = tracking.kerning(for: finalFont)
		}
		#endif
		#if os(tvOS) || os(watchOS) || os(iOS)
        if #available(iOS 11.0, watchOS 4.0, tvOS 11.0, *), adpatsToDynamicType == true {
            finalAttributes[.font] = scalableFont(from: finalFont)
        } else {
            finalAttributes[.font] = finalFont
        }
		#else
		finalAttributes[.font] = finalFont
		#endif
		return finalAttributes
	}
	#if os(tvOS) || os(watchOS) || os(iOS)
    @available(iOS 11.0, tvOS 11.0, iOSApplicationExtension 11.0, watchOS 4, *)
    private func scalableFont(from font: Font) -> Font {
        var fontMetrics: UIFontMetrics?
        if let textStyle = dynamicText?.style {
            fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        }
        #if os(OSX) || os(iOS) || os(tvOS)
        return (fontMetrics ?? UIFontMetrics.default).scaledFont(for: font, maximumPointSize: dynamicText?.maximumSize ?? 0.0, compatibleWith: dynamicText?.traitCollection)
        #else
        return (fontMetrics ?? UIFontMetrics.default).scaledFont(for: font, maximumPointSize: dynamicText?.maximumSize ?? 0.0)
        #endif
    }
	#endif
}