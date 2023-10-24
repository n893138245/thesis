import UIKit
enum ViewState {
    case kVcInit
    case kEquipmentVc
    case kSceneVc
    case kSmartVc
    case kMineVc
}
class MainViewController: BaseViewController {
    var nextVC = UIViewController()
    var currentVC:UIViewController?
    var myViewState:ViewState = .kVcInit{
        didSet{
            if oldValue == myViewState
            {
                return
            }
            setupController(state: myViewState)
            setupBottomButton(state: myViewState)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        myViewState = .kEquipmentVc
    }
    func loadSubViews(){
        loadTabbarView()
    }
    func loadTabbarView(){
        view.addSubview(tabbarView)
        tabbarView.snp.makeConstraints {
            $0.left.right.equalTo(self.view)
            $0.bottom.equalTo(0)
            $0.height.equalTo(49.fit + getAllVersionSafeAreaBottomHeight())
        }
        let tabbarLineView = UIView()
        tabbarLineView.backgroundColor = STELLAR_COLOR_C9.withAlphaComponent(0.9)
        tabbarView.addSubview(tabbarLineView)
        tabbarLineView.snp.makeConstraints {
            $0.left.right.top.equalTo(tabbarView)
            $0.height.equalTo(0.5)
        }
        tabbarView.addSubview(equipmentBtn)
        equipmentBtn.snp.makeConstraints {
            $0.left.top.bottom.equalTo(tabbarView)
            $0.width.equalTo(kScreenWidth/4.0)
        }
        tabbarView.addSubview(sceneBtn)
        sceneBtn.snp.makeConstraints {
            $0.left.equalTo(kScreenWidth/4.0)
            $0.top.bottom.equalTo(1.fit)
            $0.width.equalTo(kScreenWidth/4.0)
        }
        tabbarView.addSubview(smartBtn)
        smartBtn.snp.makeConstraints {
            $0.left.equalTo(kScreenWidth/4.0*2)
            $0.top.bottom.equalTo(1.fit)
            $0.width.equalTo(kScreenWidth/4.0)
        }
        tabbarView.addSubview(mineBtn)
        mineBtn.snp.makeConstraints {
            $0.left.equalTo(kScreenWidth/4.0*3)
            $0.top.bottom.equalTo(1.fit)
            $0.width.equalTo(kScreenWidth/4.0)
        }
        tabbarView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.96)
    }
    func setupController(state:ViewState){
        switch state {
        case .kVcInit:
            nextVC = equipmentVC
            break
        case .kEquipmentVc:
            nextVC = equipmentVC
            break
        case .kSceneVc:
            nextVC = sceneVC
            break
        case .kSmartVc:
            nextVC = smartVC
            break
        case .kMineVc:
            nextVC = mineVC
            break
        }
        currentVC?.willMove(toParent: self)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        addChild(nextVC)
        nextVC.didMove(toParent: self)
        view.insertSubview(nextVC.view, belowSubview: self.tabbarView)
        nextVC.view.frame = view.bounds
        currentVC = nextVC
    }
    func setupBottomButton(state:ViewState){
        switch state {
        case .kVcInit:
            equipmentBtn.isSelected = true
            sceneBtn.isSelected = false
            smartBtn.isSelected = false
            mineBtn.isSelected = false
            break
        case .kEquipmentVc:
            equipmentBtn.isSelected = true
            sceneBtn.isSelected = false
            smartBtn.isSelected = false
            mineBtn.isSelected = false
            break
        case .kSceneVc:
            equipmentBtn.isSelected = false
            sceneBtn.isSelected = true
            smartBtn.isSelected = false
            mineBtn.isSelected = false
            break
        case .kSmartVc:
            equipmentBtn.isSelected = false
            sceneBtn.isSelected = false
            smartBtn.isSelected = true
            mineBtn.isSelected = false
            myViewState = .kSmartVc
            break
        case .kMineVc:
            equipmentBtn.isSelected = false
            sceneBtn.isSelected = false
            smartBtn.isSelected = false
            mineBtn.isSelected = true
            break
        }
    }
    private func specifyButton(title:String,imageName:String) -> TabbarScaledButton{
        let button = TabbarScaledButton.init(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button .setImage(UIImage(named: imageName), for: .normal)
        button .setImage(UIImage(named: imageName + "_highlighted"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        button.setTitleColor(STELLAR_COLOR_C1, for: .selected)
        button.titleLabel?.font = STELLAR_FONT_T11
        button.addTarget(self, action: #selector(bottomButtonTapped(btn:)), for: .touchUpInside)
        return button
    }
    @objc private func bottomButtonTapped(btn:UIButton){
        if btn.tag == 0 {
            myViewState = .kEquipmentVc
        }
        else if btn.tag == 1 {
            myViewState = .kSceneVc
        }else if btn.tag == 2 {
            myViewState = .kSmartVc
        }else if btn.tag == 3 {
            myViewState = .kMineVc
        }
    }
    override var childForStatusBarStyle: UIViewController?
    {
        return currentVC
    }
    lazy var equipmentBtn:TabbarScaledButton = {
        let button = specifyButton(title: StellarLocalizedString("COMMON_EQUIPMENT"), imageName: "tabbar_equipment")
        button.tag = 0
        return button
    }()
    lazy var sceneBtn:TabbarScaledButton = {
        let button = specifyButton(title: StellarLocalizedString("COMMON_SCENE"), imageName: "tabbar_scene")
        button.tag = 1
        return button
    }()
    lazy var smartBtn:TabbarScaledButton = {
        let button = specifyButton(title: StellarLocalizedString("COMMON_SMART"), imageName: "tabbar_smart")
        button.tag = 2
        return button
    }()
    lazy var mineBtn:TabbarScaledButton = {
        let button = specifyButton(title: StellarLocalizedString("COMMON_MINE"), imageName: "tabbar_mine")
        button.tag = 3
        return button
    }()
    lazy var equipmentVC:EquipmentViewController = {
        let vc = EquipmentViewController()
        return vc
    }()
    lazy var sceneVC:SceneViewController = {
        let vc = SceneViewController()
        return vc
    }()
    lazy var smartVC:SmartViewController = {
        let vc = SmartViewController()
        return vc
    }()
    lazy var mineVC:MineViewController = {
        let vc = MineViewController()
        return vc
    }()
    lazy var tabbarView:UIView = {
        let tbView = UIView()
        return tbView
    }()
}