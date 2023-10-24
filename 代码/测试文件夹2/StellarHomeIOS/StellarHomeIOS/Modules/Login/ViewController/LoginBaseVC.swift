import UIKit
class LoginBaseVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    func setupViews(){
        view.backgroundColor = STELLAR_COLOR_C1
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: 44)
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp_bottomMargin).offset(8)
            make.left.equalTo(20)
        }
        view.addSubview(contentBGView)
        contentBGView.snp.makeConstraints { (make) in
            make.top.equalTo(typeLabel.snp_bottomMargin).offset(29)
            make.bottom.equalTo(-24-getAllVersionSafeAreaBottomHeight())
            make.left.equalTo(9)
            make.right.equalTo(-9)
        }
        view.addSubview(topBGView)
        topBGView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(self.contentBGView.snp.top)
            make.left.equalTo(9)
            make.right.equalTo(-9)
        }
    }
    func checkNewUser(phone:String = "",email:String = "",successBlock: ((Bool) ->Void)?,failureBlock: (() ->Void)?){
        StellarProgressHUD.showHUD()
        if phone.isEmpty && email.isEmpty{
            failureBlock?()
        }
        if phone.isEmpty{
            StellarUserStore.sharedStore.checkIsNewUser(email: email, success: { (isNew) in
                StellarProgressHUD.dissmissHUD()
                successBlock?(isNew)
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
                failureBlock?()
            }
        }else{
            StellarUserStore.sharedStore.checkIsNewUser(cellphone: phone, success: { (isNew) in
                StellarProgressHUD.dissmissHUD()
                successBlock?(isNew)
            }) { (error) in
                StellarProgressHUD.dissmissHUD()
                failureBlock?()
            }
        }
    }
    lazy var navView:NavView = {
        let view = NavView()
        view.myState = .kNavWhite
        view.setTitle(title: "")
        return view
    }()
    lazy var topBGView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "login_bg")
        return view
    }()
    lazy var typeLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = STELLAR_COLOR_C3
        label.font = STELLAR_FONT_BOLD_T30
        return label
    }()
    lazy var contentBGView:UIView = {
        let view = UIView.init()
        view.backgroundColor = STELLAR_COLOR_C3
        view.layer.cornerRadius = 12
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}