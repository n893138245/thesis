public final class RefCountDisposable : DisposeBase, Cancelable {
    private var _lock = SpinLock()
    private var _disposable = nil as Disposable?
    private var _primaryDisposed = false
    private var _count = 0
    public var isDisposed: Bool {
        self._lock.lock(); defer { self._lock.unlock() }
        return self._disposable == nil
    }
    public init(disposable: Disposable) {
        self._disposable = disposable
        super.init()
    }
    public func retain() -> Disposable {
        return self._lock.calculateLocked {
            if self._disposable != nil {
                do {
                    _ = try incrementChecked(&self._count)
                } catch {
                    rxFatalError("RefCountDisposable increment failed")
                }
                return RefCountInnerDisposable(self)
            } else {
                return Disposables.create()
            }
        }
    }
    public func dispose() {
        let oldDisposable: Disposable? = self._lock.calculateLocked {
            if let oldDisposable = self._disposable, !self._primaryDisposed {
                self._primaryDisposed = true
                if self._count == 0 {
                    self._disposable = nil
                    return oldDisposable
                }
            }
            return nil
        }
        if let disposable = oldDisposable {
            disposable.dispose()
        }
    }
    fileprivate func release() {
        let oldDisposable: Disposable? = self._lock.calculateLocked {
            if let oldDisposable = self._disposable {
                do {
                    _ = try decrementChecked(&self._count)
                } catch {
                    rxFatalError("RefCountDisposable decrement on release failed")
                }
                guard self._count >= 0 else {
                    rxFatalError("RefCountDisposable counter is lower than 0")
                }
                if self._primaryDisposed && self._count == 0 {
                    self._disposable = nil
                    return oldDisposable
                }
            }
            return nil
        }
        if let disposable = oldDisposable {
            disposable.dispose()
        }
    }
}
internal final class RefCountInnerDisposable: DisposeBase, Disposable
{
    private let _parent: RefCountDisposable
    private let _isDisposed = AtomicInt(0)
    init(_ parent: RefCountDisposable) {
        self._parent = parent
        super.init()
    }
    internal func dispose()
    {
        if fetchOr(self._isDisposed, 1) == 0 {
            self._parent.release()
        }
    }
}