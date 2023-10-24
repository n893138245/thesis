import UIKit
enum BindType {
    case email,phone
}
class CommBindViewController: BaseViewController {
    var myBindType: BindType = .email
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        view.addSubview(topLabel)
        topLabel.frame = CGRect.init(x: 20, y: navView.frame.maxY + 8, width: kScreenWidth - 20, height: 42)
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(topLabel.snp.bottom).offset(100.fit)
        }
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(iconImage.snp.bottom).offset(24.fit)
        }
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).offset(-32.fit-getAllVersionSafeAreaBottomHeight())
            $0.height.equalTo(46.fit)
            $0.width.equalTo(291.fit)
        }
        if myBindType == .email {
            topLabel.text = StellarLocalizedString("MINE_BIND_EMAIL")
            StellarAppManager.sharedManager.user.userInfo.email.isEmpty ? bottomBtn.setTitle(StellarLocalizedString("MINE_BIND_EMAIL"), for: .normal):bottomBtn.setTitle(StellarLocalizedString("MINE_BIND_CHANGEEMAIL"), for: .normal)
            contentLabel.text = StellarAppManager.sharedManager.user.userInfo.email.isEmpty ? StellarLocalizedString("MINE_BIND_UNBINDEMAIL"):"\(StellarLocalizedString("MINE_BIND_EMAIL_CURRENT")) \(StellarAppManager.sharedManager.user.userInfo.email)"
            iconImage.image = UIImage(named: "icon_email")
        }else if myBindType == .phone {
            topLabel.text = StellarLocalizedString("MINE_BIND_PHONE")
            StellarAppManager.sharedManager.user.userInfo.cellphone.isEmpty ? bottomBtn.setTitle(StellarLocalizedString("MINE_BIND_PHONE"), for: .normal):bottomBtn.setTitle(StellarLocalizedString("MINE_BIND_CHANGEPHONE"), for: .normal)
            var cellPhone = StellarAppManager.sharedManager.user.userInfo.cellphone
            if cellPhone.contains("-") {
                cellPhone = cellPhone.replacingOccurrences(of: "-", with: " ")
            }
            contentLabel.text = StellarAppManager.sharedManager.user.userInfo.cellphone.isEmpty ? StellarLocalizedString("MINE_BIND_UNBINDPHONE"):"\(StellarLocalizedString("MINE_BIND_PHONE_CURRENT")) \(cellPhone)"
            iconImage.image = UIImage(named: "icon_phone")
        }
    }
    private func setupRx() {
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            let vc = BindEmailAndPhoneViewController()
            if self?.myBindType == .phone {
                if StellarAppManager.sharedManager.user.userInfo.cellphone.isEmpty {
                    vc.myBindType = .bindPhone
                }else {
                    vc.myBindType = .changePhone
                }
            }else if self?.myBindType == .email {
                if StellarAppManager.sharedManager.user.userInfo.email.isEmpty {
                    vc.myBindType = .bindEmail
                }else {
                    vc.myBindType = .changeEmail
                }
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    private lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    private lazy var topLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C4
        label.font = STELLAR_FONT_BOLD_T30
        return label
    }()
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C4
        label.font = STELLAR_FONT_T14
        return label
    }()
    private lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.style = .normal
        return view
    }()
    private lazy var iconImage:UIImageView = {
        let view = UIImageView()
        return view
    }()
}