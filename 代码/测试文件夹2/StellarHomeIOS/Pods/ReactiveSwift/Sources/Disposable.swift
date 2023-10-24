public protocol Disposable: AnyObject {
	var isDisposed: Bool { get }
	func dispose()
}
private enum DisposableState: Int32 {
	case active
	case disposed
}
extension UnsafeAtomicState where State == DisposableState {
	@inline(__always)
	fileprivate func tryDispose() -> Bool {
		return tryTransition(from: .active, to: .disposed)
	}
}
internal final class _SimpleDisposable: Disposable {
	private let state = UnsafeAtomicState<DisposableState>(.active)
	var isDisposed: Bool {
		return state.is(.disposed)
	}
	func dispose() {
		_ = state.tryDispose()
	}
	deinit {
		state.deinitialize()
	}
}
internal final class NopDisposable: Disposable {
	static let shared = NopDisposable()
	var isDisposed = true
	func dispose() {}
	private init() {}
}
public final class AnyDisposable: Disposable {
	private final class ActionDisposable: Disposable {
		let state: UnsafeAtomicState<DisposableState>
		var action: (() -> Void)?
		var isDisposed: Bool {
			return state.is(.disposed)
		}
		init(_ action: (() -> Void)?) {
			self.state = UnsafeAtomicState(.active)
			self.action = action
		}
		deinit {
			state.deinitialize()
		}
		func dispose() {
			if state.tryDispose() {
				action?()
				action = nil
			}
		}
	}
	private let base: Disposable
	public var isDisposed: Bool {
		return base.isDisposed
	}
	public init(_ action: @escaping () -> Void) {
		base = ActionDisposable(action)
	}
	public init() {
		base = _SimpleDisposable()
	}
	public init(_ disposable: Disposable) {
		base = disposable
	}
	public func dispose() {
		base.dispose()
	}
}
public final class CompositeDisposable: Disposable {
	private let disposables: Atomic<Bag<Disposable>?>
	private var state: UnsafeAtomicState<DisposableState>
	public var isDisposed: Bool {
		return state.is(.disposed)
	}
	public init<S: Sequence>(_ disposables: S) where S.Iterator.Element == Disposable {
		let bag = Bag(disposables)
		self.disposables = Atomic(bag)
		self.state = UnsafeAtomicState(.active)
	}
	public convenience init<S: Sequence>(_ disposables: S)
		where S.Iterator.Element == Disposable?
	{
		self.init(disposables.compactMap { $0 })
	}
	public convenience init() {
		self.init([Disposable]())
	}
	public func dispose() {
		if state.tryDispose(), let disposables = disposables.swap(nil) {
			for disposable in disposables {
				disposable.dispose()
			}
		}
	}
	@discardableResult
	public func add(_ disposable: Disposable?) -> Disposable? {
		guard let d = disposable, !d.isDisposed, !isDisposed else {
			disposable?.dispose()
			return nil
		}
		return disposables.modify { disposables in
			guard let token = disposables?.insert(d) else { return nil }
			return AnyDisposable { [weak self] in
				self?.disposables.modify {
					$0?.remove(using: token)
				}
			}
		}
	}
	@discardableResult
	public func add(_ action: @escaping () -> Void) -> Disposable? {
		return add(AnyDisposable(action))
	}
	deinit {
		state.deinitialize()
	}
	@discardableResult
	public static func += (lhs: CompositeDisposable, rhs: Disposable?) -> Disposable? {
		return lhs.add(rhs)
	}
	@discardableResult
	public static func += (lhs: CompositeDisposable, rhs: @escaping () -> Void) -> Disposable? {
		return lhs.add(rhs)
	}
}
public final class ScopedDisposable<Inner: Disposable>: Disposable {
	public let inner: Inner
	public var isDisposed: Bool {
		return inner.isDisposed
	}
	public init(_ disposable: Inner) {
		inner = disposable
	}
	deinit {
		dispose()
	}
	public func dispose() {
		return inner.dispose()
	}
}
extension ScopedDisposable where Inner == AnyDisposable {
	public convenience init(_ disposable: Disposable) {
		self.init(Inner(disposable))
	}
}
extension ScopedDisposable where Inner == CompositeDisposable {
	@discardableResult
	public static func += (lhs: ScopedDisposable<CompositeDisposable>, rhs: Disposable?) -> Disposable? {
		return lhs.inner.add(rhs)
	}
	@discardableResult
	public static func += (lhs: ScopedDisposable<CompositeDisposable>, rhs: @escaping () -> Void) -> Disposable? {
		return lhs.inner.add(rhs)
	}
}
public final class SerialDisposable: Disposable {
	private let _inner: Atomic<Disposable?>
	private var state: UnsafeAtomicState<DisposableState>
	public var isDisposed: Bool {
		return state.is(.disposed)
	}
	public var inner: Disposable? {
		get {
			return _inner.value
		}
		set(disposable) {
			_inner.swap(disposable)?.dispose()
			if let disposable = disposable, isDisposed {
				disposable.dispose()
			}
		}
	}
	public init(_ disposable: Disposable? = nil) {
		self._inner = Atomic(disposable)
		self.state = UnsafeAtomicState(DisposableState.active)
	}
	public func dispose() {
		if state.tryDispose() {
			_inner.swap(nil)?.dispose()
		}
	}
	deinit {
		state.deinitialize()
	}
}