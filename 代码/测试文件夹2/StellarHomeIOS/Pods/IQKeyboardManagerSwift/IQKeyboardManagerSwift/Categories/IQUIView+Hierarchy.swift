import UIKit
@objc public extension UIView {
    @objc func viewContainingController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
    @objc func topMostController() -> UIViewController? {
        var controllersHierarchy = [UIViewController]()
        if var topController = window?.rootViewController {
            controllersHierarchy.append(topController)
            while let presented = topController.presentedViewController {
                topController = presented
                controllersHierarchy.append(presented)
            }
            var matchController: UIResponder? = viewContainingController()
            while let mController = matchController as? UIViewController, controllersHierarchy.contains(mController) == false {
                repeat {
                    matchController = matchController?.next
                } while matchController != nil && matchController is UIViewController == false
            }
            return matchController as? UIViewController
        } else {
            return viewContainingController()
        }
    }
    @objc func parentContainerViewController() -> UIViewController? {
        var matchController = viewContainingController()
        var parentContainerViewController: UIViewController?
        if var navController = matchController?.navigationController {
            while let parentNav = navController.navigationController {
                navController = parentNav
            }
            var parentController: UIViewController = navController
            while let parent = parentController.parent,
                (parent.isKind(of: UINavigationController.self) == false &&
                    parent.isKind(of: UITabBarController.self) == false &&
                    parent.isKind(of: UISplitViewController.self) == false) {
                        parentController = parent
            }
            if navController == parentController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = parentController
            }
        } else if let tabController = matchController?.tabBarController {
            if let navController = tabController.selectedViewController as? UINavigationController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = tabController.selectedViewController
            }
        } else {
            while let parentController = matchController?.parent,
                (parentController.isKind(of: UINavigationController.self) == false &&
                    parentController.isKind(of: UITabBarController.self) == false &&
                    parentController.isKind(of: UISplitViewController.self) == false) {
                        matchController = parentController
            }
            parentContainerViewController = matchController
        }
        let finalController = parentContainerViewController?.parentIQContainerViewController() ?? parentContainerViewController
        return finalController
    }
    @objc func superviewOfClassType(_ classType: UIView.Type, belowView: UIView? = nil) -> UIView? {
        var superView = superview
        while let unwrappedSuperView = superView {
            if unwrappedSuperView.isKind(of: classType) {
                if unwrappedSuperView.isKind(of: UIScrollView.self) {
                    let classNameString = NSStringFromClass(type(of: unwrappedSuperView.self))
                    if unwrappedSuperView.superview?.isKind(of: UITableView.self) == false &&
                        unwrappedSuperView.superview?.isKind(of: UITableViewCell.self) == false &&
                        classNameString.hasPrefix("_") == false {
                        return superView
                    }
                } else {
                    return superView
                }
            } else if unwrappedSuperView == belowView {
                return nil
            }
            superView = unwrappedSuperView.superview
        }
        return nil
    }
    internal func responderSiblings() -> [UIView] {
        var tempTextFields = [UIView]()
        if let siblings = superview?.subviews {
            for textField in siblings {
                if (textField == self || textField.ignoreSwitchingByNextPrevious == false) && textField.IQcanBecomeFirstResponder() == true {
                    tempTextFields.append(textField)
                }
            }
        }
        return tempTextFields
    }
    internal func deepResponderViews() -> [UIView] {
        var textfields = [UIView]()
        for textField in subviews {
            if (textField == self || textField.ignoreSwitchingByNextPrevious == false) && textField.IQcanBecomeFirstResponder() == true {
                textfields.append(textField)
            }
            else if textField.subviews.count != 0  && isUserInteractionEnabled == true && isHidden == false && alpha != 0.0 {
                for deepView in textField.deepResponderViews() {
                    textfields.append(deepView)
                }
            }
        }
        return textfields.sorted(by: { (view1: UIView, view2: UIView) -> Bool in
            let frame1 = view1.convert(view1.bounds, to: self)
            let frame2 = view2.convert(view2.bounds, to: self)
            if frame1.minY != frame2.minY {
                return frame1.minY < frame2.minY
            } else {
                return frame1.minX < frame2.minX
            }
        })
    }
    private func IQcanBecomeFirstResponder() -> Bool {
        var IQcanBecomeFirstResponder = false
        if self.conforms(to: UITextInput.self) {
            if let textView = self as? UITextView {
                IQcanBecomeFirstResponder = textView.isEditable
            } else if let textField = self as? UITextField {
                IQcanBecomeFirstResponder = textField.isEnabled
            }
        }
        if IQcanBecomeFirstResponder == true {
            IQcanBecomeFirstResponder = isUserInteractionEnabled == true && isHidden == false && alpha != 0.0 && isAlertViewTextField() == false && textFieldSearchBar() == nil
        }
        return IQcanBecomeFirstResponder
    }
    internal func textFieldSearchBar() -> UISearchBar? {
        var responder: UIResponder? = self.next
        while let bar = responder {
            if let searchBar = bar as? UISearchBar {
                return searchBar
            } else if bar is UIViewController {
                break
            }
            responder = bar.next
        }
        return nil
    }
    internal func isAlertViewTextField() -> Bool {
        var alertViewController: UIResponder? = viewContainingController()
        var isAlertViewTextField = false
        while let controller = alertViewController, isAlertViewTextField == false {
            if controller.isKind(of: UIAlertController.self) {
                isAlertViewTextField = true
                break
            }
            alertViewController = controller.next
        }
        return isAlertViewTextField
    }
    private func depth() -> Int {
        var depth: Int = 0
        if let superView = superview {
            depth = superView.depth()+1
        }
        return depth
    }
}
extension NSObject {
    internal func _IQDescription() -> String {
        return "<\(self) \(Unmanaged.passUnretained(self).toOpaque())>"
    }
}