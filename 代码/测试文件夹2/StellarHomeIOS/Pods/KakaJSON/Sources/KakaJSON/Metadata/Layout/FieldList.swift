struct FieldList<Item> {
    private let item: Item
    mutating func ptr(_ index: Int) -> UnsafeMutablePointer<Item> {
        return withUnsafeMutablePointer(to: &self) {
            ($0 + index).kj_raw ~> Item.self
        }
    }
    mutating func item(_ index: Int) -> Item {
        return withUnsafeMutablePointer(to: &self) {
            $0[index].item
        }
    }
}