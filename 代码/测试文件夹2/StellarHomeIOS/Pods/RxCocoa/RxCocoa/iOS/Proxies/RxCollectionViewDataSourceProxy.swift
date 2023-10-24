#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
extension UICollectionView: HasDataSource {
    public typealias DataSource = UICollectionViewDataSource
}
private let collectionViewDataSourceNotSet = CollectionViewDataSourceNotSet()
private final class CollectionViewDataSourceNotSet
    : NSObject
    , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        rxAbstractMethod(message: dataSourceNotSet)
    }
}
open class RxCollectionViewDataSourceProxy
    : DelegateProxy<UICollectionView, UICollectionViewDataSource>
    , DelegateProxyType 
    , UICollectionViewDataSource {
    public weak private(set) var collectionView: UICollectionView?
    public init(collectionView: ParentObject) {
        self.collectionView = collectionView
        super.init(parentObject: collectionView, delegateProxy: RxCollectionViewDataSourceProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxCollectionViewDataSourceProxy(collectionView: $0) }
    }
    private weak var _requiredMethodsDataSource: UICollectionViewDataSource? = collectionViewDataSourceNotSet
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (_requiredMethodsDataSource ?? collectionViewDataSourceNotSet).collectionView(collectionView, numberOfItemsInSection: section)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (_requiredMethodsDataSource ?? collectionViewDataSourceNotSet).collectionView(collectionView, cellForItemAt: indexPath)
    }
    open override func setForwardToDelegate(_ forwardToDelegate: UICollectionViewDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? collectionViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}
#endif