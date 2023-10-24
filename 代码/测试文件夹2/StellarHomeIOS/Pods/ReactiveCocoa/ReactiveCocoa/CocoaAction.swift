import Foundation
import ReactiveSwift
public final class CocoaAction<Sender>: NSObject {
	public static var selector: Selector {
		return #selector(CocoaAction<Sender>.execute(_:))
	}
	public let isEnabled: Property<Bool>
	public let isExecuting: Property<Bool>
	private let _execute: (Sender) -> Void
	public init<Input, Output, Error>(_ action: Action<Input, Output, Error>, _ inputTransform: @escaping (Sender) -> Input) {
		_execute = { sender in
			let producer = action.apply(inputTransform(sender))
			producer.start()
		}
		isEnabled = Property(initial: action.isEnabled.value,
		                     then: action.isEnabled.producer.observe(on: UIScheduler()))
		isExecuting = Property(initial: action.isExecuting.value,
		                       then: action.isExecuting.producer.observe(on: UIScheduler()))
		super.init()
	}
	public convenience init<Output, Error>(_ action: Action<(), Output, Error>) {
		self.init(action, { _ in })
	}
	public convenience init<Input, Output, Error>(_ action: Action<Input, Output, Error>, input: Input) {
		self.init(action, { _ in input })
	}
	@IBAction public func execute(_ sender: Any) {
		_execute(sender as! Sender)
	}
}