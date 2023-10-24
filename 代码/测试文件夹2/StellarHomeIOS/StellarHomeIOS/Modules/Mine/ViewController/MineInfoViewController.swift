import UIKit
class MineInfoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    private func setupUI() {
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 74.fit))
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(header).offset(20.fit)
            $0.top.equalTo(header).offset(8.fit)
        }
        tableView.tableHeaderView = header
        view.addSubview(logOutButton)
        let bottomSpace = 24.fit + getAllVersionSafeAreaBottomHeight()
        logOutButton.snp.makeConstraints {
            $0.left.equalTo(view).offset(42.fit)
            $0.width.equalTo(291.fit)
            $0.height.equalTo(46.fit)
            $0.bottom.equalTo(view).offset(-bottomSpace)
        }
    }
    func goCamera(){
        var sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == false {
            sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = sourceType
        self.present(picker, animated: true, completion: nil)
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        logOutButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.showLoginOutTip()
        }).disposed(by: disposeBag)
    }
    private func showLoginOutTip () {
        let alert = StellarMineAlertView.init(message: StellarLocalizedString("MINE_INFO_LOGOUT_TIP"), leftTitle: StellarLocalizedString("MINE_INFO_CONFIRM_LOGOUT"), rightTile: StellarLocalizedString("COMMON_CANCEL"), showExitButton: false)
        alert.show()
        alert.leftClickBlock = {
            FeedBackTimeTool.sharedTool.removeAccessCode()
            StellarAppManager.sharedManager.user.headImage = nil
            StellarAppManager.sharedManager.nextStep()
        }
    }
    private func showBottomPopView(changeType: MineInfoChangeType) {
        let popView = SSBottomPopView.SSBottomPopView()
        popView.setupViews(title: StellarLocalizedString("MINE_SECURITY_VERIFY"))
        let fac = HBottomAuthenticationFactory()
        popView.setDisplayFactory(factory: fac)
        popView.setContentHeight(height: CGFloat(155+75*fac.actions.count))
        popView.show()
        fac.clickBlock = { [weak self, weak popView] (type) in
            switch type {
            case .phoneCode,.emailCode:
                self?.setPopCodeVerifyFac(pop: popView ?? SSBottomPopView(),
                                          verifyType: type,
                                          changeType: changeType)
            case .password:
                self?.setPopPwdFac(pop: popView ?? SSBottomPopView(), changeType: changeType)
            }
        }
    }
    private func setPopPwdFac(pop: SSBottomPopView, changeType: MineInfoChangeType) {
        pop.setupViews(title: StellarLocalizedString("LOGIN_ENTER_PASSWORD"))
        let fac = HBottomPwdVerifyFactory()
        pop.setDisplayFactory(factory: fac)
        fac.verifySuccessBlock = { [weak pop, weak self] in 
            pop?.hidden(complete: { 
                self?.pushToChangeVC(changeType: changeType)
            })
        }
    }
    private func setPopCodeVerifyFac(pop: SSBottomPopView, verifyType: UserVerifyType, changeType: MineInfoChangeType) {
        pop.setupViews(title: StellarLocalizedString("MINE_SECURITY_INPUTCODE"))
        let fac = HBottomCodeVerifyFactory()
        fac.verifyType = verifyType
        pop.setDisplayFactory(factory: fac)
        fac.verifySuccessBlock = { [weak pop, weak self] in 
            pop?.hidden(complete: { 
                self?.pushToChangeVC(changeType: changeType)
            })
        }
    }
    private func pushToChangeVC(changeType: MineInfoChangeType) {
        switch changeType {
        case .bindEmail:
            let vc = CommBindViewController()
            vc.myBindType = .email
            navigationController?.pushViewController(vc, animated: true)
        case.changePassword:
            let vc = ChangePasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .phoneNumber:
            let vc = CommBindViewController()
            vc.myBindType = .phone
            navigationController?.pushViewController(vc, animated: true)
        case .destructionAccount:
            let vc = DestroyAccountViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    private func showBindPopView() {
        let popView = SSBottomPopView.SSBottomPopView()
        popView.setupViews(title: "账号绑定")
        let fac = HBottomBindingFactory()
        popView.setDisplayFactory(factory: fac)
        popView.setContentHeight(height: CGFloat(155+75*fac.actions.count))
        popView.show()
        fac.clickBlock = { [weak self, weak popView] (type) in
            popView?.hidden(complete: {
                let vc = BindEmailAndPhoneViewController()
                vc.myBindType = type
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    private func netSubscribe(on :Bool) {
        StellarProgressHUD.showHUD()
        StellarUserStore.sharedStore.modificationUserInfo(subscribe: on, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            guard let model = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel  else {
                return
            }
            if model.code == 0 {
                StellarAppManager.sharedManager.user.userInfo.subscribe = on
                self?.tableView.reloadData()
            }
        }) { [weak self] (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("MINE_SECURITY_OPENFAIL")) {
                self?.tableView.reloadData()
            }
        }
    }
    private func netChangeName(name: String) {
        if name == StellarLocalizedString("MINE_EMPTY_NICKNAME") {
            self.confirmNameView.showView()
        }else{
            self.confirmNameView.showView(text:name)
        }
        self.confirmNameView.rightButtonBlock = { [weak self] text in
            if !text.isEmpty{
                StellarProgressHUD.showHUD()
                StellarUserStore.sharedStore.modificationUserInfo(nickname: text.ss.spaceNewLineString(), success: { [weak self] (jsonDic) in
                    StellarProgressHUD.dissmissHUD()
                    guard let model = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel  else {
                        return
                    }
                    if model.code == 0 {
                        StellarAppManager.sharedManager.user.userInfo.nickname = text
                        self?.tableView.reloadData()
                    }
                }) { (error) in
                    StellarProgressHUD.dissmissHUD()
                }
            }
        }
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH-getAllVersionSafeAreaBottomHeight()-46.fit-32.fit-20))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "MineInfoCell", bundle: nil), forCellReuseIdentifier: "MineInfoCell")
        tempView.separatorStyle = .none
        tempView.estimatedRowHeight = 0
        tempView.estimatedSectionHeaderHeight = 0
        tempView.estimatedSectionFooterHeight = 0
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.moreButton.isHidden = true
        tempView.titleLabel.text = ""
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.text = StellarLocalizedString("MINE_INFO_USERINFO")
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
    private lazy var logOutButton: StellarButton = {
        let tempView = StellarButton.init()
        tempView.style = .gray
        tempView.setTitle(StellarLocalizedString("MINE_INFO_LOGOUT"), for: .normal)
        return tempView
    }()
    lazy var confirmNameView:StellarTextFieldAlertView = {
        let view = StellarTextFieldAlertView.stellarTextFieldAlertView()
        view.isVoiceControl = false
        view.setTitleTextFieldType(title: StellarLocalizedString("MINE_INFO_SET_NICKNAME"), secondTitle: "", leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        self.view.addSubview(view)
        return view
    }()
}
extension MineInfoViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineInfoCell", for: indexPath) as! MineInfoCell
        cell.selectionStyle = .none
        cell.setupviews(user: StellarAppManager.sharedManager.user)
        cell.infoChangeSubscribeBlock = { [weak self] on in
            self?.netSubscribe(on: on)
        }
        let info = StellarAppManager.sharedManager.user.userInfo
        let isNotNeedAuth = (info.cellphone.isEmpty && info.email.isEmpty)
        cell.infoChangeBlock = { [weak self] (infoType,name) in
            switch infoType {
            case .header:
                let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                alertController.addAction(UIAlertAction(title:StellarLocalizedString("MINE_PHOTO_ALBUM"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self?.goImage()
                }))
                alertController.addAction(UIAlertAction(title:StellarLocalizedString("MINE_PHOTO_CAMERA"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    self?.goCamera()
                }))
                alertController.addAction(UIAlertAction(title:StellarLocalizedString("COMMON_CANCEL"), style: UIAlertAction.Style.cancel, handler:nil))
                self?.present(alertController, animated: true, completion: nil)
            case .nickName:
                self?.netChangeName(name: name)
            case .thridBinding:
                if isNotNeedAuth {
                    self?.showBindPopView()
                }else {
                    let vc = AccountBindingViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .clockSetting:
                let vc = ClockSettingViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            case .bindEmail,.phoneNumber,.changePassword,.destructionAccount:
                if FeedBackTimeTool.sharedTool.getVerificationAccessCode() != nil || isNotNeedAuth { 
                    self?.pushToChangeVC(changeType: infoType)
                }else {
                    self?.showBottomPopView(changeType: infoType)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 652
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension MineInfoViewController :UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 74.fit - getAllVersionSafeAreaTopHeight()-NAVVIEW_HEIGHT_DISLODGE_SAFEAREA {
            navBar.titleLabel.text = ""
        }
        else
        {
            navBar.titleLabel.text = StellarLocalizedString("MINE_INFO_USERINFO")
        }
    }
}
extension MineInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let headImage = UIImage.ss.reSizeImage(reSize: CGSize.init(width: 300, height: 300), image: selectedImage)
        picker.dismiss(animated: true) {
            StellarProgressHUD.showHUD()
            AWSRequest.putHeaderImageToAWS(fileName: StellarAppManager.sharedManager.user.userInfo.userid, image: headImage, success: { [weak self] in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGESUCCESS"))
                StellarAppManager.sharedManager.user.headImage = headImage
                self?.tableView.reloadData()
                print("putHeaderImageToAWS success")
            }) { (errorCode) in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGEFAIL"))
                print("putHeaderImageToAWS fail \(errorCode)")
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    func goImage() {
        let imagePickerVC = TZImagePickerController.init(maxImagesCount: 1, delegate: nil)!
        imagePickerVC.naviBgColor = UIColor.white
        imagePickerVC.navigationBar.tintColor = STELLAR_COLOR_C4
        imagePickerVC.barItemTextColor = STELLAR_COLOR_C4
        imagePickerVC.naviTitleColor = STELLAR_COLOR_C4
        imagePickerVC.naviTitleFont = STELLAR_FONT_T20
        imagePickerVC.oKButtonTitleColorDisabled = UIColor.lightGray
        imagePickerVC.oKButtonTitleColorNormal = UIColor.green
        imagePickerVC.navigationBar.isTranslucent = true;
        imagePickerVC.showSelectBtn = false
        imagePickerVC.allowCrop = true
        imagePickerVC.allowPickingVideo = false
        imagePickerVC.allowTakePicture = false
        imagePickerVC.allowPickingVideo = false
        imagePickerVC.statusBarStyle = .default
        imagePickerVC.preferredLanguage = StellarLocalizedString("MINE_USER_CENTER_SELECT_ALBUM_LANGUAGE")
        let widthHeight:CGFloat = 300
        let left:CGFloat = self.view.tz_width/2.0 - widthHeight/2.0
        let top:CGFloat = self.view.tz_height/2.0 - widthHeight/2.0
        imagePickerVC.cropRect = CGRect.init(x: left, y: top, width: widthHeight, height: widthHeight)
        imagePickerVC.preferredLanguage = StellarLocalizedString("MINE_USER_CENTER_SELECT_ALBUM_LANGUAGE")
        imagePickerVC.didFinishPickingPhotosHandle = { (imageArr, arg2, arg3) in
            let headImage = UIImage.ss.reSizeImage(reSize: CGSize.init(width: 300, height: 300), image: (imageArr?.first!)!)
            StellarProgressHUD.showHUD()
            AWSRequest.putHeaderImageToAWS(fileName: StellarAppManager.sharedManager.user.userInfo.userid, image: headImage, success: { [weak self] in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGESUCCESS"))
                StellarAppManager.sharedManager.user.headImage = headImage
                self?.tableView.reloadData()
                print("putHeaderImageToAWS success")
            }) { (errorCode) in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGEFAIL"))
                print("putHeaderImageToAWS fail \(errorCode)")
            }
        }
        imagePickerVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(imagePickerVC, animated: true, completion: nil)
        }
    }
}