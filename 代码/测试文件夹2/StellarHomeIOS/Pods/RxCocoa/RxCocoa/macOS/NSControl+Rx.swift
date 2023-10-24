#if os(macOS)
import Cocoa
import RxSwift
private var rx_value_key: UInt8 = 0
private var rx_control_events_key: UInt8 = 0
extension Reactive where Base: NSControl {
    public var controlEvent: ControlEvent<()> {
        MainScheduler.ensureRunningOnMainThread()
        let source = self.lazyInstanceObservable(&rx_control_events_key) { () -> Observable<Void> in
            Observable.create { [weak control = self.base] observer in
                MainScheduler.ensureRunningOnMainThread()
                guard let control = control else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                let observer = ControlTarget(control: control) { _ in
                    observer.on(.next(()))
                }
                return observer
            }
			.takeUntil(self.deallocated)
			.share()
        }
        return ControlEvent(events: source)
    }
    public func controlProperty<T>(
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> Void
    ) -> ControlProperty<T> {
        MainScheduler.ensureRunningOnMainThread()
        let source = self.base.rx.lazyInstanceObservable(&rx_value_key) { () -> Observable<()> in
                return Observable.create { [weak weakControl = self.base] (observer: AnyObserver<()>) in
                    guard let control = weakControl else {
                        observer.on(.completed)
                        return Disposables.create()
                    }
                    observer.on(.next(()))
                    let observer = ControlTarget(control: control) { _ in
                        if weakControl != nil {
                            observer.on(.next(()))
                        }
                    }
                    return observer
                }
                .takeUntil(self.deallocated)
                .share(replay: 1, scope: .whileConnected)
            }
            .flatMap { [weak base] _ -> Observable<T> in
                guard let control = base else { return Observable.empty() }
                return Observable.just(getter(control))
            }
        let bindingObserver = Binder(self.base, binding: setter)
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { owner, value in
            owner.isEnabled = value
        }
    }
}
#endif