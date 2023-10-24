#if os(iOS) || os(tvOS)
    import RxSwift
    import UIKit
    extension Reactive where Base: UIScrollView {
        public typealias EndZoomEvent = (view: UIView?, scale: CGFloat)
        public typealias WillEndDraggingEvent = (velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
        public var delegate: DelegateProxy<UIScrollView, UIScrollViewDelegate> {
            return RxScrollViewDelegateProxy.proxy(for: base)
        }
        public var contentOffset: ControlProperty<CGPoint> {
            let proxy = RxScrollViewDelegateProxy.proxy(for: base)
            let bindingObserver = Binder(self.base) { scrollView, contentOffset in
                scrollView.contentOffset = contentOffset
            }
            return ControlProperty(values: proxy.contentOffsetBehaviorSubject, valueSink: bindingObserver)
        }
        public var isScrollEnabled: Binder<Bool> {
            return Binder(self.base) { scrollView, scrollEnabled in
                scrollView.isScrollEnabled = scrollEnabled
            }
        }
        public var didScroll: ControlEvent<Void> {
            let source = RxScrollViewDelegateProxy.proxy(for: base).contentOffsetPublishSubject
            return ControlEvent(events: source)
        }
        public var willBeginDecelerating: ControlEvent<Void> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:))).map { _ in }
            return ControlEvent(events: source)
        }
    	public var didEndDecelerating: ControlEvent<Void> {
    		let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:))).map { _ in }
    		return ControlEvent(events: source)
    	}
        public var willBeginDragging: ControlEvent<Void> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:))).map { _ in }
            return ControlEvent(events: source)
        }
        public var willEndDragging: ControlEvent<WillEndDraggingEvent> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
                .map { value -> WillEndDraggingEvent in
                    let velocity = try castOrThrow(CGPoint.self, value[1])
                    let targetContentOffsetValue = try castOrThrow(NSValue.self, value[2])
                    guard let rawPointer = targetContentOffsetValue.pointerValue else { throw RxCocoaError.unknown }
                    let typedPointer = rawPointer.bindMemory(to: CGPoint.self, capacity: MemoryLayout<CGPoint>.size)
                    return (velocity, typedPointer)
            }
            return ControlEvent(events: source)
        }
        public var didEndDragging: ControlEvent<Bool> {
    		let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))).map { value -> Bool in
    			return try castOrThrow(Bool.self, value[1])
    		}
    		return ControlEvent(events: source)
    	}
        public var didZoom: ControlEvent<Void> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidZoom)).map { _ in }
            return ControlEvent(events: source)
        }
        public var didScrollToTop: ControlEvent<Void> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))).map { _ in }
            return ControlEvent(events: source)
        }
        public var didEndScrollingAnimation: ControlEvent<Void> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:))).map { _ in }
            return ControlEvent(events: source)
        }
        public var willBeginZooming: ControlEvent<UIView?> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewWillBeginZooming(_:with:))).map { value -> UIView? in
                return try castOptionalOrThrow(UIView.self, value[1] as AnyObject)
            }
            return ControlEvent(events: source)
        }
        public var didEndZooming: ControlEvent<EndZoomEvent> {
            let source = delegate.methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:))).map { value -> EndZoomEvent in
                return (try castOptionalOrThrow(UIView.self, value[1] as AnyObject), try castOrThrow(CGFloat.self, value[2]))
            }
            return ControlEvent(events: source)
        }
        public func setDelegate(_ delegate: UIScrollViewDelegate)
            -> Disposable {
            return RxScrollViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
        }
    }
#endif