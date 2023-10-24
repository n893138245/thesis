import UIKit
class RecommendView: UIView {
    private var lastSelectedRow: Int?
    var isSmart = false
    private let dataList = [("bg_streamer_colorful","七彩流光"),("bg_streamer_red-blue","红蓝渐变"),("bg_streamer_red-green","红绿渐变"),("bg_streamer_blue-green","蓝绿渐变"),("","单色流光")]
    private var modelList: [RecommendModel] = []
    private let cellId = "StreamerCell"
    var clickMoreForRowBlock: ((_ row: Int) -> Void)?
    var chageStatusBlock: (() -> Void)? 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorsAndPlayData()
        setupUI()
    }
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self).offset(14.fit)
            $0.left.right.equalTo(self)
            $0.bottom.equalTo(self).offset(-24)
        }
    }
    private func setupColorsAndPlayData() {
        for index in 0...4 {
            let model = RecommendModel.init()
            if index != 4 {
                model.colorState = .noColor
            }else {
                model.colorState = .red
            }
            model.selected = false
            modelList.append(model)
        }
    }
    func clearSelected() {
        if let index = lastSelectedRow {
            let obj = modelList[index]
            obj.selected = false
            collectionView.reloadData()
        }
    }
    private func reloadUI() {
        var rows: [IndexPath] = []
        for i in 0...4 {
            let indexPath = IndexPath.init(row: i, section: 0)
            rows.append(indexPath)
        }
        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.reloadItems(at: rows)
        }) { (finised) in
        }
    }
    func changeColorWithIndex(index: Int) {
        let obj = modelList.last!
        switch index {
        case 0:
            obj.colorState = .red
        case 1:
            obj.colorState = .yellow
        case 2:
            obj.colorState = .green
        case 3:
            obj.colorState = .cyan
        case 4:
            obj.colorState = .blue
        case 5:
            obj.colorState = .purple
        case 6:
            obj.colorState = .white
        default:
            break
        }
        collectionView.reloadItems(at: [IndexPath.init(row: 4, section: 0)])
    }
    func changeCurrentStatus(row: Int) {
        if let lastRow = lastSelectedRow {
            if lastRow != row {
                let obj = modelList[lastRow]
                obj.selected = false
            }
        }
        let obj = modelList[row]
        obj.selected = !obj.selected!
        lastSelectedRow = row
        collectionView.reloadData()
        if let block = chageStatusBlock {
            block()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var collectionView: UICollectionView = {
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        defaultLayout.sectionInset = UIEdgeInsets.init(top: 10.fit, left: 20.fit, bottom: 10, right: 20.fit)
        defaultLayout.itemSize = CGSize(width: kScreenWidth/2-20.fit-11.fit/2, height: 98.fit)
        defaultLayout.minimumLineSpacing = 16 
        defaultLayout.minimumInteritemSpacing = 5.5.fit 
        defaultLayout.headerReferenceSize = CGSize(width: 0, height: 0)
        defaultLayout.footerReferenceSize = CGSize(width: 0, height: 0)
        let tempView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: defaultLayout)
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.delegate = self
        tempView.dataSource = self
        tempView.register(UINib.init(nibName: "StreamerCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        return tempView
    }()
}
extension RecommendView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StreamerCell
        if indexPath.row != 4 {
            cell.bgImage.image = UIImage(named: dataList[indexPath.row].0)
        }else {
            cell.bgImage.image = UIColor.ss.getImageWithColor(color: .clear)
        }
        cell.isSamrt = isSmart
        cell.nameLabel.text = dataList[indexPath.row].1
        cell.recommendObject = modelList[indexPath.row]
        cell.moreBlock = { [weak self] in
            if cell.recommendObject!.selected! {
                self?.changeCurrentStatus(row: indexPath.row)
            }else {
                if let block = self?.clickMoreForRowBlock {
                    block(indexPath.row)
                }
            }
        }
        cell.selectBlock = { [weak self] in
            self?.changeCurrentStatus(row: indexPath.row)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! StreamerCell
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.changeCurrentStatus(row: indexPath.row)
            }
        }
    }
}