import class Foundation.NotificationCenter
import struct Foundation.Notification
import RxSwift
extension Reactive where Base: NotificationCenter {
    public func notification(_ name: Notification.Name?, object: AnyObject? = nil) -> Observable<Notification> {
        return Observable.create { [weak object] observer in
            let nsObserver = self.base.addObserver(forName: name, object: object, queue: nil) { notification in
                observer.on(.next(notification))
            }
            return Disposables.create {
                self.base.removeObserver(nsObserver)
            }
        }
    }
}