import UIKit
import AuthenticationServices
class AccountBindingViewController: BaseViewController {
    private var soruceList: [ThirdPartType] = [.wechat]
    private var dataList = [ThirdPartInfoModel]()
    private var animateCell: AccountBindingCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDefaultData()
    }
    private func setupUI() {
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 54.fit))
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(header).offset(20.fit)
            $0.top.equalTo(header).offset(8.fit)
        }
        tableView.tableHeaderView = header
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func setupDefaultData() {
        if !isChinese() {
            soruceList = [.facebook]
        }
        if #available(iOS 13.0, *) {
            soruceList = [.apple,.wechat]
        }
        for type in soruceList {
            let model = ThirdPartInfoModel()
            model.thirdPartType = type
            dataList.append(model)
        }
        let thirdPartInfo = StellarAppManager.sharedManager.user.userInfo.thirdPartInfo
        if !thirdPartInfo.isEmpty {
            thirdPartInfo.forEach { (thirdPartInfoModel) in
                if let idx = self.dataList.firstIndex(where: {$0.thirdPartType == thirdPartInfoModel.thirdPartType }) {
                    self.dataList.remove(at: idx)
                    self.dataList.insert(thirdPartInfoModel, at: idx)
                }
            }
        }
        tableView.reloadData()
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH-getAllVersionSafeAreaBottomHeight()-46.fit-32.fit-20))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "AccountBindingCell", bundle: nil), forCellReuseIdentifier: "AccountBindingCell")
        tempView.separatorStyle = .none
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
        titleLabel.text = StellarLocalizedString("ALERT_BIND_ACCOUNT")
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
}
extension AccountBindingViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountBindingCell", for: indexPath) as! AccountBindingCell
        cell.selectionStyle = .none
        cell.setupViews(model: dataList[indexPath.row])
        cell.clickBlock = { [weak self, weak cell] myBindStatus in
            if myBindStatus == .binding {
                self?.showUnbindTipAlert(model: self?.dataList[indexPath.row] ?? ThirdPartInfoModel(), cell: cell ?? AccountBindingCell())
            }else {
                self?.authorizationWithShareSDK(model: self?.dataList[indexPath.row] ?? ThirdPartInfoModel(), cell: cell ?? AccountBindingCell())
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    private func authorizationWithShareSDK(model: ThirdPartInfoModel, cell: AccountBindingCell) { 
        switch model.thirdPartType {
        case .wechat:
            ThirdPartLoginManager.loginWithWeChat(success: { [weak self] (sdkUser) in
                self?.netBindThrid(model: model, user: sdkUser, cell: cell)
            }) { (code) in
                TOAST(message: StellarLocalizedString("ALERT_AUTH_FAIL"))
            }
        case .facebook:
            ThirdPartLoginManager.loginWithFaceBook(success: { [weak self] (sdkUser) in
                self?.netBindThrid(model: model, user: sdkUser, cell: cell)
            }) { (code) in
                TOAST(message: StellarLocalizedString("ALERT_AUTH_FAIL"))
            }
        case .apple:
            if #available(iOS 13.0, *) {
                self.animateCell = cell
                let appleProvider = ASAuthorizationAppleIDProvider()
                let request = appleProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let auth = ASAuthorizationController(authorizationRequests: [request])
                auth.delegate = self
                auth.performRequests()
            }
        default:
            break
        }
    }
    private func netBindThrid(model: ThirdPartInfoModel, user: SSDKUser?, cell: AccountBindingCell) {
        StellarProgressHUD.showHUD()
        let jsonObject = ThirdPartInfoModel()
        jsonObject.thirdPartType = model.thirdPartType
        if let tempUser = user {
            jsonObject.thirdPartId = tempUser.rawData["unionid"] as? String
            jsonObject.headerImage = tempUser.icon
            jsonObject.nickname = tempUser.nickname
            if let accessToken = tempUser.credential.rawData["access_token"] as? String {
                jsonObject.accessToken = accessToken
            }
            if let refreshToken = tempUser.credential.rawData["refresh_token"] as? String {
                jsonObject.refreshToken = refreshToken
            }
            if let expireIn = tempUser.credential.rawData["expires_in"] as? Int {
                jsonObject.expireIn = expireIn
            }
        }else {
            jsonObject.data = model.data
            jsonObject.thirdPartId = model.thirdPartId
        }
        StellarUserStore.sharedStore.bindThirdpart(thirdPartInfoModel: jsonObject, success: { (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let response = jsonDic.kj.model(CommonResponseModel.self)
            if response.code != 0 {
                TOAST(message: StellarLocalizedString("MINE_THRIDBIND_FAIL"))
            }else {
                if let index = self.dataList.firstIndex(where: {$0.thirdPartType == model.thirdPartType}) {
                    self.dataList.remove(at: index)
                    self.dataList.insert(jsonObject, at: index)
                    StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.append(jsonObject)
                    cell.openBg(type: model.thirdPartType) {
                        self.tableView.reloadData()
                        TOAST_SUCCESS(message: StellarLocalizedString("MINE_THRIDBIND_SUCCESS"))
                    }
                }
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            error.isEmpty ? TOAST(message: StellarLocalizedString("MINE_THRIDBIND_FAIL")):TOAST(message: error)
        }
    }
    private func netUnbindThird(model: ThirdPartInfoModel, cell: AccountBindingCell) { 
        StellarProgressHUD.showHUD()
        StellarUserStore.sharedStore.unbindThirdpart(thirdPartInfoModel: model, success: { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            let response = jsonDic.kj.model(type: CommonResponseModel.self) as? CommonResponseModel ?? CommonResponseModel()
            if response.code != 0 {
                TOAST(message: StellarLocalizedString("MINE_THRIDBIND_UNBINDFAIL"))
            }else {
                StellarAppManager.sharedManager.user.userInfo.thirdPartInfo.removeAll(where: {$0.thirdPartId == model.thirdPartId})
                let pModel = ThirdPartInfoModel()
                pModel.thirdPartType = model.thirdPartType
                guard let index = self?.dataList.firstIndex(where: {$0.thirdPartId == model.thirdPartId}) else {
                    return
                }
                self?.dataList.remove(at: index)
                self?.dataList.insert(pModel, at: index)
                cell.closeBg(type: model.thirdPartType) {
                    self?.tableView.reloadData()
                    TOAST_SUCCESS(message: StellarLocalizedString("MINE_THRIDBIND_UNBINDSUCCESS"))
                }
            }
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("MINE_THRIDBIND_UNBINDFAIL"))
        }
    }
    private func showUnbindTipAlert(model: ThirdPartInfoModel,cell: AccountBindingCell) {
        let typeString = model.thirdPartType == .wechat ? "微信":"Apple"
        let alert = StellarMineAlertView.init(title: StellarLocalizedString("MINE_THRIDBIND_UNBINDTIP"), message: "", leftTitle: StellarLocalizedString("MINE_THRIDBIND_UNBIND"), rightTitle: StellarLocalizedString("COMMON_CANCEL"), contentTip: "解绑后，您将无法使用\(typeString)登录")
        alert.show()
        alert.leftClickBlock = { [weak self] in
            self?.netUnbindThird(model: model, cell: cell)
        }
    }
}
extension AccountBindingViewController :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 54.fit - getAllVersionSafeAreaTopHeight()-NAVVIEW_HEIGHT_DISLODGE_SAFEAREA {
            navBar.titleLabel.text = ""
        }else
        {
            navBar.titleLabel.text = StellarLocalizedString("ALERT_BIND_ACCOUNT")
        }
    }
}
extension AccountBindingViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let thirdPartLoginModel = ThirdPartInfoModel()
        thirdPartLoginModel.thirdPartType = .apple
        let data = ThirdPartLoginModelData()
        thirdPartLoginModel.data = data
        if let apple = authorization.credential as? ASAuthorizationAppleIDCredential {
            thirdPartLoginModel.thirdPartId = apple.user
            data.identityToken = String.init(data: apple.identityToken ?? Data(), encoding: .utf8)
            data.authorizationCode = String.init(data: apple.authorizationCode ?? Data(), encoding: .utf8)
        } else if let password = authorization.credential as? ASPasswordCredential {
            thirdPartLoginModel.thirdPartId = password.user
        }
        guard let pCell = self.animateCell else { return }
        netBindThrid(model: thirdPartLoginModel, user: nil, cell: pCell)
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        TOAST(message: "授权失败")
    }
}