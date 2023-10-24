import UIKit
class AddConditionViewController: BaseViewController {
    var condition:IntelligentDetailModelCondition?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = STELLAR_COLOR_C3
        loadSubViews()
    }
    func loadSubViews(){
        loadNavView()
        loadTableView()
    }
    func loadNavView(){
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
    func loadTableView(){
        let titleView = UIView()
        titleView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 82)
        let titleLabel = UILabel()
        titleLabel.text = StellarLocalizedString("SMART_ADD_CONDITION")
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T30
        titleLabel.frame = CGRect.init(x: 20, y: 0, width: kScreenWidth-20, height: 58)
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
    private func getCondition() ->IntelligentDetailModelCondition {
        let pCondition = IntelligentDetailModelCondition()
        let param = IntelligentDetailModelConditionParams()
        param.weekdays = self.condition?.params.weekdays
        param.countdownTime = self.condition?.params.countdownTime ?? 0
        param.time = self.condition?.params.time ?? ""
        param.sn = self.condition?.params.sn ?? ""
        pCondition.params = param
        pCondition.type = self.condition?.type ?? .other
        return pCondition
    }
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var navView:NavView = {
        let view = NavView()
        view.myState = .kNavBlack
        view.setTitle(title: "")
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension AddConditionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationTableViewCell", for: indexPath) as! OperationTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.setupViews(topString: StellarLocalizedString("SMART_AT_TIME"), bottomString: StellarLocalizedString("SMART_ADD_CONDITION_EXAMPLE"), imageName: "icon_scence_time")
        }
        else{
            cell.setupViews(topString: StellarLocalizedString("SMART_CUTDOWN"), bottomString: StellarLocalizedString("SMART_ADD_CUTDOWN_EXAMPLE"), imageName: "icon_scence_countdown")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ChooseAppointOpenViewController()
            vc.condition = self.getCondition()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = AddCountDownViewController()
            vc.condition = self.getCondition()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}