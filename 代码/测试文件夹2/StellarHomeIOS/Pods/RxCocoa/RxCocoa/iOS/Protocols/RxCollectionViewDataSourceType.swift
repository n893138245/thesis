#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
public protocol RxCollectionViewDataSourceType  {
    associatedtype Element
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>)
}
#endif