import RxSwift
public struct Binder<Value>: ObserverType {
    public typealias Element = Value
    private let _binding: (Event<Value>) -> Void
    public init<Target: AnyObject>(_ target: Target, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target
        self._binding = { event in
            switch event {
            case .next(let element):
                _ = scheduler.schedule(element) { element in
                    if let target = weakTarget {
                        binding(target, element)
                    }
                    return Disposables.create()
                }
            case .error(let error):
                bindingError(error)
            case .completed:
                break
            }
        }
    }
    public func on(_ event: Event<Value>) {
        self._binding(event)
    }
    public func asObserver() -> AnyObserver<Value> {
        return AnyObserver(eventHandler: self.on)
    }
}