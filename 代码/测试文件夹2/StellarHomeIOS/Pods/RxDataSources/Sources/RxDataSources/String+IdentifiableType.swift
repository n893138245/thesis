import Foundation
extension String : IdentifiableType {
    public typealias Identity = String
    public var identity: String {
        return self
    }
}