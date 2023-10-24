import UIKit
public protocol CountryPickerViewDelegate: class {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: CountryPickerViewController)
    func countryPickerView(_ countryPickerView: CountryPickerView, didShow viewController: CountryPickerViewController)
}
public protocol CountryPickerViewDataSource: class {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont
    func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
    func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize
    func cellImageViewCornerRadius(in countryPickerView: CountryPickerView) -> CGFloat
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool
    func showCheckmarkInList(in countryPickerView: CountryPickerView) -> Bool
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale
    func excludedCountries(in countryPickerView: CountryPickerView) -> [Country]
}
public extension CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 17)
    }
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return nil
    }
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return nil
    }
    func cellImageViewCornerRadius(in countryPickerView: CountryPickerView) -> CGFloat {
        return 2
    }
    func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize {
        return CGSize(width: 34, height: 24)
    }
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    func showCheckmarkInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
        return Locale.current
    }
    func excludedCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
}
public extension CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           willShow viewController: CountryPickerViewController) {
    }
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didShow viewController: CountryPickerViewController) {
    }
}