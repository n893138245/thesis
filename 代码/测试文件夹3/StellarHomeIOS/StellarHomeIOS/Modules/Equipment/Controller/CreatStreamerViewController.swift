import UIKit
enum PushResState {
    case creatStreamer
    case stremerDetail
}
class CreatStreamerViewController: BaseViewController {
    var dataList: [AddStreamerLocalModel] = []
    var streamerNmae: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    var resState: PushResState = .creatStreamer {
        didSet {
            if resState == .creatStreamer {
                navBar.setTitle(title: "创建流光")
            }else {
                navBar.setTitle(title: streamerNmae ?? "", imageName: "icon_edit-1")
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            for subView in tableView.subviews {
                if String(describing: subView).range(of: "UISwipeActionPullView") != nil {
                    subView.backgroundColor = .clear
                    for button in subView.subviews {
                        let btn = button as! UIButton
                        btn.frame = CGRect(x: kScreenWidth-120, y: 0, width: 120, height: 85)
                        btn.backgroundColor = UIColor.init(hexString: "#F3F4F8")
                        btn.setTitleColor(.clear, for: .normal)
                        btn.adjustsImageWhenHighlighted = false
                        let cusButton = UIButton.init(type: .custom)
                        cusButton.setBackgroundImage(UIImage(named: "red_delete_bg2_n"), for: .normal)
                        cusButton.setBackgroundImage(UIImage(named: "red_delete_bg2_s"), for: .highlighted)
                        cusButton.setTitle("删除", for: .normal)
                        cusButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
                        cusButton.frame = btn.bounds
                        button.addSubview(cusButton)
                    }
                }
            }
        }
    }
    func setupUI() {
        let bgImage = UIImageView.init(frame: view.bounds)
        if isIphoneX_serious {
            bgImage.image = UIImage(named: "streamer_1242x2688")
        }else {
            bgImage.image = UIImage(named: "streamer_1242x2208")
        }
        view.addSubview(bgImage)
        view.addSubview(preViewButton)
        view.addSubview(saveButton)
        view.addSubview(topHeaderView)
        view.addSubview(tableView)
        view.addSubview(navBar)
    }
    private func setupActions() {
        topHeaderView.clickForTypeBlock = { [weak self] (type, title) in
            let pullView = StreamerPullView.StreamerPullView()
            pullView.type = type == .repet ? .frequency:.afterEnd
            pullView.currentText = title
            pullView.frame = self?.view.bounds ?? CGRect.zero
            self?.view.addSubview(pullView)
            pullView.clickTitleBlock = { text in
                type == .repet ? self?.topHeaderView.loopButton.setTitle(text, for: .normal):self?.topHeaderView.afterEndButton.setTitle(text, for: .normal)
                self?.topHeaderView.rotateArrow(withType: type, closed: true)
            }
            pullView.touchBlock = {
                self?.topHeaderView.rotateArrow(withType: type, closed: true)
            }
        }
        navBar.backclickBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    private func showAddActionSheet() {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: StellarLocalizedString("COMMON_CANCEL"), style: .cancel, handler: nil)
        let lightAction = UIAlertAction(title: "添加亮度", style: .default, handler: { [weak self] action in
            self?.presntToCreatVc(addTag: .brightness)
        })
        let colorAction = UIAlertAction(title: "添加色彩", style: .default, handler: { [weak self] action in
            self?.presntToCreatVc(addTag: .color)
        })
        let brightAction = UIAlertAction(title: "添加色温", style: .default, handler: { [weak self] action in
            self?.presntToCreatVc(addTag: .temperature)
        })
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(lightAction)
        alertSheet.addAction(colorAction)
        alertSheet.addAction(brightAction)
        present(alertSheet, animated: true, completion: nil)
    }
    private func presntToCreatVc(addTag: addType) {
        let vc = AddStreamerViewController.init()
        vc.addType = addTag
        vc.compeletBlock = { [weak self] (model) in
            self?.dataList.append(model)
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: kNavigationH + 93, width: kScreenWidth, height: kScreenHeight - kNavigationH - 32.fit - 66.fit - 93 - getAllVersionSafeAreaBottomHeight()), style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CreatStreamerCell", bundle: nil), forCellReuseIdentifier: "CreatStreamerCellID")
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var preViewButton: StellarButton = {
        let tempView = StellarButton.init(frame: CGRect(x: 30.fit, y: kScreenHeight - 46.fit - 32.fit - getAllVersionSafeAreaBottomHeight(), width: 140.fit, height: 46.fit))
        tempView.setTitle("预览", for: .normal)
        tempView.style = .border
        tempView.layer.borderColor = STELLAR_COLOR_C1.cgColor
        return tempView
    }()
    private lazy var saveButton: StellarButton = {
        let tempView = StellarButton.init(frame: CGRect(x:kScreenWidth - 30.fit - 140.fit - getAllVersionSafeAreaBottomHeight(), y: kScreenHeight-46.fit-32.fit, width: 140.fit, height: 46.fit))
        tempView.setTitle("保存", for: .normal)
        tempView.style = .normal
        return tempView
    }()
    private lazy var topHeaderView: CreatStreamerHeaderView = {
        let tempView = CreatStreamerHeaderView.init(frame: CGRect(x: 20.fit, y: kNavigationH, width: kScreenWidth-40.fit, height: 113.fit))
        return tempView
    }()
    private lazy var navBar: NavView = {
        let tempView = NavView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.myState = .kNavBlack
        return tempView
    }()
}
extension CreatStreamerViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatStreamerCellID", for: indexPath) as! CreatStreamerCell
        cell.selectionStyle = .none
        if indexPath.row == dataList.count {
            cell.type = .add
        }else {
            let obj = dataList[indexPath.row]
            cell.object = obj
            cell.type = .normal
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == dataList.count {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        view.setNeedsLayout()
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != dataList.count {
            let delet = UIContextualAction.init(style: .destructive, title: "删除删除删除删") { [weak self] (action, view, isF) in
                self?.dataList.remove(at: indexPath.row)
                tableView.reloadData()
            }
            let cofing = UISwipeActionsConfiguration.init(actions: [delet])
            cofing.performsFirstActionWithFullSwipe = false
            return cofing
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count {
            showAddActionSheet()
        }
    }
}