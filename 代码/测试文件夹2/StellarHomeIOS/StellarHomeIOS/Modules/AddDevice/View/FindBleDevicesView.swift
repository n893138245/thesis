import UIKit
class FindBleDevicesView: UIView {
    let headView = FindGetWayHeaderView.init(frame: CGRect.zero)
    var deviceDetailModel:AddDeviceDetailModel = AddDeviceDetailModel()
    var bleEquipmentsArr = [BleEquipmentModel](){
        didSet{
            if deviceDetailModel.connection == .dui {
                headView.findTitleLabel.text = StellarLocalizedString("ADD_DEVICE_DISCOVER") + "\(bleEquipmentsArr.count)" + StellarLocalizedString("ADD_DEVICE_AVAILABLE_GATEWAY")
                headView.selectTipLabel.isHidden = false
            }else{
                headView.findTitleLabel.text = StellarLocalizedString("ADD_DEVICE_DISCOVER") + "\(bleEquipmentsArr.count)" + StellarLocalizedString("ADD_DEVICE_AVAILABLE_DEVICE")
                headView.selectTipLabel.isHidden = true
            }
            tableView.reloadData()
        }
    }
    var clickForRowBlock: ((_ row :Int) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   private func setupUI() {
    layer.cornerRadius = 12.fit
    clipsToBounds = true
    backgroundColor = STELLAR_COLOR_C3
    headView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 116)
    tableView.tableHeaderView = headView
    }
   private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindGetwayCell", bundle: nil), forCellReuseIdentifier: "FindGetwayCellID")
        tableView.separatorStyle = .none
        addSubview(tableView)
        return tableView
    }()
}
extension FindBleDevicesView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleEquipmentsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindGetwayCellID", for: indexPath) as! FindGetwayCell
        cell.selectionStyle = .none
        let model = bleEquipmentsArr[indexPath.row]
        cell.setData(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickForRowBlock?(indexPath.row)
    }
}