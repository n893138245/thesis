#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIGestureRecognizer {
	public var stateChanged: Signal<Base, Never> {
		return Signal { observer, signalLifetime in
			let receiver = CocoaTarget<Base>(observer) { gestureRecognizer in
				return gestureRecognizer as! Base
			}
			base.addTarget(receiver, action: #selector(receiver.invoke))
			let disposable = lifetime.ended.observeCompleted(observer.sendCompleted)
			signalLifetime.observeEnded { [weak base] in
				disposable?.dispose()
				base?.removeTarget(receiver, action: #selector(receiver.invoke))
			}
		}
	}
}
#endif