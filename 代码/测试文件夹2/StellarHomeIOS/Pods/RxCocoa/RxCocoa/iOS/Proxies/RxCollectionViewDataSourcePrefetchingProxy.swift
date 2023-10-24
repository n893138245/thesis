#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
@available(iOS 10.0, tvOS 10.0, *)
extension UICollectionView: HasPrefetchDataSource {
    public typealias PrefetchDataSource = UICollectionViewDataSourcePrefetching
}
@available(iOS 10.0, tvOS 10.0, *)
private let collectionViewPrefetchDataSourceNotSet = CollectionViewPrefetchDataSourceNotSet()
@available(iOS 10.0, tvOS 10.0, *)
private final class CollectionViewPrefetchDataSourceNotSet
    : NSObject
    , UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}
}
@available(iOS 10.0, tvOS 10.0, *)
open class RxCollectionViewDataSourcePrefetchingProxy
    : DelegateProxy<UICollectionView, UICollectionViewDataSourcePrefetching>
    , DelegateProxyType
    , UICollectionViewDataSourcePrefetching {
    public weak private(set) var collectionView: UICollectionView?
    public init(collectionView: ParentObject) {
        self.collectionView = collectionView
        super.init(parentObject: collectionView, delegateProxy: RxCollectionViewDataSourcePrefetchingProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxCollectionViewDataSourcePrefetchingProxy(collectionView: $0) }
    }
    private var _prefetchItemsPublishSubject: PublishSubject<[IndexPath]>?
    internal var prefetchItemsPublishSubject: PublishSubject<[IndexPath]> {
        if let subject = _prefetchItemsPublishSubject {
            return subject
        }
        let subject = PublishSubject<[IndexPath]>()
        _prefetchItemsPublishSubject = subject
        return subject
    }
    private weak var _requiredMethodsPrefetchDataSource: UICollectionViewDataSourcePrefetching? = collectionViewPrefetchDataSourceNotSet
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let subject = _prefetchItemsPublishSubject {
            subject.on(.next(indexPaths))
        }
        (_requiredMethodsPrefetchDataSource ?? collectionViewPrefetchDataSourceNotSet).collectionView(collectionView, prefetchItemsAt: indexPaths)
    }
    open override func setForwardToDelegate(_ forwardToDelegate: UICollectionViewDataSourcePrefetching?, retainDelegate: Bool) {
        _requiredMethodsPrefetchDataSource = forwardToDelegate ?? collectionViewPrefetchDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
    deinit {
        if let subject = _prefetchItemsPublishSubject {
            subject.on(.completed)
        }
    }
}
#endif