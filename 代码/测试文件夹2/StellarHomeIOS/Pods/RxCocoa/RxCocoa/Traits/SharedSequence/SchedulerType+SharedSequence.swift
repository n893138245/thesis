import RxSwift
public enum SharingScheduler {
    public private(set) static var make: () -> SchedulerType = { MainScheduler() }
    static public func mock(scheduler: SchedulerType, action: () -> Void) {
        return mock(makeScheduler: { scheduler }, action: action)
    }
    static public func mock(makeScheduler: @escaping () -> SchedulerType, action: () -> Void) {
        let originalMake = make
        make = makeScheduler
        action()
        _forceCompilerToStopDoingInsaneOptimizationsThatBreakCode(makeScheduler)
        make = originalMake
    }
}
#if os(Linux)
    import Glibc
#else
    import func Foundation.arc4random
#endif
func _forceCompilerToStopDoingInsaneOptimizationsThatBreakCode(_ scheduler: () -> SchedulerType) {
    let a: Int32 = 1
#if os(Linux)
    let b = 314 + Int32(Glibc.random() & 1)
#else
    let b = 314 + Int32(arc4random() & 1)
#endif
    if a == b {
        print(scheduler())
    }
}