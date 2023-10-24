import UIKit
import SnapKit
class AddDeviceBaseViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupExitButtonTap()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C1
        view.addSubview(cardView)
        view.addSubview(navBar)
        lineImage.snp.makeConstraints {
            $0.top.equalTo(self.view)
            $0.right.equalTo(self.view)
        }
    }
    func setupExitButtonTap(){
        navBar.exitButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                let alert = StellarMineAlertView.init(message: StellarLocalizedString("ALERT_DOUBT_EXIT_ADD_DEVICE"), leftTitle: StellarLocalizedString("MINE_INFO_CONFIRM_LOGOUT"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
                alert.show()
                alert.leftClickBlock = {
                    if StellarAppManager.sharedManager.currentStep == .kAppStepMain {
                        self?.dismiss(animated: true, completion: nil)
                    }else{
                        StellarAppManager.sharedManager.nextStep()
                    }
                }
            }).disposed(by: disposeBag)
    }
    lazy var cardView: UIView = {
        let tempView = UIView.init()
        tempView.frame = CGRect(x: 9.fit, y: kNavigationH + 7.fit, width: 357.fit, height: kScreenHeight - 32.fit - kNavigationH - getAllVersionSafeAreaBottomHeight() - 7.fit)
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.layer.cornerRadius = 12.fit
        tempView.clipsToBounds = true
        return tempView
    }()
    lazy var lineImage: UIImageView = {
        let tempView = UIImageView.init()
        tempView.image = UIImage(named: "add_device_bg")
        tempView.contentMode = .scaleAspectFill
        view.addSubview(tempView)
        return tempView
    }()
    lazy var navBar: AddDeviceNavView = {
        let navBar = AddDeviceNavView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        return navBar
    }()
}