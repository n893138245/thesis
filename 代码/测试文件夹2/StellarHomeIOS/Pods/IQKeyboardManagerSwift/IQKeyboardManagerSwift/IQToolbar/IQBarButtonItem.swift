import UIKit
import Foundation
open class IQBarButtonItem: UIBarButtonItem {
    private static var _classInitialize: Void = classInitialize()
    @objc public override init() {
        _ = IQBarButtonItem._classInitialize
          super.init()
      }
    @objc public required init?(coder aDecoder: NSCoder) {
        _ = IQBarButtonItem._classInitialize
           super.init(coder: aDecoder)
       }
    private class func classInitialize() {
        let  appearanceProxy = self.appearance()
        #if swift(>=4.2)
        let states: [UIControl.State]
        #else
        let states: [UIControlState]
        #endif
        states = [.normal, .highlighted, .disabled, .selected, .application, .reserved]
        for state in states {
            appearanceProxy.setBackgroundImage(nil, for: state, barMetrics: .default)
            appearanceProxy.setBackgroundImage(nil, for: state, style: .done, barMetrics: .default)
            appearanceProxy.setBackgroundImage(nil, for: state, style: .plain, barMetrics: .default)
            appearanceProxy.setBackButtonBackgroundImage(nil, for: state, barMetrics: .default)
        }
        appearanceProxy.setTitlePositionAdjustment(UIOffset(), for: .default)
        appearanceProxy.setBackgroundVerticalPositionAdjustment(0, for: .default)
        appearanceProxy.setBackButtonBackgroundVerticalPositionAdjustment(0, for: .default)
    }
    @objc override open var tintColor: UIColor? {
        didSet {
            #if swift(>=4.2)
            var textAttributes = [NSAttributedString.Key: Any]()
            let foregroundColorKey = NSAttributedString.Key.foregroundColor
            #elseif swift(>=4)
            var textAttributes = [NSAttributedStringKey: Any]()
            let foregroundColorKey = NSAttributedStringKey.foregroundColor
            #else
            var textAttributes = [String: Any]()
            let foregroundColorKey = NSForegroundColorAttributeName
            #endif
            textAttributes[foregroundColorKey] = tintColor
            #if swift(>=4)
                if let attributes = titleTextAttributes(for: .normal) {
                    for (key, value) in attributes {
                        #if swift(>=4.2)
                        textAttributes[key] = value
                        #else
                        textAttributes[NSAttributedStringKey.init(key)] = value
                        #endif
                    }
                }
            #else
                if let attributes = titleTextAttributes(for: .normal) {
                    textAttributes = attributes
                }
            #endif
            setTitleTextAttributes(textAttributes, for: .normal)
        }
    }
    @objc internal var isSystemItem = false
    @objc open func setTarget(_ target: AnyObject?, action: Selector?) {
        if let target = target, let action = action {
            invocation = IQInvocation(target, action)
        } else {
            invocation = nil
        }
    }
    @objc open var invocation: IQInvocation?
    deinit {
        target = nil
        invocation = nil
    }
}