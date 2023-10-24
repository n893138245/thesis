#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import UIKit
import ReactiveSwift
public enum KeyboardEvent {
	case willShow
	case didShow
	case willHide
	case didHide
	case willChangeFrame
	case didChangeFrame
	fileprivate var notificationName: Notification.Name {
		switch self {
		case .willShow:
			return UIResponder.keyboardWillShowNotification
		case .didShow:
			return UIResponder.keyboardDidShowNotification
		case .willHide:
			return UIResponder.keyboardWillHideNotification
		case .didHide:
			return UIResponder.keyboardDidHideNotification
		case .willChangeFrame:
			return UIResponder.keyboardWillChangeFrameNotification
		case .didChangeFrame:
			return UIResponder.keyboardDidChangeFrameNotification
		}
	}
}
public struct KeyboardChangeContext {
	private let base: [AnyHashable: Any]
	public let event: KeyboardEvent
	public var beginFrame: CGRect {
		return base[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
	}
	public var endFrame: CGRect {
		return base[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
	}
	public var animationCurve: UIView.AnimationCurve {
		let value = base[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
		return UIView.AnimationCurve(rawValue: value.intValue)!
	}
	public var animationDuration: Double {
		return base[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
	}
	@available(iOS 9.0, *)
	public var isLocal: Bool {
		return base[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
	}
	fileprivate init(userInfo: [AnyHashable: Any], event: KeyboardEvent) {
		base = userInfo
		self.event = event
	}
}
extension Reactive where Base: NotificationCenter {
	public func keyboard(_ event: KeyboardEvent) -> Signal<KeyboardChangeContext, Never> {
		return notifications(forName: event.notificationName)
			.map { notification in KeyboardChangeContext(userInfo: notification.userInfo!, event: event) }
	}
	public func keyboard(_ first: KeyboardEvent, _ second: KeyboardEvent, _ tail: KeyboardEvent...) -> Signal<KeyboardChangeContext, Never> {
		let events = [first, second] + tail
		return .merge(events.map(keyboard))
	}
	public var keyboardChange: Signal<KeyboardChangeContext, Never> {
		return keyboard(.willChangeFrame)
	}
}
#endif