import UIKit
class PhotoBrowserViewController: UIViewController {
    var images: [UIImage]
    var path: NSIndexPath
    init(images: [UIImage], path: NSIndexPath)
    {
        self.images = images
        self.path = path
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(getAllVersionSafeAreaTopHeight()+20)
            make.left.equalTo(view).offset(20)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.scrollToItem(at: path as IndexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
    @objc private func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icon_close_white"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var layout: XMGPhotoBrowserLayout =  XMGPhotoBrowserLayout()
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        clv.register(BrowserCollectionViewCell.self, forCellWithReuseIdentifier: "browserCell")
        clv.dataSource = self
        clv.backgroundColor = UIColor.black
        return clv
    }()
}
extension PhotoBrowserViewController: UICollectionViewDataSource, BrowserCollectionViewCellDelegate
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browserCell", for: indexPath as IndexPath) as! BrowserCollectionViewCell
        cell.iconImage = images[indexPath.row]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func browserCollectionViewCellDidClick(cell: BrowserCollectionViewCell) {
        dismiss(animated: true, completion: nil)
    }
}
class XMGPhotoBrowserLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = UIScreen.main.bounds.size
        scrollDirection = UICollectionView.ScrollDirection.horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}