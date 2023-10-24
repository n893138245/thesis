#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UIViewController {
	public var title: BindingTarget<String?> {
		return makeBindingTarget({ $0.title = $1 })
	}
	public var viewWillAppear: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewWillAppear))
	}
	public var viewDidAppear: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewDidAppear))
	}
	public var viewWillDisappear: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewWillDisappear))
	}
	public var viewDidDisappear: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewDidDisappear))
	}
	public var viewWillLayoutSubviews: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewWillLayoutSubviews))
	}
	public var viewDidLayoutSubviews: Signal<Void, Never> {
		return trigger(for: #selector(Base.viewDidLayoutSubviews))
	}
}
#endif