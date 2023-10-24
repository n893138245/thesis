import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
extension NSNumber {
	internal static func from(float: Float?) -> NSNumber? {
		guard let float = float else { return nil }
		return NSNumber(value: float)
	}
	internal static func from(int: Int?) -> NSNumber? {
		guard let int = int else { return nil }
		return NSNumber(value: int)
	}
	internal static func from(underlineStyle: NSUnderlineStyle?) -> NSNumber? {
		guard let v = underlineStyle?.rawValue else { return nil }
		return NSNumber(value: v)
	}
	internal func toUnderlineStyle() -> NSUnderlineStyle? {
		return NSUnderlineStyle.init(rawValue: self.intValue)
	}
}
extension NSAttributedString {
    @nonobjc func mutableStringCopy() -> NSMutableAttributedString {
        guard let copy = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Failed to mutableCopy() \(self)")
        }
        return copy
    }
}
public extension Array where Array.Element == StyleProtocol {
    func mergeStyle() -> Style {
        var attributes: [NSAttributedString.Key:Any] = [:]
        var textTransforms = [TextTransform]()
        self.forEach {
            attributes.merge($0.attributes, uniquingKeysWith: {
                (_, new) in
                return new
            })
            textTransforms.append(contentsOf: $0.textTransforms ?? [])
        }
        return Style(dictionary: attributes, textTransforms: (textTransforms.isEmpty ? nil : textTransforms))
    }
}
extension CGRect {
    init?(string: String?) {
        guard let string = string else {
            return nil
        }
        let components: [CGFloat] = string.components(separatedBy: ",").compactMap {
            guard let value = Float($0) else { return nil }
            return CGFloat(value)
        }
        guard components.count == 4 else {
            return nil
        }
        self =  CGRect(x: components[0],
                      y: components[1],
                      width: components[2],
                      height: components[3])
    }
}
#if os(OSX)
public extension NSImage {
    func pngData() -> Data? {
        self.lockFocus()
        let bitmap = NSBitmapImageRep(focusedViewRect: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        let pngData = bitmap!.representation(using: .png, properties: [:])
        self.unlockFocus()
        return pngData
    }
}
#endif