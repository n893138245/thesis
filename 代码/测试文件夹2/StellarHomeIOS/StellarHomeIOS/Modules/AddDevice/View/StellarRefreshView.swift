import UIKit
class StellarRefreshView: UIView {
    private unowned var scrollView: UIScrollView
    private let contentHeight: CGFloat = 45.fit 
    private var progress: CGFloat = 0 
    var isRefreshing :Bool = false 
    var refreshBlock: (() ->Void)?
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        addSubview(content)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func benginRefresh() {
        isRefreshing = true
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentInset.top += self.contentHeight
        }) { (_) in
            self.content.startScan()
            self.content.titleLabel.text = StellarLocalizedString("ADD_DEVICE_SCANNING_NEAR")
        }
        if let block = refreshBlock {
            block()
        }
    }
    func endRefresh() {
        isRefreshing = false
        UIView.animate(withDuration: 0.25, animations: {
         self.scrollView.contentInset.top -= self.contentHeight
        }) { (_) in
           self.content.stopScan()
        }
    }
    lazy var content: StallerHeaderScanView = {
        let heder = StallerHeaderScanView.init(frame: CGRect(x: 0, y: 400-45.fit, width: kScreenWidth, height: 45.fit), title: StellarLocalizedString("ADD_DEVICE_FROP_SACN_DEVCE"))
        heder.backgroundColor = STELLAR_COLOR_C9
        return heder
    }()
}
extension StellarRefreshView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        let refreshVisiableHeight = max(0, -scrollView.contentOffset.y - scrollView.contentInset.top)
        progress = min(1, refreshVisiableHeight/contentHeight)
        if progress < 1 {
            content.titleLabel.text = StellarLocalizedString("ADD_DEVICE_FROP_SACN_DEVCE")
        }else {
            content.titleLabel.text = StellarLocalizedString("ADD_DEVICE_LOOSE_SCAN_DEVICE")
        }
        content.radarView.pullToScan(progress: progress)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress == 1 {
            benginRefresh()
        }
    }
}