import UIKit
class AccessDevicesViewController: BaseViewController {
    var dataList = [BasicDeviceModel]()
    var hub = GatewayModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
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
        let allDevices = DevicesStore.instance.allDevices
        dataList = allDevices.filter({ [weak self] (model) -> Bool in
            if let panel = model as? PanelModel {
                return panel.gatewaySn == self?.hub.sn
            }
            if let light = model as? LightModel {
                return light.gatewaySn == self?.hub.sn
            }
            return false
        })
        dataList.sort { (model1, model2) -> Bool in
            if let light = model1 as? LightModel {
                return light.status.online
            }
            if let panel = model1 as? PanelModel {
                return panel.status.online
            }
            if let light = model2 as? LightModel {
                return !light.status.online
            }
            if let panel = model2 as? PanelModel {
                return !panel.status.online
            }
            return true
        }
        tableView.reloadData()
    }
    lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "AccessDeviceCell", bundle: nil), forCellReuseIdentifier: "AccessDeviceCell")
        tempView.register(UINib(nibName: "GatewayEmptyCell", bundle: nil), forCellReuseIdentifier: "GatewayEmptyCell2")
        tempView.separatorStyle = .none
        return tempView
    }()
    lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        tempView.moreButton.isHidden = true
        tempView.titleLabel.text = ""
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.text = "接入设备"
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
}
extension AccessDevicesViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count != 0 {
            return dataList.count
        } else {
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataList.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccessDeviceCell", for: indexPath) as! AccessDeviceCell
            cell.selectionStyle = .none
            cell.setData(model: dataList[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GatewayEmptyCell2", for: indexPath) as! GatewayEmptyCell
            cell.selectionStyle = .none
            cell.setUpUI(padding: 83)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataList.count != 0 {
            return 100
        } else {
            return kScreenHeight - kNavigationH - 74.fit * 2 - kBottomArcH
        }
    }
}
extension AccessDevicesViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 74.fit - getAllVersionSafeAreaTopHeight()-NAVVIEW_HEIGHT_DISLODGE_SAFEAREA {
            navBar.titleLabel.text = ""
        }else
        {
            navBar.titleLabel.text = "接入设备"
        }
    }
}