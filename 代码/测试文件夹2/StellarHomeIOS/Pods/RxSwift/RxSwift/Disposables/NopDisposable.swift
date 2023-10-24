private struct NopDisposable : Disposable {
    fileprivate static let noOp: Disposable = NopDisposable()
    private init() {
    }
    public func dispose() {
    }
}
extension Disposables {
    static public func create() -> Disposable {
        return NopDisposable.noOp
    }
}