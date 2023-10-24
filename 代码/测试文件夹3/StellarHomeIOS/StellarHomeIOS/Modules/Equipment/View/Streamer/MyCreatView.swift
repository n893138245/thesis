import UIKit
class MyCreatView: UIView {
    private var lastSelectedRow: Int?
    var isSamrt = false
    private let cellId = "StreamerCell"
    private var dataList: [MyStreamerModel] = []
    var clickMoreForRowBlock: ((_ row: Int) -> Void)?
    var chageStatusBlock: (() -> Void)? 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTestData()
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
    private func setupTestData() {
        for idx in 0...7 {
            let model = MyStreamerModel.init()
            model.fristColor = UIColor.ss.randomColor()
            model.lastColor = UIColor.ss.randomColor().withAlphaComponent(0.5)
            model.name = "Sansi\(idx+1)"
            model.selected = false
            dataList.append(model)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func clearSelected() {
        if let index = lastSelectedRow {
            let obj = dataList[index]
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
    func changeCurrentStatus(row: Int) {
        if let lastRow = lastSelectedRow {
            if lastRow != row {
                let obj = dataList[lastRow]
                obj.selected = false
            }
        }
        let obj = dataList[row]
        obj.selected = !obj.selected!
        lastSelectedRow = row
        collectionView.reloadData()
        if let block = chageStatusBlock {
            block()
        }
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
        let bgView = Bundle.main.loadNibNamed("NoStreamerTipView", owner: nil, options: nil)?.first as! NoStreamerTipView
        bgView.frame = tempView.bounds
        tempView.backgroundView = bgView
        tempView.register(UINib.init(nibName: "StreamerCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        tempView.backgroundView?.isHidden = true
        return tempView
    }()
}
extension MyCreatView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StreamerCell
        cell.colorState = .noColor
        cell.isSamrt = isSamrt
        let model = dataList[indexPath.row]
        cell.myCreatObject = model
        cell.moreBlock = { [weak self] in
            if cell.myCreatObject!.selected! {
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