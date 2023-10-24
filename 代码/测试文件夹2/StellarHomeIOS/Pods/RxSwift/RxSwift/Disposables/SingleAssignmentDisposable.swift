public final class SingleAssignmentDisposable : DisposeBase, Cancelable {
    private enum DisposeState: Int32 {
        case disposed = 1
        case disposableSet = 2
    }
    private let _state = AtomicInt(0)
    private var _disposable = nil as Disposable?
    public var isDisposed: Bool {
        return isFlagSet(self._state, DisposeState.disposed.rawValue)
    }
    public override init() {
        super.init()
    }
    public func setDisposable(_ disposable: Disposable) {
        self._disposable = disposable
        let previousState = fetchOr(self._state, DisposeState.disposableSet.rawValue)
        if (previousState & DisposeState.disposableSet.rawValue) != 0 {
            rxFatalError("oldState.disposable != nil")
        }
        if (previousState & DisposeState.disposed.rawValue) != 0 {
            disposable.dispose()
            self._disposable = nil
        }
    }
    public func dispose() {
        let previousState = fetchOr(self._state, DisposeState.disposed.rawValue)
        if (previousState & DisposeState.disposed.rawValue) != 0 {
            return
        }
        if (previousState & DisposeState.disposableSet.rawValue) != 0 {
            guard let disposable = self._disposable else {
                rxFatalError("Disposable not set")
            }
            disposable.dispose()
            self._disposable = nil
        }
    }
}