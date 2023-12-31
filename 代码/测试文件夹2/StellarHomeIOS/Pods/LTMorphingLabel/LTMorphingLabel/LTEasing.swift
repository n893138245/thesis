import Foundation
public struct LTEasing {
    public static func easeOutQuint(_ t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        return {
            return c * (pow($0, 5) + 1.0) + b
            }(t / d - 1.0)
    }
    public static func easeInQuint(_ t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
	let t1: Float = t / d
	let t2: Float = c * t1 * t1 * t1 * t1 * t1 + b
	return t2
    }
    public static func easeOutBack(_ t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        let s: Float = 2.70158
        let t2: Float = t / d - 1.0
        return Float(c * (t2 * t2 * ((s + 1.0) * t2 + s) + 1.0)) + b
    }
    public static func easeOutBounce(_ t: Float, _ b: Float, _ c: Float, _ d: Float = 1.0) -> Float {
        return {
            if $0 < 1 / 2.75 {
                return c * 7.5625 * $0 * $0 + b
            } else if $0 < 2 / 2.75 {
                let t = $0 - 1.5 / 2.75
                return c * (7.5625 * t * t + 0.75) + b
            } else if $0 < 2.5 / 2.75 {
                let t = $0 - 2.25 / 2.75
                return c * (7.5625 * t * t + 0.9375) + b
            } else {
                let t = $0 - 2.625 / 2.75
                return c * (7.5625 * t * t + 0.984375) + b
            }
        }(t / d)
    }
}