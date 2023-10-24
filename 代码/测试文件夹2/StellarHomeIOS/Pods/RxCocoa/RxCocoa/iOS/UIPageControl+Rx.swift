#if os(iOS) || os(tvOS)
import RxSwift
import UIKit
extension Reactive where Base: UIPageControl {
    public var currentPage: Binder<Int> {
        return Binder(self.base) { controller, page in
            controller.currentPage = page
        }
    }
    public var numberOfPages: Binder<Int> {
        return Binder(self.base) { controller, page in
            controller.numberOfPages = page
        }
    }
}
#endif