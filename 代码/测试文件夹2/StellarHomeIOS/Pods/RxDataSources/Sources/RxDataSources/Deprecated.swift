#if os(iOS) || os(tvOS)
extension CollectionViewSectionedDataSource {
    @available(*, deprecated, renamed: "configureSupplementaryView")
    public var supplementaryViewFactory: ConfigureSupplementaryView? {
        get {
            return self.configureSupplementaryView
        }
        set {
            self.configureSupplementaryView = newValue
        }
    }
}
#endif