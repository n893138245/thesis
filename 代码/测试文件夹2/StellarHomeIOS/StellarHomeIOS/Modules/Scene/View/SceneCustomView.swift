import UIKit
class SceneCustomView: UIView {
    var pushBlock:((_ vc:UIViewController)->Void)? = nil
    var customDataList = [ScenesModel](){
        didSet{
            if customDataList.count == 0 {
                emptyView.isHidden = false
                tableview.reloadData()
            }else{
                emptyView.isHidden = true
                tableview.reloadData()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadsubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showAddDeviceView() {
        noDeviceView.isHidden = false
        emptyView.isHidden = true
    }
    func hiddenTopViews() {
        noDeviceView.isHidden = true
        emptyView.isHidden = true
    }
    func loadsubViews(){
        addSubview(emptyView)
        addSubview(tableview)
        tableview.register(UINib(nibName: "SceneDefaultViewCell", bundle: nil), forCellReuseIdentifier: "SceneDefaultViewCell")
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
        }
        addSubview(noDeviceView)
        noDeviceView.clickBlock = {
            let nav = AddDeviceBaseNavController.init(rootViewController: AddDeviceVC.init())
            nav.modalPresentationStyle = .fullScreen
            StellarAppManager.sharedManager.currVc?.children.first?.present(nav, animated: true, completion: nil)
        }
        noDeviceView.isHidden = true
        noDeviceView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
    }
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var emptyView: SceneEmptyView = {
        let bgView = SceneEmptyView.SceneEmptyView()
        bgView.frame = self.bounds
        return bgView
    }()
    lazy var noDeviceView:NoDeviceView = {
        let view = NoDeviceView.noDeviceView()
        return view
    }()
}
extension SceneCustomView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customDataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SceneDefaultViewCell", for: indexPath) as! SceneDefaultViewCell
        let model = customDataList[indexPath.row]
        cell.setData(sceneModel: model)
        cell.clickBlock = {
            if cell.useState == .normal{
                StellarProgressHUD.showHUD()
                cell.playButton.ss.startActivityIndicator()
                CommandManager.shared.creatScenesCommandAndSend(scenesId: model.id!, success: { (response) in
                    cell.playButton.ss.showSuccessCheck(isShowImage: true, isShowTitle: false, hideBlock: {
                        StellarProgressHUD.dissmissHUD()
                    })
                }, failure: { (_, _) in
                    StellarProgressHUD.dissmissHUD()
                    cell.playButton.ss.stopActivityIndicator(isShowImage: true, isShowTitle: false)
                    TOAST(message: StellarLocalizedString("COMMON_EXECUTE_FAIL"))
                })
            }else if cell.useState == .nolamp_icons{
                let vc = SceneDetailViewController.init()
                vc.sceneModel = model
                vc.myDetailType = .detailType
                StellarAppManager.sharedManager.currVc?.children.first?.navigationController!.pushViewController(vc, animated: true)
            }
        }
        cell.moreBlock = {
            let vc = SceneDetailViewController.init()
            vc.sceneModel = model
            vc.myDetailType = .detailType
            StellarAppManager.sharedManager.currVc?.children.first?.navigationController!.pushViewController(vc, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else{
            return
        }
        let model = customDataList[indexPath.row]
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { (_) in
                if self.pushBlock != nil{
                    let vc = SceneDetailViewController.init()
                    vc.sceneModel = model
                    vc.myDetailType = .detailType
                    self.pushBlock?(vc)
                }
            }
        }
    }
}