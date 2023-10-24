import Foundation
import UIKit
public let kIQUseDefaultKeyboardDistance = CGFloat.greatestFiniteMagnitude
private var kIQKeyboardDistanceFromTextField = "kIQKeyboardDistanceFromTextField"
private var kIQKeyboardEnableMode = "kIQKeyboardEnableMode"
private var kIQShouldResignOnTouchOutsideMode = "kIQShouldResignOnTouchOutsideMode"
private var kIQIgnoreSwitchingByNextPrevious = "kIQIgnoreSwitchingByNextPrevious"
@objc public extension UIView {
    @objc var keyboardDistanceFromTextField: CGFloat {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIQKeyboardDistanceFromTextField) as? CGFloat {
                return aValue
            } else {
                return kIQUseDefaultKeyboardDistance
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQKeyboardDistanceFromTextField, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @objc var ignoreSwitchingByNextPrevious: Bool {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQIgnoreSwitchingByNextPrevious, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @objc var enableMode: IQEnableMode {
        get {
            if let savedMode = objc_getAssociatedObject(self, &kIQKeyboardEnableMode) as? IQEnableMode {
                return savedMode
            } else {
                return .default
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQKeyboardEnableMode, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @objc var shouldResignOnTouchOutsideMode: IQEnableMode {
        get {
            if let savedMode = objc_getAssociatedObject(self, &kIQShouldResignOnTouchOutsideMode) as? IQEnableMode {
                return savedMode
            } else {
                return .default
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldResignOnTouchOutsideMode, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}