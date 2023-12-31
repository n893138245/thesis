#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
private var rx_tap_key: UInt8 = 0
extension Reactive where Base: UIBarButtonItem {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { element, value in
            element.isEnabled = value
        }
    }
    public var title: Binder<String> {
        return Binder(self.base) { element, value in
            element.title = value
        }
    }
    public var tap: ControlEvent<()> {
        let source = lazyInstanceObservable(&rx_tap_key) { () -> Observable<()> in
            Observable.create { [weak control = self.base] observer in
                guard let control = control else {
                    observer.on(.completed)
                    return Disposables.create()
                }
                let target = BarButtonItemTarget(barButtonItem: control) {
                    observer.on(.next(()))
                }
                return target
            }
            .takeUntil(self.deallocated)
            .share()
        }
        return ControlEvent(events: source)
    }
}
@objc
final class BarButtonItemTarget: RxTarget {
    typealias Callback = () -> Void
    weak var barButtonItem: UIBarButtonItem?
    var callback: Callback!
    init(barButtonItem: UIBarButtonItem, callback: @escaping () -> Void) {
        self.barButtonItem = barButtonItem
        self.callback = callback
        super.init()
        barButtonItem.target = self
        barButtonItem.action = #selector(BarButtonItemTarget.action(_:))
    }
    override func dispose() {
        super.dispose()
#if DEBUG
        MainScheduler.ensureRunningOnMainThread()
#endif
        barButtonItem?.target = nil
        barButtonItem?.action = nil
        callback = nil
    }
    @objc func action(_ sender: AnyObject) {
        callback()
    }
}
#endif