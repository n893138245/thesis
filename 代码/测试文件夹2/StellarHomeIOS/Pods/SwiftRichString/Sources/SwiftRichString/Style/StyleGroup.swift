import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public class StyleGroup: StyleProtocol {
    public var attributes: [NSAttributedString.Key : Any] = [:]
    public var fontData: FontData? = nil
    public var textTransforms: [TextTransform]? = nil
    public private(set) var styles: [String : StyleProtocol]
    public var baseStyle: StyleProtocol?
    public var xmlParsingOptions: XMLParsingOptions = []
    public var xmlAttributesResolver: XMLDynamicAttributesResolver = StandardXMLAttributesResolver()
    public init(base: StyleProtocol? = nil, _ styles: [String: StyleProtocol]) {
        self.styles = styles
        self.baseStyle = base
    }
    public func add(style: Style, as name: String) {
        return self.styles[name] = style
    }
    @discardableResult
    public func remove(style name: String) -> StyleProtocol? {
        return styles.removeValue(forKey: name)
    }
    public func set(to source: String, range: NSRange?) -> AttributedString {
        let attributed = NSMutableAttributedString(string: source)
        return self.apply(to: attributed, adding: true, range: range)
    }
    public func add(to source: AttributedString, range: NSRange?) -> AttributedString {
        return self.apply(to: source, adding: true, range: range)
    }
    public func set(to source: AttributedString, range: NSRange?) -> AttributedString {
        return self.apply(to: source, adding: false, range: range)
    }
    public func apply(to attrStr: AttributedString, adding: Bool, range: NSRange?) -> AttributedString {
        do {
            let xmlParser = XMLStringBuilder(string: attrStr.string, options: xmlParsingOptions,
                                       baseStyle: baseStyle, styles: styles,
                                       xmlAttributesResolver: xmlAttributesResolver)
            return try xmlParser.parse()
        } catch {
            debugPrint("Failed to generate attributed string from xml: \(error)")
            return attrStr
        }
    }
}