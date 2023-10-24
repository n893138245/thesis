import UIKit
class PreSetViewController: BaseViewController {
    private let cellId = "PreSetCellID"
    private var selectedIndex: Int?
    var light: LightModel? {
        didSet {
            setupData()
        }
    }
    private var dataList: [(modeModel: LightInternalMode, isCurrentMode: Bool)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    private func setupData() {
        guard let pLight = light else { return }
        for mode in pLight.internalMode {
            dataList.append((mode,false))
            if mode.params?.brightness == light?.status.brightness && mode.params?.cct == light?.status.cct {
                guard let index = dataList.firstIndex(where: {$0.modeModel == mode}) else { return }
                selectedIndex = index
                dataList[index].isCurrentMode = true
            }
        }
        if let index = dataList.firstIndex(where: {$0.modeModel.id == pLight.status.mode}),pLight.status.currentMode == .mode {
            selectedIndex = index
            dataList[index].isCurrentMode = true
        }
        collectionView.reloadData()
    }
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.register(UINib.init(nibName: "PreSetCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 40, height: 60))
        label.text = "内置灯光"
        label.font = STELLAR_FONT_MEDIUM_T20
        collectionView.addSubview(label)
    }
    private func setupRx() {
        NotificationCenter.default.rx.notification(.NOTIFY_USER_CCT_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let dic = notify.userInfo as? [String: Int] else {
                    return
                }
                guard let cct = dic["cct"] else {
                    return
                }
                self?.fixCCT(cct: cct)
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.NOTIFY_USER_BRIGHTNESS_CHANGE)
            .subscribe(onNext: { [weak self] (notify) in
                guard let dic = notify.userInfo as? [String: Int] else {
                    return
                }
                guard let brightness = dic["brightness"] else {
                    return
                }
                self?.fixBrightness(b: brightness)
            }).disposed(by: disposeBag)
    }
    private func fixBrightness(b: Int) {
        guard let index = selectedIndex else { return }
        if dataList[index].modeModel.params?.brightness ?? 0 != b {
            dataList[index].isCurrentMode = false
            collectionView.reloadData()
        }
    }
    private func fixCCT(cct: Int) {
        guard let index = selectedIndex else { return }
        if dataList[index].modeModel.params?.cct ?? 0 != cct {
            dataList[index].isCurrentMode = false
            collectionView.reloadData()
        }
    }
    private func creatNetCommand(mode: LightInternalMode) {
        guard let pTriats = light?.traits else { return }
        if pTriats.contains(.internalMode) { 
            creatModeCommand(mode: mode)
        }else { 
            creatNormalCommad(mode: mode)
        }
    }
    private func creatModeCommand(mode: LightInternalMode) {
        guard let pLight = light else { return }
        CommandManager.shared.creatInternalModeCommandAndSend(deviceGroup: [pLight], internalMode: mode, success: { (response) in
            guard let resultList = response as? [[CommonResponseModel]] else {
                return
            }
            guard let cct = mode.params?.cct else {
                return
            }
            if resultList.first?.count ?? 0 > 0 { 
                NotificationCenter.default.post(name: .NOTIFY_CCT_CHANGE, object: nil, userInfo: ["cct": cct])
            }
            guard let brightness = mode.params?.brightness else {
                return
            }
            if resultList.first?.count ?? 0 > 0 { 
                NotificationCenter.default.post(name: .NOTIFY_BRIGHTNESS_CHANGE, object: nil, userInfo: ["brightness": brightness])
            }
        }) { (_, _) in
        }
    }
    private func creatNormalCommad(mode: LightInternalMode) {
        guard let pLight = light else { return }
        guard let cct = mode.params?.cct else { return }
        CommandManager.shared.creatCCTCommandAndSend(deviceGroup: [pLight], cct: cct, success: { (response) in
            guard let resultList = response as? [[CommonResponseModel]] else {
                return
            }
            if resultList.first?.count ?? 0 > 0 { 
                NotificationCenter.default.post(name: .NOTIFY_CCT_CHANGE, object: nil, userInfo: ["cct": cct])
            }
        }) { (_, _) in
        }
        guard let brightness = mode.params?.brightness else { return }
        CommandManager.shared.creatBringhtnessCommandAndSend(deviceGroup: [pLight], brightness: brightness, success: { (response) in
            guard let resultList = response as? [[CommonResponseModel]] else {
                return
            }
            if resultList.first?.count ?? 0 > 0 { 
                NotificationCenter.default.post(name: .NOTIFY_BRIGHTNESS_CHANGE, object: nil, userInfo: ["brightness": brightness])
            }
        }) { (_, _) in
        }
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: kScreenWidth - 40, height: 60)
        let tempView = UICollectionView.init(frame: CGRect(x: 20, y: kNavigationH, width: kScreenWidth - 40, height: kScreenHeight - kNavigationH - 126.fit - getAllVersionSafeAreaBottomHeight()), collectionViewLayout: layout)
        tempView.backgroundColor = STELLAR_COLOR_C3
        return tempView
    }()
}
extension PreSetViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PreSetCell
        cell.setupViews(model: dataList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedIndex {
            dataList[index].isCurrentMode = false
        }
        dataList[indexPath.row].isCurrentMode = true
        selectedIndex = indexPath.row
        collectionView.reloadData()
        creatNetCommand(mode: dataList[indexPath.row].modeModel)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 40 - 32) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.fit
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.fit
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth - 40, height: 36)
    }
}