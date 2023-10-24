import UIKit
class FoundSkillsViewController: BaseViewController {
    var orderModel: OrdersSetModel?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let effect = LTMorphingEffect(rawValue:0)
        headView.contentLabel.text = orderModel?.title ?? ""
        headView.contentLabel.morphingEffect = effect!
    }
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
        navView.myState = .kNavBlack
        navView.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: getAllVersionSafeAreaTopHeight(), width: kScreenWidth, height: NAVVIEW_HEIGHT_DISLODGE_SAFEAREA)
    }
    func loadTableView(){
        headView.bounds = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 169+16)
        tableview.tableHeaderView = headView
        tableview.register(UINib(nibName: "FoundSkillsRowCell", bundle: nil), forCellReuseIdentifier: "FoundSkillsRowCell")
        view.addSubview(tableview)
        tableview.frame = CGRect.init(x: 0, y: navView.frame.maxY, width: kScreenWidth, height: kScreenHeight - navView.frame.maxY)
    }
    func calculateRowHeight(indexPath: IndexPath) -> CGFloat {
        let contentLabel = UILabel.init()
        contentLabel.font = STELLAR_FONT_T16
        contentLabel.numberOfLines = 0
        contentLabel.text = "“\(orderModel?.orderArray[indexPath.section].orders[indexPath.row] ?? "")”"
        let size = contentLabel.sizeThatFits(CGSize.init(width: kScreenWidth - 57*2, height: kScreenHeight))
        let result = size.height + 24.0 + 18.0
        print("zzzzzzzzzzzzz rowheight \(result)  \(contentLabel.text ?? "")")
        return result
    }
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var navView:NavView = {
        let view = NavView()
        return view
    }()
    lazy var headView:FoundSkillsHeadView = {
        let view = FoundSkillsHeadView.FoundSkillsHeadView()
        view.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 0)
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
extension FoundSkillsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if orderModel?.title == "网关快捷唤醒词" {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 80))
            let label = UILabel(frame: CGRect(x: 26, y: 0, width: kScreenWidth - 52, height: 80))
            label.numberOfLines = 0
            view.addSubview(label)
            let text = NSMutableAttributedString.init(string: orderModel?.orderArray[section].header ?? "")
            text.lineSpacing = 6
            text.font = STELLAR_FONT_T15
            text.color = UIColor.ss.rgbColor(39, 42, 53)
            label.attributedText = text
            label.textAlignment = .center
            return view
        }
        let view = FoundSkillsSectionView.FoundSkillsSectionView()
        view.topLabel.text = orderModel?.orderArray[section].header ?? ""
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if orderModel?.title == "网关快捷唤醒词" {
            return 80
        }
        return 52
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderModel?.orderArray[section].orders.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderModel?.orderArray.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundSkillsRowCell", for: indexPath) as! FoundSkillsRowCell
        cell.selectionStyle = .none
        cell.setupViews(content: orderModel?.orderArray[indexPath.section].orders[indexPath.row] ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateRowHeight(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}