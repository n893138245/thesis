import Foundation
public struct XMLStringBuilderError: Error {
    public let parserError: Error
    public let line: Int
    public let column: Int
}
public struct XMLParsingOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let doNotWrapXML = XMLParsingOptions(rawValue: 1)
}
public class XMLStringBuilder: NSObject, XMLParserDelegate {
    private static let topTag = "source"
    private var xmlParser: XMLParser
    private var options: XMLParsingOptions
    private var attributedString: AttributedString
    private var baseStyle: StyleProtocol?
    private var styles: [String: StyleProtocol]
    private var xmlStylers = [XMLDynamicStyle]()
    public var xmlAttributesResolver: XMLDynamicAttributesResolver
    var currentString: String?
    public init(string: String, options: XMLParsingOptions,
                baseStyle: StyleProtocol?, styles: [String: StyleProtocol],
                xmlAttributesResolver: XMLDynamicAttributesResolver) {
        let xml = (options.contains(.doNotWrapXML) ? string : "<\(XMLStringBuilder.topTag)>\(string)</\(XMLStringBuilder.topTag)>")
        guard let data = xml.data(using: String.Encoding.utf8) else {
            fatalError("Unable to convert to UTF8")
        }
        self.options = options
        self.attributedString = NSMutableAttributedString()
        self.xmlAttributesResolver = xmlAttributesResolver
        self.xmlParser = XMLParser(data: data)
        self.baseStyle = baseStyle
        self.styles = styles
        if let baseStyle = baseStyle {
            self.xmlStylers.append( XMLDynamicStyle(tag: XMLStringBuilder.topTag, style: baseStyle) )
        }
        super.init()
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.delegate = self
    }
    public func parse() throws -> AttributedString {
        guard xmlParser.parse() else {
            let line = xmlParser.lineNumber
            let shiftColumn = (line == 1 && options.contains(.doNotWrapXML) == false)
            let shiftSize = XMLStringBuilder.topTag.lengthOfBytes(using: String.Encoding.utf8) + 2
            let column = xmlParser.columnNumber - (shiftColumn ? shiftSize : 0)
            throw XMLStringBuilderError(parserError: xmlParser.parserError!, line: line, column: column)
        }
        return attributedString
    }
    @objc public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        foundNewString()
        enter(element: elementName, attributes: attributeDict)
    }
    @objc public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        foundNewString()
        guard elementName != XMLStringBuilder.topTag else {
            return
        }
        exit(element: elementName)
    }
    @objc public func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString = (currentString ?? "").appending(string)
    }
    func enter(element elementName: String, attributes: [String: String]) {
        guard elementName != XMLStringBuilder.topTag else {
            return
        }
        if elementName != XMLStringBuilder.topTag {
            xmlStylers.append( XMLDynamicStyle(tag: elementName, style: styles[elementName], xmlAttributes: attributes) )
        }
    }
    func exit(element elementName: String) {
        xmlStylers.removeLast()
    }
    func foundNewString() {
        var newAttributedString = AttributedString(string: currentString ?? "")
        for xmlStyle in xmlStylers {
            if let style = xmlStyle.style {
                newAttributedString = newAttributedString.add(style: style)
                if xmlStyle.xmlAttributes != nil {
                    xmlAttributesResolver.applyDynamicAttributes(to: &newAttributedString, xmlStyle: xmlStyle)
                }
            } else {
                xmlAttributesResolver.styleForUnknownXMLTag(xmlStyle.tag, to: &newAttributedString, attributes: xmlStyle.xmlAttributes)
            }
        }
        attributedString.append(newAttributedString)
        currentString = nil
    }
}
public class XMLDynamicStyle {
    public let tag: String
    public let style: StyleProtocol?
    public let xmlAttributes: [String: String]?
    internal init(tag: String, style: StyleProtocol?, xmlAttributes: [String: String]? = nil) {
        self.tag = tag
        self.style = style
        self.xmlAttributes = ((xmlAttributes?.keys.isEmpty ?? true) == false ? xmlAttributes : nil)
    }
    public func enumerateAttributes(_ handler: ((_ key: String, _ value: String) -> Void)) {
        guard let xmlAttributes = xmlAttributes else {
            return
        }
        xmlAttributes.keys.forEach {
            handler($0, xmlAttributes[$0]!)
        }
    }
}