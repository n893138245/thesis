import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif
public protocol XMLDynamicAttributesResolver {
    func applyDynamicAttributes(to attributedString: inout AttributedString, xmlStyle: XMLDynamicStyle)
    func styleForUnknownXMLTag(_ tag: String, to attributedString: inout AttributedString, attributes: [String: String]?)
}
open class StandardXMLAttributesResolver: XMLDynamicAttributesResolver {
    public func applyDynamicAttributes(to attributedString: inout AttributedString, xmlStyle: XMLDynamicStyle) {
        let finalStyleToApply = Style()
        xmlStyle.enumerateAttributes { key, value  in
            switch key {
                case "color": 
                    finalStyleToApply.color = Color(hexString: value)
                default:
                    break
            }
        }
        attributedString.add(style: finalStyleToApply)
    }
    public func styleForUnknownXMLTag(_ tag: String, to attributedString: inout AttributedString, attributes: [String: String]?) {
        let finalStyleToApply = Style()
        switch tag {
            case "a": 
                finalStyleToApply.linkURL = URL(string: attributes?["href"])
            case "img":
                #if os(iOS)
                if let url = attributes?["url"] {
                    if let image = AttributedString(imageURL: url, bounds: attributes?["rect"]) {
                        attributedString.append(image)
                    }
                }
                #endif
                #if os(iOS) || os(OSX)
                if let imageName = attributes?["named"] {
                    if let image = AttributedString(imageNamed: imageName, bounds: attributes?["rect"]) {
                        attributedString.append(image)
                    }
                }
                #endif
            default:
                break
        }
        attributedString.add(style: finalStyleToApply)
    }
}