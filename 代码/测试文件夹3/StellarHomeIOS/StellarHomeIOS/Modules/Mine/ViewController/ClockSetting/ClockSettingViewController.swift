import UIKit
class ClockSettingViewController: BaseViewController {
    private var dataList: [(type: UserAlertWays,isOpen: Bool,isWayExistance: Bool)] = []
    private var alertWays: [UserAlertWays] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupActions()
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
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func setupData() {
        let info = StellarAppManager.sharedManager.user.userInfo
        info.cellphone.isEmpty ? dataList.append((.cellphone,false,false)) : dataList.append((.cellphone,false,true))
        info.email.isEmpty ? dataList.append((.email,false,false)) : dataList.append((.email,false,true))
        checkData(info: info)
        self.alertWays = info.alertWays
    }
    private func checkData(info: InfoModel) {
        dataList[0].isOpen = info.alertWays.contains(.cellphone)
        dataList[1].isOpen = info.alertWays.contains(.email)
    }
    private func netChangeInfo() {
        StellarProgressHUD.showHUD()
        StellarUserStore.sharedStore.modificationUserInfo(alertWays: alertWays.map({$0.rawValue})) { [weak self] (_) in
            StellarProgressHUD.dissmissHUD()
            StellarAppManager.sharedManager.user.userInfo.alertWays = self?.alertWays ?? []
            self?.checkData(info: StellarAppManager.sharedManager.user.userInfo)
            self?.tableView.reloadData()
        } failure: { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: "修改失败，请重试")
            self.tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH-getAllVersionSafeAreaBottomHeight()))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "UserClockSetCell", bundle: nil), forCellReuseIdentifier: "UserClockSetCell")
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
        titleLabel.text = "报警消息接收设置"
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
}
extension ClockSettingViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserClockSetCell", for: indexPath) as! UserClockSetCell
        cell.selectionStyle = .none
        cell.setupData(model: dataList[indexPath.row])
        cell.switchBlock = { [weak self] isOn in
            if !isOn {
                self?.alertWays.removeAll(where: {$0 == self?.dataList[indexPath.row].type})
            }else {
                guard let model = self?.dataList[indexPath.row] else { return }
                guard let ways = self?.alertWays else { return }
                if !ways.contains(model.type) {
                    self?.alertWays.append(model.type)
                }
            }
            self?.netChangeInfo()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension ClockSettingViewController :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 74.fit - getAllVersionSafeAreaTopHeight()-NAVVIEW_HEIGHT_DISLODGE_SAFEAREA {
            navBar.titleLabel.text = ""
        }else {
            navBar.titleLabel.text = "报警消息接收设置"
        }
    }
}