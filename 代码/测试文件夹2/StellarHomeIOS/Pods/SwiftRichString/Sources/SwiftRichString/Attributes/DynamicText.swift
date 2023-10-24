#if os(tvOS) || os(watchOS) || os(iOS)
import UIKit
public class DynamicText {
    public var style: UIFont.TextStyle?
    #if os(OSX) || os(iOS) || os(tvOS)
    public var traitCollection: UITraitCollection?
    #endif
    public var maximumSize: CGFloat?
    public typealias InitHandler = ((DynamicText) -> (Void))
    public init(_ handler: InitHandler? = nil) {
        handler?(self)
    }
}
#endif