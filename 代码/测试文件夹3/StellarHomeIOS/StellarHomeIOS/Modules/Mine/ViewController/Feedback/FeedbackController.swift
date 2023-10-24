import UIKit
class FeedbackController: BaseViewController {
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var collectView: UICollectionView!
    private let cellIdentifier = "UploadPicCollectionViewCellID"
    @IBOutlet weak var mNavTitle: UILabel!
    @IBOutlet weak var mContentLabel: UILabel!
    var upLoadImageviews:Array<UIImage> = []
    private let submitMiniTimeDefference = 5 
    private let submitMaxChance = 5 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        updateChanceLabel()
    }
    func loadSubViews(){
        mNavTitle.text = StellarLocalizedString("MINE_FEEDBACK_FEEDBACK")
        mContentLabel.text = StellarLocalizedString("MINE_FEEDBACK_CONTENT_TIP")
        textBgView.addSubview(textView)
        textBgView.backgroundColor = STELLAR_COLOR_C8
        textView.backgroundColor = STELLAR_COLOR_C8
        textView.snp.makeConstraints {
            $0.top.bottom.equalTo(textBgView)
            $0.left.equalTo(textBgView).offset(12)
            $0.right.equalTo(textBgView).offset(-12)
        }
        textView.font = STELLAR_FONT_T14
        textView.addSubview(placeHolderLabel)
        textView.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        view.addSubview(bottomBtn)
        bottomBtn.frame = CGRect.init(x: kScreenWidth/2.0 - 146.fit, y: kScreenHeight - BOTTOMBUTTON_BOTTOM_CONSTRAINT, width: 290.fit , height: 46.fit)
        bottomBtn.isEnabled = false
        view.addSubview(chanceLabel)
        chanceLabel.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(bottomBtn.snp.top).offset(-12.fit)
        }
        textView.rx.didChange
            .subscribe(onNext: { [weak self] in
                if !(self?.textView.text.isEmpty ?? true) && FeedBackTimeTool.sharedTool.submitCount < self?.submitMaxChance ?? 5{
                    self?.bottomBtn.isEnabled = true
                }else{
                    self?.bottomBtn.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        bottomBtn.rx.tap.subscribe(onNext:{ [weak self] in
            let min = FeedBackTimeTool.sharedTool.timeDefferenceResult()
            if min >= self?.submitMiniTimeDefference ?? 5 {
                self?.netSubmit()
            }else {
                self?.showBusyAlert(min: min)
            }
        }).disposed(by: disposeBag)
    }
    private func updateChanceLabel() {
        if FeedBackTimeTool.sharedTool.submitCount < submitMaxChance {
            if isChinese() {
//                chanceLabel.text = "今天还能提交\(submitMaxChance-FeedBackTimeTool.sharedTool.submitCount)次"
            }else {
                chanceLabel.text = "You can submit \(submitMaxChance-FeedBackTimeTool.sharedTool.submitCount)times today"
            }
        }else {
            chanceLabel.text = StellarLocalizedString("MINE_FEEDBACK_SUBMIT_NOCHANCE")
        }
    }
    private func showBusyAlert(min: Int) {
        let alert = StellarMineAlertView.init(title: StellarLocalizedString("MINE_FEEDBACK_SUBMIT_BUSY"), message: "\(StellarLocalizedString("MINE_FEEDBACK_PLEASE")) \(submitMiniTimeDefference-min) \(StellarLocalizedString("MINE_FEEDBACK_LATER"))", icon: UIImage(named: "icon_feedback_wait")!, confimTitle: StellarLocalizedString("COMMON_FINE"))
        alert.show()
    }
    private func netSubmit() {
        self.bottomBtn.startIndicator()
//        StellarProgressHUD.showHUD()
//        GitLabAPIManager.sharedManager.sendFeedback(feedback: self.textView.text, success: {
            self.bottomBtn.stopIndicator()
//            StellarProgressHUD.dissmissHUD()
//            FeedBackTimeTool.sharedTool.saveCurrentTime()
//            self.updateChanceLabel()
            TOAST(message: StellarLocalizedString("MINE_FEEDBACK_SUCCESS"))
            self.navigationController?.popViewController(animated: true)
//        }) { (_) in
//            self.bottomBtn.stopIndicator()
//            StellarProgressHUD.dissmissHUD()
//            TOAST(message: StellarLocalizedString("MINE_FEEDBACK_FAIL"))
//        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    lazy var bottomBtn:StellarButton = {
        let view = StellarButton()
        view.setTitle(StellarLocalizedString("MINE_FEEDBACK_SUBMIT"), for: .normal)
        view.style = .normal
        return view
    }()
    lazy var placeHolderLabel:UILabel = {
        let view = UILabel()
        view.textColor = STELLAR_COLOR_C6
        view.text = StellarLocalizedString("MINE_FEEDBACK_LOVETO")
        view.numberOfLines = 0
        view.font = STELLAR_FONT_T14
        view.sizeToFit()
        return view
    }()
    lazy var chanceLabel:UILabel = {
        let view = UILabel()
        view.textColor = STELLAR_COLOR_C6
//        if isChinese() {
//           view.text = "今天还能提交5次"
//        }else {
//            view.text = "You can submit 5 times today"
//        }
        view.numberOfLines = 0
        view.font = STELLAR_FONT_T12
        view.sizeToFit()
        return view
    }()
    lazy var textView:UITextView = {
        let view = UITextView()
        return view
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
