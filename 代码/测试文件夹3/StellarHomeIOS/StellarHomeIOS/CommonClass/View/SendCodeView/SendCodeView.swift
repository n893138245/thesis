import UIKit
class SendCodeView: UIView {
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var textfieldLeftConstraint: NSLayoutConstraint!
    let _bag: DisposeBag = DisposeBag()
    var isVerificating = false
    var timeTask:SSTimeTask?
    var verificateCodeBlock:(()->Void)?
    var clickBlock:(()->Void)? = nil
    var kernSpace:CGFloat = 0
    let oneWordW:CGFloat = 9
    let num:CGFloat = 6
    let spaceSide:CGFloat = 25
    let lineSpace:CGFloat = 25
    class func SendCodeView() ->SendCodeView {
        let view = Bundle.main.loadNibNamed("SendCodeView", owner: nil, options: nil)?.last as! SendCodeView
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
        initCountDownClock()
    }
    private func initViews(){
        let sendCodeViewW:CGFloat = kScreenWidth - 18.0
        let lineViewWidth = (sendCodeViewW - spaceSide * 2 - lineSpace * (num - 1)) / num
        textfieldLeftConstraint.constant = spaceSide + lineViewWidth / 2.0 - oneWordW
        for index in 0...5 {
            let lineView = UIView(frame: CGRect.init(x: CGFloat(index) * (lineViewWidth + lineSpace) + spaceSide, y: 61, width: lineViewWidth, height: 1))
            lineView.backgroundColor = STELLAR_COLOR_C7
            addSubview(lineView)
            if index == 0 || index == 1{
                kernSpace = lineView.center.x - kernSpace
            }
        }
        timeButton.setTitle(StellarLocalizedString("REGIST_GET_CODE"), for: .normal)
        timeButton.setTitleColor(STELLAR_COLOR_C7, for: .disabled)
        timeButton.titleLabel?.font = STELLAR_FONT_T13
        timeButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        timeButton.isEnabled = false
        timeButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickBlock?()
        }).disposed(by: _bag)
        textfield.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.setupTextStyles(attributedText:self?.textfield.text ?? "")
                if self?.textfield.text?.count == 6{
                    self?.textfield.resignFirstResponder()
                    self?.verificateCodeBlock?()
                }
            }).disposed(by: _bag)
        textfield.becomeFirstResponder()
    }
    private func setupTextStyles(attributedText:String) {
        let agreementAttributedText2 = NSMutableAttributedString(string: attributedText)
        agreementAttributedText2.addAttributes([NSAttributedString.Key.foregroundColor : STELLAR_COLOR_C4, NSAttributedString.Key.font: STELLAR_FONT_NUMBER_T32,NSAttributedString.Key.kern:kernSpace - oneWordW*2], range: NSRange(location: 0, length: attributedText.count))
        textfield.attributedText = agreementAttributedText2
        textfield.font = STELLAR_FONT_NUMBER_T32
        textfield.textColor = STELLAR_COLOR_C4
    }
    func clear(){
        textfield.text = ""
    }
    func getTextString() -> String{
        return textfield.text ?? ""
    }
    @objc func initCountDownClock(){
        self.timeButton.isEnabled = false
        timeTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true) { [weak self] task in
            if self?.timeTask!.repeatCount ?? 0 >= 60 {
                self?.timeTask?.isStop = true
                self?.timeButton.setTitle(StellarLocalizedString("SENDCODE_RESEND_CODE"), for: .normal)
                self?.timeButton.isEnabled = true
            }else{
                if self?.timeTask != nil{
                    let isEnglish = !isChinese()
                    self?.timeButton.setTitle(String(format: "00:%02d", 60 - (self?.timeTask!.repeatCount ?? 0)) + "后 " + StellarLocalizedString("SENDCODE_RESEND_CODE"), for: .normal)
                }
            }
        }
    }
}