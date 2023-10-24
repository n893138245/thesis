import UIKit
class AddDeviceBaseNavController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.white
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: STELLAR_COLOR_C3,NSAttributedString.Key.font : STELLAR_FONT_T18]
        navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count != 0 {
            let backBtn = UIBarButtonItem.init(image: UIImage.init(named: "bar_icon_white"), style: .plain, target: self, action: #selector(popAction))
            viewController.navigationItem.leftBarButtonItem = backBtn
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    @objc func popAction() {
        popViewController(animated: true)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }
}