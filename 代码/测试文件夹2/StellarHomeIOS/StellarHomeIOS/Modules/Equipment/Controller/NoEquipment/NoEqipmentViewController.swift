import UIKit
class NoEqipmentViewController: BaseViewController {
    var isLightStatusBar = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBgView()
    }
    func loadBgView(){
        let imageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        imageview.image = UIImage.init(named: "equipment_bg")
        view.addSubview(imageview)
        imageview.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.bottom.equalTo(view)
        }
        view.addSubview(noResultView)
        noResultView.snp.makeConstraints {
            $0.top.equalTo(getAllVersionSafeAreaTopHeight())
            $0.left.right.equalTo(view)
            $0.bottom.equalTo(view)
        }
        noResultView.addEquipmentBlock = { [weak self] in
            let nav = AddDeviceBaseNavController.init(rootViewController: AddDeviceVC.init())
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    lazy var noResultView:EquipmentNoResultView = {
        let view = EquipmentNoResultView.equipmentNoResultView()
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightStatusBar ? .lightContent : .default
    }
}