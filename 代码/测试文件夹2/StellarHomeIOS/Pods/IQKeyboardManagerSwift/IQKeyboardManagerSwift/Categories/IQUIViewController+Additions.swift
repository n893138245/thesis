import UIKit
private var kIQLayoutGuideConstraint = "kIQLayoutGuideConstraint"
@objc public extension UIViewController {
    func parentIQContainerViewController() -> UIViewController? {
        return self
    }
    @available(*, deprecated, message: "Due to change in core-logic of handling distance between textField and keyboard distance, this layout contraint tweak is no longer needed and things will just work out of the box regardless of constraint pinned with safeArea/layoutGuide/superview.")
    @IBOutlet @objc var IQLayoutGuideConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kIQLayoutGuideConstraint) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQLayoutGuideConstraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}