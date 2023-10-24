import UIKit
public class NibView: UIView {
    weak var view: UIView!
    override public init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    fileprivate func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    fileprivate func loadViewFromNib() -> UIView {
        let selfName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        let nibBundleURL = podBundle.url(forResource: selfName, withExtension: "bundle")!
        var nibBundle = Bundle(url: nibBundleURL)
        if nibBundle?.url(forResource: selfName, withExtension: "nib") == nil {
            nibBundle = podBundle
        }
        let nib = UINib(nibName: selfName, bundle: nibBundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}