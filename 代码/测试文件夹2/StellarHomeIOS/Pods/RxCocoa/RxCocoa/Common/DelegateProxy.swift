#if !os(Linux)
    import RxSwift
    #if SWIFT_PACKAGE && !os(Linux)
        import RxCocoaRuntime
    #endif
    open class DelegateProxy<P: AnyObject, D>: _RXDelegateProxy {
        public typealias ParentObject = P
        public typealias Delegate = D
        private var _sentMessageForSelector = [Selector: MessageDispatcher]()
        private var _methodInvokedForSelector = [Selector: MessageDispatcher]()
        private weak var _parentObject: ParentObject?
        private let _currentDelegateFor: (ParentObject) -> AnyObject?
        private let _setCurrentDelegateTo: (AnyObject?, ParentObject) -> Void
        public init<Proxy: DelegateProxyType>(parentObject: ParentObject, delegateProxy: Proxy.Type)
            where Proxy: DelegateProxy<ParentObject, Delegate>, Proxy.ParentObject == ParentObject, Proxy.Delegate == Delegate {
            self._parentObject = parentObject
            self._currentDelegateFor = delegateProxy._currentDelegate
            self._setCurrentDelegateTo = delegateProxy._setCurrentDelegate
            MainScheduler.ensureRunningOnMainThread()
            #if TRACE_RESOURCES
                _ = Resources.incrementTotal()
            #endif
            super.init()
        }
        open func sentMessage(_ selector: Selector) -> Observable<[Any]> {
            MainScheduler.ensureRunningOnMainThread()
            let subject = self._sentMessageForSelector[selector]
            if let subject = subject {
                return subject.asObservable()
            }
            else {
                let subject = MessageDispatcher(selector: selector, delegateProxy: self)
                self._sentMessageForSelector[selector] = subject
                return subject.asObservable()
            }
        }
        open func methodInvoked(_ selector: Selector) -> Observable<[Any]> {
            MainScheduler.ensureRunningOnMainThread()
            let subject = self._methodInvokedForSelector[selector]
            if let subject = subject {
                return subject.asObservable()
            }
            else {
                let subject = MessageDispatcher(selector: selector, delegateProxy: self)
                self._methodInvokedForSelector[selector] = subject
                return subject.asObservable()
            }
        }
        fileprivate func checkSelectorIsObservable(_ selector: Selector) {
            MainScheduler.ensureRunningOnMainThread()
            if self.hasWiredImplementation(for: selector) {
                print("⚠️ Delegate proxy is already implementing `\(selector)`, a more performant way of registering might exist.")
                return
            }
            if self.voidDelegateMethodsContain(selector) {
                return
            }
            if !(self._forwardToDelegate?.responds(to: selector) ?? true) {
                print("⚠️ Using delegate proxy dynamic interception method but the target delegate object doesn't respond to the requested selector. " +
                    "In case pure Swift delegate proxy is being used please use manual observing method by using`PublishSubject`s. " +
                    " (selector: `\(selector)`, forwardToDelegate: `\(self._forwardToDelegate ?? self)`)")
            }
        }
        open override func _sentMessage(_ selector: Selector, withArguments arguments: [Any]) {
            self._sentMessageForSelector[selector]?.on(.next(arguments))
        }
        open override func _methodInvoked(_ selector: Selector, withArguments arguments: [Any]) {
            self._methodInvokedForSelector[selector]?.on(.next(arguments))
        }
        open func forwardToDelegate() -> Delegate? {
            return castOptionalOrFatalError(self._forwardToDelegate)
        }
        open func setForwardToDelegate(_ delegate: Delegate?, retainDelegate: Bool) {
            #if DEBUG 
                MainScheduler.ensureRunningOnMainThread()
            #endif
            self._setForwardToDelegate(delegate, retainDelegate: retainDelegate)
            let sentSelectors: [Selector] = self._sentMessageForSelector.values.filter { $0.hasObservers }.map { $0.selector }
            let invokedSelectors: [Selector] = self._methodInvokedForSelector.values.filter { $0.hasObservers }.map { $0.selector }
            let allUsedSelectors = sentSelectors + invokedSelectors
            for selector in Set(allUsedSelectors) {
                self.checkSelectorIsObservable(selector)
            }
            self.reset()
        }
        private func hasObservers(selector: Selector) -> Bool {
            return (self._sentMessageForSelector[selector]?.hasObservers ?? false)
                || (self._methodInvokedForSelector[selector]?.hasObservers ?? false)
        }
        override open func responds(to aSelector: Selector!) -> Bool {
            return super.responds(to: aSelector)
                || (self._forwardToDelegate?.responds(to: aSelector) ?? false)
                || (self.voidDelegateMethodsContain(aSelector) && self.hasObservers(selector: aSelector))
        }
        fileprivate func reset() {
            guard let parentObject = self._parentObject else { return }
            let maybeCurrentDelegate = self._currentDelegateFor(parentObject)
            if maybeCurrentDelegate === self {
                self._setCurrentDelegateTo(nil, parentObject)
                self._setCurrentDelegateTo(castOrFatalError(self), parentObject)
            }
        }
        deinit {
            for v in self._sentMessageForSelector.values {
                v.on(.completed)
            }
            for v in self._methodInvokedForSelector.values {
                v.on(.completed)
            }
            #if TRACE_RESOURCES
                _ = Resources.decrementTotal()
            #endif
        }
    }
    private let mainScheduler = MainScheduler()
    private final class MessageDispatcher {
        private let dispatcher: PublishSubject<[Any]>
        private let result: Observable<[Any]>
        fileprivate let selector: Selector
        init<P, D>(selector: Selector, delegateProxy _delegateProxy: DelegateProxy<P, D>) {
            weak var weakDelegateProxy = _delegateProxy
            let dispatcher = PublishSubject<[Any]>()
            self.dispatcher = dispatcher
            self.selector = selector
            self.result = dispatcher
                .do(onSubscribed: { weakDelegateProxy?.checkSelectorIsObservable(selector); weakDelegateProxy?.reset() }, onDispose: { weakDelegateProxy?.reset() })
                .share()
                .subscribeOn(mainScheduler)
        }
        var on: (Event<[Any]>) -> Void {
            return self.dispatcher.on
        }
        var hasObservers: Bool {
            return self.dispatcher.hasObservers
        }
        func asObservable() -> Observable<[Any]> {
            return self.result
        }
    }
#endif