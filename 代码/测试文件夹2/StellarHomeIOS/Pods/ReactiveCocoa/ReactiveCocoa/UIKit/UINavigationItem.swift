#if canImport(UIKit) && !os(watchOS)
import ReactiveSwift
import UIKit
extension Reactive where Base: UINavigationItem {
	public var title: BindingTarget<String?> {
		return makeBindingTarget { $0.title = $1 }
	}
	public var titleView: BindingTarget<UIView?> {
		return makeBindingTarget { $0.titleView = $1 }
	}
#if os(iOS)
	public var prompt: BindingTarget<String?> {
		return makeBindingTarget { $0.prompt = $1 }
	}
	public var backBarButtonItem: BindingTarget<UIBarButtonItem?> {
		return makeBindingTarget { $0.backBarButtonItem = $1 }
	}
	public var hidesBackButton: BindingTarget<Bool> {
		return makeBindingTarget { $0.hidesBackButton = $1 }
	}
#endif
	public var leftBarButtonItems: BindingTarget<[UIBarButtonItem]?> {
		return makeBindingTarget { $0.leftBarButtonItems = $1 }
	}
	public var rightBarButtonItems: BindingTarget<[UIBarButtonItem]?> {
		return makeBindingTarget { $0.rightBarButtonItems = $1 }
	}
	public var leftBarButtonItem: BindingTarget<UIBarButtonItem?> {
		return makeBindingTarget { $0.leftBarButtonItem = $1 }
	}
	public var rightBarButtonItem: BindingTarget<UIBarButtonItem?> {
		return makeBindingTarget { $0.rightBarButtonItem = $1 }
	}
#if os(iOS)
	@available(iOS 5.0, *)
	public var leftItemsSupplementBackButton: BindingTarget<Bool> {
		return makeBindingTarget { $0.leftItemsSupplementBackButton = $1 }
	}
	@available(iOS 11.0, *)
	public var largeTitleDisplayMode: BindingTarget<UINavigationItem.LargeTitleDisplayMode> {
		return makeBindingTarget { $0.largeTitleDisplayMode = $1 }
	}
	@available(iOS 11.0, *)
	public var searchController: BindingTarget<UISearchController?> {
		return makeBindingTarget { $0.searchController = $1 }
	}
	@available(iOS 11.0, *)
	public var hidesSearchBarWhenScrolling: BindingTarget<Bool> {
		return makeBindingTarget { $0.hidesSearchBarWhenScrolling = $1 }
	}
#endif
}
#endif