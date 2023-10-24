import UIKit
class SwitchPowerPopView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    class func SwitchPowerPopView() ->SwitchPowerPopView {
        let view = Bundle.main.loadNibNamed("SwitchPowerPopView", owner: nil, options: nil)?.last as! SwitchPowerPopView
        StellarAppManager.sharedManager.currVc!.view.addSubview(view)
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }
    func setupViews(){
        titleLabel.text = "共 60 盏灯"
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_MEDIUM_T17
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "SwitchPowerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SwitchPowerCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        let space:CGFloat = 9
        let width:CGFloat = (kScreenWidth - space * 2) / 3.0
        let height:CGFloat = width
        layout.itemSize = CGSize(width:width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        collectionView.collectionViewLayout = layout
        contentViewCenterYConstraint.constant = -(kScreenHeight + contentViewHeightConstraint.constant)/2.0
    }
    @IBAction func clickAction(_ sender: Any)
    {
        closeView()
    }
    func showView(){
        layoutIfNeeded()
        isHidden = false;
        contentViewCenterYConstraint.constant = 0
        bgView.pop_add(self.ss.popScaleAnimation(), forKey: "scale")
    }
    func closeView(){
        contentViewCenterYConstraint.constant = -(kScreenHeight + contentViewHeightConstraint.constant)/2.0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.isHidden = true;
        }
    }
}
extension SwitchPowerPopView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SwitchPowerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchPowerCollectionViewCell", for: indexPath) as! SwitchPowerCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}