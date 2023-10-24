#if os(iOS)
    import RxSwift
    import UIKit
    extension Reactive where Base: UIPickerView {
        public var delegate: DelegateProxy<UIPickerView, UIPickerViewDelegate> {
            return RxPickerViewDelegateProxy.proxy(for: base)
        }
        public func setDelegate(_ delegate: UIPickerViewDelegate)
            -> Disposable {
                return RxPickerViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
        }
        public var dataSource: DelegateProxy<UIPickerView, UIPickerViewDataSource> {
            return RxPickerViewDataSourceProxy.proxy(for: base)
        }
        public var itemSelected: ControlEvent<(row: Int, component: Int)> {
            let source = delegate
                .methodInvoked(#selector(UIPickerViewDelegate.pickerView(_:didSelectRow:inComponent:)))
                .map {
                    return (row: try castOrThrow(Int.self, $0[1]), component: try castOrThrow(Int.self, $0[2]))
                }
            return ControlEvent(events: source)
        }
        public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<[T]> {
            let source = itemSelected.flatMap { [weak view = self.base as UIPickerView] _, component -> Observable<[T]> in
                guard let view = view else {
                    return Observable.empty()
                }
                let model: [T] = try (0 ..< view.numberOfComponents).map { component in
                    let row = view.selectedRow(inComponent: component)
                    return try view.rx.model(at: IndexPath(row: row, section: component))
                }
                return Observable.just(model)
            }
            return ControlEvent(events: source)
        }
        public func itemTitles<Sequence: Swift.Sequence, Source: ObservableType>
            (_ source: Source)
            -> (_ titleForRow: @escaping (Int, Sequence.Element) -> String?)
            -> Disposable where Source.Element == Sequence {
                return { titleForRow in
                    let adapter = RxStringPickerViewAdapter<Sequence>(titleForRow: titleForRow)
                    return self.items(adapter: adapter)(source)
                }
        }
        public func itemAttributedTitles<Sequence: Swift.Sequence, Source: ObservableType>
            (_ source: Source)
            -> (_ attributedTitleForRow: @escaping (Int, Sequence.Element) -> NSAttributedString?)
            -> Disposable where Source.Element == Sequence {
                return { attributedTitleForRow in
                    let adapter = RxAttributedStringPickerViewAdapter<Sequence>(attributedTitleForRow: attributedTitleForRow)
                    return self.items(adapter: adapter)(source)
                }
        }
        public func items<Sequence: Swift.Sequence, Source: ObservableType>
            (_ source: Source)
            -> (_ viewForRow: @escaping (Int, Sequence.Element, UIView?) -> UIView)
            -> Disposable where Source.Element == Sequence {
                return { viewForRow in
                    let adapter = RxPickerViewAdapter<Sequence>(viewForRow: viewForRow)
                    return self.items(adapter: adapter)(source)
                }
        }
        public func items<Source: ObservableType,
                          Adapter: RxPickerViewDataSourceType & UIPickerViewDataSource & UIPickerViewDelegate>(adapter: Adapter)
            -> (_ source: Source)
            -> Disposable where Source.Element == Adapter.Element {
                return { source in
                    let delegateSubscription = self.setDelegate(adapter)
                    let dataSourceSubscription = source.subscribeProxyDataSource(ofObject: self.base, dataSource: adapter, retainDataSource: true, binding: { [weak pickerView = self.base] (_: RxPickerViewDataSourceProxy, event) in
                        guard let pickerView = pickerView else { return }
                        adapter.pickerView(pickerView, observedEvent: event)
                    })
                    return Disposables.create(delegateSubscription, dataSourceSubscription)
                }
        }
        public func model<T>(at indexPath: IndexPath) throws -> T {
            let dataSource: SectionedViewDataSourceType = castOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.itemTitles, rx.itemAttributedTitles, items(_ source: O)` methods was used.")
            return castOrFatalError(try dataSource.model(at: indexPath))
        }
    }
#endif