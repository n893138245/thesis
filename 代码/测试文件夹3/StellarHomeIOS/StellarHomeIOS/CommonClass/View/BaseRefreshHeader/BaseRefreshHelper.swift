import UIKit
class BaseRefreshHelper: NSObject {
    static let sharedInstance = BaseRefreshHelper.init()
    let iamgeW = 100
    enum RefreshStyle: String {
        case blue = "xiala"
        case white = ""
    }
    var style: RefreshStyle = .blue
    override init() {
        super.init()
    }
    lazy var idleImages: [UIImage] = {
        var tempArr: [UIImage] = []
        for i in 0..<32{
            let image = UIImage.init(named: "\(style.rawValue)_\(String(format: "%05d",  i))")!.ss.reSizeImage(reSize: CGSize.init(width: iamgeW, height: iamgeW))
            tempArr.append(image)
        }
        return tempArr
    }()
    lazy var pullingImages: [UIImage] = {
        var tempArr: [UIImage] = []
        let image = UIImage.init(named: "\(style.rawValue)_\(String(format: "%05d", 31))")!.ss.reSizeImage(reSize: CGSize.init(width: iamgeW, height: iamgeW))
        tempArr.append(image)
        return tempArr
    }()
    lazy var refreshingImages: [UIImage] = {
        var tempArr: [UIImage] = []
        for i in 0..<94{
            let image = UIImage.init(named: "\(style.rawValue)_\(String(format: "%05d", i))")!.ss.reSizeImage(reSize: CGSize.init(width: iamgeW, height: iamgeW))
            tempArr.append(image)
        }
        return tempArr
    }()
}