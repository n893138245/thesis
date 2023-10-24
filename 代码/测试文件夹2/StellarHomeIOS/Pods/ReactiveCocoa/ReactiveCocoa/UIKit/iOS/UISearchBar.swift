#if canImport(UIKit) && !os(tvOS) && !os(watchOS)
import ReactiveSwift
import UIKit
private class SearchBarDelegateProxy: DelegateProxy<UISearchBarDelegate>, UISearchBarDelegate {
	@objc func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		forwardee?.searchBarTextDidBeginEditing?(searchBar)
	}
	@objc func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		forwardee?.searchBarTextDidEndEditing?(searchBar)
	}
	@objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		forwardee?.searchBar?(searchBar, textDidChange: searchText)
	}
	@objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		forwardee?.searchBarCancelButtonClicked?(searchBar)
	}
	@objc func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		forwardee?.searchBarSearchButtonClicked?(searchBar)
	}
	@objc func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		forwardee?.searchBarBookmarkButtonClicked?(searchBar)
	}
	@objc func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
		forwardee?.searchBarResultsListButtonClicked?(searchBar)
	}
	@objc func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		forwardee?.searchBar?(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
	}
}
extension Reactive where Base: UISearchBar {
	private var proxy: SearchBarDelegateProxy {
		_ = DelegateProxy<UISearchBarDelegate>.self
		return .proxy(for: base,
		              setter: #selector(setter: base.delegate),
		              getter: #selector(getter: base.delegate))
	}
	public var text: BindingTarget<String?> {
		return makeBindingTarget { $0.text = $1 }
	}
	public var selectedScopeButtonIndex: BindingTarget<Int> {
		return makeBindingTarget { $0.selectedScopeButtonIndex = $1 }
	}
	public var textValues: Signal<String?, Never> {
		return proxy.intercept(#selector(UISearchBarDelegate.searchBarTextDidEndEditing))
			.map { [unowned base] in base.text }
	}
	public var continuousTextValues: Signal<String?, Never> {
		return proxy.intercept(#selector(proxy.searchBar(_:textDidChange:)))
			.map { [unowned base] in base.text }
	}
	public var selectedScopeButtonIndices: Signal<Int, Never> {
		return proxy.intercept(#selector(proxy.searchBar(_:selectedScopeButtonIndexDidChange:)))
			.map { $0[1] as! Int }
	}
	public var cancelButtonClicked: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarCancelButtonClicked))
	}
	public var searchButtonClicked: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarSearchButtonClicked(_:)))
	}
	public var bookmarkButtonClicked: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarBookmarkButtonClicked))
	}
	public var resultsListButtonClicked: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarResultsListButtonClicked))
	}
	public var textDidBeginEditing: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarTextDidBeginEditing))
	}
	public var textDidEndEditing: Signal<Void, Never> {
		return proxy.intercept(#selector(proxy.searchBarTextDidEndEditing))
	}
	public var showsCancelButton: BindingTarget<Bool> {
		return makeBindingTarget { $0.showsCancelButton = $1 }
	}
}
#endif