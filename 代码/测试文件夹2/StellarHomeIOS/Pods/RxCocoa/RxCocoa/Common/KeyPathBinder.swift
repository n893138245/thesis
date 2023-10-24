import RxSwift
extension Reactive where Base: AnyObject {
    public subscript<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>) -> Binder<Value> {
        return Binder(self.base) { base, value in
            base[keyPath: keyPath] = value
        }
    }
    public subscript<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>, on scheduler: ImmediateSchedulerType) -> Binder<Value> {
        return Binder(self.base, scheduler: scheduler) { base, value in
            base[keyPath: keyPath] = value
        }
    }
}