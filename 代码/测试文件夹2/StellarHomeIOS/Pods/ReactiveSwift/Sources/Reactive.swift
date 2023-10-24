public protocol ReactiveExtensionsProvider {}
extension ReactiveExtensionsProvider {
	public var reactive: Reactive<Self> {
		return Reactive(self)
	}
	public static var reactive: Reactive<Self>.Type {
		return Reactive<Self>.self
	}
}
public struct Reactive<Base> {
	public let base: Base
	fileprivate init(_ base: Base) {
		self.base = base
	}
}