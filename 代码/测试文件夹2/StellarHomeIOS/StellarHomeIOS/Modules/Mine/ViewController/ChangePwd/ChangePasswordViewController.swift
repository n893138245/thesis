import UIKit
class ChangePasswordViewController: BaseViewController {
    struct Input {
        let textfieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
        setupActions()
    }
    func loadSubViews(){
        loadHead()
        addSubViews()
        setupLogic()
    }
    func loadHead(){
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
        view.addSubview(topLabel)
        topLabel.text = StellarLocalizedString("MINE_CHANGEPWD_TITLE")
        topLabel.frame = CGRect.init(x: 20, y: navView.frame.maxY + 8, width: kScreenWidth - 20, height: 42)
        phoneNumLabel.frame = CGRect.init(x: 20, y: topLabel.frame.maxY + 6, width: kScreenWidth - 20, height: 20)
        view.addSubview(phoneNumLabel)
    }
    func addSubViews(){
        pwdTextField.isHidden = false
        pwdTextField.frame = CGRect.init(x: 22.fit, y: phoneNumLabel.frame.maxY + 39.fit, width: kScreenWidth - 44.fit, height: 79.fit)
        view.addSubview(pwdTextField)
        view.addSubview(bottomBtn)
        bottomBtn.setTitle(StellarLocalizedString("MINE_CHANGEPWD_CONFRIM"), for: .normal)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: phoneNumLabel.frame.maxY + 193, width: 290.fit , height: 46.fit)
        bottomBtn.isEnabled = false
        pwdTextField.textField.becomeFirstResponder()
    }
    func setupLogic(){
        let passwordInput = Input.init(textfieldInput: pwdTextField.textField.rx.value.orEmpty.asObservable().distinctUntilChanged())
        var passwordOutput = Output()
        passwordOutput.textFieldValidateResult = passwordInput.textfieldInput
            .flatMapLatest { (textfieldInput) -> Observable<ValidateResult> in
                return ValidateService.validatePasssword(text: textfieldInput)
        }
        .share(replay: 1)
        passwordOutput.textFieldValidateResult
            .subscribe { [weak self] (event: Event<ValidateResult>) in
                switch event{
                case .completed:return
                case .error(_): break
                case .next(let result):
                    switch result{
                    case .ok:
                        self?.pwdTextField.bottomTitleLabel.text = ""
                        self?.bottomBtn.isEnabled = true
                        break
                    case .failed(let reason):
                        switch reason{
                        case .emptyInput:
                            self?.bottomBtn.isEnabled = false
                            break
                        case .other(let msg):
                            self?.bottomBtn.isEnabled = false
                            self?.pwdTextField.bottomTitleLabel.text = msg
                            break
                        }
                    }
                }
        }.disposed(by: disposeBag)
    }
    private func setupActions() {
        bottomBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.netSetNewPwd()
        }).disposed(by: disposeBag)
    }
    private func netSetNewPwd() {
        bottomBtn.startIndicator()
        StellarProgressHUD.showHUD()
        let password = pwdTextField.textField.text ?? ""
        StellarUserStore.sharedStore.changePassword(newPassword: password.sha256(), accessCode: FeedBackTimeTool.sharedTool.getVerificationAccessCode() ?? "", success: { [weak self] (jsonDic) in
            self?.bottomBtn.stopIndicator()
            StellarProgressHUD.dissmissHUD()
            guard let response = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel else {
                self?.setPwdFailedAction()
                return
            }
            if response.code == 0 {
                TOAST(message: StellarLocalizedString("ALERT_CONFIRM_SUCCESS")) {
                    self?.popToUserInfoVc()
                }
            }else {
                self?.setPwdFailedAction()
            }
        }) { [weak self] (error) in
            self?.setPwdFailedAction()
        }
    }
    func setPwdFailedAction(){
        StellarProgressHUD.dissmissHUD()
        bottomBtn.stopIndicator()
        hintView.showAnimationWithTitle(StellarLocalizedString("ALERT_CONFIRM_FAIL"), duration: 1.0)
    }
    private func popToUserInfoVc() {
        popToViewController(withClass: MineInfoViewController.className())
    }
    lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    lazy var topLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C4
        label.font = STELLAR_FONT_BOLD_T30
        return label
    }()
    lazy var phoneNumLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C6
        label.font = STELLAR_FONT_BOLD_T14
        return label
    }()
    lazy var pwdTextField:StellarTextField = {
        let view = StellarTextField.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth-60.fit, height: 79.fit))
        view.title = StellarLocalizedString("MINE_CHANGEPWD_RESET")
        view.style = .password
        return view
    }()
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.style = .normal
        return view
    }()
    lazy var hintView:HintTextView = {
        let hView =  HintTextView.HintTextView()
        hView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 100)
        view.addSubview(hView)
        return hView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}