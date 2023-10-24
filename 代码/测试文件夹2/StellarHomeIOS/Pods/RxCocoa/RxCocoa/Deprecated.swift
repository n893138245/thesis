import RxSwift
import Dispatch
import Foundation
extension ObservableType {
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self.subscribe(observer)
    }
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element? {
        return self.map { $0 }.subscribe(observer)
    }
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo(_ variable: Variable<Element>) -> Disposable {
        return self.subscribe { e in
            switch e {
            case let .next(element):
                variable.value = element
            case let .error(error):
                let error = "Binding error to variable: \(error)"
                #if DEBUG
                    rxFatalError(error)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo(_ variable: Variable<Element?>) -> Disposable {
        return self.map { $0 as Element? }.bindTo(variable)
    }
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo<Result>(_ binder: (Self) -> Result) -> Result {
        return binder(self)
    }
    @available(*, deprecated, renamed: "bind(to:)")
    public func bindTo<R1, R2>(_ binder: (Self) -> (R1) -> R2, curriedArgument: R1) -> R2 {
        return binder(self)(curriedArgument)
    }
    @available(*, deprecated, renamed: "bind(onNext:)")
    public func bindNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext, onError: { error in
            let error = "Binding error: \(error)"
            #if DEBUG
                rxFatalError(error)
            #else
                print(error)
            #endif
        })
    }
}
#if os(iOS) || os(tvOS)
    import UIKit
    extension NSTextStorage {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxTextStorageDelegateProxy {
            fatalError()
        }
    }
    extension UIScrollView {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxScrollViewDelegateProxy {
            fatalError()
        }
    }
    extension UICollectionView {
        @available(*, unavailable, message: "createRxDataSourceProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDataSourceProxy() -> RxCollectionViewDataSourceProxy {
            fatalError()
        }
    }
    extension UITableView {
        @available(*, unavailable, message: "createRxDataSourceProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDataSourceProxy() -> RxTableViewDataSourceProxy {
            fatalError()
        }
    }
    extension UINavigationBar {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxNavigationControllerDelegateProxy {
            fatalError()
        }
    }
    extension UINavigationController {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxNavigationControllerDelegateProxy {
            fatalError()
        }
    }
    extension UITabBar {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxTabBarDelegateProxy {
            fatalError()
        }
    }
    extension UITabBarController {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxTabBarControllerDelegateProxy {
            fatalError()
        }
    }
    extension UISearchBar {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxSearchBarDelegateProxy {
            fatalError()
        }
    }
#endif
#if os(iOS)
    extension UISearchController {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxSearchControllerDelegateProxy {
            fatalError()
        }
    }
    extension UIPickerView {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxPickerViewDelegateProxy {
            fatalError()
        }
        @available(*, unavailable, message: "createRxDataSourceProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDataSourceProxy() -> RxPickerViewDataSourceProxy {
            fatalError()
        }
    }
#endif
#if os(macOS)
    import Cocoa
    extension NSTextField {
        @available(*, unavailable, message: "createRxDelegateProxy is now unavailable, check DelegateProxyFactory")
        public func createRxDelegateProxy() -> RxTextFieldDelegateProxy {
            fatalError()
        }
    }
#endif
@available(*, deprecated, renamed: "SharingScheduler.mock(scheduler:action:)")
public func driveOnScheduler(_ scheduler: SchedulerType, action: () -> Void) {
    SharingScheduler.mock(scheduler: scheduler, action: action)
}
@available(*, deprecated, message: "Variable is deprecated. Please use `BehaviorRelay` as a replacement.")
extension Variable {
    @available(*, deprecated, renamed: "asDriver()")
    public func asSharedSequence<SharingStrategy: SharingStrategyProtocol>(strategy: SharingStrategy.Type = SharingStrategy.self) -> SharedSequence<SharingStrategy, Element> {
        let source = self.asObservable()
            .observeOn(SharingStrategy.scheduler)
        return SharedSequence(source)
    }
}
#if !os(Linux)
extension DelegateProxy {
    @available(*, unavailable, renamed: "assignedProxy(for:)")
    public static func assignedProxyFor(_ object: ParentObject) -> Delegate? {
        fatalError()
    }
    @available(*, unavailable, renamed: "currentDelegate(for:)")
    public static func currentDelegateFor(_ object: ParentObject) -> Delegate? {
        fatalError()
    }
}
#endif
@available(*, deprecated, renamed: "Binder")
public final class UIBindingObserver<UIElement, Value> : ObserverType where UIElement: AnyObject {
    public typealias Element = Value
    weak var UIElement: UIElement?
    let binding: (UIElement, Value) -> Void
    @available(*, deprecated, renamed: "UIBinder.init(_:scheduler:binding:)")
    public init(UIElement: UIElement, binding: @escaping (UIElement, Value) -> Void) {
        self.UIElement = UIElement
        self.binding = binding
    }
    public func on(_ event: Event<Value>) {
        if !DispatchQueue.isMain {
            DispatchQueue.main.async {
                self.on(event)
            }
            return
        }
        switch event {
        case .next(let element):
            if let view = self.UIElement {
                self.binding(view, element)
            }
        case .error(let error):
            bindingError(error)
        case .completed:
            break
        }
    }
    public func asObserver() -> AnyObserver<Value> {
        return AnyObserver(eventHandler: self.on)
    }
}
#if os(iOS)
    extension Reactive where Base: UIRefreshControl {
        @available(*, deprecated, renamed: "isRefreshing")
        public var refreshing: Binder<Bool> {
            return self.isRefreshing
        }
    }
