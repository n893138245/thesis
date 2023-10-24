import Foundation
public struct ItemPath {
    public let sectionIndex: Int
    public let itemIndex: Int
    public init(sectionIndex: Int, itemIndex: Int) {
        self.sectionIndex = sectionIndex
        self.itemIndex = itemIndex
    }
}
extension ItemPath : Equatable {
}
public func == (lhs: ItemPath, rhs: ItemPath) -> Bool {
    return lhs.sectionIndex == rhs.sectionIndex && lhs.itemIndex == rhs.itemIndex
}
extension ItemPath: Hashable {
    public func hash(into hasher: inout Hasher) {
      hasher.combine(sectionIndex.byteSwapped.hashValue)
      hasher.combine(itemIndex.hashValue)
    }
}