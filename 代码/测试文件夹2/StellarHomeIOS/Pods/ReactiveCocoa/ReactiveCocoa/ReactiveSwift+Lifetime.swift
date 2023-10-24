import ReactiveSwift
extension Signal {
	public func take(duringLifetimeOf object: AnyObject) -> Signal<Value, Error> {
		return take(during: Lifetime.of(object))
	}
}
extension SignalProducer {
	public func take(duringLifetimeOf object: AnyObject) -> SignalProducer<Value, Error> {
		return take(during: Lifetime.of(object))
	}
}