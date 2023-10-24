import Foundation
public final class Lifetime {
	private let disposables: CompositeDisposable
	public var ended: Signal<Never, Never> {
		return Signal { observer, lifetime in
			lifetime += (disposables += observer.sendCompleted)
		}
	}
	public var hasEnded: Bool {
		return disposables.isDisposed
	}
	internal init(_ disposables: CompositeDisposable) {
		self.disposables = disposables
	}
	public convenience init(_ token: Token) {
		self.init(token.disposables)
	}
	@discardableResult
	public func observeEnded(_ action: @escaping () -> Void) -> Disposable? {
		return disposables += action
	}
	@discardableResult
	public static func += (lifetime: Lifetime, disposable: Disposable?) -> Disposable? {
		guard let dispose = disposable?.dispose else { return nil }
		return lifetime.observeEnded(dispose)
	}
}
extension Lifetime {
	public static func make() -> (lifetime: Lifetime, token: Token) {
		let token = Token()
		return (Lifetime(token), token)
	}
	public static let empty: Lifetime = {
		let disposables = CompositeDisposable()
		disposables.dispose()
		return Lifetime(disposables)
	}()
}
extension Lifetime {
	public final class Token {
		fileprivate let disposables: CompositeDisposable
		public init() {
			disposables = CompositeDisposable()
		}
		public func dispose() {
			disposables.dispose()
		}
		deinit {
			dispose()
		}
	}
}