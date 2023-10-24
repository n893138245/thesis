import Foundation
import UIKit
private var kIQShouldIgnoreScrollingAdjustment      = "kIQShouldIgnoreScrollingAdjustment"
private var kIQShouldIgnoreContentInsetAdjustment   = "kIQShouldIgnoreContentInsetAdjustment"
private var kIQShouldRestoreScrollViewContentOffset = "kIQShouldRestoreScrollViewContentOffset"
@objc public extension UIScrollView {
    @objc var shouldIgnoreScrollingAdjustment: Bool {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIQShouldIgnoreScrollingAdjustment) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldIgnoreScrollingAdjustment, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @objc var shouldIgnoreContentInsetAdjustment: Bool {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIQShouldIgnoreContentInsetAdjustment) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldIgnoreContentInsetAdjustment, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    @objc var shouldRestoreScrollViewContentOffset: Bool {
        get {
            if let aValue = objc_getAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kIQShouldRestoreScrollViewContentOffset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
internal extension UITableView {
    func previousIndexPath(of indexPath: IndexPath) -> IndexPath? {
        var previousRow = indexPath.row - 1
        var previousSection = indexPath.section
        if previousRow < 0 {
            previousSection -= 1
            if previousSection >= 0 {
                previousRow = self.numberOfRows(inSection: previousSection) - 1
            }
        }
        if previousRow >= 0 && previousSection >= 0 {
            return IndexPath(row: previousRow, section: previousSection)
        } else {
            return nil
        }
    }
}
internal extension UICollectionView {
    func previousIndexPath(of indexPath: IndexPath) -> IndexPath? {
        var previousRow = indexPath.row - 1
        var previousSection = indexPath.section
        if previousRow < 0 {
            previousSection -= 1
            if previousSection >= 0 {
                previousRow = self.numberOfItems(inSection: previousSection) - 1
            }
        }
        if previousRow >= 0 && previousSection >= 0 {
            return IndexPath(item: previousRow, section: previousSection)
        } else {
            return nil
        }
    }
}