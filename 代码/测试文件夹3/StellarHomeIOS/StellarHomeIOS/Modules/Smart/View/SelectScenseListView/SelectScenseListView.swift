import UIKit
enum executeScenesType {
    case defaultType,customType
}
class SelectScenseListView: UIView {
    var executeScenesType: executeScenesType = .defaultType {
        didSet {
            loadData()
        }
    }
    private var lastSelectRow: Int?
    private let disposeBag = DisposeBag()
    private var dataList = [(scense: ScenesModel, selected: Bool)]()
    var selctedBlock: ((_ scenseId: String) ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = STELLAR_COLOR_C3
        addSubview(tableview)
        let TABLE_HAED_HEIGHT: CGFloat = 114+46+5
        let TABLE_HEIGT = kScreenHeight - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA - getAllVersionSafeAreaBottomHeight() - getAllVersionSafeAreaTopHeight() - 46.fit - 32.fit - 30.0
        tableview.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: TABLE_HEIGT)
        tableview.showsVerticalScrollIndicator = false
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: TABLE_HAED_HEIGHT))
        tableview.tableHeaderView = headerView
        tableview.register(UINib(nibName: "SceneDefaultViewCell", bundle: nil), forCellReuseIdentifier: "SceneDefaultViewCell")
        noEabledView.frame = CGRect(x: 0, y: TABLE_HAED_HEIGHT, width: kScreenWidth, height: TABLE_HEIGT-TABLE_HAED_HEIGHT)
        addSubview(noEabledView)
        noEabledView.isHidden = true
    }
    private func loadData() {
        var arr = [ScenesModel]()
        if executeScenesType == .defaultType {
            arr = StellarAppManager.sharedManager.user.mySceneModelArr.filter{$0.isDefault == true}
        }else {
            arr = StellarAppManager.sharedManager.user.mySceneModelArr.filter{$0.isDefault != true} 
        }
        arr.forEach { (model) in
            self.dataList.append((model,false))
        }
        dataList.sort { (model, model1) -> Bool in
            return model.scense.available == true
        }
        if dataList.isEmpty || DevicesStore.instance.lights.count == 0 {
            noEabledView.isHidden = false
        }
        addFooterIfNeed()
        tableview.reloadData()
    }
    private func addFooterIfNeed() {
        let TOP_VIEW_HEIGHT: CGFloat = 46+5
        let BOTTOM_SPACE: CGFloat = 46.fit+32+30
        let visibleHeight = kScreenHeight - NAVVIEW_HEIGHT_DISLODGE_SAFEAREA - getAllVersionSafeAreaTopHeight() - getAllVersionSafeAreaBottomHeight() - TOP_VIEW_HEIGHT - BOTTOM_SPACE 
        let tableContentHeight = 156*dataList.count
        if CGFloat(tableContentHeight) < visibleHeight {
            let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: visibleHeight - CGFloat(tableContentHeight)))
            tableview.tableFooterView = footerView
        }
    }
    func clearCurrentSelect() {
        if let lastRow = lastSelectRow {
            dataList[lastRow].selected = false
            tableview.reloadData()
        }
        lastSelectRow = nil
    }
    func setDefultSelectId(id: String) {
        if let index = dataList.firstIndex(where: {$0.scense.id == id}) {
            dataList[index].selected = true
            lastSelectRow = index
            tableview.reloadData()
        }
    }
    lazy var tableview: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        return view
    }()
    lazy var noEabledView: NoEnabledSceneView = {
        let view = NoEnabledSceneView.NoEnabledSceneView()
        return view
    }()
}
extension SelectScenseListView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DevicesStore.instance.lights.count == 0 {
            return 0
        }
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SceneDefaultViewCell", for: indexPath) as! SceneDefaultViewCell
        let model = dataList[indexPath.row]
        cell.selectionStyle = .none
        cell.setDataBySelectStyleModel(model: model)
        cell.isSelectStyle = true 
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if lastSelectRow == indexPath.row {
            return
        }
        if dataList[indexPath.row].scense.available == false {
            TOAST(message: "当前场景没有可用的设备")
            return
        }
        if let lastRow = lastSelectRow,let lastSelectCell = tableView.cellForRow(at: IndexPath(row: lastRow, section: 0)) as? SceneDefaultViewCell {
            lastSelectCell.setUnSelect()
            dataList[lastRow].selected = false
        }
        if let cell = tableView.cellForRow(at: indexPath) as? SceneDefaultViewCell {
            cell.setSelect()
        }
        dataList[indexPath.row].selected = true
        lastSelectRow = indexPath.row
        selctedBlock?(dataList[indexPath.row].scense.id ?? "")
    }
}