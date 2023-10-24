#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UICollectionView {
    public func items<Sequence: Swift.Sequence, Source: ObservableType>
        (_ source: Source)
        -> (_ cellFactory: @escaping (UICollectionView, Int, Sequence.Element) -> UICollectionViewCell)
        -> Disposable where Source.Element == Sequence {
        return { cellFactory in
            let dataSource = RxCollectionViewReactiveArrayDataSourceSequenceWrapper<Sequence>(cellFactory: cellFactory)
            return self.items(dataSource: dataSource)(source)
        }
    }
    public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable where Source.Element == Sequence {
        return { source in
            return { configureCell in
                let dataSource = RxCollectionViewReactiveArrayDataSourceSequenceWrapper<Sequence> { cv, i, item in
                    let indexPath = IndexPath(item: i, section: 0)
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! Cell
                    configureCell(i, item, cell)
                    return cell
                }
                return self.items(dataSource: dataSource)(source)
            }
        }
    }
    public func items<
            DataSource: RxCollectionViewDataSourceType & UICollectionViewDataSource,
            Source: ObservableType>
        (dataSource: DataSource)
        -> (_ source: Source)
        -> Disposable where DataSource.Element == Source.Element
          {
        return { source in
            _ = self.delegate
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true) { [weak collectionView = self.base] (_: RxCollectionViewDataSourceProxy, event) -> Void in
                guard let collectionView = collectionView else {
                    return
                }
                dataSource.collectionView(collectionView, observedEvent: event)
            }
        }
    }
}
extension Reactive where Base: UICollectionView {
    public typealias DisplayCollectionViewCellEvent = (cell: UICollectionViewCell, at: IndexPath)
    public typealias DisplayCollectionViewSupplementaryViewEvent = (supplementaryView: UICollectionReusableView, elementKind: String, at: IndexPath)
    public var dataSource: DelegateProxy<UICollectionView, UICollectionViewDataSource> {
        return RxCollectionViewDataSourceProxy.proxy(for: base)
    }
    public func setDataSource(_ dataSource: UICollectionViewDataSource)
        -> Disposable {
        return RxCollectionViewDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { a in
                return try castOrThrow(IndexPath.self, a[1])
            }
        return ControlEvent(events: source)
    }
    public var itemDeselected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didDeselectItemAt:)))
            .map { a in
                return try castOrThrow(IndexPath.self, a[1])
        }
        return ControlEvent(events: source)
    }
    public var itemHighlighted: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didHighlightItemAt:)))
            .map { a in
                return try castOrThrow(IndexPath.self, a[1])
            }
        return ControlEvent(events: source)
    }
    public var itemUnhighlighted: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didUnhighlightItemAt:)))
            .map { a in
                return try castOrThrow(IndexPath.self, a[1])
            }
        return ControlEvent(events: source)
    }
    public var willDisplayCell: ControlEvent<DisplayCollectionViewCellEvent> {
        let source: Observable<DisplayCollectionViewCellEvent> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:willDisplay:forItemAt:)))
            .map { a in
                return (try castOrThrow(UICollectionViewCell.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
            }
        return ControlEvent(events: source)
    }
    public var willDisplaySupplementaryView: ControlEvent<DisplayCollectionViewSupplementaryViewEvent> {
        let source: Observable<DisplayCollectionViewSupplementaryViewEvent> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:willDisplaySupplementaryView:forElementKind:at:)))
            .map { a in
                return (try castOrThrow(UICollectionReusableView.self, a[1]),
                        try castOrThrow(String.self, a[2]),
                        try castOrThrow(IndexPath.self, a[3]))
            }
        return ControlEvent(events: source)
    }
    public var didEndDisplayingCell: ControlEvent<DisplayCollectionViewCellEvent> {
        let source: Observable<DisplayCollectionViewCellEvent> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:)))
            .map { a in
                return (try castOrThrow(UICollectionViewCell.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
            }
        return ControlEvent(events: source)
    }
    public var didEndDisplayingSupplementaryView: ControlEvent<DisplayCollectionViewSupplementaryViewEvent> {
        let source: Observable<DisplayCollectionViewSupplementaryViewEvent> = self.delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)))
            .map { a in
                return (try castOrThrow(UICollectionReusableView.self, a[1]),
                        try castOrThrow(String.self, a[2]),
                        try castOrThrow(IndexPath.self, a[3]))
            }
        return ControlEvent(events: source)
    }
    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemSelected.flatMap { [weak view = self.base as UICollectionView] indexPath -> Observable<T> in
            guard let view = view else {
                return Observable.empty()
            }
            return Observable.just(try view.rx.model(at: indexPath))
        }
        return ControlEvent(events: source)
    }
    public func modelDeselected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemDeselected.flatMap { [weak view = self.base as UICollectionView] indexPath -> Observable<T> in
            guard let view = view else {
                return Observable.empty()
            }
            return Observable.just(try view.rx.model(at: indexPath))
        }
        return ControlEvent(events: source)
    }
    public func model<T>(at indexPath: IndexPath) throws -> T {
        let dataSource: SectionedViewDataSourceType = castOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.itemsWith*` methods was used.")
        let element = try dataSource.model(at: indexPath)
        return try castOrThrow(T.self, element)
    }
}
@available(iOS 10.0, tvOS 10.0, *)
extension Reactive where Base: UICollectionView {
    public var prefetchDataSource: DelegateProxy<UICollectionView, UICollectionViewDataSourcePrefetching> {
        return RxCollectionViewDataSourcePrefetchingProxy.proxy(for: base)
    }
    public func setPrefetchDataSource(_ prefetchDataSource: UICollectionViewDataSourcePrefetching)
        -> Disposable {
            return RxCollectionViewDataSourcePrefetchingProxy.installForwardDelegate(prefetchDataSource, retainDelegate: false, onProxyForObject: self.base)
    }
    public var prefetchItems: ControlEvent<[IndexPath]> {
        let source = RxCollectionViewDataSourcePrefetchingProxy.proxy(for: base).prefetchItemsPublishSubject
        return ControlEvent(events: source)
    }
    public var cancelPrefetchingForItems: ControlEvent<[IndexPath]> {
        let source = prefetchDataSource.methodInvoked(#selector(UICollectionViewDataSourcePrefetching.collectionView(_:cancelPrefetchingForItemsAt:)))
            .map { a in
                return try castOrThrow(Array<IndexPath>.self, a[1])
        }
        return ControlEvent(events: source)
    }
}
#endif
#if os(tvOS)
extension Reactive where Base: UICollectionView {
    public var didUpdateFocusInContextWithAnimationCoordinator: ControlEvent<(context: UICollectionViewFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator)> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didUpdateFocusIn:with:)))
            .map { a -> (context: UICollectionViewFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator) in
                let context = try castOrThrow(UICollectionViewFocusUpdateContext.self, a[1])
                let animationCoordinator = try castOrThrow(UIFocusAnimationCoordinator.self, a[2])
                return (context: context, animationCoordinator: animationCoordinator)
            }
        return ControlEvent(events: source)
    }
}
#endif