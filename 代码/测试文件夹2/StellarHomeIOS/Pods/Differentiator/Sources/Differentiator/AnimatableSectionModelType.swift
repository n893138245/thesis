import Foundation
public protocol AnimatableSectionModelType
    : SectionModelType
    , IdentifiableType where Item: IdentifiableType, Item: Equatable {
}