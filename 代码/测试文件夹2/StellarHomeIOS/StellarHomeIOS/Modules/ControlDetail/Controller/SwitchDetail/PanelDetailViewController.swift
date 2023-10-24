import UIKit
class PanelDetailViewController: BaseViewController {
    private var disabled: Bool = false {
        didSet {
            setEnabledStatus()
        }
    }
    var selectIndex = 5 
    var panelModel = PanelModel()
    private var dataList: [ButttonModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupCollcetionViewLayout()
        setDefaultData()
        netGetPanelInfo()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C9
        view.addSubview(navBar)
        view.addSubview(topBgView)
        view.addSubview(deviceImage)
        if panelModel.room != nil {
            navBar.titleLabel.text = "\(StellarRoomManager.shared.getRoom(roomId: panelModel.room ?? 0).name ?? "") \(panelModel.name)"
        }
        if #available(iOS 11.0, *) {
            view.addSubview(bottomView)
            bottomView.frame = CGRect(x: 0, y: kScreenHeight-safeAreaBottomHeight!, width: kScreenWidth, height: safeAreaBottomHeight!)
        }
    }
    private func setupCollcetionViewLayout() {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        defaultLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        defaultLayout.minimumLineSpacing = 0 
        defaultLayout.minimumInteritemSpacing = 0.0 
        defaultLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        defaultLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        var height: CGFloat = 294.fit
        if panelModel.buttonCount == 1 {
            defaultLayout.itemSize = CGSize(width: kScreenWidth, height: 294.fit)
        }else if panelModel.buttonCount == 2 {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-1)/2, height: 294.fit)
        }else if panelModel.buttonCount == 3 {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-2)/3, height: 294.fit)
        }else if panelModel.buttonCount == 4 {
            defaultLayout.itemSize = CGSize(width: (kScreenWidth-1)/2, height: (406.fit-1)/2)
            height = 406.fit
        }
        collectionView.frame = CGRect(x: 0, y: kScreenHeight - height - getAllVersionSafeAreaBottomHeight(), width: kScreenWidth, height: height)
        collectionView.collectionViewLayout = defaultLayout
        view.addSubview(collectionView)
        topBgView.snp.makeConstraints {
            $0.left.right.equalTo(self.view)
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalTo(self.collectionView.snp.top)
        }
        deviceImage.image = UIImage(named: "switch_\(panelModel.buttonCount)")
        deviceImage.snp.makeConstraints {
            $0.center.equalTo(topBgView)
            $0.width.height.equalTo(132.fit)
        }
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navBar.rightBlock = { [weak self] in
            let vc = SetupViewController.init()
            vc.device = self?.panelModel
            vc.changeInfoBlock = { (name, id) in
                self?.panelModel.name = name
                self?.panelModel.room = id
                self?.navBar.titleLabel.text = "\(StellarRoomManager.shared.getRoom(roomId: id).name ?? "") \(name)"
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func setEnabledStatus() {
        for idx in 0..<dataList.count {
            if selectIndex != idx {
                if let cell = collectionView.cellForItem(at: IndexPath(row: idx, section: 0)) as? SwitchKeyCell {
                    disabled ? cell.disabledStatus() : cell.normalStatus()
                }
            }
        }
    }
    private func setDefaultData() {
        if panelModel.buttonCount == 4 
        {
            for idx in 0..<panelModel.buttonCount {
                var buttonModel = ButttonModel()
                if idx == 0 {
                    buttonModel.id = 1
                }else if idx == 1 {
                    buttonModel.id = 2
                }else if idx == 2 {
                    buttonModel.id = 0
                }else {
                    buttonModel.id = idx
                }
                dataList.append(buttonModel)
            }
        }
        else 
        {
            for idx in 0..<panelModel.buttonCount {
                var buttonModel = ButttonModel()
                buttonModel.id = idx
                dataList.append(buttonModel)
            }
        }
        collectionView.reloadData()
    }
    private func netGetPanelInfo() {
        StellarProgressHUD.showHUD()
        DevicesStore.sharedStore().getPanelButtonsActions(sn: panelModel.sn, success: { [weak self] (butttonModels) in
            StellarProgressHUD.dissmissHUD()
            if butttonModels.count > 0 {
                for model in butttonModels {
                    if let index = self?.dataList.firstIndex(where: {$0.id == model.id}) {
                        self?.dataList.remove(at: index)
                        self?.dataList.insert(model, at: index)
                    }
                }
            }
            self?.collectionView.reloadData()
        }) { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("SMART_NET_ERROR"))
        }
    }
    private  lazy var bottomView: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.titleLabel.text = "卧室 智能开关"
        return tempView
    }()
    private lazy var deviceImage: UIImageView = {
        let tempView = UIImageView.init()
        return tempView
    }()
    private lazy var topBgView: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = STELLAR_COLOR_C9
        return tempView
    }()
    private lazy var collectionView: UICollectionView = {
        let tempView = UICollectionView.init(frame: CGRect(x: 0, y:kScreenHeight - 406.fit - getAllVersionSafeAreaBottomHeight(), width: kScreenWidth, height: 406.fit),collectionViewLayout: UICollectionViewFlowLayout())
        tempView.backgroundColor = .clear
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib.init(nibName: "SwitchKeyCell", bundle: nil), forCellWithReuseIdentifier: "SwitchKeyCell")
        return tempView
    }()
}
extension PanelDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchKeyCell", for: indexPath) as! SwitchKeyCell
        let buttonModel = dataList[indexPath.row]
        cell.buttonModel = buttonModel
        cell.settingBlock = { [weak self] in
            self?.pushToSetting(button: buttonModel)
        }
        cell.excuteBlock = { [weak self] in
            self?.netExecuteButtonActions(cell: cell, indexPath: indexPath, buttonModel: buttonModel)
        }
        return cell
    }
    private func pushToSetting(button: ButttonModel) {
        let vc = SwitchSettingViewController.init()
        vc.switchIndex = button.id
        switch dataList.count {
        case 1:
            vc.keyType = .keyTypeOne
        case 2:
            vc.keyType = .keyTypeTwo
        case 3:
            vc.keyType = .keyTypeThree
        case 4:
            vc.keyType = .keyTypeFour
        default:
            break
        }
        vc.panelModel = panelModel
        vc.buttonModel = button
        vc.setCompleteBlock = { [weak self] (button) in
            if let index = self?.dataList.firstIndex(where: {$0.id == button.id}) {
                self?.dataList.remove(at: index)
                self?.dataList.insert(button, at: index)
                self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    private func netExecuteButtonActions(cell :SwitchKeyCell, indexPath: IndexPath, buttonModel: ButttonModel) {
        if panelModel.buttonCount != 1 {
            selectIndex = indexPath.row
            disabled = true
        }
        cell.showLoading()
        DevicesStore.sharedStore().excutePanelActions(sn: panelModel.sn, buttonId: "\(buttonModel.id)", success: {[weak self] (response) in
            if response.count > 0 {
                self?.executeSuccess(cell: cell)
            }else {
                self?.executeFailure(cell: cell)
            }
        }) {[weak self] (error) in
            self?.executeFailure(cell: cell)
        }
    }
    private func executeSuccess(cell: SwitchKeyCell) {
        cell.showSuccess(finished: { [weak self] in
            if self?.panelModel.buttonCount != 1 {
                self?.disabled = false
            }
        })
    }
    private func executeFailure(cell: SwitchKeyCell) {
        cell.stopLoading()
        TOAST(message: StellarLocalizedString("COMMON_EXECUTE_FAIL"))
        if panelModel.buttonCount != 1 {
            disabled = false
        }
    }
}