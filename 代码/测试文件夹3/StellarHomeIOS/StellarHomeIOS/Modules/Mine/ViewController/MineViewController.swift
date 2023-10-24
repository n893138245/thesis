import UIKit
class MineViewController: BaseViewController {
    let headviewHeight:CGFloat = 202
    let headImageViewHeight:CGFloat = 157
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.netLoadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        setupViews()
        setupTableViewScroll()
        if let image = StellarAppManager.sharedManager.user.getPhoto() {
            tableHeaderView.icon.image = image
        }
        refreshConfigData()
    }
    func setupViews(){
        view.addSubview(headImageView)
        headImageView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: headImageViewHeight+getAllVersionSafeAreaTopHeight())
        tableHeaderView.clickIconBlock = { [weak self] in
            let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("MINE_PHOTO_ALBUM"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self?.goImage()
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("MINE_PHOTO_CAMERA"), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self?.goCamera()
            }))
            alertController.addAction(UIAlertAction(title:StellarLocalizedString("COMMON_CANCEL"), style: UIAlertAction.Style.cancel, handler:nil))
            self?.present(alertController, animated: true, completion: nil)
        }
        tableHeaderView.clickTitleBlock = { [weak self] in
            if self?.tableHeaderView.nameLabel.text == StellarLocalizedString("MINE_EMPTY_NICKNAME") {
                self?.confirmNameView.showView()
            }else{
                self?.confirmNameView.showView(text:self?.tableHeaderView.nameLabel.text ?? "")
            }
            self?.confirmNameView.showView()
            self?.confirmNameView.rightButtonBlock = { text in
                self?.updateUserNickName(nickName: text.ss.spaceNewLineString())
            }
        }
        tableview.tableHeaderView = tableHeaderView
        tableview.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - BOTTOM_HEIGHT)
        view.addSubview(tableview)
        tableview.register(UINib(nibName: "LeftImageViewLabelCell", bundle: nil), forCellReuseIdentifier: "LeftImageViewLabelCellID")
        tableview.rowHeight = 72
        mineVM.mineVariable.asObservable()
            .bind(to: tableview.rx
                .items(cellIdentifier: "LeftImageViewLabelCellID", cellType: LeftImageViewLabelCell.self)) { [weak self] (row, hero, cell) in
                    let model = self?.mineVM.getMineModels()[row] ?? MineModel(leftImageName: "", leftTitle: "", isShowArrow: true)
                    cell.setupViews(leftString: model.leftTitle, leftIconName: model.leftImageName, isHiddenRightIcon: !model.isShowArrow)
        }.disposed(by: disposeBag)
        tableview.rx
            .modelSelected(MineModel.self)
            .subscribe { [weak self] model in
                let mineModel = model.element
                if mineModel?.leftTitle == StellarLocalizedString("MINE_HELP_CENTER"){
                    jumpTo(url: StellarHomeResourceUrl.sansi_io)
                }else if mineModel?.leftTitle == StellarLocalizedString("MINE_FEEDBACK_FEEDBACK"){
                    let vc = FeedbackController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if mineModel?.leftTitle == StellarLocalizedString("MINE_INFO_USERINFO"){
                    let vc = MineInfoViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if mineModel?.leftTitle == StellarLocalizedString("MINE_ABOUT_US"){
                    let vc = AboutSansiViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if mineModel?.leftTitle == StellarLocalizedString("MINE_THIRD_PARTY") {
                    let vc = ThirdPartViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if mineModel?.leftTitle == "Third Party Access" {
                    let vc = ThirdPartViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
        }.disposed(by: disposeBag)
    }
    func refreshConfigData(){
        if !StellarAppManager.sharedManager.user.userInfo.nickname.isEmpty {
            tableHeaderView.nameLabel.text = StellarAppManager.sharedManager.user.userInfo.nickname
        }else {
            if let thridInfo = StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.first {
                tableHeaderView.nameLabel.text = thridInfo.nickname
            }else{
                tableHeaderView.nameLabel.text = StellarLocalizedString("MINE_EMPTY_NICKNAME")
            }
        }
        if StellarAppManager.sharedManager.user.headImage != nil {
            tableHeaderView.icon.image = StellarAppManager.sharedManager.user.headImage
        }else {
            if let thridInfo = StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.first {
                tableHeaderView.icon.kf.setImage(with: URL(string: thridInfo.headerImage), placeholder: UIImage.init(named: "faces_normal"))
            }else{
                tableHeaderView.icon.image = UIImage.init(named: "faces_normal")
            }
        }
    }
    func setupTableViewScroll(){
        tableview.rx.contentOffset
            .subscribe(onNext: { [weak self] (contentOffset) in
                let contentOffsetY = contentOffset.y
                if contentOffsetY < -getAllVersionSafeAreaTopHeight() {
                    let height = (self?.headImageViewHeight ?? 0) - contentOffsetY
                    let width = kScreenWidth * height / ((self?.headImageViewHeight ?? 0)+getAllVersionSafeAreaTopHeight())
                    self?.headImageView.center = CGPoint.init(x: self?.view.center.x ?? 0, y: height / 2.0)
                    self?.headImageView.bounds = CGRect.init(x: 0, y: 0, width: width, height: height)
                }
            }).disposed(by: disposeBag)
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
    private func netLoadData() {
        getUserInfo()
        updateUserPhoto()
    }
    private func getUserInfo() {
        StellarUserStore.sharedStore.getUserInfo(success: { (jsonDic) in
            let model = jsonDic.kj.model(InfoModel.self)
            StellarAppManager.sharedManager.user.userInfo = model
            StellarAppManager.sharedManager.user.save()
            self.refreshConfigData()
        }) { (error) in
            print(error)
        }
    }
    private func updateUserNickName(nickName: String) {
        StellarProgressHUD.showHUD()
        StellarUserStore.sharedStore.modificationUserInfo(nickname: nickName, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let model = jsonDic.kj.model(CommonResponseModel.self)
            if model.code == 0 {
                StellarAppManager.sharedManager.user.userInfo.nickname = nickName
                self?.tableHeaderView.nameLabel.text = nickName
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
        }
    }
    private func updateUserPhoto() {
        AWSRequest.getHeaderImage(fileName: StellarAppManager.sharedManager.user.userInfo.userid, success: { (data) in
            if let headData = data,let headImage = UIImage.init(data: headData) {
                StellarAppManager.sharedManager.user.headImage = headImage
                StellarAppManager.sharedManager.user.savePhoto(data: headData)
                self.refreshConfigData()
            }
        }) { (errorCode) in
            print(errorCode)
        }
    }
    lazy var headImageView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "my_bg")
        view.contentMode = .scaleAspectFill
        return view
    }()
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.clear
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    private lazy var mineVM : MineViewModel = MineViewModel()
    private lazy var tableHeaderView:MineHeadView = {
        let headView = MineHeadView.MineHeadView()
        headView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: headviewHeight)
        headView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 0)
        return headView
    }()
    lazy var confirmNameView:StellarTextFieldAlertView = {
        let view = StellarTextFieldAlertView.stellarTextFieldAlertView()
        view.isVoiceControl = false
        view.setTitleTextFieldType(title: StellarLocalizedString("MINE_INFO_SET_NICKNAME"), secondTitle: "", leftClickString: StellarLocalizedString("COMMON_CANCEL"), rightClickString: StellarLocalizedString("COMMON_CONFIRM"))
        self.view.addSubview(view)
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
extension MineViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let headImage = UIImage.ss.reSizeImage(reSize: CGSize.init(width: 300, height: 300), image: selectedImage)
        picker.dismiss(animated: true, completion: {
            StellarProgressHUD.showHUD()
            AWSRequest.putHeaderImageToAWS(fileName: StellarAppManager.sharedManager.user.userInfo.userid, image: headImage, success: { [weak self] in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGESUCCESS"))
                StellarAppManager.sharedManager.user.headImage = headImage
                self?.tableHeaderView.icon.image = headImage
                print("putHeaderImageToAWS success")
            }) { (errorCode) in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGEFAIL"))
                print("putHeaderImageToAWS fail \(errorCode)")
            }
        })
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
                self?.tableHeaderView.icon.image = headImage
                print("putHeaderImageToAWS success")
            }) { (errorCode) in
                StellarProgressHUD.dissmissHUD()
                TOAST(message: StellarLocalizedString("MINE_INFO_CHANGEFAIL"))
                print("putHeaderImageToAWS fail \(errorCode)")
            }
        }
        imagePickerVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.present(imagePickerVC, animated: true, completion: nil)
        }
    }
}
