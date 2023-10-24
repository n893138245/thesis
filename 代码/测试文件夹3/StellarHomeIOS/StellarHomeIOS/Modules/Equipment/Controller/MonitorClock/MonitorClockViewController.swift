import UIKit
class MonitorClockViewController: BaseViewController {
    var device: BasicDeviceModel?
    private var dataList: [(tittle: String, isOpen: Bool)] = [("生命体征消失报警", false),("跌倒报警", false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
    }
    private func setupUI() {
        view.backgroundColor = UIColor.ss.rgbColor(243, 244, 249)
        view.addSubview(navBar)
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(tableView)
        navBar.titleLabel.text = "监测报警设置"
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func setupData() {
        guard let light = device as? LightModel else { return }
        if light.status.vitalSignDisappearAlert == true {
            dataList[0].isOpen = true
        }
        if light.status.fallDownAlert == true {
            dataList[1].isOpen = true
        }
        tableView.reloadData()
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
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
}
extension MonitorClockViewController :UITableViewDelegate,UITableViewDataSource{
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
            switch self?.dataList[indexPath.row].tittle {
            case "生命体征消失报警":
                self?.netSendVitalSignDisappearAlert(isOn: isOn)
            case "跌倒报警":
                self?.netSendFallDownAlert(isOn: isOn)
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    private func netSendFallDownAlert(isOn: Bool) {
        guard let light = device as? LightModel else { return }
        StellarProgressHUD.showHUD()
        CommandManager.shared.creatFallDownAlertCommandAndSend(deviceGroup: [light], isOn: isOn) { [weak self] (_) in
            StellarProgressHUD.dissmissHUD()
            self?.dataList[1].isOpen = isOn
        } failure: { [weak self] (_, _) in
            self?.sendFailure()
        }
    }
    private func netSendVitalSignDisappearAlert(isOn: Bool) {
        guard let light = device as? LightModel else { return }
        StellarProgressHUD.showHUD()
        CommandManager.shared.creatVitalSignDisappearAlertCommandAndSend(deviceGroup: [light], isOn: isOn) { [weak self] (_) in
            StellarProgressHUD.dissmissHUD()
            self?.dataList[0].isOpen = isOn
        } failure: { [weak self] (_, _) in
            self?.sendFailure()
        }
    }
    private func sendFailure() {
        StellarProgressHUD.dissmissHUD()
        TOAST(message: "设置失败，请重试")
        self.tableView.reloadData()
    }
}