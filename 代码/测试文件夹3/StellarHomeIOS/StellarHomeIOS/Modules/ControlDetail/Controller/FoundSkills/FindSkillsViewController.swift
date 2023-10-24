import UIKit
class FindSkillsViewController: BaseViewController {
    var skillModels: [(skillModel: DUIInternalSkillModel, UIModel: OrdersSetModel)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        getData()
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
    lazy var tableView: UITableView = {
        let tempView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight-kNavigationH))
        tempView.showsVerticalScrollIndicator = false
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib(nibName: "GetwayVoiceCommandsCell", bundle: nil), forCellReuseIdentifier: "GetwayVoiceCommandsCell")
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
        titleLabel.text = "发现技能"
        titleLabel.font = STELLAR_FONT_MEDIUM_T30
        titleLabel.textColor = STELLAR_COLOR_C4
        return titleLabel
    }()
    func getData() {
        StellarProgressHUD.showHUD()
        DUIManager.sharedManager().queryInternalSkills(success: { [weak self] in
            self?.skillModels.removeAll()
            let skillModels = DUIManager.sharedManager().internalSkills
            skillModels.forEach { (model) in
                let uiModel = OrdersSetModel.init(skillModel: model)
                if uiModel.orderArray.first?.orders.isEmpty == false{
                    self?.skillModels.append((skillModel: model, UIModel: uiModel))
                }
            }
            StellarProgressHUD.dissmissHUD()
            self?.tableView.reloadData()
        }) {
            StellarProgressHUD.dissmissHUD()
        }
    }
}
extension FindSkillsViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skillModels.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GetwayVoiceCommandsCell", for: indexPath) as! GetwayVoiceCommandsCell
        let skillModel = skillModels[indexPath.row]
        cell.selectionStyle = .none
        cell.updateIconImage(url: skillModel.skillModel.img, isBgHidden: true)
        cell.setupUI(findSkillModel: skillModel.UIModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FoundSkillsViewController.init()
        vc.orderModel = self.skillModels[indexPath.row].UIModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension FindSkillsViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let contentOffsetY:CGFloat = scrollView.contentOffset.y
        if contentOffsetY <= navBar.frame.maxY + 74.fit - getAllVersionSafeAreaTopHeight()-NAVVIEW_HEIGHT_DISLODGE_SAFEAREA {
            navBar.titleLabel.text = ""
        }else
        {
            navBar.titleLabel.text = "发现技能"
        }
    }
}