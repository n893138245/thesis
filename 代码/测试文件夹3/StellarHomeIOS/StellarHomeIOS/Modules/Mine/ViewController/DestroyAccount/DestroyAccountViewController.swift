import UIKit
class DestroyAccountViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
    }
    func loadSubViews(){
        loadNavView()
        loadSubView()
    }
    func loadNavView(){
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: 44)
    }
    func loadSubView(){
        let titleLabel = UILabel()
        titleLabel.text = "销毁账户"
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: navView.frame.maxY + 8, width: kScreenWidth-20, height: 42)
        view.addSubview(titleLabel)
        let middleImageView = UIImageView()
        middleImageView.frame = CGRect.init(x: kScreenWidth/2.0 - 38, y: titleLabel.frame.maxY + 100, width: 76, height: 76)
        middleImageView.image = UIImage.init(named: "icon_destroy")
        view.addSubview(middleImageView)
        let middleLabel = UILabel()
        middleLabel.text = "销毁后账户信息无法恢复\n请谨慎操作！"
        middleLabel.textAlignment = .center
        middleLabel.numberOfLines = 0
        middleLabel.frame = CGRect.init(x: 10, y: middleImageView.frame.maxY + 27, width: kScreenWidth - 20, height: 50)
        middleLabel.textColor = STELLAR_COLOR_C2
        middleLabel.font = STELLAR_FONT_T16
        view.addSubview(middleLabel)
        let bottomLabel = UILabel()
        if !StellarAppManager.sharedManager.user.userInfo.cellphone.isEmpty {
            var cellPhone = StellarAppManager.sharedManager.user.userInfo.cellphone
            if cellPhone.contains("-") {
                cellPhone = cellPhone.replacingOccurrences(of: "-", with: " ")
            }
            bottomLabel.text = "销毁的账号为 \(cellPhone)"
        }else if !StellarAppManager.sharedManager.user.userInfo.email.isEmpty {
            bottomLabel.text = "销毁的账号为 \(StellarAppManager.sharedManager.user.userInfo.email)"
        }else {
            bottomLabel.text = ""
        }
        bottomLabel.sizeToFit()
        bottomLabel.center = CGPoint.init(x: kScreenWidth/2.0 + 24, y: kScreenHeight - 120)
        bottomLabel.textColor = STELLAR_COLOR_C5
        bottomLabel.font = STELLAR_FONT_T14
        view.addSubview(bottomLabel)
        let bottomImageView = UIImageView()
        bottomImageView.frame = CGRect.init(x: bottomLabel.frame.minX - 8 - 16, y: bottomLabel.frame.minY + 3, width: 16, height: 16)
        bottomImageView.image = UIImage.init(named: "icon_sigh")
        view.addSubview(bottomImageView)
        bottomImageView.isHidden = bottomLabel.text?.isEmpty ?? false
        view.addSubview(bottomBtn)
        bottomBtn.setTitle("销毁账户", for: .normal)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: bottomImageView.frame.maxY + 24, width: 290.fit , height: 46.fit)
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.showTipAlert()
        }).disposed(by: disposeBag)
    }
    private func showTipAlert() {
        let alert = StellarMineAlertView.init(message: "确定要永久销毁这个账户吗？销毁后将无法找回，请谨慎操作！", leftTitle: "确定销毁", rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.show()
        alert.leftClickBlock = { [weak self] in
            self?.netDestoty()
        }
    }
    private func netDestoty() {
        StellarProgressHUD.showHUD()
        bottomBtn.startIndicator()
        StellarUserStore.sharedStore.destroyAccount(accessCode: FeedBackTimeTool.sharedTool.getVerificationAccessCode() ?? "", success: { jsonDic in
            StellarProgressHUD.dissmissHUD()
            AWSRequest.deleteHeaderImageFromAWS(fileName: StellarAppManager.sharedManager.user.userInfo.userid, success: {
                print("headerImagDestroysuccess")
            }) { (errorid) in
                 print("headerImagDestroysuccessFail")
            }
            self.bottomBtn.stopIndicator()
            TOAST(message: "销毁成功") {
                FeedBackTimeTool.sharedTool.removeAccessCode()
                StellarAppManager.sharedManager.user.headImage = nil
                StellarAppManager.sharedManager.nextStep()
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            self.bottomBtn.stopIndicator()
            TOAST(message: "销毁失败")
        }
    }
    lazy var navView:NavView = {
        let view = NavView()
        view.myState = .kNavBlack
        view.setTitle(title: "")
        return view
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.style = .normal
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}