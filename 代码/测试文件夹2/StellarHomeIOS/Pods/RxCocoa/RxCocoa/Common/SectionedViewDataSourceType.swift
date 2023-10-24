import struct Foundation.IndexPath
public protocol SectionedViewDataSourceType {
    func model(at indexPath: IndexPath) throws -> Any
}