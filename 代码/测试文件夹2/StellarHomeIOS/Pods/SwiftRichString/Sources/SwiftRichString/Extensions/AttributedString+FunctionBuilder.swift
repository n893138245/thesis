import Foundation
@_functionBuilder
public class AttributedStringBuilder {
    public static func buildBlock(_ components: AttributedString...) -> AttributedString {
        let result = NSMutableAttributedString(string: "")
        return components.reduce(into: result) { (result, current) in result.append(current) }
    }
}
extension AttributedString {
    public class func composing(@AttributedStringBuilder _ parts: () -> AttributedString) -> AttributedString {
        return parts()
    }
}