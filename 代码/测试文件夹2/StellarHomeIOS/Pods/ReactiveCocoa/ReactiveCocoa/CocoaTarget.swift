import Foundation
import ReactiveSwift
internal final class CocoaTarget<Value>: NSObject {
	private enum State {
		case idle
		case sending(queue: [Value])
	}
	private let observer: Signal<Value, Never>.Observer
	private let transform: (Any?) -> Value
	private var state: State
	internal init(_ observer: Signal<Value, Never>.Observer, transform: @escaping (Any?) -> Value) {
		self.observer = observer
		self.transform = transform
		self.state = .idle
	}
	@objc internal func invoke(_ sender: Any?) {
		switch state {
		case .idle:
			state = .sending(queue: [])
			observer.send(value: transform(sender))
			while case let .sending(values) = state {
				guard !values.isEmpty else {
					break
				}
				state = .sending(queue: Array(values.dropFirst()))
				observer.send(value: values[0])
			}
			state = .idle
		case let .sending(values):
			state = .sending(queue: values + [transform(sender)])
		}
	}
}
extension CocoaTarget where Value == Void {
	internal convenience init(_ observer: Signal<(), Never>.Observer) {
		self.init(observer, transform: { _ in })
	}
}