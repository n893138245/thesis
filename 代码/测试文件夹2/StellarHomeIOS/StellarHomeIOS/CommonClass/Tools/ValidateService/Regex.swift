import Foundation
public struct Regex {
    private let regularExpression: NSRegularExpression
    public init(_ pattern: String, options: Options = []) throws {
        regularExpression = try NSRegularExpression(
            pattern: pattern,
            options: options.toNSRegularExpressionOptions
        )
    }
    public func matches(_ string: String) -> Bool {
        return firstMatch(in: string) != nil
    }
    public func firstMatch(in string: String) -> Match? {
        let firstMatch = regularExpression
            .firstMatch(in: string, options: [],
                        range: NSRange(location: 0, length: string.utf16.count))
            .map { Match(result: $0, in: string) }
        return firstMatch
    }
    public func matches(in string: String) -> [Match] {
        let matches = regularExpression
            .matches(in: string, options: [],
                     range: NSRange(location: 0, length: string.utf16.count))
            .map { Match(result: $0, in: string) }
        return matches
    }
    public func replacingMatches(in input: String, with template: String,
                                 count: Int? = nil) -> String {
        var output = input
        let matches = self.matches(in: input)
        let rangedMatches = Array(matches[0..<min(matches.count, count ?? .max)])
        for match in rangedMatches.reversed() {
            let replacement = match.string(applyingTemplate: template)
            output.replaceSubrange(match.range, with: replacement)
        }
        return output
    }
}
extension Regex {
    public struct Options: OptionSet {
        public static let ignoreCase = Options(rawValue: 1)
        public static let ignoreMetacharacters = Options(rawValue: 1 << 1)
        public static let anchorsMatchLines = Options(rawValue: 1 << 2)
        public static let dotMatchesLineSeparators = Options(rawValue: 1 << 3)
        public let rawValue: Int
        var toNSRegularExpressionOptions: NSRegularExpression.Options {
            var options = NSRegularExpression.Options()
            if contains(.ignoreCase) { options.insert(.caseInsensitive) }
            if contains(.ignoreMetacharacters) {
                options.insert(.ignoreMetacharacters) }
            if contains(.anchorsMatchLines) { options.insert(.anchorsMatchLines) }
            if contains(.dotMatchesLineSeparators) {
                options.insert(.dotMatchesLineSeparators) }
            return options
        }
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
extension Regex {
    public class Match: CustomStringConvertible {
        public lazy var string: String = {
            return String(describing: self.baseString[self.range])
        }()
        public lazy var range: Range<String.Index> = {
            return Range(self.result.range, in: self.baseString)!
        }()
        public lazy var captures: [String?] = {
            let captureRanges = stride(from: 0, to: result.numberOfRanges, by: 1)
                .map(result.range)
                .dropFirst()
                .map { [unowned self] in
                    Range($0, in: self.baseString)
            }
            return captureRanges.map { [unowned self] captureRange in
                if let captureRange = captureRange {
                    return String(describing: self.baseString[captureRange])
                }
                return nil
            }
        }()
        private let result: NSTextCheckingResult
        private let baseString: String
        internal init(result: NSTextCheckingResult, in string: String) {
            precondition(
                result.regularExpression != nil,
                "NSTextCheckingResult必需使用正则表达式"
            )
            self.result = result
            self.baseString = string
        }
        public func string(applyingTemplate template: String) -> String {
            let replacement = result.regularExpression!.replacementString(
                for: result,
                in: baseString,
                offset: 0,
                template: template
            )
            return replacement
        }
        public var description: String {
            return "Match<\"\(string)\">"
        }
    }
}