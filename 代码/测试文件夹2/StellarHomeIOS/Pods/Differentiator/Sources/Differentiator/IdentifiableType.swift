import Foundation
public protocol IdentifiableType {
    associatedtype Identity: Hashable
    var identity : Identity { get }
}