import Foundation
extension Array where Element: AnimatableSectionModelType {
    subscript(index: ItemPath) -> Element.Item {
        return self[index.sectionIndex].items[index.itemIndex]
    }
}