import UIKit
enum SwitchKeyType {
    case keyTypeOne 
    case keyTypeTwo 
    case keyTypeThree
    case keyTypeFour
}
class SwitchSettingViewController: BaseViewController {
    var switchIndex: Int = 0
    var setCompleteBlock: ((_ button: ButttonModel) -> Void)?
    var buttonModel = ButttonModel()
    var firstSetData = true
    var dataList: [GroupModel] = [] {
        didSet {
            tableview.reloadData()
            saveButton.isEnabled = firstSetData ? false:true
            addButton.isHidden = viewModel.isHiddenRightTopButton()
            firstSetData = false
        }
    }
    var panelModel = PanelModel()
    var keyType: SwitchKeyType = .keyTypeOne {
        didSet {
            let modelResult = viewModel.getFingerCenterAndPanelImage(switchIndex: switchIndex, switcthType: keyType)
            deviceImage.image = modelResult.panelImage
            fingerView.center = modelResult.fingerCenter
        }
    }
    private var isPush = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupData()
        BackNetManager.sharedManager.copyDeviceList()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isPush {
            BackNetManager.sharedManager.restDeviceStatus()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPush = false
    }
    private func setupUI() {
        viewModel.delegate = self
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        view.addSubview(deviceImage)
        deviceImage.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(navBar.snp.bottom).offset(33.fit)
            $0.width.height.equalTo(132.fit)
        }
        view.addSubview(tipLabel)
        view.addSubview(addButton)
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(deviceImage.snp.bottom).offset(32.fit)
            $0.left.equalTo(view).offset(20.fit)
        }
        var buttonWidth = 90.fit
        if !isChinese() {
            buttonWidth = 120
        }
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(tipLabel)
            $0.right.equalTo(self.view).offset(-20.fit)
            $0.height.equalTo(20.fit)
            $0.width.equalTo(buttonWidth)
        }
        view.addSubview(saveButton)
        view.addSubview(tableview)
        tableview.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.equalTo(tipLabel.snp.bottom).offset(16.fit)
            $0.bottom.equalTo(saveButton.snp.top).offset(-20.fit)
        }
        let fingerBgView = UIView.init()
        deviceImage.addSubview(fingerBgView)
        fingerBgView.snp.makeConstraints {
            $0.center.equalTo(deviceImage)
            $0.width.height.equalTo(100.fit)
        }
        fingerBgView.addSubview(fingerView)
        addButton.isHidden = true
    }
    private func setupActions() {
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        addButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.pushToAddOperationViewController()
        }).disposed(by: disposeBag)
        saveButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.changeActions()
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.Scenes_SetDeviceStatusComplete).subscribe(onNext: { [weak self] (nitify) in
            let info = nitify.userInfo
            let group = info?["userInfo"] as? GroupModel ?? GroupModel()
            self?.dataList = (self?.viewModel.filterGroup(newGroup: group)) ?? [GroupModel]()
        }).disposed(by: disposeBag)
    }
    private func setupData() {
        dataList = viewModel.getDataWithAcions(actions: buttonModel.actions)
    }
    private func pushToAddOperationViewController() {
        isPush = true
        let vc = AddOperationViewController.init()
        vc.creatGroupDataModel = viewModel.creatGroupDataModel
        navigationController?.pushViewController(vc, animated: true)
    }
    private func changeActions() {
        let result = viewModel.judgeLightsAreSameRoom(datas: dataList)
        if result.sameRoom {
            viewModel.showTrunOffOtherLinghtsTipAlert(lights: result.restOfLights ?? [LightModel()], datas: dataList) {
                self.netChangeButtonActions()
            }
        }else {
            self.netChangeButtonActions()
        }
    }
    private func netChangeButtonActions() {
        saveButton.startIndicator()
        StellarProgressHUD.showHUD()
        let actions = viewModel.getAllActions(datas: dataList)
        DevicesStore.sharedStore().setPanelButtonsActions(sn: panelModel.sn, buttonId: switchIndex, actions: actions, success: { [weak self](jsonDic) in
            self?.saveButton.stopIndicator()
            StellarProgressHUD.dissmissHUD()
            var buttonModel = jsonDic.kj.model(ButttonModel.self)
            buttonModel.id = self?.switchIndex ?? 0
            if buttonModel.actions.elementsEqual(actions, by: { (model, model2) -> Bool in
                return model.groupId == model2.groupId
            }){
                TOAST_SUCCESS(message: StellarLocalizedString("ALERT_SETUP_SUCCESS"))
                if let block = self?.setCompleteBlock {
                    block(buttonModel)
                }
                self?.navigationController?.popViewController(animated: true)
            }else {
                TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
            }
        }) {[weak self] (error) in
            self?.saveButton.stopIndicator()
            StellarProgressHUD.dissmissHUD()
            TOAST(message: StellarLocalizedString("ALERT_CONFIRM_FAIL"))
        }
    }
    private lazy var viewModel: SwitchSettingViewModel = {
        let temp = SwitchSettingViewModel()
        return temp
    }()
    private lazy var deviceImage: UIImageView = {
        let tempView = UIImageView.init()
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.moreButton.isHidden = true
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.titleLabel.text = StellarLocalizedString("EQUIPMENT_PANEL_SETTINGS")
        let line = UIView.init(frame: CGRect(x: 0, y: kNavigationH-1, width: kScreenWidth, height: 1))
        line.backgroundColor = STELLAR_COLOR_C9
        tempView.addSubview(line)
        return tempView
    }()
    private lazy var addButton: UIButton = {
        let tempView = UIButton.init(type: .custom)
        tempView.titleLabel?.font =  STELLAR_FONT_MEDIUM_T14
        tempView.setTitle(StellarLocalizedString("ALERT_ADD_OPERATION"), for: .normal)
        tempView.setImage(UIImage(named: "icon_add_blue"), for: .normal)
        tempView.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 11.fit, bottom: 0, right: 0 )
        tempView.setTitleColor(UIColor.init(hexString: "#1E55B7"), for: .normal)
        tempView.layer.cornerRadius = 27.fit/2
        tempView.clipsToBounds = true
        return tempView
    }()
    private lazy var tipLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_MEDIUM_T16
        tempView.textColor = STELLAR_COLOR_C4
        tempView.text = "点击按键后，就执行"
        return tempView
    }()
    private lazy var tableview: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.backgroundColor = UIColor.clear
        view.delegate = self.viewModel
        view.dataSource = self.viewModel
        view.register(UINib(nibName: "OperationTableViewCell", bundle: nil), forCellReuseIdentifier: "OperationTableViewCell")
        view.separatorColor = UIColor.clear
        return view
    }()
    private lazy var saveButton: StellarButton = {
        var frame = CGRect(x: 42.fit, y: kScreenHeight - 24.fit - 46.fit - getAllVersionSafeAreaBottomHeight() , width: 291.fit, height: 46.fit)
        let tempView = StellarButton.init(frame: frame)
        tempView.style = .normal
        tempView.setTitle(StellarLocalizedString("SMART_SAVE"), for: .normal)
        tempView.isEnabled = false
        return tempView
    }()
    private lazy var fingerView: UIImageView = {
        let tempView = UIImageView.init(image: UIImage(named: "finger"))
        tempView.bounds = CGRect(x: 0, y: 0, width: 40.fit, height: 37.fit)
        return tempView
    }()
}
extension SwitchSettingViewController: AddOpreationViewModelDelegate {
    func pushViewController(vc: UIViewController) {
        isPush = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func present(vc: UIViewController) {
        isPush = true
        present(vc, animated: true, completion: nil)
    }
    func riceveDataChange(datas: [GroupModel]) {
        dataList = datas
    }
}