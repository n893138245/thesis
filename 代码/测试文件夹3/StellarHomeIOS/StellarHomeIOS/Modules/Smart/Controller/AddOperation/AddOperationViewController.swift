import UIKit
class AddOperationViewController: BaseViewController {
    var creatGroupDataModel = CreatGroupDataModel()
    private var dataList: [DataType] = [.executeScenesType,.controlRoomType,.controlDeviceType]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        setupData()
        loadSubViews()
    }
    private func setupData() {
        if creatGroupDataModel.sourceVc == .creatScense {
            dataList = [.controlRoomType,.controlDeviceType]
        }
    }
    private func loadSubViews(){
        loadNavView()
        loadTableView()
    }
    private func loadNavView(){
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.top.equalTo(getAllVersionSafeAreaTopHeight())
            make.left.right.equalTo(0)
            make.height.equalTo(44.fit)
        }
    }
    private func loadTableView(){
        let titleView = UIView()
        titleView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 114)
        titleView.addSubview(tipView)
        let titleLabel = UILabel()
        titleLabel.text = StellarLocalizedString("ALERT_ADD_OPERATION")
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-20, height: 45)
        titleView.addSubview(titleLabel)
        tableview.tableHeaderView = titleView
        tableview.register(UINib(nibName: "OperationTableViewCell", bundle: nil), forCellReuseIdentifier: "OperationTableViewCell")
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-getAllVersionSafeAreaBottomHeight() - 10.fit)
        }
    }
    private func pushWithControlType(type: DataType) {
        switch type {
        case .executeScenesType:
            let vc = SelectScenesViewController()
            vc.creatGroupDataModel = creatGroupDataModel
            navigationController?.pushViewController(vc, animated: true)
        case .controlRoomType:
            let vc = ControllRoomViewController()
            vc.creatGroupDataModel = creatGroupDataModel
            navigationController?.pushViewController(vc, animated: true)
        case.controlDeviceType:
            let vc = SelectLightsViewController()
            vc.creatGroupDataModel = creatGroupDataModel
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    private func showToast() {
        var tipString = ""
        switch creatGroupDataModel.myDataType {
        case .controlRoomType:
            tipString = StellarLocalizedString("SMART_DELET_ROOM")
        case .controlDeviceType:
            tipString = StellarLocalizedString("SMART_DELET_DEVICE")
        case .executeScenesType:
            tipString = StellarLocalizedString("SMART_DELET_SCENSE")
        default:
            break
        }
        TOAST_BOTTOM(message: tipString)
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
    private lazy var tipView:ScenseTitleTipView = {
        let view = ScenseTitleTipView.init(frame: CGRect(x: 0, y: 42, width: kScreenWidth, height: 72),title: StellarLocalizedString("SMART_ONLY_ONE_OPREATION"))
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension AddOperationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationTableViewCell", for: indexPath) as! OperationTableViewCell
        cell.selectionStyle = .none
        cell.setupOreation(operation: dataList[indexPath.row], currentOperation: creatGroupDataModel.myDataType)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controlType = dataList[indexPath.row]
        if creatGroupDataModel.myDataType != .emptyType {
            if controlType == creatGroupDataModel.myDataType {
                pushWithControlType(type: controlType)
            }else {
                showToast()
            }
        }else
        {
            pushWithControlType(type: controlType)
        }
    }
}