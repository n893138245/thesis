import UIKit
class HBottomSelectionBaseFactory: NSObject {
    var reloadBlock:(()->Void)? = nil
    func getSectionModelData() -> [TableViewSectionModel]{
        return [TableViewSectionModel]()
    }
}