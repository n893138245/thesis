import UIKit
extension SwipeCollectionViewCell {
    open override func accessibilityElementCount() -> Int {
        guard state != .center else {
            return super.accessibilityElementCount()
        }
        return 1
    }
    open override func accessibilityElement(at index: Int) -> Any? {
        guard state != .center else {
            return super.accessibilityElement(at: index)
        }
        return actionsView
    }
    open override func index(ofAccessibilityElement element: Any) -> Int {
        guard state != .center else {
            return super.index(ofAccessibilityElement: element)
        }
        return element is SwipeActionsView ? 0 : NSNotFound
    }
}
extension SwipeCollectionViewCell {
    open override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        get {
            guard let collectionView = collectionView, let indexPath = collectionView.indexPath(for: self) else {
                return super.accessibilityCustomActions
            }
            let leftActions = delegate?.collectionView(collectionView, editActionsForItemAt: indexPath, for: .left) ?? []
            let rightActions = delegate?.collectionView(collectionView, editActionsForItemAt: indexPath, for: .right) ?? []
            let actions = [rightActions.first, leftActions.first].compactMap({ $0 }) + rightActions.dropFirst() + leftActions.dropFirst()
            if actions.count > 0 {
                return actions.compactMap({ SwipeAccessibilityCustomAction(action: $0,
                                                                    indexPath: indexPath,
                                                                    target: self,
                                                                    selector: #selector(performAccessibilityCustomAction(accessibilityCustomAction:))) })
            } else {
                return super.accessibilityCustomActions
            }
        }
        set {
            super.accessibilityCustomActions = newValue
        }
    }
    @objc func performAccessibilityCustomAction(accessibilityCustomAction: SwipeAccessibilityCustomAction) -> Bool {
        guard let collectionView = collectionView else { return false }
        let swipeAction = accessibilityCustomAction.action
        swipeAction.handler?(swipeAction, accessibilityCustomAction.indexPath)
        if swipeAction.style == .destructive {
            collectionView.deleteItems(at: [accessibilityCustomAction.indexPath])
        }
        return true
    }
}