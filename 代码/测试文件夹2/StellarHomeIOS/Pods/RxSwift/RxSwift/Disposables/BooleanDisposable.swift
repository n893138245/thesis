public final class BooleanDisposable : Cancelable {
    internal static let BooleanDisposableTrue = BooleanDisposable(isDisposed: true)
    private var _isDisposed = false
    public init() {
    }
    public init(isDisposed: Bool) {
        self._isDisposed = isDisposed
    }
    public var isDisposed: Bool {
        return self._isDisposed
    }
    public func dispose() {
        self._isDisposed = true
    }
}