public final class SerialDisposable : DisposeBase, Cancelable {
    private var _lock = SpinLock()
    private var _current = nil as Disposable?
    private var _isDisposed = false
    public var isDisposed: Bool {
        return self._isDisposed
    }
    override public init() {
        super.init()
    }
    public var disposable: Disposable {
        get {
            return self._lock.calculateLocked {
                return self._current ?? Disposables.create()
            }
        }
        set (newDisposable) {
            let disposable: Disposable? = self._lock.calculateLocked {
                if self._isDisposed {
                    return newDisposable
                }
                else {
                    let toDispose = self._current
                    self._current = newDisposable
                    return toDispose
                }
            }
            if let disposable = disposable {
                disposable.dispose()
            }
        }
    }
    public func dispose() {
        self._dispose()?.dispose()
    }
    private func _dispose() -> Disposable? {
        self._lock.lock(); defer { self._lock.unlock() }
        if self._isDisposed {
            return nil
        }
        else {
            self._isDisposed = true
            let current = self._current
            self._current = nil
            return current
        }
    }
}