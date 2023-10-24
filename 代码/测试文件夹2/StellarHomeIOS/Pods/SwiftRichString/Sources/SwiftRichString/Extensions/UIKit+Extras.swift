import Foundation
#if os(iOS) || os(tvOS)
import UIKit
internal enum IBInterfaceKeys: String {
	case styleName = "SwiftRichString.StyleName"
	case styleObj = "SwiftRichString.StyleObj"
}
extension UILabel {
	@IBInspectable
	public var styleName: String? {
		get { return getAssociatedValue(key: IBInterfaceKeys.styleName.rawValue, object: self) }
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleName.rawValue, object: self)
			self.style = StylesManager.shared[newValue]
		}
	}
	public var style: StyleProtocol? {
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleObj.rawValue, object: self)
			self.styledText = self.text
		}
		get {
			if let innerValue: StyleProtocol? = getAssociatedValue(key: IBInterfaceKeys.styleObj.rawValue, object: self) {
				return innerValue
			}
			return StylesManager.shared[self.styleName]
		}
	}
	public var styledText: String? {
		get {
			return attributedText?.string
		}
		set {
			guard let text = newValue else {
                self.attributedText = nil
                return 
            }
            let style = self.style ?? Style()
            self.attributedText = style.set(to: text, range: nil)
		}
	}
}
extension UITextField {
	@IBInspectable
	public var styleName: String? {
		get { return getAssociatedValue(key: IBInterfaceKeys.styleName.rawValue, object: self) }
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleName.rawValue, object: self)
			self.style = StylesManager.shared[newValue]
		}
	}
	public var style: StyleProtocol? {
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleObj.rawValue, object: self)
			self.styledText = self.text
		}
		get {
			if let innerValue: StyleProtocol? = getAssociatedValue(key: IBInterfaceKeys.styleObj.rawValue, object: self) {
				return innerValue
			}
			return StylesManager.shared[self.styleName]
		}
	}
	public var styledText: String? {
		get {
			return attributedText?.string
		}
		set {
			guard let text = newValue else {
                self.attributedText = nil
                return 
            }
            let style = self.style ?? Style()
            self.attributedText = style.set(to: text, range: nil)
		}
	}
}
extension UITextView {
	@IBInspectable
	public var styleName: String? {
		get { return getAssociatedValue(key: IBInterfaceKeys.styleName.rawValue, object: self) }
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleName.rawValue, object: self)
			self.style = StylesManager.shared[newValue]
		}
	}
	public var style: StyleProtocol? {
		set {
			set(associatedValue: newValue, key: IBInterfaceKeys.styleObj.rawValue, object: self)
			self.styledText = self.text
		}
		get {
			if let innerValue: StyleProtocol? = getAssociatedValue(key: IBInterfaceKeys.styleObj.rawValue, object: self) {
				return innerValue
			}
			return StylesManager.shared[self.styleName]
		}
	}
	public var styledText: String? {
		get {
			return attributedText?.string
		}
		set {
			guard let text = newValue else {
                self.attributedText = nil
                return 
            }
            let style = self.style ?? Style()
            self.attributedText = style.set(to: text, range: nil)
		}
	}
}
#endif
#if swift(>=4.1)
#else
extension Collection {
	func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
		return try flatMap(transform)
	}
}
#endif