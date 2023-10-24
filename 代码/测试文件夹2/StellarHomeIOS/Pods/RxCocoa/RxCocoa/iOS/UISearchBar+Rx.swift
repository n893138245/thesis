#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UISearchBar {
    public var delegate: DelegateProxy<UISearchBar, UISearchBarDelegate> {
        return RxSearchBarDelegateProxy.proxy(for: base)
    }
    public var text: ControlProperty<String?> {
        return value
    }
    public var value: ControlProperty<String?> {
        let source: Observable<String?> = Observable.deferred { [weak searchBar = self.base as UISearchBar] () -> Observable<String?> in
            let text = searchBar?.text
            let textDidChange = (searchBar?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBar(_:textDidChange:))) ?? Observable.empty())
            let didEndEditing = (searchBar?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarTextDidEndEditing(_:))) ?? Observable.empty())
            return Observable.merge(textDidChange, didEndEditing)
                    .map { _ in searchBar?.text ?? "" }
                    .startWith(text)
        }
        let bindingObserver = Binder(self.base) { (searchBar, text: String?) in
            searchBar.text = text
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    public var selectedScopeButtonIndex: ControlProperty<Int> {
        let source: Observable<Int> = Observable.deferred { [weak source = self.base as UISearchBar] () -> Observable<Int> in
            let index = source?.selectedScopeButtonIndex ?? 0
            return (source?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBar(_:selectedScopeButtonIndexDidChange:))) ?? Observable.empty())
                .map { a in
                    return try castOrThrow(Int.self, a[1])
                }
                .startWith(index)
        }
        let bindingObserver = Binder(self.base) { (searchBar, index: Int) in
            searchBar.selectedScopeButtonIndex = index
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
#if os(iOS)
    public var cancelButtonClicked: ControlEvent<Void> {
        let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarCancelButtonClicked(_:)))
            .map { _ in
                return ()
            }
        return ControlEvent(events: source)
    }
	public var bookmarkButtonClicked: ControlEvent<Void> {
		let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarBookmarkButtonClicked(_:)))
			.map { _ in
				return ()
			}
		return ControlEvent(events: source)
	}
	public var resultsListButtonClicked: ControlEvent<Void> {
		let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarResultsListButtonClicked(_:)))
			.map { _ in
				return ()
		}
		return ControlEvent(events: source)
	}
#endif
    public var searchButtonClicked: ControlEvent<Void> {
        let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:)))
            .map { _ in
                return ()
        }
        return ControlEvent(events: source)
    }
	public var textDidBeginEditing: ControlEvent<Void> {
		let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarTextDidBeginEditing(_:)))
			.map { _ in
				return ()
		}
		return ControlEvent(events: source)
	}
	public var textDidEndEditing: ControlEvent<Void> {
		let source: Observable<Void> = self.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarTextDidEndEditing(_:)))
			.map { _ in
				return ()
		}
		return ControlEvent(events: source)
	}
    public func setDelegate(_ delegate: UISearchBarDelegate)
        -> Disposable {
        return RxSearchBarDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
#endif