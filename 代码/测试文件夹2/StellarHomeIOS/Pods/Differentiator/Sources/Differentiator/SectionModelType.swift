import Foundation
public protocol SectionModelType {
    associatedtype Item
    var items: [Item] { get }
    init(original: Self, items: [Item])
}