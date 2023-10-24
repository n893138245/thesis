import UIKit
class SceneDefaultView: UIView {
    var pushBlock:((_ vc:UIViewController)->Void)? = nil
    var defaultDataList = [ScenesModel](){
        didSet {
            tableview.reloadData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadsubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showAddView() {
        noDeviceView.isHidden = false
    }
    func hiddenAddView() {
        noDeviceView.isHidden = true
    }
    func loadsubViews(){
        addSubview(tableview)
        tableview.register(UINib(nibName: "SceneDefaultViewCell", bundle: nil), forCellReuseIdentifier: "SceneDefaultViewCell")
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalTo(0)
        }
        headView.addSubview(topLeftView)
        topLeftView.snp.makeConstraints { (make) in
            make.left.equalTo(20.fit)
            make.top.equalTo(32.fit)
        }
        headView.addSubview(reminderView)
        reminderView.snp.makeConstraints { (make) in
            make.left.equalTo(topLeftView.snp.right).offset(9.fit)
            make.top.equalTo(32.fit)
            if isChinese() {
                make.width.equalTo(171.fit)
            }else {
                make.width.equalTo(220.fit)
            }
            make.height.equalTo(41.fit)
        }
        reminderLabel.text = StellarLocalizedString("SCENE_GATEWAY_TIP")
        reminderView.addSubview(reminderLabel)
        reminderLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(reminderView)
        }
        headView.addSubview(reminderLabelCorner)
        reminderLabelCorner.snp.makeConstraints { (make) in
            make.right.equalTo(reminderView.snp.left)
            make.top.equalTo(40.fit)
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
    lazy var topLeftView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "img_prompt_voice")
        return imageView
    }()
    lazy var reminderLabel:UILabel = {
        let label = UILabel()
        label.textColor = STELLAR_COLOR_C3
        label.textAlignment = .left
        label.font = STELLAR_FONT_BOLD_T12
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        return label
    }()
    lazy var reminderLabelCorner:UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "blue_angle")
        return view
    }()
    lazy var reminderView:UIView = {
        let view = UIView()
        view.backgroundColor = STELLAR_COLOR_C1
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    lazy var tableview:UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = STELLAR_COLOR_C3
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets.init(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        view.separatorColor = UIColor.clear
        return view
    }()
    lazy var headView:UIView = {
        let view = UIView()
        return view
    }()
    lazy var noDeviceView:NoDeviceView = {
        let view = NoDeviceView.noDeviceView()
        return view
    }()
}
extension SceneDefaultView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultDataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SceneDefaultViewCell", for: indexPath) as! SceneDefaultViewCell
        let model = defaultDataList[indexPath.row]
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
                vc.myDetailType = .defaultType
                StellarAppManager.sharedManager.currVc?.children.first?.navigationController!.pushViewController(vc, animated: true)
            }
        }
        cell.moreBlock = {
            let vc = SceneDetailViewController.init()
            vc.sceneModel = model
            vc.myDetailType = .defaultType
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
        let model = defaultDataList[indexPath.row]
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { (_) in
                if self.pushBlock != nil{
                    let vc = SceneDetailViewController.init()
                    vc.sceneModel = model
                    vc.myDetailType = .defaultType
                    self.pushBlock?(vc)
                }
            }
        }
    }
}