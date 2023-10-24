#if os(iOS) || os(tvOS)
import UIKit
public enum ImageTransition {
    case none
    case fade(TimeInterval)
    case flipFromLeft(TimeInterval)
    case flipFromRight(TimeInterval)
    case flipFromTop(TimeInterval)
    case flipFromBottom(TimeInterval)
    case custom(duration: TimeInterval,
                 options: UIView.AnimationOptions,
              animations: ((UIImageView, UIImage) -> Void)?,
              completion: ((Bool) -> Void)?)
    var duration: TimeInterval {
        switch self {
        case .none:                          return 0
        case .fade(let duration):            return duration
        case .flipFromLeft(let duration):    return duration
        case .flipFromRight(let duration):   return duration
        case .flipFromTop(let duration):     return duration
        case .flipFromBottom(let duration):  return duration
        case .custom(let duration, _, _, _): return duration
        }
    }
    var animationOptions: UIView.AnimationOptions {
        switch self {
        case .none:                         return []
        case .fade:                         return .transitionCrossDissolve
        case .flipFromLeft:                 return .transitionFlipFromLeft
        case .flipFromRight:                return .transitionFlipFromRight
        case .flipFromTop:                  return .transitionFlipFromTop
        case .flipFromBottom:               return .transitionFlipFromBottom
        case .custom(_, let options, _, _): return options
        }
    }
    var animations: ((UIImageView, UIImage) -> Void)? {
        switch self {
        case .custom(_, _, let animations, _): return animations
        default: return { $0.image = $1 }
        }
    }
    var completion: ((Bool) -> Void)? {
        switch self {
        case .custom(_, _, _, let completion): return completion
        default: return nil
        }
    }
}
#else
public enum ImageTransition {
    case none
}
#endif