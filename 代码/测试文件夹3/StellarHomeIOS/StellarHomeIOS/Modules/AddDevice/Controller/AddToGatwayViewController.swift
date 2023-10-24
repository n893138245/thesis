import UIKit
class AddToGatwayViewController: AddDeviceBaseViewController {
    var hubList: [GatewayModel] = []
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel(){
        didSet {
            if deviceDetailModel.type != oldValue.type {
                setupViewType()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
    }
    private func setupViewType() {
        switch deviceDetailModel.type {
        case .light:
            navBar.titleLabel.text = StellarLocalizedString("EQUIPMENT_ADD_LIGHT")
        case .panel:
            navBar.titleLabel.text = StellarLocalizedString("ADD_DEVICE_ADD_PANEL")
        default:
            break
        }
    }
    private func setupUI() {
        navBar.exitButton.isHidden = true
        let headerView = UILabel.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100.fit))
        headerView.textColor = STELLAR_COLOR_C4
        headerView.textAlignment = .center
        headerView.font = STELLAR_FONT_MEDIUM_T20
        headerView.text = StellarLocalizedString("ADD_DEVICE_ADD") + StellarLocalizedString("COMMON_TO")
        tableView.tableHeaderView = headerView
        cardView.addSubview(tableView)
    }
    private func setupActions() {
        navBar.backButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    private func setupData() {
        hubList.sort { (model, _) -> Bool in
            return model.status.online
        }
        tableView.reloadData()
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: cardView.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindGetwayCell", bundle: nil), forCellReuseIdentifier: "FindGetwayCellID")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12.fit
        tableView.clipsToBounds = true
        return tableView
    }()
}
extension AddToGatwayViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hubList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindGetwayCellID", for: indexPath) as! FindGetwayCell
        cell.selectionStyle = .none
        let gateWay = hubList[indexPath.row]
        cell.setupData(gatewayModel: gateWay)
        if indexPath.row == hubList.count - 1 {
            cell.bottomLine.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.fit
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gateWay = hubList[indexPath.row]
        if gateWay.status.online {
            if deviceDetailModel.type == .light {
                let vc = SearchDeviceViewController()
                vc.deviceDetailModel = deviceDetailModel
                vc.belongGateWayModel = gateWay
                navigationController?.pushViewController(vc, animated: true)
            }else
            {
                let vc = CommonGuideViewController.init()
                vc.deviceDetailModel = deviceDetailModel
                vc.gateWayModel = gateWay 
                navigationController?.pushViewController(vc, animated: true)
            }
        }else
        {
            TOAST(message: StellarLocalizedString("ADD_DEVICE_DEVICE_OFFLINE"))
        }
    }
}