import UIKit
protocol BrowserCollectionViewCellDelegate: NSObjectProtocol
{
    func browserCollectionViewCellDidClick(cell: BrowserCollectionViewCell)
}
class BrowserCollectionViewCell: UICollectionViewCell {
    weak var delegate: BrowserCollectionViewCellDelegate?
    var iconImage: UIImage = UIImage.init()
        {
        didSet{
            reset()
            iconImageView.image = iconImage
            let scale = iconImage.size.height / iconImage.size.width
            let height = scale * kScreenWidth
            self.iconImageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: height))
            if height < kScreenHeight
            {
                let offsetY = (kScreenHeight - height) * 0.5
                self.scrollview.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
            }else
            {
                self.scrollview.contentSize = self.iconImageView.frame.size
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconImageView)
        scrollview.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func reset()
    {
        scrollview.contentSize = CGSize.zero
        scrollview.contentOffset = CGPoint.zero
        scrollview.contentInset = UIEdgeInsets.zero
        iconImageView.transform = CGAffineTransform.identity
    }
    @objc private func imageClick()
    {
        delegate?.browserCollectionViewCellDidClick(cell: self)
    }
    private lazy var scrollview: UIScrollView = {
       let sl = UIScrollView()
        sl.minimumZoomScale = 0.5
        sl.maximumZoomScale = 3.0
        sl.delegate = self
        return sl
    }()
    lazy var iconImageView: UIImageView =  {
       let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageClick))
        iv.addGestureRecognizer(tap)
        return iv
    }()
}
extension BrowserCollectionViewCell: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iconImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var offsetY = (kScreenHeight - iconImageView.frame.height) * 0.5
        offsetY = (offsetY < 0) ? 0 : offsetY
        var offsetX = (kScreenWidth - iconImageView.frame.width) * 0.5
        offsetX = (offsetX < 0) ? 0 : offsetX
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}