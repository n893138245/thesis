import UIKit
@objc public enum LTMorphingEffect
    : Int
    , CustomStringConvertible
    , ExpressibleByIntegerLiteral
    , ExpressibleByStringLiteral
    , CaseIterable {
    public typealias IntegerLiteralType = Int
    public typealias StringLiteralType = String
    case scale = 0
    case evaporate
    case fall
    case pixelate
    case sparkle
    case burn
    case anvil
    public static let allValues = [
        "Scale", "Evaporate", "Fall", "Pixelate", "Sparkle", "Burn", "Anvil"
    ]
    public var description: String {
        switch self {
        case .evaporate:
            return "Evaporate"
        case .fall:
            return "Fall"
        case .pixelate:
            return "Pixelate"
        case .sparkle:
            return "Sparkle"
        case .burn:
            return "Burn"
        case .anvil:
            return "Anvil"
        default:
            return "Scale"
        }
    }
    public init(integerLiteral value: Int) {
        self = LTMorphingEffect(rawValue: value) ?? .scale
    }
    public init(stringLiteral value: String) {
        self = {
            switch value {
            case "Evaporate": return .evaporate
            case "Fall": return .fall
            case "Pixelate": return .pixelate
            case "Sparkle": return .sparkle
            case "Burn": return .burn
            case "Anvil": return .anvil
            default: return .scale
            }
        }()
    }
}