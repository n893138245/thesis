import Foundation
public protocol URLRepresentable {
    var url: URL { get }
}
extension URL: URLRepresentable {
    public var url: URL {
        return self
    }
    public init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string: string)
    }
}