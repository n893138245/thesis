import UIKit
import WebKit
class PrivacyAlertView: UIView {
    var agreeActionClosure: ((_ isReadToBottom: Bool)->Void)?
    private var isReadToBottom = false {
        didSet {
            if isReadToBottom {
                confirmBtn.isEnabled = true
                let title = "同意并继续"
                confirmBtn.setTitle(title, for: .normal)
            }
        }
    }
    private var wkWebView: WKWebView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 6
        layer.masksToBounds = true
        addSubview(titleLabel)
        addSubview(spaceLineView)
        addSubview(loadView)
        addSubview(progressView)
        addSubview(confirmBtn)
        addSubview(cancelBtn)
        loadWebURL()
        wkWebView?.scrollView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadWebURL() {
        let webConfiguration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: loadView.bounds, configuration: webConfiguration)
        loadView.addSubview(wkWebView!)
        let urlStr = StellarHomeResourceUrl.privacy_link
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        wkWebView?.load(request)
        wkWebView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        wkWebView?.scrollView.isScrollEnabled = false
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.wkWebView?.estimatedProgress) ?? 0), animated: true)
            if (self.wkWebView?.estimatedProgress ?? 0.0)  >= 1.0 {
                wkWebView?.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'", completionHandler: nil)
                wkWebView?.scrollView.isScrollEnabled = true
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    @objc func cancelBtnAction() {
        if let temp = self.agreeActionClosure {
            temp(false)
        }
        GHProgressHUD.dismissCustomView()
    }
    @objc func confirmBtnAction() {
        if let temp = self.agreeActionClosure {
            temp(true)
        }
        GHProgressHUD.dismissCustomView()
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 16, width: bounds.width, height: 25))
        label.text = "用户使用协议"
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Medium", size: 18)
        label.textColor = STELLAR_COLOR_C4
        return label
    }()
    lazy var spaceLineView: UIView = {
        let view = UIView(frame: CGRect(x: 8, y: 57, width: bounds.width - 16, height: 1))
        view.backgroundColor = UIColor.ss.rgbColor(245, 247, 250)
        return view
    }()
    lazy var loadView: UIView = {
        let view = UIView(frame: CGRect(x: 20, y: 74, width: bounds.width - 40, height: bounds.height - 74 - 138))
        return view
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(frame: CGRect(x: 0, y: loadView.frame.origin.y, width: bounds.width, height: 2))
        view.tintColor = .green
        view.trackTintColor = .white
        return view
    }()
    lazy var confirmBtn: StellarButton = {
        let btn = StellarButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 44, y: bounds.height - 60 - 44, width: bounds.width - 88, height: 46)
        btn.layer.cornerRadius = 23
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        btn.setTitle("阅读至底部", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        btn.isEnabled = false
        return btn
    }()
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: (bounds.width - 90)/2, y: confirmBtn.frame.maxY + 16, width: 90, height: 20)
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        btn.setTitle("不同意", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(STELLAR_COLOR_C6, for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 15)
        return btn
    }()
    deinit {
        wkWebView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
extension PrivacyAlertView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if wkWebView?.estimatedProgress ?? 0 >= 1.0 && !isReadToBottom && scrollView.contentOffset.y >= scrollView.contentSize.height - (bounds.height - 74 - 138) {
            isReadToBottom = true
        }
    }
}
