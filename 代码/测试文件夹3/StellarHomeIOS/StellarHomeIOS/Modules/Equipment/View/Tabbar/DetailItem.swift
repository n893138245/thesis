import UIKit
import NVActivityIndicatorView
class DetailItem: UIButton {
    var tabGorupCount:CGFloat = 0 
    var tempTitle = ""
    var tempImage = UIImage()
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.sizeToFit()
        titleLabel?.sizeToFit()
        imageView?.center = CGPoint.init(x: kScreenWidth/(tabGorupCount*2), y: 49.fit)
        titleLabel?.center = CGPoint.init(x: kScreenWidth/(tabGorupCount*2), y: 8.fit + 50.fit + 24.fit + (titleLabel?.bounds.size.height ?? 0)/2.0)
    }
    private struct nv_associatedKeys {
        static var indicatorStr = "stellar_nv_indicator"
    }
    private var nvIndicator : NVActivityIndicatorView? {
        get{
            if let accpetEventInterval = objc_getAssociatedObject(self, &nv_associatedKeys.indicatorStr) as? NVActivityIndicatorView {
                return accpetEventInterval
            }else{
                return nil
            }
        }
        set{
            objc_setAssociatedObject(self, &nv_associatedKeys.indicatorStr, newValue as NVActivityIndicatorView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func powerStartNVIndicator(color: UIColor) {
        if nvIndicator == nil{
            nvIndicator = NVActivityIndicatorView.init(frame: self.imageView?.frame ?? CGRect.zero, type: .circleStrokeSpin, color: color, padding: nil)
            addSubview(nvIndicator!)
            bringSubviewToFront(nvIndicator!)
        }
        isEnabled = false
        nvIndicator?.color = color
        nvIndicator?.isHidden = false
        nvIndicator?.startAnimating()
    }
    func powerStopNVIndicator() {
        isEnabled = true
        nvIndicator?.isHidden = true
        nvIndicator?.stopAnimating()
    }
    override func draw(_ rect: CGRect) {
    }
}