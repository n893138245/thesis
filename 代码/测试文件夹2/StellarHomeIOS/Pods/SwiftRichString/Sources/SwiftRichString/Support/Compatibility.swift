import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
#if os(OSX)
#if swift(>=4.2)
#else
public typealias NSLineBreakMode = NSParagraphStyle.LineBreakMode
#endif
#endif
func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
#if swift(>=4.2)
#else
extension NSAttributedString {
	public typealias Key = NSAttributedStringKey
}
#endif
#if os(iOS) || os(tvOS) || os(watchOS)
extension NSAttributedString.Key {
	#if swift(>=4.2)
	#else
	static let accessibilitySpeechPunctuation = NSAttributedString.Key(UIAccessibilitySpeechAttributePunctuation)
	static let accessibilitySpeechLanguage = NSAttributedString.Key(UIAccessibilitySpeechAttributeLanguage)
	static let accessibilitySpeechPitch = NSAttributedString.Key(UIAccessibilitySpeechAttributePitch)
	@available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
	static let accessibilitySpeechIPANotation = NSAttributedString.Key(UIAccessibilitySpeechAttributeIPANotation)
	@available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
	static let accessibilitySpeechQueueAnnouncement = NSAttributedString.Key(UIAccessibilitySpeechAttributeQueueAnnouncement)
	@available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
	static let accessibilityTextHeadingLevel = NSAttributedString.Key(UIAccessibilityTextAttributeHeadingLevel)
	#endif
}
#endif