import Foundation
import CoreGraphics
#if os(OSX)
	import AppKit
	public typealias Color = NSColor
	public typealias Image = NSImage
	public typealias Font = NSFont
	public typealias FontDescriptor = NSFontDescriptor
	public typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits
	public typealias LineBreak = NSLineBreakMode
	let FontDescriptorFeatureSettingsAttribute = NSFontDescriptor.AttributeName.featureSettings
	let FontFeatureTypeIdentifierKey = NSFontDescriptor.FeatureKey.typeIdentifier
	let FontFeatureSelectorIdentifierKey = NSFontDescriptor.FeatureKey.selectorIdentifier
#else
	import UIKit
	public typealias Color = UIColor
	public typealias Image = UIImage
	public typealias Font = UIFont
	public typealias FontDescriptor = UIFontDescriptor
	public typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits
	public typealias LineBreak = NSLineBreakMode
	let FontDescriptorFeatureSettingsAttribute = UIFontDescriptor.AttributeName.featureSettings
	let FontFeatureTypeIdentifierKey = UIFontDescriptor.FeatureKey.featureIdentifier
	let FontFeatureSelectorIdentifierKey = UIFontDescriptor.FeatureKey.typeIdentifier
#endif
public enum Kerning {
	case point(CGFloat)
	case adobe(CGFloat)
	public func kerning(for font: Font?) -> CGFloat {
		switch self {
		case .point(let kernValue):
			return kernValue
		case .adobe(let adobeTracking):
			let AdobeTrackingDivisor: CGFloat = 1000.0
			if font == nil {
				print("Missing font for apply tracking; 0 is the fallback.")
			}
			return (font?.pointSize ?? 0) * (adobeTracking / AdobeTrackingDivisor)
		}
	}
}
public enum Ligatures: Int {
	case disabled = 0
	case defaults = 1
	#if os(OSX)
	case all = 2
	#endif
}
public enum HeadingLevel: Int {
	case none = 0
	case one = 1
	case two = 2
	case three = 3
	case four = 4
	case five = 5
	case six = 6
}
public struct TraitVariant: OptionSet {
	public var rawValue: Int
	public static let italic = TraitVariant(rawValue: 1 << 0)
	public static let bold = TraitVariant(rawValue: 1 << 1)
	public static let expanded = TraitVariant(rawValue: 1 << 2)
	public static let condensed = TraitVariant(rawValue: 1 << 3)
	public static let vertical = TraitVariant(rawValue: 1 << 4)
	public static let uiOptimized = TraitVariant(rawValue: 1 << 5)
	public static let tightLineSpacing = TraitVariant(rawValue: 1 << 6)
	public static let looseLineSpacing = TraitVariant(rawValue: 1 << 7)
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}
extension TraitVariant {
	var symbolicTraits: SymbolicTraits {
		var traits: SymbolicTraits = []
		if contains(.italic) {
			traits.insert(SymbolicTraits.italic)
		}
		if contains(.bold) {
			traits.insert(.bold)
		}
		if contains(.expanded) {
			traits.insert(.expanded)
		}
		if contains(.condensed) {
			traits.insert(.condensed)
		}
		if contains(.vertical) {
			traits.insert(.vertical)
		}
		if contains(.uiOptimized) {
			traits.insert(.uiOptimized)
		}
		if contains(.tightLineSpacing) {
			traits.insert(.tightLineSpacing)
		}
		if contains(.looseLineSpacing) {
			traits.insert(.looseLineSpacing)
		}
		return traits
	}
}
extension SymbolicTraits {
	#if os(iOS) || os(tvOS) || os(watchOS)
	static var italic: SymbolicTraits {
		return .traitItalic
	}
	static var bold: SymbolicTraits {
		return .traitBold
	}
	static var expanded: SymbolicTraits {
		return .traitExpanded
	}
	static var condensed: SymbolicTraits {
		return .traitCondensed
	}
	static var vertical: SymbolicTraits {
		return .traitVertical
	}
	static var uiOptimized: SymbolicTraits {
		return .traitUIOptimized
	}
	static var tightLineSpacing: SymbolicTraits {
		return .traitTightLeading
	}
	static var looseLineSpacing: SymbolicTraits {
		return .traitLooseLeading
	}
	#else
	static var uiOptimized: SymbolicTraits {
		return .UIOptimized
	}
	static var tightLineSpacing: SymbolicTraits {
		return .tightLeading
	}
	static var looseLineSpacing: SymbolicTraits {
		return .looseLeading
	}
	#endif
}