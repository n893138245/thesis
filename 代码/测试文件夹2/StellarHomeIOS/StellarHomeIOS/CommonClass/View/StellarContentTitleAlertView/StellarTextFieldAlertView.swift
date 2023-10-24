import UIKit
enum PopViewType{
    case imageContentType(content:String,leftClickString:String,rightClickString:String,image:UIImage?)
    case titleTextFieldType(title:String,leftClickString:String,rightClickString:String)
    case contentType(content:String,leftClickString:String,rightClickString:String)
    case titleAndContentType(content:String,leftClickString:String,rightClickString:String,title:String)
}
class StellarAlertView: UIView {
    private let bag: DisposeBag = DisposeBag()
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineview2: UIView!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var lineview1: UIView!
    @IBOutlet weak var contentViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var leftButtonBlock:(()->Void)? = nil
    var rightButtonBlock:((String)->Void)? = nil
    struct Input {
        let textFieldInput: Observable<String>
    }
    struct Output {
        var textFieldValidateResult: Observable<ValidateResult>!
    }
    func setType(_ type:PopViewType){
        switch type {
        case .imageContentType(let content,let leftClickString,let rightClickString,let image):
            if image != nil{
                imageView.image = image
            }
            secondTitleLabel.isHidden = true
            textField.text = ""
            titleLabel.text = ""
            contentLabel.text = content
            leftButton.setTitle(leftClickString, for: .normal)
            rightButton.setTitle(rightClickString, for: .normal)
            textfieldView.isHidden = true
            imageViewHeightConstraint.constant = 83
            contentLabelTopConstraint.constant = 31
            contentViewCenterYConstraint.constant = 0
            leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            contentLabel.textColor = STELLAR_COLOR_C4
            contentLabel.font = STELLAR_FONT_T16
            break
        case .titleTextFieldType(let title,let leftClickString,let rightClickString):
            textField.text = ""
            titleLabel.text = title
            contentLabel.text = ""
            leftButton.setTitle(leftClickString, for: .normal)
            rightButton.setTitle(rightClickString, for: .normal)
            imageViewHeightConstraint.constant = 0
            contentLabelTopConstraint.constant = 31
            textfieldView.isHidden = false
            contentViewCenterYConstraint.constant = -120
            leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            contentLabel.textColor = STELLAR_COLOR_C4
            contentLabel.font = STELLAR_FONT_T16
            break
        case .contentType(let content,let leftClickString,let rightClickString):
            secondTitleLabel.isHidden = true
            textField.text = ""
            imageViewHeightConstraint.constant = 0
            titleLabel.text = ""
            contentLabel.text = content
            leftButton.setTitle(leftClickString, for: .normal)
            rightButton.setTitle(rightClickString, for: .normal)
            imageViewHeightConstraint.constant = 0
            contentLabelTopConstraint.constant = 10
            textfieldView.isHidden = true
            contentViewCenterYConstraint.constant = 0
            leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            contentLabel.textColor = STELLAR_COLOR_C4
            contentLabel.font = STELLAR_FONT_T16
            break
        case .titleAndContentType(let content,let leftClickString,let rightClickString,let tilte):
            secondTitleLabel.isHidden = true
            textField.text = ""
            imageViewHeightConstraint.constant = 0
            titleLabel.text = tilte
            contentLabel.text = content
            leftButton.setTitle(leftClickString, for: .normal)
            rightButton.setTitle(rightClickString, for: .normal)
            imageViewHeightConstraint.constant = 0
            contentLabelTopConstraint.constant = 10
            textfieldView.isHidden = true
            contentViewCenterYConstraint.constant = 0
            contentLabel.font = STELLAR_FONT_T14
            leftButton.setTitleColor(STELLAR_COLOR_C2, for: .normal)
            leftButton.titleLabel?.font = STELLAR_FONT_T17
            rightButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
            rightButton.titleLabel?.font = STELLAR_FONT_T17
            contentLabel.textColor = STELLAR_COLOR_C6
            break
        }
    }
    class func StellarAlertView() ->StellarAlertView {
        let view = Bundle.main.loadNibNamed("StellarAlertView", owner: nil, options: nil)?.last as! StellarAlertView
        getKeyboardWindow().addSubview(view)
        view.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView(){
        titleLabel.textColor = STELLAR_COLOR_C4
        titleLabel.font = STELLAR_FONT_BOLD_T17
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = STELLAR_FONT_T16
        let placeholserAttributes = [NSAttributedString.Key.foregroundColor:STELLAR_COLOR_C7,NSAttributedString.Key.font:STELLAR_FONT_T16]
        textField.attributedPlaceholder = NSAttributedString(string: StellarLocalizedString("ALERT_INPUT"),attributes: placeholserAttributes)
        textfieldView.backgroundColor = STELLAR_COLOR_C8
        leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        lineview1.backgroundColor = STELLAR_COLOR_C8
        lineview2.backgroundColor = STELLAR_COLOR_C8
        secondTitleLabel.textColor = STELLAR_COLOR_C6
        secondTitleLabel.font = STELLAR_FONT_BOLD_T13
    }
    @IBAction private func leftClick(_ sender: Any) {
        textField.resignFirstResponder()
        closeView()
        if leftButtonBlock != nil {
            leftButtonBlock!()
        }
    }
    @IBAction private func rightClick(_ sender: Any) {
        textField.resignFirstResponder()
        closeView()
        if rightButtonBlock != nil {
            rightButtonBlock!(textField.text ?? "")
        }
    }
    func setVerifyChinese(){
        contentLabel.isEnabled = false
        contentLabel.textColor = STELLAR_COLOR_C2
        contentLabel.font = STELLAR_FONT_BOLD_T13
        secondTitleLabel.text = "为了保证语音正常使用，请设置易读名称"
        let input = Input.init(textFieldInput: textField.rx.value.orEmpty.asObservable().distinctUntilChanged())
        var output = Output()
        output.textFieldValidateResult = input.textFieldInput
            .flatMapLatest { (userPhoneNum) -> Observable<ValidateResult> in
                return ValidateService.validateChinese(inputString: userPhoneNum)
            }
            .share(replay: 1)
        output.textFieldValidateResult.subscribe { [weak self] (event: Event<ValidateResult>) in
            switch event{
            case .completed:return
            case .error(_): break
            case .next(let result):
                switch result{
                case .ok:
                    self?.rightButton.isEnabled = true
                    self?.contentLabel.text = "点击确定保存"
                    break
                case .validating:
                    self?.rightButton.isEnabled = false
                    self?.contentLabel.text = "validating"
                    break
                case .failed(let reason):
                    switch reason{
                    case .emptyInput:
                        self?.rightButton.isEnabled = false
                        self?.contentLabel.text = "输入不能为空"
                        break
                    case .other(let msg):
                        self?.rightButton.isEnabled = false
                        self?.contentLabel.text = msg
                        break
                    }
                }
            }
        }.disposed(by:bag )
    }
    func showView(){
        if self.isHidden != false {
            self.isHidden = false
            let basic = POPBasicAnimation.init(propertyNamed: kPOPViewBackgroundColor)
            basic?.fromValue = UIColor.black.withAlphaComponent(0.0)
            basic?.toValue = UIColor.black.withAlphaComponent(0.4)
            basic?.duration = 0.25
            self.pop_add(basic, forKey: "view.backgroundColor")
            let pop = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
            pop?.fromValue = CGSize(width: 0.3, height: 0.3)
            pop?.toValue = CGSize(width: 1, height: 1)
            pop?.springSpeed = 20
            pop?.springBounciness = 12
            contentView.pop_add(pop, forKey: "scale")
        }
    }
    func closeView(){
        if self.isHidden != true {
            self.isHidden = true
        }
    }
    func setContentTypeCommonStyle(){
        contentLabel.textColor = STELLAR_COLOR_C4
        contentLabel.font = STELLAR_FONT_T17
        leftButton.setTitleColor(STELLAR_COLOR_C4, for: .normal)
        leftButton.titleLabel?.font = STELLAR_FONT_T17
        rightButton.setTitleColor(STELLAR_COLOR_C1, for: .normal)
        rightButton.titleLabel?.font = STELLAR_FONT_T17
    }
}