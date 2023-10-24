import UIKit
class SelectBgImageViewController: BaseViewController {
    let cellId = "SelectBgImageCell"
    var backImageUrl: String?
    private var dataList: [(model: ScenesBGImageModel,isSelected: Bool)] = []
    var lastIndex: Int?
    private var lastSelectedIndex: Int?
    var imageSelectBlock:((_ path: String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        let topLabel = UILabel.init()
        topLabel.text = StellarLocalizedString("SCENE_SELECT_BG")
        topLabel.font = STELLAR_FONT_BOLD_T30
        topLabel.textColor = STELLAR_COLOR_C4
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints {
            $0.left.equalTo(self.view).offset(20)
            $0.top.equalTo(navBar.snp.bottom).offset(8.fit)
        }
        view.addSubview(collectionView)
    }
    private func getData() {
        StellarProgressHUD.showHUD()
        ScenesStore.sharedStore.queryAllScenesBGImageList { [weak self] (jsonDic) in
            StellarProgressHUD.dissmissHUD()
            guard let list = jsonDic["scene_bgs"] as? [[String: Any]] else {
                TOAST(message: "网络错误，请重试")
                return
            }
            for dic in list {
                let model = dic.kj.model(ScenesBGImageModel.self)
                self?.dataList.append((model,false))
            }
            self?.checkData()
        } failure: { (error) in
            StellarProgressHUD.dissmissHUD()
            TOAST(message: "网络错误，请重试")
        }
    }
    private func checkData() {
        guard let backUrl = backImageUrl else {
            collectionView.reloadData()
            return
        }
        guard let index = self.dataList.firstIndex(where: {$0.model.path == backUrl}) else {
            collectionView.reloadData()
            return
        }
        dataList[index].isSelected = true
        lastSelectedIndex = index
        collectionView.reloadData()
    }
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.titleLabel.isHidden = true
        tempView.moreButton.isHidden = true
        return tempView
    }()
    lazy var collectionView: UICollectionView = {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        defaultLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        defaultLayout.itemSize = CGSize(width: (kScreenWidth-53.fit)/2, height: 70.fit)
        defaultLayout.minimumLineSpacing = 16.fit 
        defaultLayout.minimumInteritemSpacing = 0.0 
        defaultLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        defaultLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        let tempView = UICollectionView.init(frame: CGRect(x: 20.fit, y:77.fit+kNavigationH, width: kScreenWidth-40.fit, height: view.frame.height-kNavigationH-77.fit), collectionViewLayout: defaultLayout)
        tempView.showsVerticalScrollIndicator = false
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib.init(nibName: "SelectBgImageCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        return tempView
    }()
}
extension SelectBgImageViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SelectBgImageCell
        cell.setupData(bgModel: dataList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let idx = lastSelectedIndex {
            dataList[idx].isSelected = false
        }
        dataList[indexPath.row].isSelected = true
        lastSelectedIndex = indexPath.row
        collectionView.reloadData()
        imageSelectBlock?(dataList[indexPath.row].model.path)
        navigationController?.popViewController(animated: true)
    }
}