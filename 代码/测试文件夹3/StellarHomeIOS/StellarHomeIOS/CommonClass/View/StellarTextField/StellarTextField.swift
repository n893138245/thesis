import UIKit
class StellarTextField: UIView {
    let disposeBag = DisposeBag()
    enum TextViewStyle {
        case email
        case phoneNumber
        case name
        case password
        case wifiName
        case wifiPassword
        case unknown
    }
    var title: String?{
        didSet{
            self.titleLabel.text = title
            self.textField.placeholder = title
        }
    }
    var security: Bool = false{
        didSet{
            if security {
                self.textField.isSecureTextEntry = true
                self.textField.clearButtonMode = .never
                self.textField.rightViewMode = .whileEditing
                let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 60.fit, height: 30.fit))
                let securityButton = UIButton(frame: CGRect(x:32,y:0,width:26.fit,height:26.fit))
                securityButton.setImage(UIImage(named: "input_icon_eye_n"), for: .normal)
                securityButton.setImage(UIImage(named: "input_icon_eye_s"), for: .selected)
                securityButton.rx.tap.subscribe(onNext:{ [weak self] in
                    self?.textField.isSecureTextEntry = !(self?.textField.isSecureTextEntry)!
                    securityButton.isSelected = !securityButton.isSelected
                })
                    .disposed(by: disposeBag)
               let clearButton = UIButton(frame: CGRect(x:0,y:0,width:26.fit,height:26.fit))
                clearButton.setImage(UIImage(named: "delete_text"), for: .normal)
                clearButton.rx.tap.subscribe(onNext:{ [weak self] in
                    self?.textField.text = ""
                })
                    .disposed(by: disposeBag)
                rightView.addSubview(securityButton)
                rightView.addSubview(clearButton)
                self.textField.rightView = rightView
                self.textField.clearButtonMode = .whileEditing
            }else{
                self.textField.isSecureTextEntry = false
                self.textField.clearButtonMode = .whileEditing
                self.textField.rightViewMode = .never
            }
        }
    }
    var showWifiChangeButton: Bool = false{
        didSet{
            if showWifiChangeButton {
                self.textField.clearButtonMode = .never
                self.textField.rightViewMode = .always
                changeWifiBtn = UIButton.init(type: .custom)
                changeWifiBtn?.frame = CGRect(x: 0, y: 0, width: 65.fit, height: 20.fit)
                changeWifiBtn?.setTitleColor(UIColor.init(hexString: "#394657"), for: .normal)
                changeWifiBtn?.setTitle(StellarLocalizedString("ADD_DEVICE_CHANGE_WI-FI"), for: .normal)
                changeWifiBtn?.titleLabel?.font = STELLAR_FONT_T15
                textField.rightView = changeWifiBtn
            }else{
                self.textField.isSecureTextEntry = false
                self.textField.clearButtonMode = .whileEditing
                self.textField.rightViewMode = .never
            }
        }
    }
    var style: TextViewStyle = .unknown{
        didSet{
            switch style {
            case .email:
                showWifiChangeButton = false
                security = false
                textField.keyboardType = .default
            case .phoneNumber:
                showWifiChangeButton = false
                security = false
                textField.keyboardType = .phonePad
            case .password:
                showWifiChangeButton = false
                security = true
                textField.keyboardType = .asciiCapable
                textField.clearButtonMode = .never
            case .wifiPassword:
                showWifiChangeButton = false
                security = true
                textField.keyboardType = .asciiCapable
                textField.clearButtonMode = .never
                bottomTitleLabel.text = "仅支持8~63位wifi密码"
                bottomTitleLabel.isHidden = true
                textField.rx.controlEvent(.editingChanged).asObservable()
                .subscribe(onNext: { [weak self] _ in
                    guard let textFieldText = self?.textField.text else {
                        return
                    }
                    if textFieldText.count == 0{
                        self?.bottomTitleLabel.isHidden = true
                        self?.showTitleLabel(show: false, animation: true)
                    } else if textFieldText.count < 8 || textFieldText.count >= 64{
                        self?.bottomTitleLabel.isHidden = false
                        self?.showTitleLabel(show: false, animation: true)
                    }else {
                        self?.bottomTitleLabel.isHidden = true
                        self?.showTitleLabel(show: true, animation: true)
                    }
                }).disposed(by: disposeBag)
            case .name:
                showWifiChangeButton = false
                security = false
                textField.keyboardType = .default
            case .wifiName:
                security = false
                showWifiChangeButton = true
                textField.keyboardType = .default
            default:
                break
            }
            layoutIfNeeded()
        }
    }
    var changeWifiBtn:UIButton?
    private let editingColor = STELLAR_COLOR_C1
    private let normalLineColor = UIColor.init(hexString: "#E6EAEF")
    private let normalTitleColor = UIColor.init(hexString: "#3E4A59")
    private func setupUI() {
        addSubview(textField)
        addSubview(bottomLine)
        addSubview(titleLabel)
        addSubview(bottomTitleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(self)
            $0.top.equalTo(self)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(self).offset(23.fit)
            $0.left.equalTo(self)
            $0.right.equalTo(self).offset(-10.fit)
            $0.bottom.equalTo(self).offset(-31.fit)
        }
        bottomLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(self)
            $0.right.equalTo(self)
            $0.bottom.equalTo(self).offset(-18.fit)
        }
        bottomTitleLabel.snp.makeConstraints {
            $0.left.equalTo(self)
            $0.top.equalTo(bottomLine.snp.bottom).offset(3)
            $0.width.equalTo(self)
        }
        showTitleLabel(show: false, animation: false)
    }
    private func setupRx() {
        textField.rx.observe(String.self, "text").subscribe(onNext:{ text in
            if text != nil {
                if text!.count > 0 {
                    self.showTitleLabel(show: true, animation: true)
                }else {
                    self.showTitleLabel(show: false, animation: false)
                }
            }
        }).disposed(by: disposeBag)
        textField.rx.controlEvent(.editingDidBegin).asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.bottomLine.backgroundColor = self?.editingColor
                self?.titleLabel.textColor = self?.editingColor
            })
            .disposed(by: disposeBag)
        textField.rx.controlEvent(.editingDidEnd).asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.bottomLine.backgroundColor = self?.normalLineColor
                self?.titleLabel.textColor = self?.normalTitleColor
            })
            .disposed(by: disposeBag)
        textField.rx.controlEvent(.editingChanged).asObservable()
            .subscribe(onNext: { [weak self] _ in
                if self?.textField.text != nil {
                    let str = self?.textField.text
                    if str!.count > 0 {
                        self?.showTitleLabel(show: true, animation: true)
                    }else {
                        self?.showTitleLabel(show: false, animation: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    private func showTitleLabel(show: Bool, animation: Bool) {
        UIView.animate(withDuration: animation ? 0.5 : 0) {
            if show{
                self.titleLabel.alpha = 1.0
            }else{
                self.titleLabel.alpha = 0
            }
        }
    }
    lazy var textField: UITextField = {
        let tempview = UITextField.init()
        tempview.textColor = STELLAR_COLOR_C4
        tempview.font = STELLAR_FONT_T17
        tempview.placeholder = self.title
        tempview.borderStyle = .none
        tempview.clearButtonMode = .whileEditing
        return tempview
    }()
    lazy var bottomLine: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = normalLineColor
        return tempView
    }()
    lazy var titleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = normalTitleColor
        return tempView
    }()
    lazy var bottomTitleLabel: UILabel = {
        let tempView = UILabel.init()
        tempView.font = STELLAR_FONT_T12
        tempView.textColor = STELLAR_COLOR_C2
        tempView.numberOfLines = 0
        return tempView
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupRx()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}