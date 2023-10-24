import UIKit
class SwipeAccessibilityCustomAction: UIAccessibilityCustomAction {
    let action: SwipeAction
    let indexPath: IndexPath
    init?(action: SwipeAction, indexPath: IndexPath, target: Any, selector: Selector) {
        self.action = action
        self.indexPath = indexPath
        let name = action.accessibilityLabel ?? action.title ?? action.image?.accessibilityIdentifier ?? nil
        if let name = name {
            super.init(name: name, target: target, selector: selector)
        } else {
            return nil
        }
    }
}