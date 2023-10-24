#if os(iOS)
import Foundation
import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
open class RxPickerViewStringAdapter<Components>: RxPickerViewDataSource<Components>, UIPickerViewDelegate {
    public typealias TitleForRow = (
        _ dataSource: RxPickerViewStringAdapter<Components>,
        _ pickerView: UIPickerView,
        _ components: Components,
        _ row: Int,
        _ component: Int
    ) -> String?
    private let titleForRow: TitleForRow
    public init(components: Components,
                numberOfComponents: @escaping NumberOfComponents,
                numberOfRowsInComponent: @escaping NumberOfRowsInComponent,
                titleForRow: @escaping TitleForRow) {
        self.titleForRow = titleForRow
        super.init(components: components,
                   numberOfComponents: numberOfComponents,
                   numberOfRowsInComponent: numberOfRowsInComponent)
    }
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleForRow(self, pickerView, components, row, component)
    }
}
open class RxPickerViewAttributedStringAdapter<Components>: RxPickerViewDataSource<Components>, UIPickerViewDelegate {
    public typealias AttributedTitleForRow = (
        _ dataSource: RxPickerViewAttributedStringAdapter<Components>,
        _ pickerView: UIPickerView,
        _ components: Components,
        _ row: Int,
        _ component: Int
    ) -> NSAttributedString?
    private let attributedTitleForRow: AttributedTitleForRow
    public init(components: Components,
                numberOfComponents: @escaping NumberOfComponents,
                numberOfRowsInComponent: @escaping NumberOfRowsInComponent,
                attributedTitleForRow: @escaping AttributedTitleForRow) {
        self.attributedTitleForRow = attributedTitleForRow
        super.init(components: components,
                   numberOfComponents: numberOfComponents,
                   numberOfRowsInComponent: numberOfRowsInComponent)
    }
    open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return attributedTitleForRow(self, pickerView, components, row, component)
    }
}
open class RxPickerViewViewAdapter<Components>: RxPickerViewDataSource<Components>, UIPickerViewDelegate {
    public typealias ViewForRow = (
        _ dataSource: RxPickerViewViewAdapter<Components>,
        _ pickerView: UIPickerView,
        _ components: Components,
        _ row: Int,
        _ component: Int,
        _ view: UIView?
    ) -> UIView
    private let viewForRow: ViewForRow
    public init(components: Components,
                numberOfComponents: @escaping NumberOfComponents,
                numberOfRowsInComponent: @escaping NumberOfRowsInComponent,
                viewForRow: @escaping ViewForRow) {
        self.viewForRow = viewForRow
        super.init(components: components,
                   numberOfComponents: numberOfComponents,
                   numberOfRowsInComponent: numberOfRowsInComponent)
    }
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return viewForRow(self, pickerView, components, row, component, view)
    }
}
open class RxPickerViewDataSource<Components>: NSObject, UIPickerViewDataSource {
    public typealias NumberOfComponents = (
        _ dataSource: RxPickerViewDataSource,
        _ pickerView: UIPickerView,
        _ components: Components) -> Int
    public typealias NumberOfRowsInComponent = (
        _ dataSource: RxPickerViewDataSource,
        _ pickerView: UIPickerView,
        _ components: Components,
        _ component: Int
    ) -> Int
    fileprivate var components: Components
    init(components: Components,
         numberOfComponents: @escaping NumberOfComponents,
         numberOfRowsInComponent: @escaping NumberOfRowsInComponent) {
        self.components = components
        self.numberOfComponents = numberOfComponents
        self.numberOfRowsInComponent = numberOfRowsInComponent
        super.init()
    }
    private let numberOfComponents: NumberOfComponents
    private let numberOfRowsInComponent: NumberOfRowsInComponent
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents(self, pickerView, components)
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRowsInComponent(self, pickerView, components, component)
    }
}
extension RxPickerViewDataSource: RxPickerViewDataSourceType {
    public func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Components>) {
        Binder(self) { (dataSource, components) in
            dataSource.components = components
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
#endif