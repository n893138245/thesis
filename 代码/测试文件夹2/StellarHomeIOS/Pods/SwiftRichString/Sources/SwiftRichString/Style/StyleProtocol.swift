import Foundation
public typealias AttributedString = NSMutableAttributedString
public protocol StyleProtocol: class {
	var attributes: [NSAttributedString.Key : Any] { get }
	var fontData: FontData? { get }
    var textTransforms: [TextTransform]? { get }
	func set(to source: String, range: NSRange?) -> AttributedString
	func add(to source: AttributedString, range: NSRange?) -> AttributedString
	@discardableResult
	func set(to source: AttributedString, range: NSRange?) -> AttributedString
	@discardableResult
	func remove(from source: AttributedString, range: NSRange?) -> AttributedString
}
public extension StyleProtocol {
	func set(to source: String, range: NSRange?) -> AttributedString {
		let attributedText = NSMutableAttributedString(string: source)
		self.fontData?.addAttributes(to: attributedText, range: nil)
		attributedText.addAttributes(self.attributes, range: (range ?? NSMakeRange(0, attributedText.length)))
        return applyTextTransform(self.textTransforms, to: attributedText)
	}
	func add(to source: AttributedString, range: NSRange?) -> AttributedString {
		self.fontData?.addAttributes(to: source, range: range)
		source.addAttributes(self.attributes, range: (range ?? NSMakeRange(0, source.length)))
        return applyTextTransform(self.textTransforms, to: source)
	}
	@discardableResult
	func set(to source: AttributedString, range: NSRange?) -> AttributedString {
		self.fontData?.addAttributes(to: source, range: range)
		source.addAttributes(self.attributes, range: (range ?? NSMakeRange(0, source.length)))
        return applyTextTransform(self.textTransforms, to: source)
	}
	@discardableResult
	func remove(from source: AttributedString, range: NSRange?) -> AttributedString {
		self.attributes.keys.forEach({
			source.removeAttribute($0, range: (range ?? NSMakeRange(0, source.length)))
		})
        return applyTextTransform(self.textTransforms, to: source)
	}
    private func applyTextTransform(_ transforms: [TextTransform]?, to string: AttributedString) -> AttributedString {
        guard let transforms = self.textTransforms else {
            return string
        }
        let mutable = string.mutableStringCopy()
        let fullRange = NSRange(location: 0, length: mutable.length)
        mutable.enumerateAttributes(in: fullRange, options: [], using: { (_, range, _) in
            var substring = mutable.attributedSubstring(from: range).string
            transforms.forEach {
                substring = $0.transformer(substring)
            }
            mutable.replaceCharacters(in: range, with: substring)
        })
        return mutable
    }
}