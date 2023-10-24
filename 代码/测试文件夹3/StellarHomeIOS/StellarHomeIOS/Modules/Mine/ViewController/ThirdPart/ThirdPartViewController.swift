import UIKit
class ThirdPartViewController: BaseViewController {
//    private let dataList = [(icon:"AmazonAlexa",title: "Amazon Alexa",content:"Connect your SANSI device to Alexa for handsfree control"),(icon:"GoogleHome",title: "Google Home",content:"Connect your SANSI device to google for handsfree control")]
    private let dataList = [
        "Alamofire (4.9.1)",
        "AWSAuthCore (2.19.1)",
        "AWSCore (2.19.1)",
        "AWSCognito (2.19.1)",
        "AWSCognitoIdentityProvider (2.19.1)",
        "AWSCognitoIdentityProviderASF (2.19.1)",
        "AWSMobileClient (2.19.1)",
        "AWSS3 (2.19.1)",
        "CocoaAsyncSocket (7.6.5)",
        "CocoaLumberjack (3.7.2)",
        "CocoaLumberjack/Core (3.7.2)",
        "CocoaMQTT (1.2.5)",
        "CountryPickerView (3.2.0)",
        "CryptoSwift (1.4.0)",
        "Differentiator (4.0.1)",
        "FBAllocationTracker (0.1.5)",
        "FBRetainCycleDetector (0.1.4)",
        "FDFullscreenPopGesture (1.1)",
        "FSCalendar (2.8.2)",
        "IQKeyboardManagerSwift (6.5.6)",
        "KakaJSON (1.1.2)",
        "Kingfisher (5.14.1)",
        "Kingfisher/Core (5.14.1)",
        "libPhoneNumber-iOS (0.9.15)",
        "LTMorphingLabel (0.8.1)",
        "MBProgressHUD (1.2.0)",
        "MJRefresh (3.2.3)",
        "Moya (13.0.1)",
        "Moya/Core (13.0.1)",
        "Result (~> 4.1)",
        "NSHash (1.2.0)",
        "NVActivityIndicatorView (5.1.1)",
        "NVActivityIndicatorView/Base (5.1.1)",
        "pop (1.0.12)",
        "ReactiveCocoa (11.2.1)",
        "ReactiveSwift (~> 6.6)",
        "RxCocoa (5.1.1)",
        "RxRelay (~> 5)",
        "RxSwift (~> 5)",
        "RxDataSources (4.0.1)",
        "RxCocoa (~> 5.0)",
        "RxSwift (~> 5.0)",
        "RxRelay (5.1.1)",
        "SnapKit (5.0.1)",
        "SwiftRichString (3.5.1)",
        "SwiftyJSON (4.3.0)",
        "SwipeCellKit (2.7.1)",
        "TZImagePickerController (3.6.0)",
        "YYKit (1.0.9)",
        "YYKit/no-arc (1.0.9)"
    ]
    private let nameList = [
        "Alamofire",
        "AWSAuthCore",
        "AWSCore",
        "AWSCognito",
        "AWSCognitoIdentityProvider",
        "AWSCognitoIdentityProviderASF",
        "AWSMobileClient",
        "AWSS3",
        "CocoaAsyncSocket",
        "CocoaLumberjack",
        "CocoaLumberjack/Core",
        "CocoaMQTT",
        "CountryPickerView",
        "CryptoSwift",
        "Differentiator",
        "FBAllocationTracker",
        "FBRetainCycleDetector",
        "FDFullscreenPopGesture",
        "FSCalendar",
        "IQKeyboardManagerSwift",
        "KakaJSON",
        "Kingfisher",
        "Kingfisher/Core",
        "libPhoneNumber-iOS",
        "LTMorphingLabel",
        "MBProgressHUD",
        "MJRefresh",
        "Moya",
        "Moya/Core",
        "Result",
        "NSHash",
        "NVActivityIndicatorView",
        "NVActivityIndicatorView/Base",
        "pop",
        "ReactiveCocoa",
        "ReactiveSwift",
        "RxCocoa",
        "RxRelay",
        "RxSwift",
        "RxDataSources",
        "RxCocoa",
        "RxSwift",
        "RxRelay",
        "SnapKit",
        "SwiftRichString",
        "SwiftyJSON",
        "SwipeCellKit",
        "TZImagePickerController",
        "YYKit",
        "YYKit/no-arc"
    ]
    private let versionList = [
        "4.9.1",
        "2.19.1",
        "2.19.1",
        "2.19.1",
        "2.19.1",
        "2.19.1",
        "2.19.1",
        "2.19.1",
        "7.6.5",
        "3.7.2",
        "3.7.2",
        "1.2.5",
        "3.2.0",
        "1.4.0",
        "4.0.1",
        "0.1.5",
        "0.1.4",
        "1.1",
        "2.8.2",
        "6.5.6",
        "1.1.2",
        "5.14.1",
        "5.14.1",
        "0.9.15",
        "0.8.1",
        "1.2.0",
        "3.2.3",
        "13.0.1",
        "13.0.1",
        "~> 4.1",
        "1.2.0",
        "5.1.1",
        "5.1.1",
        "1.0.12",
        "11.2.1",
        "~> 6.6",
        "5.1.1",
        "~> 5",
        "~> 5",
        "4.0.1",
        "~> 5.0",
        "~> 5.0",
        "5.1.1",
        "5.0.1",
        "3.5.1",
        "4.3.0",
        "2.7.1",
        "3.6.0",
        "1.0.9",
        "1.0.9"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH)
        let titleView = UIView()
        titleView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 80)
        let titleLabel = UILabel()
        titleLabel.text = "第三方库"
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-20, height: 80)
        titleView.addSubview(titleLabel)
        tableview.tableHeaderView = titleView
        tableview.register(UINib(nibName: "ThridPartCell", bundle: nil), forCellReuseIdentifier: "ThridPartCell")
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-getAllVersionSafeAreaBottomHeight() - 10.fit)
        }
    }
    private lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    private lazy var navView:NavView = {
        let view = NavView()
        view.myState = .kNavBlack
        view.setTitle(title: "")
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension ThirdPartViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThridPartCell", for: indexPath) as! ThridPartCell
        cell.selectionStyle = .none
//        cell.setupViews(icon: dataList[indexPath.row].icon, title: dataList[indexPath.row].title, content: dataList[indexPath.row].content)
//        cell.title.text = dataList[indexPath.row]
        cell.title.text = nameList[indexPath.row]
        cell.content.text = versionList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
