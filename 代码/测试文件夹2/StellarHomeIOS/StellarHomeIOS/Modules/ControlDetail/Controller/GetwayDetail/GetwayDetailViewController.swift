import UIKit
class GetwayDetailViewController: BaseViewController {
    var gateWay = GatewayModel()
    lazy var orderModels: [OrdersSetModel] = {
        var result: [OrdersSetModel] = []
        let childDevices = DevicesStore.sharedStore().lights.filter{$0.gatewaySn == gateWay.sn}
        childDevices.forEach { (light) in
            let orderModel = OrdersSetModel.init(device: light)
            result.append(orderModel)
        }
        let orderModel = OrdersSetModel.init(device: self.gateWay)
        result.insert(orderModel, at: 0)
        return result
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        let allDevices = DevicesStore.instance.allDevices
        let arr = allDevices.filter({ [weak self] (model) -> Bool in
            if let panel = model as? PanelModel {
                return panel.gatewaySn == self?.gateWay.sn
            }
            if let light = model as? LightModel {
                return light.gatewaySn == self?.gateWay.sn
            }
            return false
        })
        headerView.leftButton.subTitleLabel.text = "共\(arr.count)个"
        if gateWay.room != nil {
            navBar.titleLabel.text = "\(StellarRoomManager.shared.getRoom(roomId: gateWay.room!).name ?? "") \(gateWay.name)"
        }
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navBar.rightBlock = { [weak self] in
            let vc = SetupViewController()
            vc.device = self?.gateWay
            vc.changeInfoBlock = { (name, id) in
                self?.gateWay.name = name
                self?.gateWay.room = id
                self?.navBar.titleLabel.text = "\(StellarRoomManager.shared.getRoom(roomId: id).name ?? "") \(name)"
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        headerView.rightButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                let vc = FindSkillsViewController.init()
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        headerView.leftButton.rx
            .tap.subscribe(onNext: { [weak self] (_) in
                let vc = AccessDevicesViewController.init()
                if let tempHub = self?.gateWay{
                    vc.hub = tempHub
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "GetwayVoiceCommandsCell", bundle: nil), forCellReuseIdentifier: "GetwayVoiceCommandsCell")
        tempView.register(UINib(nibName: "GatewayEmptyCell", bundle: nil), forCellReuseIdentifier: "GatewayEmptyCell")
        tempView.separatorStyle = .none
        return tempView
    }()
    lazy var headerView: GetwayDetailHeaderView = {
        let tempView = GetwayDetailHeaderView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 380.fit + getAllVersionSafeAreaTopHeight()))
        return tempView
    }()
}
extension GetwayDetailViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderModels.count == 0 {
            return 1
        } else {
            return orderModels.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if orderModels.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GetwayVoiceCommandsCell", for: indexPath) as! GetwayVoiceCommandsCell
            cell.selectionStyle = .none
            cell.setupUI(findSkillModel: orderModels[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GatewayEmptyCell", for: indexPath) as! GatewayEmptyCell
            cell.selectionStyle = .none
            cell.setUpUI(padding: 108)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if orderModels.count != 0 {
            return 140
        } else {
            return kScreenHeight - kNavigationH - headerView.frame.size.height - kBottomArcH
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if orderModels.count != 0 {
            let orderModel = orderModels[indexPath.row]
            let nextVC = FoundSkillsViewController.init()
            nextVC.orderModel = orderModel
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}