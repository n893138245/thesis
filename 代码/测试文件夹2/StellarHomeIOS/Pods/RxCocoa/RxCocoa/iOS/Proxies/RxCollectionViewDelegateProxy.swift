#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
open class RxCollectionViewDelegateProxy
    : RxScrollViewDelegateProxy
    , UICollectionViewDelegate
    , UICollectionViewDelegateFlowLayout {
    public weak private(set) var collectionView: UICollectionView?
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(scrollView: collectionView)
    }
}
#endif