import UIKit
class FindDeviceView: UIView {
    let disposeBag = DisposeBag()
    var devices = [(BasicDeviceModel,Bool)]()
    var myDeviceType:DeviceType = .unknown
    var isClickAllCancel = false
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
        addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.width.equalTo(291.fit)
            $0.bottom.equalTo(self).offset(-32.fit)
            $0.height.equalTo(46.fit)
        }
        setupTableHeaderView()
        bottomBtn.isEnabled = true
    }
    private func setupTableHeaderView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 96.fit)
        tableView.tableHeaderView = tableHeaderView
        tableHeaderView.addSubview(topLabel)
        tableHeaderView.addSubview(bottomLabel)
        tableHeaderView.addSubview(allSelectBtn)
        topLabel.snp.makeConstraints {
            $0.top.equalTo(tableHeaderView).offset(32.fit)
            $0.centerX.equalTo(tableHeaderView)
        }
        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(8.fit)
            $0.left.equalTo(tableHeaderView).offset(80.fit)
        }
        allSelectBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomLabel)
            $0.left.equalTo(bottomLabel.snp.right).offset(4.fit)
        }
        bottomLabel.text = StellarLocalizedString("ADD_DEVICE_SELECT_ADD_DEVICE")
        allSelectBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            if self?.isClickAllCancel == false{
                self?.allSelectBtn.setTitle(StellarLocalizedString("ADD_DEVICE_FUTRURE_GENERATION"), for: .normal)
                self?.isClickAllCancel = true
                self?.devices = (self?.devices.map({($0.0,false)}))!
                self?.bottomBtn.isEnabled = false
            }else{
                self?.allSelectBtn.setTitle(StellarLocalizedString("ADD_DEVICE_CANCEL_ALL"), for: .normal)
                self?.isClickAllCancel = false
                self?.devices = (self?.devices.map({($0.0,true)}))!
                self?.bottomBtn.isEnabled = true
            }
            self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    func addDevice(model:BasicDeviceModel){
        model.name = checkName(deviceName: model.name, existDevices: devices.map({ (device) -> String in
            device.0.name
        }))
        if isClickAllCancel {
            devices.append((model,false))
        }else{
            devices.append((model,true))
            bottomBtn.isEnabled = true
        }
        if devices.count == 1 {
            bottomLabel.isHidden = true
            allSelectBtn.isHidden = true
        }else{
            bottomLabel.isHidden = false
            allSelectBtn.isHidden = false
        }
        topLabel.text = StellarLocalizedString("ADD_DEVICE_DISCOVER") + "\(devices.count)" + StellarLocalizedString("ADD_DEVICE_AVAILABLE_DEVICE")
        tableView.reloadData()
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-46.fit-32.fit-10), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindDeviceCell", bundle: nil), forCellReuseIdentifier: "findDeviceCellID")
        tableView.separatorStyle = .none
        addSubview(tableView)
        return tableView
    }()
   lazy var bottomBtn: StellarButton = {
        let tempView = StellarButton()
        tempView.style = .normal
        tempView.setTitle(StellarLocalizedString("ADD_DEVICE_ONE_KEY_ADD"), for: .normal)
        return tempView
    }()
    private lazy var topLabel: UILabel = {
        let tempView = UILabel()
        tempView.textColor = STELLAR_COLOR_C4
        tempView.font = STELLAR_FONT_MEDIUM_T20
        return tempView
    }()
    private lazy var bottomLabel: UILabel = {
        let tempView = UILabel()
        tempView.textColor = STELLAR_COLOR_C6
        tempView.font = STELLAR_FONT_T14
        return tempView
    }()
    private lazy var allSelectBtn: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.setTitle(StellarLocalizedString("ADD_DEVICE_CANCEL_ALL"), for: .normal)
        tempView.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        tempView.titleLabel?.font = STELLAR_FONT_T14
        return tempView
    }()
    private lazy var tableHeaderView: UIView = {
        let tempView = UIView()
        return tempView
    }()
}
extension FindDeviceView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findDeviceCellID", for: indexPath) as! FindDeviceCell
        cell.selectionStyle = .none
        let model = devices[indexPath.row]
        cell.setData(model: model, theType: myDeviceType)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FindDeviceCell
        if cell.isSelcted {
            devices[indexPath.row].1 = false
        }else{
            devices[indexPath.row].1 = true
        }
        bottomBtn.isEnabled = (devices.filter { (device) -> Bool in
            device.1
        }).count > 0
        tableView.reloadData()
    }
}