import UIKit
class ThirdPartViewController: BaseViewController {
    private let dataList = [(icon:"AmazonAlexa",title: "Amazon Alexa",content:"Connect your SANSI device to Alexa for handsfree control"),(icon:"GoogleHome",title: "Google Home",content:"Connect your SANSI device to google for handsfree control")]
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
        titleLabel.text = "Third Party Access"
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
        cell.setupViews(icon: dataList[indexPath.row].icon, title: dataList[indexPath.row].title, content: dataList[indexPath.row].content)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
}