import UIKit
class MyRootNavViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var childForStatusBarHidden: UIViewController?{
        return topViewController
    }
    override var childForStatusBarStyle: UIViewController?
    {
        guard let topVC = visibleViewController else {
            return topViewController
        }
        guard let childrenVC = topVC.children.first else {
            return topViewController
        }
        if childrenVC.isKind(of: SceneViewController.classForCoder()) || childrenVC.isKind(of: EquipmentViewController.classForCoder()) || childrenVC.isKind(of: MineViewController.classForCoder()) || childrenVC.isKind(of: SmartViewController.classForCoder()){
            return childrenVC
        }
        return topViewController
    }
}