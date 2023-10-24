#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension UIScrollView: HasDelegate {
    public typealias Delegate = UIScrollViewDelegate
}
open class RxScrollViewDelegateProxy
    : DelegateProxy<UIScrollView, UIScrollViewDelegate>
    , DelegateProxyType 
    , UIScrollViewDelegate {
    public weak private(set) var scrollView: UIScrollView?
    public init(scrollView: ParentObject) {
        self.scrollView = scrollView
        super.init(parentObject: scrollView, delegateProxy: RxScrollViewDelegateProxy.self)
    }
    public static func registerKnownImplementations() {
        self.register { RxScrollViewDelegateProxy(scrollView: $0) }
        self.register { RxTableViewDelegateProxy(tableView: $0) }
        self.register { RxCollectionViewDelegateProxy(collectionView: $0) }
        self.register { RxTextViewDelegateProxy(textView: $0) }
    }
    private var _contentOffsetBehaviorSubject: BehaviorSubject<CGPoint>?
    private var _contentOffsetPublishSubject: PublishSubject<()>?
    internal var contentOffsetBehaviorSubject: BehaviorSubject<CGPoint> {
        if let subject = _contentOffsetBehaviorSubject {
            return subject
        }
        let subject = BehaviorSubject<CGPoint>(value: self.scrollView?.contentOffset ?? CGPoint.zero)
        _contentOffsetBehaviorSubject = subject
        return subject
    }
    internal var contentOffsetPublishSubject: PublishSubject<()> {
        if let subject = _contentOffsetPublishSubject {
            return subject
        }
        let subject = PublishSubject<()>()
        _contentOffsetPublishSubject = subject
        return subject
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let subject = _contentOffsetBehaviorSubject {
            subject.on(.next(scrollView.contentOffset))
        }
        if let subject = _contentOffsetPublishSubject {
            subject.on(.next(()))
        }
        self._forwardToDelegate?.scrollViewDidScroll?(scrollView)
    }
    deinit {
        if let subject = _contentOffsetBehaviorSubject {
            subject.on(.completed)
        }
        if let subject = _contentOffsetPublishSubject {
            subject.on(.completed)
        }
    }
}
#endif