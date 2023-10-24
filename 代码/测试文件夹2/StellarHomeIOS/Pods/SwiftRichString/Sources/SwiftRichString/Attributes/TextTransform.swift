import Foundation
public enum TextTransform {
    public typealias TransformFunction = (String) -> String
    case lowercase
    case uppercase
    case capitalized
    case lowercaseWithLocale(Locale)
    case uppercaseWithLocale(Locale)
    case capitalizedWithLocale(Locale)
    case custom(TransformFunction)
    var transformer: TransformFunction {
        switch self {
            case .lowercase:
                return { string in
                    if #available(iOS 9.0, iOSApplicationExtension 9.0, *) {
                        return string.localizedLowercase
                    } else {
                        return string.lowercased(with: Locale.current)
                    }
                }
            case .uppercase:
                return { string in
                    if #available(iOS 9.0, iOSApplicationExtension 9.0, *) {
                        return string.localizedUppercase
                    } else {
                        return string.uppercased(with: Locale.current)
                    }
                }
            case .capitalized:
                return { string in
                    if #available(iOS 9.0, iOSApplicationExtension 9.0, *) {
                        return string.localizedCapitalized
                    } else {
                        return string.capitalized(with: Locale.current)
                    }
                }
            case .lowercaseWithLocale(let locale):
                return { string in
                    string.lowercased(with: locale)
                }
            case .uppercaseWithLocale(let locale):
                return { string in
                    string.uppercased(with: locale)
                }
            case .capitalizedWithLocale(let locale):
                return { string in
                    string.capitalized(with: locale)
                }
            case .custom(let transform):
                return transform
        }
    }
}