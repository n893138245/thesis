import Foundation
@objc public enum IQAutoToolbarManageBehaviour: Int {
    case bySubviews
    case byTag
    case byPosition
}
@objc public enum IQPreviousNextDisplayMode: Int {
    case `default`
    case alwaysHide
    case alwaysShow
}
@objc public enum IQEnableMode: Int {
    case `default`
    case enabled
    case disabled
}