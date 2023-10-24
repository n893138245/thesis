import UIKit
import WebKit
class UserAgreementViewController: BaseViewController {
    var urlStr:String = ""
    var titleText:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = STELLAR_COLOR_C3
        view.addSubview(navBar)
        view.addSubview(webView)
        view.addSubview(progressView)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        navBar.leftBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.webView.estimatedProgress)), animated: true)
            if (self.webView.estimatedProgress)  >= 1.0 {
                webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '70%'", completionHandler: nil)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (_) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    lazy var webView: WKWebView = {
        let tempView = WKWebView.init(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: kScreenHeight - kNavigationH - getAllVersionSafeAreaBottomHeight()), configuration: WKWebViewConfiguration())
        return tempView
    }()
    private lazy var navBar: DetailNavBar = {
        let tempView = DetailNavBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationH))
        tempView.style = .defaultStyle
        tempView.backgroundColor = STELLAR_COLOR_C3
        tempView.moreButton.isHidden = true
        tempView.titleLabel.text = titleText
        return tempView
    }()
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView(frame: CGRect(x: 0, y: kNavigationH, width: kScreenWidth, height: 2))
        view.tintColor = .green
        view.trackTintColor = .white
        return view
    }()
}