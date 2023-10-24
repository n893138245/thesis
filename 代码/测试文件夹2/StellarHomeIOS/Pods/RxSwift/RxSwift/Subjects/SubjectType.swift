public protocol SubjectType : ObservableType {
    associatedtype Observer: ObserverType
    @available(*, deprecated, renamed: "Observer")
    typealias SubjectObserverType = Observer
    func asObserver() -> Observer
}