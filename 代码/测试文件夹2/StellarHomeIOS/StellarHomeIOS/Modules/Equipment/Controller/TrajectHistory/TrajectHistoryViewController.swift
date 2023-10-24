import UIKit
class TrajectHistoryViewController: BaseViewController {
    var device: BasicDeviceModel?
    var timeList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
    }
    private func setupData() {
        guard let time = timeList.first else { return }
        let date = getDate(utcTime: time)
        titleLabel.text = "\(date.m)月\(date.d)号"
    }
    private func getDate(utcTime: String) -> (y: String,m: String, d: String) {
        let transTime = String.ss.localTimeWithUTCString(UTCtimeString: utcTime, dateFormat: "yyyy-MM-dd")
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        let date = dateF.date(from: transTime) ?? Date()
        let calender = Calendar.current
        return ("\(calender.component(.year, from: date))","\(calender.component(.month, from: date))","\(calender.component(.day, from: date))")
    }
    private func getMinString(utcTime: String) -> String {
        let minLeft = String.ss.localTimeWithUTCString(UTCtimeString: utcTime, dateFormat: "HH:mm")
        let pDateString = String.ss.localTimeWithUTCString(UTCtimeString: utcTime, dateFormat: "yyyy-MM-dd HH:mm:ss")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: pDateString) ?? Date()
        let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        let minRight = dateFormatter.string(from: nextDate)
        return "\(minLeft)-\(minRight)"
    }
    private func setupUI() {
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 80))
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(header).offset(20)
            $0.top.equalTo(header).offset(24)
        }
        tableView.tableHeaderView = header
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH-getAllVersionSafeAreaBottomHeight()))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "HistoryMinCell", bundle: nil), forCellReuseIdentifier: "HistoryMinCell")
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
        tempView.titleLabel.text = "运动轨迹历史"
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.text = "1月7号"
        titleLabel.font = STELLAR_FONT_MEDIUM_T20
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
}
extension TrajectHistoryViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryMinCell", for: indexPath) as! HistoryMinCell
        cell.selectionStyle = .none
        let isHiddenTopLine = indexPath.row == 0 ? true:false
        let isHiddenBottmLine = indexPath.row + 1 == timeList.count ? true:false
        let utcTime = timeList[indexPath.row]
        cell.setupData(time: getMinString(utcTime: utcTime), isHiddenTopLine: isHiddenTopLine, isHiddenBottmLine: isHiddenBottmLine)
        cell.clickBlock = { [weak self] in
            self?.netGetLocations(utcTime: utcTime)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    private func netGetLocations(utcTime: String) {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().getLocationsHistoryByTime(sn: device?.sn ?? "", time: utcTime) { [weak self] (infoList) in
            StellarProgressHUD.dissmissHUD()
            self?.showBottomView(time: utcTime, infoList: infoList)
        } failure: { (_) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: "获取轨迹失败")
        }
    }
    private func showBottomView(time: String, infoList: [RadarLocationInfo]) {
        let popView = SSBottomPopView.SSBottomPopView()
        let date = getDate(utcTime: time)
        popView.setupViews(title: "\(date.m)月\(date.d)号 \(getMinString(utcTime: time))")
        let fac = HBottomHistoryFactory()
        fac.locations = infoList
        popView.setDisplayFactory(factory: fac)
        popView.setContentHeight(height: 320.fit + getAllVersionSafeAreaBottomHeight())
        popView.show()
    }
}