import UIKit
class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    let disposeBag = DisposeBag()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
        view.clipsToBounds = true
    }
    func popToViewController(withClass className: String, animated: Bool = true) {
        for vc in self.navigationController?.viewControllers ?? [UIViewController]() {
            if vc.className() == className {
                self.navigationController?.popToViewController(vc, animated: animated)
            }
        }
    }
    deinit {
        print("deinit-------> \(classForCoder)")
    }
}