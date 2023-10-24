import UIKit
class BaseRefreshHeader: MJRefreshGifHeader {
    let iamgeW = 100
    enum RefreshStyle: String {
        case blue = "xiala"
        case white = ""
    }
    var style: RefreshStyle = .blue{
        didSet{
            reloadImages()
        }
    }
    func reloadImages() {
        setImages(idleImages, for: .idle)
        setImages(refreshingImages, duration: 1.5, for: .refreshing)
        setImages(pullingImages, for: .pulling)
    }
    override func prepare() {
        super.prepare()
        setImages(idleImages, for: .idle)
        setImages(refreshingImages, duration: 1.5, for: .refreshing)
        setImages(pullingImages, for: .pulling)
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
    }
    private lazy var idleImages: [UIImage] = {
        let idleImages = BaseRefreshHelper.sharedInstance.idleImages
        return idleImages
    }()
    private lazy var refreshingImages: [UIImage] = {
        let refreshingImages = BaseRefreshHelper.sharedInstance.refreshingImages
        return refreshingImages
    }()
    private lazy var pullingImages: [UIImage] = {
        let pullingImages = BaseRefreshHelper.sharedInstance.pullingImages
        return pullingImages
    }()
}