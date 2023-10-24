public protocol ObservableConvertibleType {
    associatedtype Element
    @available(*, deprecated, renamed: "Element")
    typealias E = Element
    func asObservable() -> Observable<Element>
}