#endif
#if os(iOS) || os(tvOS)
extension Reactive where Base: UIImageView {
    @available(*, deprecated, renamed: "image")
    public func image(transitionType: String? = nil) -> Binder<UIImage?> {
        return Binder(base) { imageView, image in
            if let transitionType = transitionType {
                if image != nil {
                    let transition = CATransition()
                    transition.duration = 0.25
                    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    transition.type = CATransitionType(rawValue: transitionType)
                    imageView.layer.add(transition, forKey: kCATransition)
                }
            }
            else {
                imageView.layer.removeAllAnimations()
            }
            imageView.image = image
        }
    }
}
extension Reactive where Base: UISegmentedControl {
    @available(*, deprecated, renamed: "enabledForSegment(at:)")
    public func enabled(forSegmentAt segmentAt: Int) -> Binder<Bool> {
        return enabledForSegment(at: segmentAt)
    }
}
#endif
#if os(macOS)
    extension Reactive where Base: NSImageView {
        @available(*, deprecated, renamed: "image")
        public func image(transitionType: String? = nil) -> Binder<NSImage?> {
            return Binder(self.base) { control, value in
                if let transitionType = transitionType {
                    if value != nil {
                        let transition = CATransition()
                        transition.duration = 0.25
                        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                        transition.type = CATransitionType(rawValue: transitionType)
                        control.layer?.add(transition, forKey: kCATransition)
                    }
                }
                else {
                    control.layer?.removeAllAnimations()
                }
                control.image = value
            }
        }
    }
#endif
@available(*, deprecated, message: "Variable is deprecated. Please use `BehaviorRelay` as a replacement.")
extension Variable {
    public func asDriver() -> Driver<Element> {
        let source = self.asObservable()
            .observeOn(DriverSharingStrategy.scheduler)
        return Driver(source)
    }
}
private let errorMessage = "`drive*` family of methods can be only called from `MainThread`.\n" +
"This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n"
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    @available(*, deprecated, message: "Variable is deprecated. Please use `BehaviorRelay` as a replacement.")
    public func drive(_ variable: Variable<Element>) -> Disposable {
        MainScheduler.ensureRunningOnMainThread(errorMessage: errorMessage)
        return self.drive(onNext: { e in
            variable.value = e
        })
    }
    @available(*, deprecated, message: "Variable is deprecated. Please use `BehaviorRelay` as a replacement.")
    public func drive(_ variable: Variable<Element?>) -> Disposable {
        MainScheduler.ensureRunningOnMainThread(errorMessage: errorMessage)
        return self.drive(onNext: { e in
            variable.value = e
        })
    }
}
@available(*, deprecated, message: "Variable is deprecated. Please use `BehaviorRelay` as a replacement.")
extension ObservableType {
    public func bind(to variable: Variable<Element>) -> Disposable {
        return self.subscribe { e in
            switch e {
            case let .next(element):
                variable.value = element
            case let .error(error):
                let error = "Binding error to variable: \(error)"
                #if DEBUG
                    rxFatalError(error)
                #else
                    print(error)
                #endif
            case .completed:
                break
            }
        }
    }
    public func bind(to variable: Variable<Element?>) -> Disposable {
        return self.map { $0 as Element? }.bind(to: variable)
    }
}
extension SharedSequenceConvertibleType {
    @available(*, deprecated, message: "Use DispatchTimeInterval overload instead.", renamed: "timeout(_:latest:)")
    public func throttle(_ dueTime: Foundation.TimeInterval, latest: Bool = true)
        -> SharedSequence<SharingStrategy, Element> {
        return throttle(.milliseconds(Int(dueTime * 1000.0)), latest: latest)
    }
    @available(*, deprecated, message: "Use DispatchTimeInterval overload instead.", renamed: "debounce(_:)")
    public func debounce(_ dueTime: Foundation.TimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return debounce(.milliseconds(Int(dueTime * 1000.0)))
    }
}
extension SharedSequenceConvertibleType {
    @available(*, deprecated, message: "Use DispatchTimeInterval overload instead.", renamed: "delay(_:)")
    public func delay(_ dueTime: Foundation.TimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return delay(.milliseconds(Int(dueTime * 1000.0)))
    }
}
extension SharedSequence where Element : RxAbstractInteger {
    @available(*, deprecated, message: "Use DispatchTimeInterval overload instead.", renamed: "interval(_:)")
    public static func interval(_ period: Foundation.TimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return interval(.milliseconds(Int(period * 1000.0)))
    }
}
extension SharedSequence where Element: RxAbstractInteger {
    @available(*, deprecated, message: "Use DispatchTimeInterval overload instead.", renamed: "timer(_:)")
    public static func timer(_ dueTime: Foundation.TimeInterval, period: Foundation.TimeInterval)
        -> SharedSequence<SharingStrategy, Element> {
        return timer(.milliseconds(Int(dueTime * 1000.0)), period: .milliseconds(Int(period * 1000.0)))
    }
}