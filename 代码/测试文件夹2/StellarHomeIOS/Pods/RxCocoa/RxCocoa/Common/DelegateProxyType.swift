#if !os(Linux)
    import func Foundation.objc_getAssociatedObject
    import func Foundation.objc_setAssociatedObject
    import RxSwift
public protocol DelegateProxyType: class {
    associatedtype ParentObject: AnyObject
    associatedtype Delegate
    static func registerKnownImplementations()
    static var identifier: UnsafeRawPointer { get }
    static func currentDelegate(for object: ParentObject) -> Delegate?
    static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject)
    func forwardToDelegate() -> Delegate?
    func setForwardToDelegate(_ forwardToDelegate: Delegate?, retainDelegate: Bool)
}
extension DelegateProxyType {
    public static var identifier: UnsafeRawPointer {
        let delegateIdentifier = ObjectIdentifier(Delegate.self)
        let integerIdentifier = Int(bitPattern: delegateIdentifier)
        return UnsafeRawPointer(bitPattern: integerIdentifier)!
    }
}
extension DelegateProxyType {
    static func _currentDelegate(for object: ParentObject) -> AnyObject? {
        return currentDelegate(for: object).map { $0 as AnyObject }
    }
    static func _setCurrentDelegate(_ delegate: AnyObject?, to object: ParentObject) {
        return setCurrentDelegate(castOptionalOrFatalError(delegate), to: object)
    }
    func _forwardToDelegate() -> AnyObject? {
        return self.forwardToDelegate().map { $0 as AnyObject }
    }
    func _setForwardToDelegate(_ forwardToDelegate: AnyObject?, retainDelegate: Bool) {
        return self.setForwardToDelegate(castOptionalOrFatalError(forwardToDelegate), retainDelegate: retainDelegate)
    }
}
extension DelegateProxyType {
    public static func register<Parent>(make: @escaping (Parent) -> Self) {
        self.factory.extend(make: make)
    }
    public static func createProxy(for object: AnyObject) -> Self {
        return castOrFatalError(factory.createProxy(for: object))
    }
    public static func proxy(for object: ParentObject) -> Self {
        MainScheduler.ensureRunningOnMainThread()
        let maybeProxy = self.assignedProxy(for: object)
        let proxy: AnyObject
        if let existingProxy = maybeProxy {
            proxy = existingProxy
        }
        else {
            proxy = castOrFatalError(self.createProxy(for: object))
            self.assignProxy(proxy, toObject: object)
            assert(self.assignedProxy(for: object) === proxy)
        }
        let currentDelegate = self._currentDelegate(for: object)
        let delegateProxy: Self = castOrFatalError(proxy)
        if currentDelegate !== delegateProxy {
            delegateProxy._setForwardToDelegate(currentDelegate, retainDelegate: false)
            assert(delegateProxy._forwardToDelegate() === currentDelegate)
            self._setCurrentDelegate(proxy, to: object)
            assert(self._currentDelegate(for: object) === proxy)
            assert(delegateProxy._forwardToDelegate() === currentDelegate)
        }
        return delegateProxy
    }
    public static func installForwardDelegate(_ forwardDelegate: Delegate, retainDelegate: Bool, onProxyForObject object: ParentObject) -> Disposable {
        weak var weakForwardDelegate: AnyObject? = forwardDelegate as AnyObject
        let proxy = self.proxy(for: object)
        assert(proxy._forwardToDelegate() === nil, "This is a feature to warn you that there is already a delegate (or data source) set somewhere previously. The action you are trying to perform will clear that delegate (data source) and that means that some of your features that depend on that delegate (data source) being set will likely stop working.\n" +
            "If you are ok with this, try to set delegate (data source) to `nil` in front of this operation.\n" +
            " This is the source object value: \(object)\n" +
            " This is the original delegate (data source) value: \(proxy.forwardToDelegate()!)\n" +
            "Hint: Maybe delegate was already set in xib or storyboard and now it's being overwritten in code.\n")
        proxy.setForwardToDelegate(forwardDelegate, retainDelegate: retainDelegate)
        return Disposables.create {
            MainScheduler.ensureRunningOnMainThread()
            let delegate: AnyObject? = weakForwardDelegate
            assert(delegate == nil || proxy._forwardToDelegate() === delegate, "Delegate was changed from time it was first set. Current \(String(describing: proxy.forwardToDelegate())), and it should have been \(proxy)")
            proxy.setForwardToDelegate(nil, retainDelegate: retainDelegate)
        }
    }
}
extension DelegateProxyType {
    private static var factory: DelegateProxyFactory {
        return DelegateProxyFactory.sharedFactory(for: self)
    }
    private static func assignedProxy(for object: ParentObject) -> AnyObject? {
        let maybeDelegate = objc_getAssociatedObject(object, self.identifier)
        return castOptionalOrFatalError(maybeDelegate)
    }
    private static func assignProxy(_ proxy: AnyObject, toObject object: ParentObject) {
        objc_setAssociatedObject(object, self.identifier, proxy, .OBJC_ASSOCIATION_RETAIN)
    }
}
public protocol HasDelegate: AnyObject {
    associatedtype Delegate
    var delegate: Delegate? { get set }
}
extension DelegateProxyType where ParentObject: HasDelegate, Self.Delegate == ParentObject.Delegate {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.delegate
    }
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.delegate = delegate
    }
}
public protocol HasDataSource: AnyObject {
    associatedtype DataSource
    var dataSource: DataSource? { get set }
}
extension DelegateProxyType where ParentObject: HasDataSource, Self.Delegate == ParentObject.DataSource {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.dataSource
    }
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.dataSource = delegate
    }
}
@available(iOS 10.0, tvOS 10.0, *)
public protocol HasPrefetchDataSource: AnyObject {
    associatedtype PrefetchDataSource
    var prefetchDataSource: PrefetchDataSource? { get set }
}
@available(iOS 10.0, tvOS 10.0, *)
extension DelegateProxyType where ParentObject: HasPrefetchDataSource, Self.Delegate == ParentObject.PrefetchDataSource {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.prefetchDataSource
    }
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.prefetchDataSource = delegate
    }
}
    #if os(iOS) || os(tvOS)
        import UIKit
        extension ObservableType {
            func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void)
                -> Disposable
                where DelegateProxy.ParentObject: UIView
                , DelegateProxy.Delegate: AnyObject {
                let proxy = DelegateProxy.proxy(for: object)
                let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)
                object.layoutIfNeeded()
                let subscription = self.asObservable()
                    .observeOn(MainScheduler())
                    .catchError { error in
                        bindingError(error)
                        return Observable.empty()
                    }
                    .concat(Observable.never())
                    .takeUntil(object.rx.deallocated)
                    .subscribe { [weak object] (event: Event<Element>) in
                        if let object = object {
                            assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                        }
                        binding(proxy, event)
                        switch event {
                        case .error(let error):
                            bindingError(error)
                            unregisterDelegate.dispose()
                        case .completed:
                            unregisterDelegate.dispose()
                        default:
                            break
                        }
                    }
                return Disposables.create { [weak object] in
                    subscription.dispose()
                    object?.layoutIfNeeded()
                    unregisterDelegate.dispose()
                }
            }
        }
    #endif
    private class DelegateProxyFactory {
        private static var _sharedFactories: [UnsafeRawPointer: DelegateProxyFactory] = [:]
        fileprivate static func sharedFactory<DelegateProxy: DelegateProxyType>(for proxyType: DelegateProxy.Type) -> DelegateProxyFactory {
            MainScheduler.ensureRunningOnMainThread()
            let identifier = DelegateProxy.identifier
            if let factory = _sharedFactories[identifier] {
                return factory
            }
            let factory = DelegateProxyFactory(for: proxyType)
            _sharedFactories[identifier] = factory
            DelegateProxy.registerKnownImplementations()
            return factory
        }
        private var _factories: [ObjectIdentifier: ((AnyObject) -> AnyObject)]
        private var _delegateProxyType: Any.Type
        private var _identifier: UnsafeRawPointer
        private init<DelegateProxy: DelegateProxyType>(for proxyType: DelegateProxy.Type) {
            self._factories = [:]
            self._delegateProxyType = proxyType
            self._identifier = proxyType.identifier
        }
        fileprivate func extend<DelegateProxy: DelegateProxyType, ParentObject>(make: @escaping (ParentObject) -> DelegateProxy) {
                MainScheduler.ensureRunningOnMainThread()
                precondition(self._identifier == DelegateProxy.identifier, "Delegate proxy has inconsistent identifier")
                guard self._factories[ObjectIdentifier(ParentObject.self)] == nil else {
                    rxFatalError("The factory of \(ParentObject.self) is duplicated. DelegateProxy is not allowed of duplicated base object type.")
                }
                self._factories[ObjectIdentifier(ParentObject.self)] = { make(castOrFatalError($0)) }
        }
        fileprivate func createProxy(for object: AnyObject) -> AnyObject {
            MainScheduler.ensureRunningOnMainThread()
            var maybeMirror: Mirror? = Mirror(reflecting: object)
            while let mirror = maybeMirror {
                if let factory = self._factories[ObjectIdentifier(mirror.subjectType)] {
                    return factory(object)
                }
                maybeMirror = mirror.superclassMirror
            }
            rxFatalError("DelegateProxy has no factory of \(object). Implement DelegateProxy subclass for \(object) first.")
        }
    }
#endif