protocol Lock {
    func lock()
    func unlock()
}
typealias SpinLock = RecursiveLock
extension RecursiveLock : Lock {
    @inline(__always)
    final func performLocked(_ action: () -> Void) {
        self.lock(); defer { self.unlock() }
        action()
    }
    @inline(__always)
    final func calculateLocked<T>(_ action: () -> T) -> T {
        self.lock(); defer { self.unlock() }
        return action()
    }
    @inline(__always)
    final func calculateLockedOrFail<T>(_ action: () throws -> T) throws -> T {
        self.lock(); defer { self.unlock() }
        let result = try action()
        return result
    }
}