import UIKit
class DevicesSearchView: UIView {
    var selectDeviceBlock:((AddDeviceDetailModel) -> Void)?
    var selectList:[AddDeviceDetailModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    var selectDevice:AddDeviceDetailModel = AddDeviceDetailModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private func setupUI() {
        addSubview(tableView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.mj_w, height: self.mj_h))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "AddDeviceCell", bundle: nil), forCellReuseIdentifier: "AddDeviceCell")
        tempView.separatorStyle = .none
        return tempView
    }()
}
extension DevicesSearchView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "AddDeviceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddDeviceCell
        cell.selectionStyle = .none
        if let model = selectList?[indexPath.row] {
            cell.setData(detailModel: model,isHiddenArrow: false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = selectList?[indexPath.row]{
            self.selectDevice = model
            selectDeviceBlock?(model)
        }
    }
}